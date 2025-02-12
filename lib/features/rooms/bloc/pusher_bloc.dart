import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sw/common/services/pusher_service.dart';
import 'package:sw/common/utils/dio_helper.dart';
import 'package:sw/features/rooms/models/message_model.dart';
import 'package:sw/features/rooms/models/question_model.dart';
import 'package:sw/features/rooms/models/room_model.dart';

part 'pusher_event.dart';
part 'pusher_state.dart';

/// This BLoC now handles not only quiz and messaging events but also Connect Four game events.
/// All game data (like the current board, game id, etc.) is stored as instance variables.
class PusherBloc extends Bloc<PusherBlocEvent, PusherState> {
  late PusherService pusherService;

  // -------------------------------
  // Connect Four (C4) game variables
  // -------------------------------
  int? c4GameId;
  List<List<int>> boardC4 = List.generate(6, (_) => List.filled(7, 0));
  int? c4CurrentTurn;
  int? c4ChallengerId;

  // -------------------------------
  // (Existing quiz & messaging variables)
  // -------------------------------
  int? quizId;
  int? roomId;
  List<MessageModel> messages = [];

  PusherBloc() : super(PusherInitial()) {
    // Existing events
    on<PusherConnect>(handlePusherConnect);
    on<PusherReceiveMessage>(handleReciveMessage);
    on<GetOldMessages>(handleGetOldMessages);
    on<SendMessage>(handleSendMessage);
    on<StartQuizGame>(handleStartQuizGame);
    on<QuizStarted>(handleQuizGameStarted);
    on<SubmitAnswer>(handleAnswer);
    on<QuizAnswerMade>(handleQuizAnswerMade);
    on<EndQuizGame>(handleEndQuizGame);
    on<NoAnswer>(handleNoAnswer);

    // -------------------------------
    // New events for Connect Four game
    // -------------------------------
    on<StartC4Game>(handleStartC4Game);
    on<C4GameStarted>(handleC4GameStarted);
    on<MakeC4Move>(handleMakeC4Move);
    on<C4MoveMade>(handleC4MoveMade);
  }

  Future<void> handlePusherConnect(PusherConnect event, Emitter emit) async {
    pusherService = PusherService();
    await pusherService.initPusher(onPusherEvent, roomId: event.roomId);
  }

  /// Called whenever a pusher event is received.
  /// We now add cases for the C4 events “c4.started” and “move.made.”
  void onPusherEvent(PusherEvent pusherEvent) {
    log("Event received: ${pusherEvent.eventName} with data: ${pusherEvent.data}");
    try {
      switch (pusherEvent.eventName) {
        // ---------------------------
        // Existing events (messaging, quiz)
        // ---------------------------
        case r"message.sent":
          final data = jsonDecode(pusherEvent.data);
          final message = MessageModel.fromJson(data);
          add(PusherReceiveMessage(message));
          break;
        case r"quiz.started":
          final data = jsonDecode(pusherEvent.data);
          final List<dynamic> dynamicQuestion = data['questions'];
          final List<QuestionModel> questions =
              dynamicQuestion.map((e) => QuestionModel.fromJson(e)).toList();
          quizId = data['game_id'];
          roomId = data['room_id'];
          add(QuizStarted(questions: questions, quizId: data['game_id']));
          break;
        case r"answer.made":
          final data = jsonDecode(pusherEvent.data);
          add(QuizAnswerMade(
              answerId: data['answerId'],
              isRightAnswer: data['isCorrect'] == 1 ? true : false));
          break;
        case r"quiz.over":
          final data = jsonDecode(pusherEvent.data);
          add(EndQuizGame(
              score: data['score'], minutesTaken: data['minutes_taken']));
          break;

        // ---------------------------
        // New Connect Four events
        // ---------------------------
        case r"c4.started":
          {
            final data = jsonDecode(pusherEvent.data);
            c4GameId = data['game_id'];
            c4ChallengerId = data['challenger_id'];
            c4CurrentTurn = data['current_turn'];
            // Initialize an empty board (6 rows x 7 columns)
            boardC4 = List.generate(6, (_) => List.filled(7, 0));
            add(C4GameStarted(
                gameId: c4GameId!,
                challengerId: c4ChallengerId!,
                currentTurn: c4CurrentTurn!,
                board: boardC4));
          }
          break;
        case r"move.made":
          {
            final data = jsonDecode(pusherEvent.data);
            // Convert the dynamic board list to a List<List<int>>
            boardC4 = (data['board'] as List)
                .map<List<int>>((row) => List<int>.from(row))
                .toList();
            c4CurrentTurn = data['current_turn'];
            String message = data['message'];
            add(C4MoveMade(
                board: boardC4, currentTurn: c4CurrentTurn, message: message));
          }
          break;
        default:
          // (Other events can be handled here if needed.)
          break;
      }
    } catch (e) {
      log("Error processing pusher event: ${e.toString()}");
    }
  }

  // ---------------------------
  // Existing message and quiz handlers...
  // ---------------------------
  Future<void> handleGetOldMessages(GetOldMessages event, Emitter emit) async {
    log("Fetching old messages...");
    emit(GetOldMessagesLoading());
    try {
      final response =
          await DioHelper.getAuthData(path: '/messages/rooms/${event.roomId}');
      List<dynamic> data = response!.data['data'];
      List<MessageModel> resMessages =
          data.map((e) => MessageModel.fromJson(e)).toList();
      messages = resMessages;
      emit(GetOldMessagesSuccess(messages: resMessages));
    } catch (e) {
      emit(GetOldMessagesError());
    }
  }

