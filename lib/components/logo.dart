import 'package:flutter/material.dart';
import 'package:smartwin/components/helpers.dart';
import 'package:smartwin/theme/colors.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, required double width, required double height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      width: getScreenSize(context).width,
      height: getScreenSize(context).height * 0.25,
      child: const FittedBox(
        child: Text(
          "Smart Win",
          style: TextStyle(
              color: AppColors.primaryColor, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
