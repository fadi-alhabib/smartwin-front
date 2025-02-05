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

class PusherBloc extends Bloc<PusherBlocEvent, PusherState> {
  late PusherService pusherService;
  PusherBloc() : super(PusherInitial()) {
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
  }

  Future<void> handlePusherConnect(PusherConnect event, Emitter emit) async {
    pusherService = PusherService();
    await pusherService.initPusher(onPusherEvent, roomId: event.roomId);
  }

  int? quizId;
  int? roomId;
  void onPusherEvent(PusherEvent pusherEvent) {
    log("event came: ${pusherEvent.data}");
    log("event came: ${pusherEvent.eventName}");
    try {
      log(pusherEvent.eventName.toString());
      switch (pusherEvent.eventName) {
        case r"message.sent":
          log("event ${pusherEvent.data}");
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
          print(data);
          add(QuizAnswerMade(
              answerId: data['answerId'],
              isRightAnswer: data['isCorrect'] == 1 ? true : false));
          break;
        case r"quiz.over":
          final data = jsonDecode(pusherEvent.data);
          add(EndQuizGame(
              score: data['score'], minutesTaken: data['minutes_taken']));
        default:
          // Handle any other events here if needed
          break;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  List<MessageModel> messages = [];
  Future<void> handleGetOldMessages(GetOldMessages event, Emitter emit) async {
    log("Iam here");
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
          data: {
            "message": event.message,
          });
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
          queryParameters: {
            'is_images_game': event.isImagesGame,
          });

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
          data: {
            'answerId': event.answerId,
          });
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
          data: {
            'answerId': wrongAnswerId,
          });
      emit(SubmitAnswerSuccess());
    } on DioException catch (e) {
      log(e.toString());
      emit(SubmitAnswerError());
    }
  }

  void _resetState() {
    rightAnswersCount = 0;
    wrongAnswersCount = 0;
    answersCount = 0;
    currentGame = null;
    questions = null;
  }
}
