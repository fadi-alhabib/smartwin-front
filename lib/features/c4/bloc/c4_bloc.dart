// import 'dart:convert';

// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:flutter/foundation.dart';
// import 'package:sw/features/c4/models/connect4/c4_move.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// part 'c4_event.dart';
// part 'c4_bloc_state.dart';

// enum C4SuccessStates {
//   initial,
//   moveMade,
//   win,
//   draw,
// }

// enum C4FailureStates {
//   badMove,
//   boardLocked,
//   notPlayer,
//   gameOver,
// }

// class C4Bloc extends Bloc<C4Event, C4BlocState> {
//   final String wsUrl; // Replace with your WebSocket server URL
//   WebSocketChannel? _channel;
//   List<List<int>>? board;
//   bool? isPlayer;
//   // late List<dynamic> board;
//   C4Bloc(this.wsUrl) : super(C4Initial()) {
//     on<C4ConnectWebSocket>(_handleConnection);

//     on<C4MakeMove>(_handleMakeMove);
//   }
//   _handleMakeMove(C4MakeMove event, Emitter<C4BlocState> emit) async {
//     _channel!.sink.add(json.encode({"column": event.column}));
//   }

//   Future<void> _handleConnection(
//       C4ConnectWebSocket event, Emitter<C4BlocState> emit) async {
//     emit(C4WSConnecting());

//     try {
//       Uri uri = Uri.parse(wsUrl);
//       _channel = IOWebSocketChannel.connect(
//         uri,
//         protocols: ['websocket'],
//         headers: {
//           "Authorization":
//               "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxOTQ1MTY2MzQ5LCJpYXQiOjE3MjQ0MTQzNDksImp0aSI6ImEyNTMyZmQ5ZDdlMTQxYjZhNTY2YWVlOGM3ZDMwYTg1IiwidXNlcl9pZCI6MX0.q7y8LtuxopiTx2XRlRn2FEBLmW5xOHlo63rsKAdbh78"
//         },
//       );
//       emit(C4WSConnected());

//       await _channel!.stream.forEach((data) {
//         Map<String, dynamic> dataJson = json.decode(data);
//         print(dataJson["state"]);
//         if (dataJson["state"] == "INITIAL") {
//           // TODO:: Add player type to socket initial response
//           List<dynamic> boardList = dataJson["board"];
//           board = boardList.map((e) => List<int>.from(e)).toList();
//           isPlayer = dataJson["is_player"];
//           print(board);
//           emit(C4BoardInitialized());
//         }
//         if (dataJson["state"] == "MOVE_MADE") {
//           C4Move move = C4Move.fromMap(dataJson["move"]);
//           board![move.column][move.row] = move.color;
//           emit(C4WSNewMove(move: move));
//         }
//         //Board
//         if (dataJson["state"] == "WIN" || dataJson["state"] == "LOSE") {
//           List<dynamic> winningTiles = dataJson["winning_tiles"];
//           for (var indexPair in winningTiles) {
//             int rowIndex = indexPair[1];
//             int colIndex = indexPair[0];
//             if (rowIndex < board!.length &&
//                 colIndex < board![rowIndex].length) {
//               board![rowIndex][colIndex] = 3;
//             }
//           }
//         }
//         if (dataJson["state"] == "WIN") {
//           emit(C4WinState());
//         }
//         if (dataJson["state"] == "LOSE") {
//           emit(C4LoseState());
//         }
//         //Board
//         if (dataJson["state"] == "DRAW") {
//           emit(C4DrawState());
//         }
//         //Board
//         if (dataJson["state"] == "BOARD_LOCKED") {
//           emit(C4BoardLockedState());
//         }
//         //Board
//         if (dataJson["state"] == "NOT_PLAYER") {
//           emit(C4NotPlayerState());
//         }

//         if (dataJson["state"] == "GAME_OVER") {
//           // emit(C4GameOverState());
//           emit(C4LoseState());
//           // emit(C4LoseState());
//         }
//         // TODO:: Handle Incomming events
//       });
//     } catch (error) {
//       print(error);
//       emit(C4WSError());
//     }
//   }
// }
