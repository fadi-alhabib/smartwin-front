import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/common/utils/cache_helper.dart';
import 'package:sw/features/stores/my_store/my_store_profile/my_store_screen.dart';

import '../../common/components/page_transformer.dart';
import 'all_stores/store_home_screen.dart';
import 'products/products_screen.dart';

class StoreMainScreen extends HookWidget {
  StoreMainScreen({super.key});
  var indexController = IndexController();
  @override
  Widget build(BuildContext context) {
    List screens = [
      const StoreHomeScreen(),
      const ProductsScreen(),
      const MyStoreScreen()
    ];

    var currentindex = useState(0);

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            "Smart win",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 210, 63),
                fontStyle: FontStyle.italic),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      CacheHelper.getCache(key: "userPoints").toString(),
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Lottie.asset('images/animations/coin.json', width: 40),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    CacheHelper.getCache(key: "userPoints").toString(),
                    style: TextStyle(
                      color: AppColors.greenColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Lottie.asset('images/animations/dollar.json'),
                ],
              ),
            )
          ],
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
                title: currentindex.value == 0 ? "المتاجر" : "",
                icon: Icons.store_sharp,
                inactiveColor: const Color.fromARGB(255, 255, 210, 63),
                activeColor: const Color.fromARGB(255, 255, 210, 63),
              ),
              BarItem(
                title: currentindex.value == 1 ? "المنتجات" : "",
                icon: CupertinoIcons.cart,
                inactiveColor: const Color.fromARGB(255, 255, 210, 63),
                activeColor: const Color.fromARGB(255, 255, 210, 63),
              ),
              BarItem(
                title: currentindex.value == 2 ? "متجري" : "",
                icon: Icons.person,
                inactiveColor: const Color.fromARGB(255, 255, 210, 63),
                activeColor: const Color.fromARGB(255, 255, 210, 63),
              ),
            ],
            onButtonPressed: (index) {
              indexController.move(index, animation: true);
            },
            selectedIndex: currentindex.value,
          ),
        ),
        body: TransformerPageView(
          duration: const Duration(milliseconds: 650),
          onPageChanged: (value) {
            currentindex.value = value!;
          },
          itemBuilder: (context, index) => screens[index],
          transformer: ZoomOutPageTransformer(),
          itemCount: screens.length,
          controller: indexController,
          curve: Curves.easeOut,
        ));
  }
}
