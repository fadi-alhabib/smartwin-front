import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwin/animations/c4_lose_animation.dart';
import 'package:smartwin/animations/c4_win_animation.dart';
import 'package:smartwin/bloc/c4_bloc.dart';
import 'package:smartwin/components/animate_sound_widget/animate_sound_widget.dart';
import 'package:smartwin/components/connect4/game_board.dart';
import 'package:smartwin/components/helpers.dart';
import 'package:smartwin/components/text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

class C4Screen extends HookWidget {
  const C4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<C4Bloc>().add(C4ConnectWebSocket());
      return null;
    }, const []);
    final shadowAnimationController = useAnimationController();
    final winAnimationController = useAnimationController();
    final loseAnimationController = useAnimationController();
    final blurAnimationController = useAnimationController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 30, 36),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocConsumer<C4Bloc, C4BlocState>(
            listener: (context, state) {
              if (state is C4WinState) {
                winAnimationController.forward();
                blurAnimationController.forward();
              }
              if (state is C4LoseState) {
                loseAnimationController.forward();
                shadowAnimationController.forward();
                blurAnimationController.forward();
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AnimatedSoundWidget(
                        soundController: SoundController(1.0),
                        title: "Person one",
                      ),
                      AnimatedSoundWidget(
                          image: "images/kkk.jpg",
                          soundController: SoundController(1.0),
                          title: "Person two"),
                    ],
                  ),
                  Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          const C4GameBoard()
                              .animate(
                                  autoPlay: false,
                                  controller: blurAnimationController)
                              .blur(),
                          C4WinAnimation(
                              animationController: winAnimationController),
                          C4LoseAnimation(
                              animationController: loseAnimationController),
                        ],
                      )),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        // color: const Color.fromARGB(255, 47, 118, 175),
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.yellow.shade700)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: 20,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Gap(10);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return Directionality(
                                textDirection: index % 3 == 0
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage:
                                          AssetImage("images/kkk.jpg"),
                                    ),
                                    const Gap(5),
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                              topRight: Radius.circular(7.5),
                                              bottomLeft: Radius.circular(15))),
                                      child: SizedBox(
                                        width:
                                            getScreenSize(context).width / 1.35,
                                        child: const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Ahmad Ahmad"),
                                            Gap(5),
                                            Text(
                                              "Pariatur tempor nostrud ea nisi i.",
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const Gap(7),
                        MyTextField(
                          padding: const EdgeInsets.all(5.0),
                          suffix: IconButton(
                              onPressed: () {}, icon: const Icon(Icons.send)),
                        )
                      ],
                    ),
                  ))
                ],
              );
            },
          ),
        ),
      ).animate(autoPlay: false, controller: shadowAnimationController).color(
          duration: 1.seconds, begin: Colors.transparent, end: Colors.black45),
    );
  }
}
