import 'package:flutter/material.dart';
import 'package:sw/common/utils/cache_helper.dart';

import '../../../common/components/app_dialog.dart';
import '../../../common/components/helpers.dart';
import '../../../common/constants/constants.dart';
import '../../stores/all_stores/cubit/stores_cubit.dart';
import '../../stores/store_main_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(baseUrl),
                      radius: 80,
                    ),
                    const CircleAvatar(
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
                  Text(
                    "${CacheHelper.getCache(key: "first_name")} ${CacheHelper.getCache(key: "last_name")}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ),
                  const Divider(color: Colors.white),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 25,
                            color: Color.fromARGB(255, 255, 210, 63),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${CacheHelper.getCache(key: "country")}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showGeneralDialog(
                            context: context,
                            transitionBuilder: (context, animation,
                                    secondaryAnimation, child) =>
                                Transform.scale(
                              scale: animation.value,
                              alignment: Alignment.bottomCenter,
                              child: child,
                            ),
                            transitionDuration:
                                const Duration(milliseconds: 350),
                            pageBuilder:
                                (context, animation, secondryAnimation) =>
                                    AppDialog(
                              body: const [
                                Text(
                                  "حساب الماسي لغاية 2/4/2112",
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
                            Icon(
                              Icons.diamond_outlined,
                              color: Colors.deepPurpleAccent,
                              size: 35,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "غير مفعل",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            int.parse(CacheHelper.getCache(key: "points")) == 0
                                ? Icons.heart_broken
                                : Icons.favorite,
                            size: 25,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${CacheHelper.getCache(key: "points")}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        AllStoresCubit().get(context).getAllStores();
                        AllStoresCubit().get(context).getAllProducts();
                        AllStoresCubit().get(context).getUserStore();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StoreMainScreen(),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: getScreenSize(context).width / 2.7,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "الذهاب للمتجر ",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              Icon(
                                Icons.storefront,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ])));
  }
}
