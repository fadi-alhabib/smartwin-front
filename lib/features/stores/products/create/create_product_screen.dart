import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sw/common/components/loading.dart';

import '../../../../common/components/button_animated.dart';
import '../../../../common/components/helpers.dart';
import '../../../../common/components/text_field.dart';
import '../../all_stores/cubit/stores_cubit.dart';
import 'cubit/create_product_cubit.dart';

class CreateProductScreen extends HookWidget {
  CreateProductScreen({super.key});

  final formKey = GlobalKey<FormState>();
  // This list will hold the converted MultipartFiles on submission.
  final List<MultipartFile> imagesFiles = [];

  @override
  Widget build(BuildContext context) {
    // Initialize a list with 4 null items.
    final images = useState<List<XFile?>>(
      List.generate(4, (_) => null),
    );
    final productNameController = useTextEditingController();
    final productPriceController = useTextEditingController();
    final productDescriptionController = useTextEditingController();

    /// Opens a new screen to pick a single image for the given index.
    Future<void> pickSingleImageAtIndex(int index) async {
      final pickedFile = await Navigator.push<XFile?>(
        context,
        MaterialPageRoute(
          builder: (context) => const SingleImagePickerScreen(),
        ),
      );
      if (pickedFile != null) {
        final list = List<XFile?>.from(images.value);
        list[index] = pickedFile;
        images.value = list;
      }
    }

    return BlocProvider(
      create: (context) => CreateProductCubit(),
      child: BlocConsumer<CreateProductCubit, CreateProductState>(
        listener: (context, state) {
          if (state is CreateProductSuccessState) {
            AllStoresCubit().get(context).getUserStore();
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 36, 36, 42),
            appBar: AppBar(
              title: const Text(
                "إنشاء منتج",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 210, 63),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // Image picking section: first image is large, the rest in a row.
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Big image slot (index 0)
                          GestureDetector(
                            onTap: () {
                              pickSingleImageAtIndex(0);
                            },
                            child: Container(
                              width: getScreenSize(context).width,
                              height: getScreenSize(context).height / 3,
                              color: Colors.grey.shade300,
                              child: images.value[0] != null
                                  ? Image.file(
                                      File(images.value[0]!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Text(
                                        "إضغط لإختيار الصورة 1",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16),
                                      ),
                                    ),
                            ),
                          ),
                          const Gap(8.0),
                          // Row of three small image slots (indexes 1, 2, 3)
                          Row(
                            children: List.generate(3, (i) {
                              final index = i + 1;
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: i < 2 ? 4.0 : 0.0,
                                    left: i > 0 ? 4.0 : 0.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      pickSingleImageAtIndex(index);
                                    },
                                    child: Container(
                                      height: getScreenSize(context).height / 7,
                                      color: Colors.grey.shade300,
                                      child: images.value[index] != null
                                          ? Image.file(
                                              File(images.value[index]!.path),
                                              fit: BoxFit.cover,
                                            )
                                          : Center(
                                              child: Text(
                                                "إضغط لإختيار الصورة ${index + 1}",
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    // Show an error message if not all images are picked.
                    Builder(builder: (context) {
                      final allImagesPicked =
                          images.value.every((element) => element != null);
                      return allImagesPicked
                          ? const SizedBox.shrink()
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "يرجى اختيار جميع الصور الأربعة",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            );
                    }),
                    MyTextField(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      controller: productNameController,
                      hint: "اسم المنتج",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                        return null;
                      },
                    ),
                    MyTextField(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      controller: productPriceController,
                      hint: "سعر المنتج",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                        return null;
                      },
                    ),
                    MyTextField(
                      expands: true,
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      controller: productDescriptionController,
                      hint: "وصف المنتج",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    state is CreateProductLoadingState
                        ? Loading()
                        : AnimatedButton(
                            onTap: () async {
                              // Ensure all images have been picked.
                              if (images.value
                                  .any((element) => element == null)) {
                                // showSnackBar(
                                //     context, "يرجى اختيار جميع الصور الأربعة");
                                return;
                              }
                              if (formKey.currentState!.validate()) {
                                imagesFiles.clear();
                                // Convert each XFile to a MultipartFile.
                                for (var image in images.value) {
                                  if (image != null) {
                                    imagesFiles.add(
                                        await MultipartFile.fromFile(
                                            image.path));
                                  }
                                }
                                CreateProductCubit().get(context).createProduct(
                                      name: productNameController.text,
                                      description:
                                          productDescriptionController.text,
                                      price: productPriceController.text,
                                      images: imagesFiles,
                                    );
                              }
                            },
                            scaleAnimation: true,
                            translateAnimation: false,
                            child: SizedBox(
                              width: getScreenSize(context).width / 2,
                              child: const Center(child: Text("إضافة")),
                            ),
                          )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// This screen is used to pick a single image.
/// When an image is selected, it pops the route returning the picked file.
class SingleImagePickerScreen extends StatelessWidget {
  const SingleImagePickerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختر صورة"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final pickedFile = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            Navigator.pop(context, pickedFile);
          },
          child: const Text("اختيار صورة"),
        ),
      ),
    );
  }
}
