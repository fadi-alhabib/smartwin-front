import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartwin/components/helpers.dart';
import 'package:smartwin/components/text_field.dart';
import 'package:gap/gap.dart';

import '../components/animate_sound_widget/animate_sound_widget.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  List scales = [0.4, 0.5, 1.0, 0.7, 0.9, 0.3];
  final SoundController soundController = SoundController(0.85);

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      soundController.value = scales[Random().nextInt(5)];
    });
  }

  @override
  void dispose() {
    soundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 36),
      appBar: AppBar(
        title: const Text("اسم الغرفة"),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AnimatedSoundWidget(
                soundController: soundController,
                title: "Person one",
              ),
              AnimatedSoundWidget(
                  image: "images/kkk.jpg",
                  soundController: SoundController(1.0),
                  title: "Person two"),
            ],
          ),
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
                    separatorBuilder: (BuildContext context, int index) {
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
                              backgroundImage: AssetImage("images/kkk.jpg"),
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
                                width: getScreenSize(context).width / 1.35,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ahmad Ahmad"),
                                    Gap(5),
                                    Text(
                                      "Pariatur tempor nostrud ea nisi incididunt incididunt anim incididunt sunt dolor est Lorem officia pariatur. Excepteur quis fugiat nisi nisi cillum commodo adipisicing velit cupidatat Lorem. Nostrud consectetur tempor eiusmod esse tempor aliquip reprehenderit in magna. Tempor aliqua culpa consectetur duis proident proident cupidatat commodo aute. Cupidatat elit eu tempor nulla ullamco ex culpa adipisicing Lorem ad ullamco elit. Amet proident cillum sit tempor duis voluptate sunt eiusmod est laboris consequat laborum in cillum.",
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
      ),
    );
  }
}
