import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/rooms/screens/question_screen.dart';
import 'package:sw/features/rooms/bloc/pusher_bloc.dart';
import 'package:sw/features/rooms/models/game_thumbnail_model.dart';
import 'package:sw/features/rooms/widgets/room_chat.dart';

class RoomPageView extends HookWidget {
  const RoomPageView({
    super.key,
    required this.roomId,
  });
  final int roomId;

  @override
  Widget build(BuildContext context) {
    final PageController pageController = usePageController();
    return Scaffold(
      body: BlocListener<PusherBloc, PusherState>(
        listener: (context, state) {
          if (state is GameStarted) {
            pageController.animateToPage(state.game.value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceIn);
          }
        },
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // First Page: Existing RoomView
            RoomView(roomId: roomId),

            // Second Page: Placeholder for another page
            const QuestionScreen(),

            // Third Page: Placeholder for another page
            const Center(child: Text('Page 3')),

            // Fourth Page: Placeholder for another page
            const Center(child: Text('Page 4')),
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
          image: images[0], title: 'Connect 4', onPressed: () {}),
      GameThumbnailModel(
          image: images[1],
          title: 'Quiz',
          onPressed: () {
            context
                .read<PusherBloc>()
                .add(StartQuizGame(roomId: roomId, isImagesGame: false));
          }),
      GameThumbnailModel(
          image: images[2], title: 'Images Quiz', onPressed: () {}),
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
                              color: AppColors.primaryColor, width: 2)),
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
            )),
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
        if (state is StartQuizLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
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
