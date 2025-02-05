import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sw/common/components/app_dialog.dart';
import 'package:sw/common/components/button_animated.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/rooms/screens/room_screen.dart';
import 'package:sw/features/home/cubit/home_cubit.dart';
import 'package:sw/features/stores/cubit/stores_cubit.dart';
import 'package:sw/features/stores/screens/store_main_screen.dart';

import '../../../common/components/helpers.dart';

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
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        } else if (state is HomeDataError) {
          return const Center(
            child:
                Text('Something wrong happend check you internet connectivity'),
          );
        } else if (state is HomeDataSuccess) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                CarouselSlider.builder(
                    itemCount: state.data.ads!.length,
                    itemBuilder: (context, index, realIndex) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          state.data.ads![index].path!,
                          height: getScreenSize(context).height / 3,
                          width: getScreenSize(context).width,
                          fit: BoxFit.cover,
                        )),
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        viewportFraction: 0.9)),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      transitionBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              Transform.scale(
                        scale: animation.value,
                        alignment: Alignment.bottomCenter,
                        child: child,
                      ),
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (context, animation, secondryAnimation) =>
                          AppDialog(
                        body: const [
                          Text(
                            "Duis deserunt esse proident dolor. Ex elit pariatur proident ipsum incididunt ullamco occaecat magna velit. Minim eiusmod nulla qui culpa nulla amet aliqua amet officia elit dolor ut et minim. Velit quis reprehenderit ullamco reprehenderit aliquip in elit id ipsum commodo mollit. Mollit labore proident ad qui duis.",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                        actions: [
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Close",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    );
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 68, 68, 65),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: ListTile(
                      title: const Text(
                        "استبدال نقاطي",
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: const CircleAvatar(
                          child: Icon(
                        Icons.repeat_rounded,
                        color: Colors.white,
                      )),
                      subtitle: const Text(""),
                      trailing: Text(
                        "${state.data.points}/1000",
                        style: TextStyle(
                            color: state.data.points!.toInt() == 1000
                                ? AppColors.greenColor
                                : state.data.points!.toInt() >= 500
                                    ? AppColors.primaryColor
                                    : AppColors.redColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    AllStoresCubit().get(context).getAllStores();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreMainScreen(),
                        ));
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 68, 68, 65),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: const ListTile(
                      title: Text(
                        "المتاجر",
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: CircleAvatar(
                          child: Icon(
                        Icons.storefront_outlined,
                        color: Colors.white,
                      )),
                      subtitle: Text(
                        "يمكنك انشاء متجر و رؤية المتاجر الاخرى",
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                  width: getScreenSize(context).width / 1.5,
                  child: AnimatedButton(
                      onTap: () {
                        // TODO:: NAVIGATE TO MY ROOM SCREEN
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RoomScreen()));
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
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
