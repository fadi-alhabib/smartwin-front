import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:sw/common/components/loading.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/common/utils/cache_helper.dart';
import 'package:sw/features/auth/models/user_model.dart';
import 'package:sw/features/rooms/models/room_model.dart';
import 'package:sw/features/rooms/screens/connect4_screen.dart';
import 'package:sw/features/rooms/screens/question_screen.dart';
import 'package:sw/features/rooms/bloc/pusher_bloc.dart';
import 'package:sw/features/rooms/models/game_thumbnail_model.dart';
import 'package:sw/features/rooms/widgets/active_users_dialog.dart';
import 'package:sw/features/rooms/widgets/room_chat.dart';

class RoomPageView extends HookWidget {
  const RoomPageView({
    super.key,
    required this.roomId,
    required this.room,
  });
  final int roomId;
  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<PusherBloc>().add(PusherConnect(roomId));
      context.read<PusherBloc>().add(GetOldMessages(roomId));
      return null;
    }, const []);
    final PageController pageController = usePageController();
    return Scaffold(
      body: BlocListener<PusherBloc, PusherState>(
        listener: (context, state) {
          if (state is GameStarted) {
            // Assume that GamesEnum.connect4 corresponds to page 1.
            pageController.animateToPage(
              state.game.value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.bounceIn,
            );
          }
          if (state is C4GameStartedState) {
            pageController.animateToPage(
              2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.bounceIn,
            );
          }
          if (state is QuizEndedState) {
            pageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceIn);
            state.minutesTaken;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.backgroundColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(29)),
                content: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (state.score != 0)
                      FittedBox(
                        child: Text(
                          state.score.toString(),
                          style: TextStyle(
                              color: state.score == 0
                                  ? AppColors.redColor
                                  : AppColors.primaryColor,
                              fontSize: 46),
                        ),
                      ),
                    if (state.score != 0)
                      Lottie.asset(
                        'images/animations/sparkles-1.json',
                        repeat: true,
                      ),
                    if (state.score == 0)
                      Lottie.asset('images/animations/game_over.json')
                  ],
                ),
              ),
            );
          }
        },
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // First Page: Room view.
            RoomView(roomId: roomId),

            // Second Page: Quiz Screen.
            const QuestionScreen(),

            // Third Page: Connect 4 game screen.
            C4GameScreen(
              roomId: roomId,
              isHost: room.hostId ==
                  UserModel.fromJson(
                          jsonDecode(CacheHelper.getCache(key: "user")))
                      .id,
              pageController: pageController,
            ),
          ],
        ),
      ),
    );
  }
}

class RoomView extends HookWidget {
  const RoomView({
    super.key,
    required this.roomId,
  });
  final int roomId;

  @override
  Widget build(BuildContext context) {
    final isChatFull = useState<bool>(false);
    List<GameThumbnailModel> thumbnails = [
      GameThumbnailModel(
        image: images[0],
        title: 'Connect 4',
        onPressed: () async {
          // Open the dialog and wait for the selected user id.
          final int? challengedUserId = await showDialog<int>(
            context: context,
            builder: (context) => const ActiveUsersDialog(),
          );

          // If a user was selected, dispatch the event.
          if (challengedUserId != null) {
            context.read<PusherBloc>().add(
                  StartC4Game(roomId: roomId, challengedId: challengedUserId),
                );
          }
        },
      ),
      GameThumbnailModel(
        image: images[1],
        title: 'Quiz',
        onPressed: () {
          context
              .read<PusherBloc>()
              .add(StartQuizGame(roomId: roomId, isImagesGame: false));
        },
      ),
      GameThumbnailModel(
        image: images[2],
        title: 'Images Quiz',
        onPressed: () {
          context
              .read<PusherBloc>()
              .add(StartQuizGame(roomId: roomId, isImagesGame: true));
        },
      ),
    ];

    return Column(
      children: [
        if (!isChatFull.value)
          Expanded(
            flex: 2,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 260,
              diameterRatio: 4,
              perspective: 0.01,
              squeeze: 1.1,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                // Handle item selection if needed
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return GameCard(
                    imagePath: thumbnails[index].image,
                    title: thumbnails[index].title,
                    onPressed: thumbnails[index].onPressed,
                  );
                },
                childCount: thumbnails.length,
              ),
            ),
          ),
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              const RoomChat(),
              Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    backgroundColor: AppColors.backgroundColor,
                  ),
                  onPressed: () {
                    isChatFull.value = !isChatFull.value;
                  },
                  child: Icon(
                    isChatFull.value
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onPressed,
  });

  final String imagePath;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PusherBloc, PusherState>(
      builder: (context, state) {
        if (state is StartQuizLoading || state is C4GameStartLoading) {
          return Loading();
        }
        return GestureDetector(
          onTap: state is StartQuizLoading ? null : onPressed,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 4,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
