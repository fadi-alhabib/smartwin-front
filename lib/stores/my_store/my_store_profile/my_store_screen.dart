import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartwin/components/app_dialog.dart';
import 'package:smartwin/components/grid_view_builder.dart';
import 'package:smartwin/components/helpers.dart';
import 'package:smartwin/components/store_item_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smartwin/theme/colors.dart';

class MyStoreScreen extends HookWidget {
  const MyStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      'images/store.jpg',
                    ),
                    radius: 80,
                  ),
                  CircleAvatar(
                      child: Icon(
                    Icons.photo_camera_outlined,
                    size: 20,
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Sears",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text(
                            "السعودية العربية",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: AppColors.primaryColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Text(
                  "اكسسوارات موبايلات وعطورات",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 12),
                ),
                const Divider(color: Colors.white),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 25,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "3.5",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.white),
                        )
                      ],
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
                          transitionDuration: const Duration(milliseconds: 350),
                          pageBuilder:
                              (context, animation, secondryAnimation) =>
                                  AppDialog(
                            body: const [
                              Text(
                                "المتجر مفعل لتاريخ 25/6/2025",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                            actions: [
                              TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "إغلاق",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        );
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //
                          Icon(
                            Icons.task_alt,
                            size: 25,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "تم التفعيل",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 25,
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "200 نقطة",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // const Divider(color: Colors.white),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 17,
                      backgroundColor: Color.fromARGB(255, 68, 68, 65),
                      child: Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "تعديل معلومات المتجر",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "منتجاتي",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                GridViewBuilder(
                    itemBuilder: (context, index) =>
                        AnimationConfiguration.staggeredGrid(
                            duration: const Duration(milliseconds: 500),
                            columnCount: 2,
                            position: index,
                            child: ScaleAnimation(
                                child: StoreItemBuilder(
                              imageUrl:
                                  "https://th.bing.com/th/id/OIP.HlMkQ5ocVv5uP0i1zMjiYAHaHa?rs=1&pid=ImgDetMain",
                              title: "أيفون 14",
                              country: "السعودية العربية",
                              description: "سييررزز",
                              rateWidget: false,
                              priceWidget: true,
                              price: "12",
                            ))),
                    crossAxisCount: 2,
                    itemCount: 15)
              ],
            )
          ],
        ),
      ),
    );
  }
}
