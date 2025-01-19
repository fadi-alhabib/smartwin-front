import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartwin/stores/my_store/my_store_profile/my_store_screen.dart';
import 'package:smartwin/stores/products/products_screen.dart';
import 'package:smartwin/stores/all_stores/store_home_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:smartwin/theme/colors.dart';

import '../components/page_transformer.dart';

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
                      "نقاطي:",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "2",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ))
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
                inactiveColor: AppColors.primaryColor,
                activeColor: AppColors.primaryColor,
              ),
              BarItem(
                title: currentindex.value == 1 ? "المنتجات" : "",
                icon: CupertinoIcons.cart,
                inactiveColor: AppColors.primaryColor,
                activeColor: AppColors.primaryColor,
              ),
              BarItem(
                title: currentindex.value == 2 ? "متجري" : "",
                icon: Icons.person,
                inactiveColor: AppColors.primaryColor,
                activeColor: AppColors.primaryColor,
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
