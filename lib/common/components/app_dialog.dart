import 'package:flutter/material.dart';
import 'package:sw/common/constants/constants.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppDialog extends HookWidget {
  AppDialog({super.key, required this.body, required this.actions});
  List<Widget> body;
  List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: primarySwatch,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Container(
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: body,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: actions,
          )
        ],
      ),
    );
  }
}
