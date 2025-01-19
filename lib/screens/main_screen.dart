import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:smartwin/screens/home_screen.dart';
import 'package:smartwin/screens/profile_screen.dart';
import 'package:smartwin/screens/register_screen.dart';
import 'package:smartwin/screens/room_screen.dart';
import 'package:smartwin/stores/store_main_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:smartwin/theme/colors.dart';

import '../components/helpers.dart';
import 'rooms_screen.dart';

class MainScreen extends HookWidget {
  MainScreen({super.key});

  var navigationScreen = [
    const HomeScreen(),
    const RoomScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    var pageController =
        usePageController(keepPage: false, initialPage: 0, viewportFraction: 1);
    var currentindex = useState(0);
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 36, 36, 42),
        appBar: AppBar(
          foregroundColor: AppColors.primaryColor,
          centerTitle: false,
          title: const Text(
            "Smart win",
            style: TextStyle(
                color: AppColors.primaryColor, fontStyle: FontStyle.italic),
          ),
          actions: const [
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "2",
                      style: TextStyle(
                          color: Color.fromARGB(255, 223, 41, 53),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.favorite,
                      color: Color.fromARGB(255, 223, 41, 53),
                    ),
                  ],
                ))
          ],
        ),
        drawer: Drawer(
          width: getScreenSize(context).width / 1.2,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25))),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 36, 36, 42),
          child: ListView(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                  color: Color.fromARGB(255, 30, 30, 36),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Smart win',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              fontSize: 25),
                        ),
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 150,
            ),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: const ListTile(
                title: Text("دعوة صديق"),
                subtitle: Text(
                  "يمكنك الحصول على نقطتين عند دعوة صديق",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 10,
                ),
                leading: CircleAvatar(child: Icon(Icons.share)),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreMainScreen(),
                    ));
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: const ListTile(
                  title: Text("المتاجر"),
                  leading: CircleAvatar(child: Icon(Icons.storefront)),
                ),
              ),
            ),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: const ListTile(
                title: Text("الشروط والاحكام"),
                leading: CircleAvatar(child: Icon(Icons.privacy_tip)),
              ),
            ),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                    (route) => false)
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: const ListTile(
                  title: Text("تسجيل خروج"),
                  leading: CircleAvatar(child: Icon(Icons.logout_outlined)),
                ),
              ),
            ),
          ]),
        ),
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
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
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
            itemBuilder: (context, index) => navigationScreen[index]));
  }
}
