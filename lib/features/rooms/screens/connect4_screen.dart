import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/common/utils/cache_helper.dart';
import 'package:sw/features/auth/models/user_model.dart';
import 'package:sw/features/rooms/bloc/pusher_bloc.dart';

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
  bool _isLoadingMove = false;
  // Controls for error overlay display.
  bool _showErrorAnimation = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _startGameIfHost();
  }

  void _startGameIfHost() {
    if (widget.isHost && widget.challengedId != null) {
      context.read<PusherBloc>().add(
            StartC4Game(
              roomId: widget.roomId,
              challengedId: widget.challengedId!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark gradient background for a modern look.
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundColor,
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocConsumer<PusherBloc, PusherState>(
          listener: _stateListener,
          builder: (context, state) => _buildGameInterface(context),
        ),
      ),
    );
  }

  Widget _buildGameInterface(BuildContext context) {
    final bloc = context.watch<PusherBloc>();

    return SafeArea(
      child: Column(
        children: [
          _buildCurrentTurnIndicator(bloc.c4CurrentTurn),
          Expanded(child: _buildGameBoard(bloc)),
        ],
      ),
    );
  }

  /// Builds the game board with the board container, loading overlay,
  /// and the error overlay (used for both "ليس دورك" and "عامود ممتلئ").
  Widget _buildGameBoard(PusherBloc bloc) {
    return Stack(
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              children: List.generate(6, (row) => _buildBoardRow(bloc, row)),
            ),
          ),
        ),
        if (_isLoadingMove) _buildLoadingOverlay(),
        if (_showErrorAnimation) _buildErrorOverlay(),
      ],
    );
  }

  /// Creates a row of board cells.
  Widget _buildBoardRow(PusherBloc bloc, int row) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(7, (col) => _buildBoardCell(bloc, row, col)),
      ),
    );
  }

  /// Creates an individual board cell.
  Widget _buildBoardCell(PusherBloc bloc, int row, int col) {
    final cellValue = bloc.boardC4[row][col];

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleMove(bloc, col),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getCellColor(cellValue),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  /// Handles a tap on a board cell.
  void _handleMove(PusherBloc bloc, int col) {
    if (bloc.c4GameId == null || bloc.c4CurrentTurn == null || _isLoadingMove)
      return;

    final currentUser = _getCurrentUser();

    // If it's not the current user's turn, trigger the error overlay.
    if (bloc.c4CurrentTurn != currentUser.id) {
      _triggerErrorAnimation("ليس دورك!");
      return;
    }

    setState(() {
      _isLoadingMove = true;
    });
    context.read<PusherBloc>().add(
          MakeC4Move(
            roomId: widget.roomId,
            gameId: bloc.c4GameId!,
            column: col,
          ),
        );
  }

  /// Triggers an error overlay with the provided [message].
  void _triggerErrorAnimation(String message) {
    setState(() {
      _errorText = message;
      _showErrorAnimation = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showErrorAnimation = false;
      });
    });
  }

  /// Builds an error overlay widget to display error messages.
  Widget _buildErrorOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: AnimatedOpacity(
            opacity: _showErrorAnimation ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _errorText ?? "",
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a loading overlay to show during move processing.
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "جاري التحميل...",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the appropriate color for a cell based on its [value].
  Color _getCellColor(int value) {
    switch (value) {
      case 1:
        return AppColors.redColor;
      case 2:
        return AppColors.primaryColor;
      default:
        return AppColors.whiteColor.withOpacity(0.3);
    }
  }

  /// Builds the current turn indicator widget.
  Widget _buildCurrentTurnIndicator(int? currentTurn) {
    Color indicatorColor;
    String labelText;

    if (currentTurn != null) {
      indicatorColor =
          currentTurn == 1 ? AppColors.redColor : AppColors.primaryColor;
      labelText = 'دور اللاعب: $currentTurn';
    } else {
      indicatorColor = AppColors.greyColor;
      labelText = 'في انتظار بدء اللعبة...';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: indicatorColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            labelText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ),
    );
  }

  /// Listens to state changes from the BLoC and updates the UI.
  void _stateListener(BuildContext context, PusherState state) {
    if (state is C4MoveMadeState) {
      setState(() => _isLoadingMove = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تنفيذ الحركة')),
      );
    } else if (state is C4MoveError) {
      setState(() => _isLoadingMove = false);
      // If the error indicates "ليس دورك" or a full column, show the overlay.
      if (state.error.contains("ليس دورك")) {
        _triggerErrorAnimation("ليس دورك!");
      } else if (state.error.contains("Column is full") ||
          state.error.contains("العمود ممتلئ")) {
        _triggerErrorAnimation("عامود ممتلئ");
      } else {
        // Otherwise, show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error)),
        );
      }
    } else if (state is C4GameOverState) {
      _handleGameCompletion(context, state);
    }
  }

  void _handleGameCompletion(BuildContext context, C4GameOverState state) {
    setState(() => _isLoadingMove = false);
    Future.delayed(const Duration(milliseconds: 500), () {
      final user = _getCurrentUser();
      final isParticipant = widget.isHost || widget.challengedId == user.id;
      if (isParticipant) {
        _showParticipantDialog(context, state, user);
      } else {
        _showSpectatorDialog(context, state);
      }
    });
  }

  void _showParticipantDialog(
      BuildContext context, C4GameOverState state, UserModel user) {
    final bool isWinner = user.id == state.winnerId;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isWinner ? "🎉 انتصار!" : "😞 خسارة"),
        content: Text(
          isWinner ? "مبروك! لقد ربحت 10 نقاط!" : "حظًا أوفر في المرة القادمة.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.pageController.animateTo(
                0,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              );
            },
            child: const Text(
              "حسنًا",
              style: TextStyle(color: AppColors.whiteColor),
            ),
          ),
        ],
        backgroundColor: AppColors.backgroundColor,
      ),
    );
  }

  void _showSpectatorDialog(BuildContext context, C4GameOverState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("انتهت اللعبة"),
        content: Text("الفائز هو: اللاعب ${state.winnerId}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.pageController.animateTo(
                0,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              );
            },
            child: const Text(
              "حسنًا",
              style: TextStyle(color: AppColors.whiteColor),
            ),
          ),
        ],
        backgroundColor: AppColors.backgroundColor,
      ),
    );
  }

  UserModel _getCurrentUser() {
    final cachedUser = CacheHelper.getCache(key: 'user');
    if (cachedUser == null) {
      throw Exception("لم يتم العثور على بيانات المستخدم في الذاكرة المؤقتة");
    }
    return UserModel.fromJson(jsonDecode(cachedUser));
  }
}
