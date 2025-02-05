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

    List<QuestionModel> questions = context.read<PusherBloc>().questions!;
    ValueNotifier<int> currentQuestionIdx = useState<int>(0);
    final CountDownController countDownController =
        useMemoized(() => CountDownController());
    final room = context.read<RoomCubit>().myRoom;
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 47, 118, 175),
          borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                    const SizedBox(
                      height: 2,
                    ),
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
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "$errorAnswers",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
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
            SizedBox(
              height: getScreenSize(context).height / 2,
              child: Column(
                children: List.generate(
                  questions[currentQuestionIdx.value].answers!.length,
                  (index) => AnswerItem(
                    index: index + 1,
                    color: colors[index],
                    currentQuestionIdx: currentQuestionIdx,
                    answer: questions[currentQuestionIdx.value].answers![index],
                    countDownController: countDownController,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerItem extends HookWidget {
  final int index;

  final Color color;
  final ValueNotifier<int> currentQuestionIdx;
  final AnswerModel answer;
  final CountDownController countDownController;
  const AnswerItem({
    super.key,
    required this.index,
    required this.color,
    required this.answer,
    required this.currentQuestionIdx,
    required this.countDownController,
  });

  @override
  Widget build(BuildContext context) {
    final room = context.read<RoomCubit>().myRoom;
    final ValueNotifier<Color> stateColor =
        useState<Color>(AppColors.whiteColor);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: BlocBuilder<PusherBloc, PusherState>(
        builder: (context, state) {
          return GestureDetector(
              onTap: state is SubmitAnswerLoading
                  ? null
                  : () {
                      stateColor.value = AppColors.greyColor;
                      countDownController.pause();
                      context.read<PusherBloc>().add(
                            SubmitAnswer(
                                roomId: room!.id!, answerId: answer.id!),
                          );
                    },
              child: BlocListener<PusherBloc, PusherState>(
                listener: (context, state) async {
                  if (state is NextQuestionState &&
                      state.answerId == answer.id) {
                    stateColor.value = state.isCorrect
                        ? AppColors.greenColor
                        : AppColors.redColor;
                    await Future.delayed(Duration(seconds: 1));
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
                    child: Row(
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
                            maxLines: 2, // Set max lines to 2
                            overflow: TextOverflow
                                .ellipsis, // Handle overflow with ellipsis
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
