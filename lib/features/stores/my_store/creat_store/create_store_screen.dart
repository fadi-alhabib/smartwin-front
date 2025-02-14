import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lottie/lottie.dart';

import '../../../../common/components/button_animated.dart';
import '../../../../common/components/helpers.dart';
import '../../../../common/components/text_field.dart';
import '../../all_stores/cubit/stores_cubit.dart';
import 'cubit/create_store_cubit.dart';

class CreateStoreScreen extends HookWidget {
  CreateStoreScreen(
      {super.key,
      this.name = "",
      this.address = "",
      this.country = "",
      this.phone = "",
      this.type = "",
      this.networkImage,
      this.id,
      this.update = false});
  var formKey = GlobalKey<FormState>();
  String? name;
  String? type;
  String? country;
  String? address;
  String? phone;
  String? networkImage;
  bool update;
  String? id;
  @override
  Widget build(BuildContext context) {
    var image = useState<XFile?>(null);
    var storeNameController = useTextEditingController(text: name);
    var storeTypeController = useTextEditingController(text: type);
    var storeCountryController = useTextEditingController(text: country);
    var storeAddressController = useTextEditingController(text: address);
    var storePhoneController = useTextEditingController(text: phone);

    return BlocProvider(
      create: (context) => CreateStoreCubit(),
      child: BlocConsumer<CreateStoreCubit, CreateStoreState>(
        listener: (context, state) {
          if (state is CreateStoreSuccessState) {
            AllStoresCubit().get(context).getUserStore();
            Navigator.pop(context);
          } else if (state is CreateStoreErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("حصل خطأ حاول مرة اخرى"),
              backgroundColor: Colors.red,
            ));
          }
          if (state is UpdateStoreSuccessState) {
            AllStoresCubit().get(context).getUserStore();
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 36, 36, 42),
            appBar: AppBar(
              title: const Text(
                "إنشاء متجر",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 210, 63),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      FormField<String>(
                        initialValue: "",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return update ? null : "يجب إضافة صورة";
                          }
                        },
                        builder: (field) => Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await ImagePicker()
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) {
                                  image.value = value!;
                                  field.setValue(image.value?.path);
                                });
                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                width: getScreenSize(context).width / 3,
                                height: getScreenSize(context).height / 5,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 210, 63),
                                        Color.fromARGB(255, 255, 193, 10),
                                        Color.fromARGB(255, 230, 180, 26),
                                        Color.fromARGB(255, 214, 160, 80),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  shape: BoxShape.circle,
                                ),
                                child: update
                                    ? Image.network(networkImage.toString())
                                    : image.value != null
                                        ? Image.file(
                                            File("${image.value?.path}"),
                                            fit: BoxFit.cover,
                                          )
                                        : Lottie.asset("images/store.json"),
                              ),
                            ),
                            field.hasError
                                ? Text(
                                    field.errorText!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 14),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                      MyTextField(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        hint: "اسم المتجر",
                        controller: storeNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "اسم المتجر مطلوب";
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
                            return "نوع المتجر مطلوب";
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
                              storeCountryController.text =
                                  country.nameLocalized!;
                            },
                          );
                        },
                        controller: storeCountryController,
                        validator: (value) {
                          if (storeCountryController.text.isEmpty) {
                            return " يجب تحديد البلد";
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
                            return " عنوان المتجر مطلوب";
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
                            return "رقم التواصل مطلوب";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      state is CreateStoreLoadingState ||
                              state is UpdateStoreLoadingState
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 255, 193, 10),
                            )
                          : AnimatedButton(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  if (update) {
                                    CreateStoreCubit().get(context).updateStore(
                                        name: storeNameController.text,
                                        type: storeTypeController.text,
                                        id: id!,
                                        country: storeCountryController.text,
                                        address: storeAddressController.text,
                                        phone: storePhoneController.text,
                                        image: image.value != null
                                            ? File("${image.value?.path}")
                                            : null);
                                  } else {
                                    CreateStoreCubit().get(context).createStore(
                                        name: storeNameController.text,
                                        type: storeTypeController.text,
                                        country: storeCountryController.text,
                                        address: storeAddressController.text,
                                        phone: storePhoneController.text,
                                        image: File(image.value!.path));
                                  }
                                }
                              },
                              scaleAnimation: false,
                              translateAnimation: true,
                              child: SizedBox(
                                width: getScreenSize(context).width / 2,
                                child: Center(
                                    child: Text(update ? "تعديل" : "إنشاء")),
                              ))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
