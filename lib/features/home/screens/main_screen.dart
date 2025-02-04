import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/c4/screens/profile_screen.dart';
import 'package:sw/features/home/cubit/home_cubit.dart';
import 'package:sw/features/home/screens/home_screen.dart';
import 'package:sw/features/home/widgets/main_screen_appbar.dart';
import 'package:sw/features/home/widgets/main_screen_drawer.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';

import '../../rooms/screens/rooms_screen.dart';

class MainScreen extends HookWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var navigationScreen = [];
    var pageController =
        usePageController(keepPage: false, initialPage: 0, viewportFraction: 1);
    useEffect(() {
      navigationScreen = [
        const HomeScreen(
            // onPlayNowPressed: () {
            //   pageController.animateToPage(
            //     2,
            //     duration: const Duration(milliseconds: 500),
            //     curve: Curves.easeInOut,
            //   );
            // },
            ),
        const RoomsScreen(),
        const ProfileScreen(),
      ];

      return () {};
    });
    var currentindex = useState(0);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => RoomCubit()),
      ],
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 36, 36, 42),
          appBar: const MainScreenAppBar(),
          drawer: const MainScreenDrawer(),
          bottomNavigationBar: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 30, 30, 36),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: SlidingClippedNavBar.colorful(
              backgroundColor: Colors.transparent,
              barItems: [
                BarItem(
                  title: currentindex.value == 0 ? "الرئيسية" : "",
                  icon: Icons.home,
                  inactiveColor: AppColors.primaryColor,
                  activeColor: AppColors.primaryColor,
                ),
                BarItem(
                  title: currentindex.value == 1 ? "الغرف" : "",
                  icon: Icons.chat,
                  inactiveColor: AppColors.primaryColor,
                  activeColor: AppColors.primaryColor,
                ),
                BarItem(
                  title: currentindex.value == 2 ? "الحساب" : "",
                  icon: Icons.person,
                  inactiveColor: AppColors.primaryColor,
                  activeColor: AppColors.primaryColor,
                ),
              ],
              onButtonPressed: (index) {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
                currentindex.value = index;
              },
              selectedIndex: currentindex.value,
            ),
          ),
          body: PageView.builder(
              onPageChanged: (value) {
                currentindex.value = value;
              },
              padEnds: false,
              controller: pageController,
              itemCount: navigationScreen.length,
              itemBuilder: (context, index) => navigationScreen[index])),
    );
  }
}
