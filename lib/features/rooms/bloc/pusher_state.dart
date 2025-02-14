part of 'pusher_bloc.dart';

sealed class PusherState extends Equatable {
  const PusherState();

  @override
  List<Object> get props => [];
}

final class PusherInitial extends PusherState {}

final class GetOldMessagesLoading extends PusherState {}

final class GetOldMessagesSuccess extends PusherState {
  final List<MessageModel> messages;
  const GetOldMessagesSuccess({required this.messages});

  @override
  List<Object> get props => [messages];
}

final class GetOldMessagesError extends PusherState {}

final class SendMessageLoading extends PusherState {}

final class SendMessageSuccess extends PusherState {
  final MessageModel message;
  const SendMessageSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class SendMessageError extends PusherState {}

final class MessageRecived extends PusherState {
  final MessageModel message;
  const MessageRecived({required this.message});
  @override
  List<Object> get props => [message];
}

final class StartQuizLoading extends PusherState {}

final class StartQuizSuccess extends PusherState {
  @override
  List<Object> get props => [];
}

final class StartQuizError extends PusherState {}

final class GameStarted extends PusherState {
  final GamesEnum game;
  const GameStarted({required this.game});
}

final class RightAnswerState extends PusherState {
  final int answerId;
  const RightAnswerState({required this.answerId});
  @override
  List<Object> get props => [answerId];
}

final class WrongAnswerState extends PusherState {
  final int answerId;
  const WrongAnswerState({required this.answerId});
  @override
  List<Object> get props => [answerId];
}

class NextQuestionState extends PusherState {
  final bool isCorrect;
  final int answerId;
  const NextQuestionState({
    required this.isCorrect,
    required this.answerId,
  });
}

class MessageReceived extends PusherState {
  final MessageModel message;
  const MessageReceived({required this.message});
}

class QuizGameOver extends PusherState {
  final int score;
  final int minutesTaken;
  const QuizGameOver({required this.score, required this.minutesTaken});
}

class SubmitAnswerLoading extends PusherState {}

class SubmitAnswerSuccess extends PusherState {}

class SubmitAnswerError extends PusherState {}

class QuizEndedState extends PusherState {
  final int score;
  final int minutesTaken;
  const QuizEndedState({required this.score, required this.minutesTaken});
}

class C4GameStartLoading extends PusherState {}

class C4GameStartSuccess extends PusherState {}

class C4GameStartError extends PusherState {
  final String error;
  const C4GameStartError({required this.error});
  @override
  List<Object> get props => [error];
}

class C4GameStartedState extends PusherState {}

class C4MoveLoading extends PusherState {}

class C4MoveSuccess extends PusherState {}

class C4MoveError extends PusherState {
  final String error;
  const C4MoveError({required this.error});
  @override
  List<Object> get props => [error];
}

class C4MoveMadeState extends PusherState {
  final String message;
  const C4MoveMadeState({required this.message});
  @override
  List<Object> get props => [message];
}

class C4GameOverState extends PusherState {
  final int? winnerId;
  const C4GameOverState({this.winnerId});

  @override
  List<Object> get props => [winnerId!];
}

/// NEW: State emitted when a vote update is received (real time).
class QuizVotesUpdatedState extends PusherState {
  final Map<int, Map<int, int>> quizVotes;
  const QuizVotesUpdatedState({required this.quizVotes});

  @override
  List<Object> get props => [quizVotes];
}

/// NEW: State emitted when the host is retrieving vote counts.
class QuizVotesLoadingState extends PusherState {}

/// NEW: State emitted after successfully retrieving aggregated votes.
class QuizVotesRetrievedState extends PusherState {
  final Map<int, Map<int, int>> quizVotes;
  const QuizVotesRetrievedState({required this.quizVotes});

  @override
  List<Object> get props => [quizVotes];
}

/// NEW: State emitted when an error occurs while retrieving votes.
class QuizVotesErrorState extends PusherState {
  final String error;
  const QuizVotesErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
