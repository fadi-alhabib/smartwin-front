import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sw/common/components/button_animated.dart';
import 'package:sw/common/components/helpers.dart';
import 'package:sw/common/components/text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sw/common/constants/colors.dart';

class CreateStoreScreen extends HookWidget {
  CreateStoreScreen({super.key});
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var image = useState<XFile?>(null);
    var storeNameController = useTextEditingController();
    var storeTypeController = useTextEditingController();
    var storeCountryController = useTextEditingController();
    var storeAddressController = useTextEditingController();
    var storePhoneController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      image.value = pickedFile;
                    }
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    width: getScreenSize(context).width / 3,
                    height: getScreenSize(context).height / 5,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.primaryColor,
                        Color.fromARGB(255, 255, 193, 10),
                        Color.fromARGB(255, 230, 180, 26),
                        Color.fromARGB(255, 214, 160, 80),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      shape: BoxShape.circle,
                    ),
                    child: image.value != null
                        ? Image.file(
                            File(image.value!.path),
                            fit: BoxFit.cover,
                          )
                        : Lottie.asset("images/store.json"),
                  ),
                ),
                MyTextField(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  hint: "اسم المتجر",
                  controller: storeNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "هذا الحقل مطلوب";
                    }
                    return null;
                  },
                ),
                MyTextField(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  hint: "نوع المتجر",
                  controller: storeTypeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "هذا الحقل مطلوب";
                    }
                    return null;
                  },
                ),
                MyTextField(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  hint: "البلد",
                  keyboardType: TextInputType.none,
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      onSelect: (Country country) {
                        storeCountryController.text = country.nameLocalized!;
                      },
                    );
                  },
                  controller: storeCountryController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "هذا الحقل مطلوب";
                    }
                    return null;
                  },
                ),
                MyTextField(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  hint: "عنوان المتجر",
                  controller: storeAddressController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "هذا الحقل مطلوب";
                    }
                    return null;
                  },
                ),
                MyTextField(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  hint: "رقم التواصل",
                  controller: storePhoneController,
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
                    scaleAnimation: false,
                    translateAnimation: true,
                    child: SizedBox(
                      width: getScreenSize(context).width / 2,
                      child: const Center(child: Text("إنشاء")),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
