import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../components/helpers.dart';

class QuestionScreen extends HookWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var currentQuetion = useState(1.0);
    var rightAnswers = useState(0);
    var errorAnswers = useState(0);
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 42),
      appBar: AppBar(
        title: Column(
          children: [
            const Text("إختبار عشوائي"),
            Text(
              "${currentQuetion.value.round()}/10",
            ),
          ],
        ),
        toolbarHeight: getScreenSize(context).height / 8,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
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
                        "${rightAnswers.value}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return CircularCountDownTimer(
                            width: getScreenSize(context).width / 4,
                            height: getScreenSize(context).height / 10,
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            onStart: () {
                              animationController.forward();
                            },
                            onChange: (value) {},
                            duration: 30,
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
                        "${errorAnswers.value}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const Text(
                "من الدول الاستوائية النامية اقتصاديا",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),
              SizedBox(
                height: getScreenSize(context).height / 2,
                child: Column(
                  children: List.generate(
                      4,
                      (index) => buildAnswerItem(
                          index: index + 1,
                          color: colors[index],
                          title: "الصومال")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnswerItem(
      {required int index, required Color color, required String title}) {
    bool? answer;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: GestureDetector(
        onTap: () {
          // if the self.index == the index of right answer make it green else make it red
        },
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  child: Text(
                    "$index",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
