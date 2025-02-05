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
  List<Object?> get props => [roomId]; // No additional properties to compare
}

class GetOldMessages extends PusherBlocEvent {
  final int roomId;
  const GetOldMessages(this.roomId);

  @override
  List<Object?> get props => [roomId]; // No additional properties to compare
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
  List<Object?> get props => [questions];
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
