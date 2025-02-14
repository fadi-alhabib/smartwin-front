import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/rooms/bloc/pusher_bloc.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';
import 'package:sw/features/rooms/models/answer_model.dart';
import 'package:sw/features/rooms/models/question_model.dart';
import '../../../common/components/helpers.dart';

class QuestionScreen extends HookWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Right and wrong answer counts from the bloc.
    var rightAnswers = context.watch<PusherBloc>().rightAnswersCount;
    var errorAnswers = context.watch<PusherBloc>().wrongAnswersCount;

    var animationController =
        useAnimationController(duration: const Duration(seconds: 30));
    var colorTween = useAnimation(TweenSequence([
      TweenSequenceItem(
          tween: ColorTween(
              begin: getMaterialColor(Colors.green),
              end: getMaterialColor(Colors.orange)),
          weight: 45),
      TweenSequenceItem(
          tween: ColorTween(
              begin: getMaterialColor(Colors.orange),
              end: getMaterialColor(Colors.red)),
          weight: 55)
    ]).animate(animationController));
    List colors = [
      Colors.amber,
      const Color.fromARGB(255, 32, 151, 157),
      const Color.fromARGB(255, 47, 118, 175),
      Colors.purple
    ];

    // Retrieve the list of questions from the bloc.
    List<QuestionModel> questions = context.read<PusherBloc>().questions!;
    ValueNotifier<int> currentQuestionIdx = useState<int>(0);
    final CountDownController countDownController =
        useMemoized(() => CountDownController());
    final room = context.read<RoomCubit>().myRoom;

    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 47, 118, 175),
          borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top row with counters and timer.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 15,
                      child: Icon(
                        Icons.check_circle_outline_outlined,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$rightAnswers",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return CircularCountDownTimer(
                          controller: countDownController,
                          width: getScreenSize(context).width / 4,
                          height: getScreenSize(context).height / 10,
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          onStart: () {
                            animationController.forward();
                          },
                          onChange: (value) {},
                          onComplete: () => context.read<PusherBloc>().add(
                              SubmitAnswer(
                                  roomId: room!.id!,
                                  answerId: questions[currentQuestionIdx.value]
                                      .answers!
                                      .firstWhere(
                                          (ans) => ans.isCorrect == false)
                                      .id!)),
                          duration: 15,
                          fillColor: colorTween!,
                          ringColor: Colors.white);
                    }),
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 15,
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$errorAnswers",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            // Question container (image and title).
            Expanded(
              child: Container(
                width: getScreenSize(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: questions[currentQuestionIdx.value].image != null
                      ? DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              questions[currentQuestionIdx.value].image!))
                      : null,
                ),
                child: Center(
                  child: Text(
                    questions[currentQuestionIdx.value].title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            // Answers list.
            SizedBox(
              height: getScreenSize(context).height / 2,
              child: Column(
                children: List.generate(
                  questions[currentQuestionIdx.value].answers!.length,
                  (index) => AnswerItem(
                    questionId: questions[currentQuestionIdx.value].id!,
                    index: index + 1,
                    color: colors[index],
                    currentQuestionIdx: currentQuestionIdx,
                    answer: questions[currentQuestionIdx.value].answers![index],
                    countDownController: countDownController,
                  ),
                ),
              ),
            ),
            // For host: reveal vote results if not yet revealed.
            if (room != null && room.isHost!)
              BlocBuilder<PusherBloc, PusherState>(
                builder: (context, state) {
                  // Here we show the "Reveal Votes" button only if no vote data exists for the current question.
                  final currentQuestion = questions[currentQuestionIdx.value];
                  final votes =
                      context.read<PusherBloc>().quizVotes[currentQuestion.id];
                  if (votes == null || votes.isEmpty) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<PusherBloc>().add(GetQuizVotes(
                            roomId: room.id!,
                            quizId: context.read<PusherBloc>().quizId!));
                      },
                      child: const Text("Reveal Votes"),
                    );
                  } else {
                    // If votes exist, we don't need an extra button here because
                    // each AnswerItem will display the animated progress.
                    return const SizedBox.shrink();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class AnswerItem extends HookWidget {
  final int questionId;
  final int index;
  final Color color;
  final ValueNotifier<int> currentQuestionIdx;
  final AnswerModel answer;
  final CountDownController countDownController;
  const AnswerItem({
    super.key,
    required this.questionId,
    required this.index,
    required this.color,
    required this.answer,
    required this.currentQuestionIdx,
    required this.countDownController,
  });

  /// Helper widget that animates a linear progress indicator based on vote percentage.
  Widget buildAnimatedProgress(Map<int, int> votes, int answerId) {
    int voteCount = votes[answerId] ?? 0;
    int totalVotes = votes.values.fold(0, (sum, count) => sum + count);
    double progress = totalVotes > 0 ? voteCount / totalVotes : 0.0;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
          minHeight: 5,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = context.read<RoomCubit>().myRoom;
    final ValueNotifier<Color> stateColor =
        useState<Color>(AppColors.whiteColor);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: BlocBuilder<PusherBloc, PusherState>(
        builder: (context, state) {
          // Check if vote results exist for this question (for host only).
          Map<int, int>? votes;
          if (room != null && room.isHost!) {
            votes = context.read<PusherBloc>().quizVotes[questionId];
          }
          return GestureDetector(
            onTap: state is SubmitAnswerLoading
                ? null
                : () {
                    stateColor.value = AppColors.greyColor;
                    countDownController.pause();
                    context.read<PusherBloc>().add(
                          SubmitAnswer(roomId: room!.id!, answerId: answer.id!),
                        );
                  },
            child: BlocListener<PusherBloc, PusherState>(
              listener: (context, state) async {
                if (state is NextQuestionState && state.answerId == answer.id) {
                  stateColor.value = state.isCorrect
                      ? AppColors.greenColor
                      : AppColors.redColor;
                  await Future.delayed(const Duration(seconds: 1));
                  countDownController.restart();
                  currentQuestionIdx.value += 1;
                  stateColor.value = AppColors.whiteColor;
                }
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: stateColor.value,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: color,
                            child: Text(
                              "$index",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              answer.title!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // If vote results are available, show an animating progress bar.
                      if (votes != null && votes.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        buildAnimatedProgress(votes, answer.id!)
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
