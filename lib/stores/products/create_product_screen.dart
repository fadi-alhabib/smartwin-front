import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartwin/components/button_animated.dart';
import 'package:smartwin/components/helpers.dart';
import 'package:smartwin/components/text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:images_picker/images_picker.dart';
import 'package:lottie/lottie.dart';

class CreateProductScreen extends HookWidget {
  CreateProductScreen({super.key});
  var formKey = GlobalKey<FormState>();
  pickImages(images) async {
    ImagesPicker.pick(count: 3, pickType: PickType.image).then((value) {
      images.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var images = useState(<Media>[]);
    var productNameController = useTextEditingController();
    var productPriceController = useTextEditingController();
    var productDescriptionController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              images.value.length != 0
                  ? GestureDetector(
                      onTap: () {
                        pickImages(images);
                      },
                      child: showImageWidget(context, images.value))
                  : pickImageWidget(images, context),
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
              AnimatedButton(
                  onTap: () {
                    if (formKey.currentState!.validate()) {}
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
  }

  Widget showImageWidget(context, List images) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: getScreenSize(context).height / 5,
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    child: Image.file(File(images[0].path)))),
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
                              : Colors.amber),
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
                              : Colors.amber),
                      child: images.elementAtOrNull(2) != null
                          ? Image.file(File(images[2].path))
                          : null),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Padding pickImageWidget(
      ValueNotifier<List<Media>> images, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          pickImages(images);
        },
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
      ),
    );
  }
}
