import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwin/components/app_dialog.dart';
import 'package:smartwin/components/button_animated.dart';
import 'package:smartwin/constants.dart';
import 'package:smartwin/screens/question_screen.dart';
import 'package:smartwin/stores/all_stores/cubit/stores_cubit.dart';
import 'package:smartwin/stores/all_stores/cubit/stores_states.dart';
import 'package:smartwin/stores/store_main_screen.dart';
import '../components/helpers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllStoresCubit, AllStoresStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              CarouselSlider.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index, realIndex) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5.0),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        images[index],
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
                  child: const ListTile(
                    title: Text(
                      "استبدال نقاطي",
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: CircleAvatar(
                        child: Icon(
                      Icons.repeat_rounded,
                      color: Colors.white,
                    )),
                    subtitle: Text(""),
                    trailing: Text(
                      "350/1000",
                      style: TextStyle(color: Colors.green),
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
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuestionScreen(),
                          ));
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
      },
    );
  }
}
