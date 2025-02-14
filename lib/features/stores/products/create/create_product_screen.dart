import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lottie/lottie.dart';

import '../../../../common/components/button_animated.dart';
import '../../../../common/components/helpers.dart';
import '../../../../common/components/text_field.dart';
import '../../all_stores/cubit/stores_cubit.dart';
import 'cubit/create_product_cubit.dart';

class CreateProductScreen extends HookWidget {
  CreateProductScreen({super.key});
  var formKey = GlobalKey<FormState>();
  List<MultipartFile> imagesFiles = [];
  pickImages(images) async {
    ImagePicker()
        .pickMultiImage(
      limit: 4,
    )
        .then((value) {
      images.value = value;
      value.forEach((element) async {
        imagesFiles.add(await MultipartFile.fromFile(element.path));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var images = useState([]);
    var productNameController = useTextEditingController();
    var productPriceController = useTextEditingController();
    var productDescriptionController = useTextEditingController();
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
                    FormField(
                      builder: (field) => Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                pickImages(images);
                              },
                              child: images.value.isNotEmpty
                                  ? showImageWidget(context, images.value)
                                  : pickImageWidget(images, context)),
                          field.hasError
                              ? Text(
                                  field.errorText!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 14),
                                )
                              : const SizedBox()
                        ],
                      ),
                      initialValue: images.value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "يجب أن تضع 3 صور على الاكثر";
                        }
                        return null;
                      },
                    ),
                    MyTextField(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      controller: productNameController,
                      hint: "اسم المنتج",
                      validator: (value) {
                        if (value!.isEmpty) {
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
                        if (value!.isEmpty) {
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
                        if (value!.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    state is CreateProductLoadingState
                        ? const CircularProgressIndicator(
                            color: Colors.amber,
                          )
                        : AnimatedButton(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                CreateProductCubit().get(context).createProduct(
                                    name: productNameController.text,
                                    description:
                                        productDescriptionController.text,
                                    price: productPriceController.text,
                                    images: imagesFiles);
                                print(imagesFiles.length);
                              }
                            },
                            scaleAnimation: true,
                            translateAnimation: false,
                            child: SizedBox(
                              width: getScreenSize(context).width / 2,
                              child: const Center(child: Text("إضافة")),
                            ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget showImageWidget(context, List images) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: getScreenSize(context).height / 5,
        child: Row(
          children: [
            Container(
                width: getScreenSize(context).width / 1.5,
                height: getScreenSize(context).height / 5,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: Image.file(
                  File(images[0].path),
                  fit: BoxFit.cover,
                )),
            const Gap(7),
            Expanded(
                child: Column(
              children: [
                Expanded(
                  child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: images.elementAtOrNull(1) != null
                              ? null
                              : const Color.fromARGB(255, 68, 68, 65)),
                      child: images.elementAtOrNull(1) != null
                          ? Image.file(File(images[1].path))
                          : null),
                ),
                const Gap(5),
                Expanded(
                  child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: images.elementAtOrNull(2) != null
                              ? null
                              : const Color.fromARGB(255, 68, 68, 65)),
                      child: images.elementAtOrNull(2) != null
                          ? Image.file(File(images[2].path))
                          : null),
                ),
                const Gap(5),
                Expanded(
                  child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: images.elementAtOrNull(3) != null
                              ? null
                              : const Color.fromARGB(255, 68, 68, 65)),
                      child: images.elementAtOrNull(3) != null
                          ? Image.file(File(images[3].path))
                          : null),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Padding pickImageWidget(ValueNotifier<List> images, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey.shade300,
        width: getScreenSize(context).width,
        height: getScreenSize(context).height / 5,
        child: Column(
          children: [
            Lottie.asset(
              "images/upload.json",
              alignment: Alignment.centerLeft,
              width: getScreenSize(context).width / 2.3,
              height: getScreenSize(context).height / 6,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
