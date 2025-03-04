import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sw/common/components/loading.dart';
import 'package:sw/common/utils/cache_helper.dart';

import 'package:sw/features/auth/models/user_model.dart';
import 'package:sw/features/home/cubit/home_cubit.dart';
import '../../../common/components/helpers.dart';
import '../../stores/store_main_screen.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel user = UserModel.fromJson(
      jsonDecode(CacheHelper.getCache(key: 'user')),
    );
    Future<void> pickImage(BuildContext context) async {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        context.read<HomeCubit>().uploadProfileImage(imageFile);
      }
    }

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        String? imageUrl;
        if (state is ProfileImageUploaded) {
          imageUrl = state.imageUrl;
          user.image = imageUrl;
          CacheHelper.setString(key: 'user', value: jsonEncode(user));
          // CacheHelper.saveCache(key: 'user_image', value: imageUrl);
        } else {
          imageUrl = user.image;
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundImage: imageUrl == null
                            ? const AssetImage(
                                    'images/images/default-profile.jpg')
                                as ImageProvider
                            : NetworkImage(imageUrl),
                        radius: 80,
                      ),
                      InkWell(
                        onTap: () => pickImage(context),
                        child: const CircleAvatar(
                          child: Icon(
                            Icons.photo_camera_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                      if (state is ProfileImageUploading)
                        const Positioned.fill(
                          child: Loading(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "${user.fullName}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.white),
                    const SizedBox(height: 5),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         const Icon(
                    //           Icons.location_on,
                    //           size: 25,
                    //           color: Color.fromARGB(255, 255, 210, 63),
                    //         ),
                    //         const SizedBox(height: 4),
                    //         Text(
                    //           "${user.country}",
                    //           style: const TextStyle(
                    //               fontWeight: FontWeight.w400,
                    //               color: Colors.white),
                    //         )
                    //       ],
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         showGeneralDialog(
                    //           context: context,
                    //           transitionBuilder: (context, animation,
                    //                   secondaryAnimation, child) =>
                    //               Transform.scale(
                    //             scale: animation.value,
                    //             alignment: Alignment.bottomCenter,
                    //             child: child,
                    //           ),
                    //           transitionDuration:
                    //               const Duration(milliseconds: 350),
                    //           pageBuilder:
                    //               (context, animation, secondryAnimation) =>
                    //                   AppDialog(
                    //             body: const [
                    //               Text(
                    //                 "حساب الماسي لغاية 2/4/2112",
                    //                 style: TextStyle(color: Colors.white),
                    //               )
                    //             ],
                    //             actions: [
                    //               TextButton(
                    //                 onPressed: () {},
                    //                 child: const Text(
                    //                   "إغلاق",
                    //                   style: TextStyle(color: Colors.white),
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         );
                    //       },
                    //       child: const Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(
                    //             Icons.diamond_outlined,
                    //             color: Colors.deepPurpleAccent,
                    //             size: 35,
                    //           ),
                    //           SizedBox(height: 4),
                    //           Text(
                    //             "غير مفعل",
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.w400,
                    //                 color: Colors.white),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(
                    //           user.points! == 0
                    //               ? Icons.heart_broken
                    //               : Icons.favorite,
                    //           size: 25,
                    //           color: Colors.red,
                    //         ),
                    //         const SizedBox(height: 4),
                    //         Text(
                    //           "${user.points!}",
                    //           style: const TextStyle(
                    //               fontWeight: FontWeight.w400,
                    //               color: Colors.white),
                    //         )
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 50),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StoreMainScreen(),
                            ),
                          );
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
              ],
            ),
          ),
        );
      },
    );
  }
}
