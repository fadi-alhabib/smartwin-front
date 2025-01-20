part of 'c4_bloc.dart';

@immutable
sealed class C4Event extends Equatable {
  const C4Event();

  @override
  List<Object> get props => [];
}

class C4ConnectWebSocket extends C4Event {}

class C4MakeMove extends C4Event {
  final int column;

  const C4MakeMove({required this.column});

  @override
  List<Object> get props => [column];
}
