import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      state.data.availableTime!,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 223, 41, 53),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.favorite,
                color: Color.fromARGB(255, 223, 41, 53),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
