import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:sw/common/components/button_animated.dart';
import 'package:sw/common/components/loading.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/home/widgets/purchase_time_dialog.dart';
import 'package:sw/features/home/widgets/transfer_dialog.dart';
import 'package:sw/features/rooms/screens/room_screen.dart';
import 'package:sw/features/home/cubit/home_cubit.dart';

import '../../../common/components/helpers.dart';
import '../../stores/store_main_screen.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<HomeCubit>().getHomeData();
      return null;
    });
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeDataLoading) {
          return Loading();
        } else if (state is HomeDataError) {
          return const Center(
            child: Text(
                'Something went wrong. Please check your internet connectivity.'),
          );
        } else if (state is HomeDataSuccess) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CarouselSlider.builder(
                          itemCount: state.data.ads!.length,
                          itemBuilder: (context, index, realIndex) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5.0),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              state.data.ads![index].path!,
                              height: getScreenSize(context).height / 3,
                              width: getScreenSize(context).width,
                              fit: BoxFit.cover,
                            ),
                          ),
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            viewportFraction: 0.9,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            if (state.data.points! < 1000) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: AppColors.backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.asset(
                                          "images/animations/sad.json"),
                                      Gap(10),
                                      Text(
                                        "لا يوجد لديك نقاط كافية",
                                        style: TextStyle(
                                            color: AppColors.primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<HomeCubit>(),
                                  child: const TransferDialog(),
                                ),
                              ).then((_) =>
                                  context.read<HomeCubit>().getHomeData());
                            }
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 68, 68, 65),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: ListTile(
                              title: const Text(
                                "استبدال نقاطي",
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: const CircleAvatar(
                                child: Icon(
                                  Icons.repeat_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: const Text(""),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "${state.data.points}/1000",
                                    style: TextStyle(
                                      color: state.data.points!.toInt() == 1000
                                          ? AppColors.greenColor
                                          : state.data.points!.toInt() >= 500
                                              ? AppColors.primaryColor
                                              : AppColors.redColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${state.data.points! / 10}\$",
                                    style: TextStyle(
                                      color: AppColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoreMainScreen(),
                              ),
                            );
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 68, 68, 65),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: const ListTile(
                              title: Text(
                                "المتاجر",
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: CircleAvatar(
                                child: Icon(
                                  Icons.storefront_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                "يمكنك انشاء متجر و رؤية المتاجر الاخرى",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Removed Expanded widget to avoid forcing content beyond available space
                        Center(
                          child: SizedBox(
                            width: getScreenSize(context).width / 1.5,
                            child: AnimatedButton(
                              onTap: () {
                                // Navigate to My Room Screen or Purchase Time Dialog
                                if (state.data.availableTime == 0) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => PurchaseTimeDialog(
                                        roomId: state.data.roomId!),
                                  ).then((_) =>
                                      context.read<HomeCubit>().getHomeData());
                                  return;
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const RoomScreen(),
                                  ),
                                );
                              },
                              margin: const EdgeInsets.all(10),
                              scaleAnimation: true,
                              translateAnimation: true,
                              child: const Center(
                                child: Text(
                                  'العب الان',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
