import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/common/utils/cache_helper.dart';
import 'package:sw/features/auth/models/user_model.dart';
import 'package:sw/features/rooms/bloc/pusher_bloc.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';

/// A screen for the Connect Four game.
/// [roomId] is required to make API calls.
/// If [isHost] is true, a [challengedId] must be provided so the host
/// can initiate the game.
/// Spectator status is determined internally and prevents making moves.
class C4GameScreen extends StatefulWidget {
  final int roomId;
  final bool isHost;
  final int? challengedId;
  final PageController pageController;

  const C4GameScreen({
    super.key,
    required this.roomId,
    required this.isHost,
    this.challengedId,
    required this.pageController,
  });

  @override
  _C4GameScreenState createState() => _C4GameScreenState();
}

class _C4GameScreenState extends State<C4GameScreen> {
  bool _isLoadingMove = false; // Flag to track whether the move is loading

  @override
  void initState() {
    super.initState();
    // If the current user is the host and a challengedId is provided,
    // start the Connect Four game immediately.
    if (widget.isHost && widget.challengedId != null) {
      context.read<PusherBloc>().add(
            StartC4Game(
              roomId: widget.roomId,
              challengedId: widget.challengedId!,
            ),
          );
    }
  }

  /// Build a widget for the Connect Four board.
  /// The board is assumed to be a 6x7 grid (6 rows, 7 columns).
  Widget _buildBoard(PusherBloc bloc, List<List<int>> board, int? currentTurn,
      bool isSpectator) {
    return AspectRatio(
      aspectRatio: 7 / 6,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.backgroundColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(6, (row) {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (col) {
                  int cellValue = board[row][col];
                  Color cellColor;
                  switch (cellValue) {
                    case 1:
                      cellColor = Colors.red.shade700;
                      break;
                    case 2:
                      cellColor = Colors.yellow.shade700;
                      break;
                    default:
                      cellColor = Colors.white;
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Allow a move only if a game is active, the user is not a spectator,
                        // and we're not already processing a move.
                        if (!isSpectator &&
                            bloc.c4GameId != null &&
                            currentTurn != null &&
                            !_isLoadingMove) {
                          // Start loading state before dispatching move.
                          setState(() {
                            _isLoadingMove = true;
                          });
                          // Dispatch a move event with the selected column.
                          context.read<PusherBloc>().add(
                                MakeC4Move(
                                  roomId: widget.roomId,
                                  gameId: bloc.c4GameId!,
                                  column: col,
                                ),
                              );
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cellColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                          ),
                          // Display loading indicator in the center of the cell when a move is being processed.
                          if (_isLoadingMove)
                            Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PusherBloc, PusherState>(
        listener: (context, state) {
          // Display error messages for starting a game or making a move.
          if (state is C4GameStartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error starting game: ${state.error}')),
            );
          } else if (state is C4MoveError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error making move: ${state.error}')),
            );
          } else if (state is C4MoveMadeState) {
            // After a move is made, stop the loading indicator.
            setState(() {
              _isLoadingMove = false;
            });

            // Optionally display a message after a move is made.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          // Retrieve the bloc instance to access Connect Four data.
          final bloc = context.watch<PusherBloc>();
          final board = bloc.boardC4;
          final currentTurn = bloc.c4CurrentTurn;

          // Determine spectator status.
          final UserModel user = UserModel.fromJson(
            jsonDecode(CacheHelper.getCache(key: 'user')),
          );
          final bool isSpectator = bloc.c4ChallengerId == user.id ||
              context.read<RoomCubit>().myRoom!.hostId == user.id;

          return Column(
            children: [
              const SizedBox(height: 16.0),
              // Display the current turn with a rounded indicator.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: currentTurn != null
                        ? (currentTurn == 1
                            ? Colors.red.shade700
                            : Colors.yellow.shade700)
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      currentTurn != null
                          ? 'Current Turn: Player $currentTurn'
                          : 'Waiting for game to start...',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Build the game board.
              Expanded(
                  child: _buildBoard(bloc, board, currentTurn, isSpectator)),
              const SizedBox(height: 16.0),
              // If the user is not the host and the game hasn’t started, show a waiting message.
              if (!widget.isHost && bloc.c4GameId == null)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Waiting for host to start the game...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              // Display a message for spectators.
              if (isSpectator)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'You are a spectator. You can only watch the game.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16.0),
            ],
          );
        },
      ),
    );
  }
}