  void handleReciveMessage(PusherReceiveMessage event, Emitter emit) {
    messages.add(event.message);
    emit(MessageRecived(message: event.message));
  }

  Future<void> handleSendMessage(SendMessage event, Emitter emit) async {
    emit(SendMessageLoading());
    try {
      final response = await DioHelper.postData(
          path: '/messages/rooms/${event.roomId}',
          data: {"message": event.message});
      final newMessage = MessageModel.fromJson(response!.data['data']);
      emit(SendMessageSuccess(message: newMessage));
    } catch (e) {
      emit(SendMessageError());
    }
  }

  Future<void> handleStartQuizGame(StartQuizGame event, Emitter emit) async {
    _resetState();
    emit(StartQuizLoading());
    try {
      await DioHelper.getAuthData(
          path: '/room/${event.roomId}/quiz/start',
          queryParameters: {'is_images_game': event.isImagesGame});
      emit(StartQuizSuccess());
    } on DioException catch (e) {
      log(e.response!.data.toString());
      emit(StartQuizError());
    }
  }

  GamesEnum? currentGame;
  List<QuestionModel>? questions;
  Future<void> handleQuizGameStarted(QuizStarted event, Emitter emit) async {
    _resetState();
    currentGame = GamesEnum.quiz;
    questions = event.questions;
    emit(const GameStarted(game: GamesEnum.quiz));
  }

  int rightAnswersCount = 0;
  int wrongAnswersCount = 0;
  int answersCount = 0;
  Future<void> handleQuizAnswerMade(QuizAnswerMade event, Emitter emit) async {
    answersCount += 1;
    if (answersCount == 10) {
      await DioHelper.postData(
          path: "/room/$roomId/quiz/$quizId/end",
          data: {"rightQuestionsCount": rightAnswersCount});
    }
    if (event.isRightAnswer) {
      rightAnswersCount += 1;
    } else {
      wrongAnswersCount += 1;
    }
    emit(NextQuestionState(
        isCorrect: event.isRightAnswer, answerId: event.answerId));
  }

  Future<void> handleAnswer(SubmitAnswer event, Emitter emit) async {
    emit(SubmitAnswerLoading());
    try {
      await DioHelper.postData(
          path: '/room/${event.roomId}/quiz/broadcast-answer',
          data: {'answerId': event.answerId});
      emit(SubmitAnswerSuccess());
    } on DioException catch (e) {
      log(e.toString());
      emit(SubmitAnswerError());
    }
  }

  Future<void> handleEndQuizGame(EndQuizGame event, Emitter emit) async {
    emit(QuizEndedState(score: event.score, minutesTaken: event.minutesTaken));
  }

  Future<void> handleNoAnswer(NoAnswer event, Emitter emit) async {
    emit(SubmitAnswerLoading());
    int wrongAnswerId = questions![0]
        .answers!
        .where((answer) => answer.isCorrect == false)
        .toList()
        .first
        .id!;
    try {
      await DioHelper.postData(
          path: '/room/$roomId/quiz/broadcast-answer',
          data: {'answerId': wrongAnswerId});
      emit(SubmitAnswerSuccess());
    } on DioException catch (e) {
      log(e.toString());
      emit(SubmitAnswerError());
    }
  }

  // ---------------------------
  // New handlers for Connect Four game
  // ---------------------------

  /// Handles the event when the user initiates starting a Connect Four game.
  /// This calls the backend endpoint `/room/{room}/c4/start` with the ID of the challenged player.
  Future<void> handleStartC4Game(StartC4Game event, Emitter emit) async {
    // Reset any previous Connect Four game state.
    c4GameId = null;
    boardC4 = List.generate(6, (_) => List.filled(7, 0));
    c4CurrentTurn = null;
    c4ChallengerId = null;
    emit(C4GameStartLoading());
    try {
      await DioHelper.postData(
          path: '/room/${event.roomId}/c4/start',
          data: {'challenged_id': event.challengedId});
      // The backend will trigger the pusher event “c4.started” to update our local data.
      emit(C4GameStartSuccess());
    } on DioException catch (e) {
      log(e.toString());
      emit(C4GameStartError(error: e.toString()));
    }
  }

  /// Handles the event when a move is initiated.
  /// This calls the endpoint `/room/{room}/c4/{game}/make-move` with the selected column.
  Future<void> handleMakeC4Move(MakeC4Move event, Emitter emit) async {
    emit(C4MoveLoading());
    try {
      await DioHelper.postData(
          path: '/room/${event.roomId}/c4/${event.gameId}/make-move',
          data: {'column': event.column});
      // The backend will trigger a pusher event “move.made” to update the board.
      emit(C4MoveSuccess());
    } on DioException catch (e) {
      log(e.response!.data.toString());
      emit(C4MoveError(error: "ليس دورك"));
    }
  }

  /// Called when the pusher event “c4.started” is received.
  /// The instance variables have already been updated.
  Future<void> handleC4GameStarted(C4GameStarted event, Emitter emit) async {
    emit(C4GameStartedState());
  }

  /// Called when the pusher event “move.made” is received.
  /// The updated board and message are now available.
  Future<void> handleC4MoveMade(C4MoveMade event, Emitter emit) async {
    emit(C4MoveMadeState(message: event.message));
  }

  void _resetState() {
    rightAnswersCount = 0;
    wrongAnswersCount = 0;
    answersCount = 0;
    currentGame = null;
    questions = null;
  }
}
