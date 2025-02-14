part of 'pusher_bloc.dart';

abstract class PusherBlocEvent extends Equatable {
  const PusherBlocEvent();

  @override
  List<Object?> get props => [];
}

class PusherConnect extends PusherBlocEvent {
  final int roomId;
  const PusherConnect(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class GetOldMessages extends PusherBlocEvent {
  final int roomId;
  const GetOldMessages(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class PusherReceiveMessage extends PusherBlocEvent {
  final MessageModel message;
  const PusherReceiveMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class SendMessage extends PusherBlocEvent {
  final String message;
  final int roomId;
  const SendMessage(this.message, this.roomId);

  @override
  List<Object?> get props => [message];
}

class StartQuizGame extends PusherBlocEvent {
  final int roomId;
  final bool isImagesGame;
  const StartQuizGame({required this.roomId, required this.isImagesGame});

  @override
  List<Object?> get props => [roomId, isImagesGame];
}

class QuizStarted extends PusherBlocEvent {
  final List<QuestionModel> questions;
  final int quizId;
  const QuizStarted({
    required this.questions,
    required this.quizId,
  });
  @override
  List<Object?> get props => [questions, quizId];
}

class QuizAnswerMade extends PusherBlocEvent {
  final int answerId;
  final bool isRightAnswer;
  const QuizAnswerMade({
    required this.answerId,
    required this.isRightAnswer,
  });

  @override
  List<Object?> get props => [answerId, isRightAnswer];
}

class EndQuizGame extends PusherBlocEvent {
  final int score;
  final int minutesTaken;
  const EndQuizGame({required this.score, required this.minutesTaken});
}

class SubmitAnswer extends PusherBlocEvent {
  final int roomId;
  final int answerId;
  const SubmitAnswer({required this.roomId, required this.answerId});
}

class NoAnswer extends PusherBlocEvent {}

/// NEW: Event dispatched when a vote update is received via Pusher.
/// Contains the question ID and a map of answer IDs to vote counts.
class QuizVoteUpdated extends PusherBlocEvent {
  final int questionId;
  final Map<String, dynamic> votes;
  const QuizVoteUpdated({required this.questionId, required this.votes});

  @override
  List<Object?> get props => [questionId, votes];
}

/// NEW: Event to request aggregated votes from the backend (host only).
class GetQuizVotes extends PusherBlocEvent {
  final int roomId;
  final int quizId;
  const GetQuizVotes({required this.roomId, required this.quizId});

  @override
  List<Object?> get props => [roomId, quizId];
}

class StartC4Game extends PusherBlocEvent {
  final int roomId;
  final int challengedId;
  const StartC4Game({required this.roomId, required this.challengedId});
  @override
  List<Object?> get props => [roomId, challengedId];
}

class C4GameStarted extends PusherBlocEvent {
  final int gameId;
  final int challengerId;
  final int currentTurn;
  final List<List<int>> board;
  const C4GameStarted({
    required this.gameId,
    required this.challengerId,
    required this.currentTurn,
    required this.board,
  });
}

class MakeC4Move extends PusherBlocEvent {
  final int roomId;
  final int gameId;
  final int column;
  const MakeC4Move({
    required this.roomId,
    required this.gameId,
    required this.column,
  });
}

class C4MoveMade extends PusherBlocEvent {
  final List<List<int>> board;
  final int? currentTurn;
  final String message;
  const C4MoveMade({
    required this.board,
    required this.currentTurn,
    required this.message,
  });
}
