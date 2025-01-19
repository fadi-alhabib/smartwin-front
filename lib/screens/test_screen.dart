import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import '../components/helpers.dart';

class TestScreen extends HookWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              width: getScreenSize(context).width / 1.7,
              height: getScreenSize(context).height / 3.8,
              decoration: BoxDecoration(
                  color: Colors.amber.shade400,
                  borderRadius: BorderRadius.circular(500)),
            ),
            Container(
              width: getScreenSize(context).width / 1.8,
              height: getScreenSize(context).height / 4,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                  color: Colors.amber,
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(2, 2),
                        blurRadius: 5,
                        color: Colors.black26,
                        inset: true),
                    BoxShadow(
                        offset: Offset(-2, -2),
                        color: Colors.black26,
                        inset: true)
                  ]),
            ),
            Container(
              width: getScreenSize(context).width / 4,
              height: getScreenSize(context).height / 8,
              decoration: BoxDecoration(
                color: Colors.amber.shade500,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(1, 1),
                      color: Colors.black12,
                      blurRadius: 5),
                  BoxShadow(
                      offset: Offset(-1, -1),
                      color: Colors.black12,
                      blurRadius: 5)
                ],
                shape: BoxShape.circle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
