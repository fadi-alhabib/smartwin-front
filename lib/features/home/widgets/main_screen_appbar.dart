import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/home/cubit/home_cubit.dart';

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: AppColors.primaryColor,
      centerTitle: false,
      title: const Text(
        "Smart win",
        style: TextStyle(
          color: AppColors.primaryColor,
          fontStyle: FontStyle.italic,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeDataSuccess &&
                      state.data.availableTime != null) {
                    return Text(
                      state.data.availableTime!.toString(),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 33, 150, 243),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              Lottie.asset(
                'images/animations/clock.json',
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
