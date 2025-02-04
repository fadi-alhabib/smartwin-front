import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sw/common/components/button_animated.dart' hide ScaleAnimation;
import 'package:sw/common/components/logo.dart';
import 'package:sw/common/components/text_field.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/common/components/helpers.dart';

import 'package:sw/features/rooms/cubit/room_cubit.dart';

class CreateRoomScreen extends HookWidget {
  const CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final imageFile = useState<XFile?>(null);

    Future<void> pickImage() async {
      try {
        final pickedFile = await ImagePicker()
            .pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 800,
        )
            .onError((error, stackTrace) {
          debugPrint('ImagePicker Error: $error');
          return null;
        });

        if (pickedFile != null) {
          imageFile.value = pickedFile;
        }
      } catch (e) {
        debugPrint('ImagePicker Exception: $e');
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Logo(
              width: getScreenSize(context).width,
              height: getScreenSize(context).height * 0.2,
            ),
            const Text(
              "إنشاء غرفة",
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            AnimationConfiguration.synchronized(
              duration: const Duration(milliseconds: 350),
              child: ScaleAnimation(
                child: Column(
                  children: [
                    MyTextField(
                      controller: nameController,
                      prefix: const Icon(Icons.meeting_room),
                      lable: const Text("اسم الغرفة"),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: imageFile.value != null
                            ? Image.file(File(imageFile.value!.path),
                                fit: BoxFit.cover)
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      color: AppColors.primaryColor),
                                  SizedBox(height: 10),
                                  Text(
                                    "اختر صورة للغرفة",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: getScreenSize(context).width,
              child: AnimatedButton(
                scaleAnimation: false,
                translateAnimation: false,
                onTap: () {
                  if (nameController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('خطأ'),
                        content: const Text('يرجى إدخال اسم الغرفة'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('حسناً'),
                          ),
                        ],
                      ),
                    );
                  } else if (imageFile.value == null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('خطأ'),
                        content: const Text('يرجى اختيار صورة للغرفة'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('حسناً'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    context.read<RoomCubit>().createRoom(
                          name: nameController.text.trim(),
                          imageFile: imageFile.value!,
                        );
                  }
                },
                margin: const EdgeInsets.all(20),
                child: Center(
                  child: BlocConsumer<RoomCubit, RoomState>(
                    listener: (context, state) {
                      if (state is RoomError) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('خطأ'),
                            content: Text(state.message),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('حسناً'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is RoomLoading) {
                        return const CircularProgressIndicator();
                      }
                      return const Text(
                        'إنشاء الغرفة',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
