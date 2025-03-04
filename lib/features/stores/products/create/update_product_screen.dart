import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sw/common/components/loading.dart';
import 'package:sw/features/stores/all_stores/cubit/stores_cubit.dart';
import 'package:sw/features/stores/products/create/cubit/create_product_cubit.dart';

import '../../../../common/components/button_animated.dart';
import '../../../../common/components/helpers.dart';
import '../../../../common/components/text_field.dart';

class UpdateProductScreen extends HookWidget {
  final String name;
  final String price;
  final String description;
  final String id;
  // Original images list: each element should have an `id` and an `image` (URL) property.
  final List originalImages;

  UpdateProductScreen({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.originalImages,
    required this.id,
  });

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Initialize a list of 4 slots.
    // If an original image exists for a slot, we use its URL; otherwise, the slot is null.
    final images = useState<List<dynamic>>(
      List.generate(4, (index) {
        if (originalImages.length > index) {
          return originalImages[index].image; // The URL string
        }
        return null;
      }),
    );

    final productNameController = useTextEditingController(text: name);
    final productPriceController = useTextEditingController(text: price);
    final productDescriptionController =
        useTextEditingController(text: description);

    // Get the cubit instance.
    final cubit = CreateProductCubit().get(context);

    /// Opens the image picker and, if an image is selected, sends the add-image request.
    Future<void> pickAndAddImage(int index) async {
      final pickedFile = await Navigator.push<XFile?>(
        context,
        MaterialPageRoute(
          builder: (context) => const SingleImagePickerScreen(),
        ),
      );
      if (pickedFile != null) {
        // Send the request to add the new image.
        await cubit.addImageToProduct(pickedFile.path, int.parse(id));
        // Update the UI with the new image (it will display the local file).
        final updatedList = List<dynamic>.from(images.value);
        updatedList[index] = pickedFile;
        images.value = updatedList;
      }
    }

    /// Sends a deletion request for the image at the given slot.
    Future<void> deleteImageAtIndex(int index) async {
      final dynamic imageItem = images.value[index];
      // If the image is original (a URL) and exists in the originalImages list:
      if (imageItem is String &&
          originalImages.length > index &&
          originalImages[index] != null) {
        final oldImageId = originalImages[index].id;
        if (oldImageId != null) {
          await cubit.deleteImage(oldImageId);
        }
      }
      // For both original and new images, clear the slot.
      final updatedList = List<dynamic>.from(images.value);
      updatedList[index] = null;
      images.value = updatedList;
    }

    /// Builds an image slot with overlay buttons.
    /// - If an image exists, displays it with a trash icon.
    /// - If the slot is empty, shows a plus icon.
    Widget buildImageSlot(int index, {bool isBig = false}) {
      final dynamic imageItem = images.value[index];
      return GestureDetector(
        // Only allow tap on an empty slot.
        onTap: () async {
          if (imageItem == null) {
            await pickAndAddImage(index);
          }
        },
        child: Stack(
          children: [
            Container(
              width: isBig ? getScreenSize(context).width : null,
              height: isBig
                  ? getScreenSize(context).height / 3
                  : getScreenSize(context).height / 7,
              color: Colors.grey.shade300,
              child: imageItem is XFile
                  ? Image.file(
                      File(imageItem.path),
                      fit: BoxFit.cover,
                    )
                  : imageItem is String
                      ? Image.network(
                          imageItem,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
            ),
            // If an image exists, show the trash icon.
            if (imageItem != null)
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await deleteImageAtIndex(index);
                  },
                ),
              ),
          ],
        ),
      );
    }

    return BlocProvider(
      create: (context) => CreateProductCubit(),
      child: BlocConsumer<CreateProductCubit, CreateProductState>(
        listener: (context, state) {
          // Handle any state changes if needed.
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 36, 36, 42),
            appBar: AppBar(
              title: const Text(
                "تعديل منتج",
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
                    // Images section: one large image and three smaller ones.
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          buildImageSlot(0, isBig: true),
                          const Gap(8.0),
                          Row(
                            children: List.generate(3, (i) {
                              final index = i + 1;
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: i < 2 ? 4.0 : 0.0,
                                    left: i > 0 ? 4.0 : 0.0,
                                  ),
                                  child: buildImageSlot(index),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    // Error message if not all image slots are filled.
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
                    // Text fields for product info.
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
                    state is UpdateProductLoadingState ||
                            state is ProductImageLoading
                        ? Loading()
                        : AnimatedButton(
                            onTap: () async {
                              if (formKey.currentState!.validate() &&
                                  images.value
                                      .every((element) => element != null)) {
                                // Update the product details.
                                await cubit.updateProduct(
                                  name: productNameController.text,
                                  description:
                                      productDescriptionController.text,
                                  price: productPriceController.text,
                                  id: id,
                                );
                                // Refresh the store and pop the screen.
                                AllStoresCubit().get(context).getUserStore();
                                Navigator.of(context).pop();
                              }
                            },
                            scaleAnimation: true,
                            translateAnimation: false,
                            child: SizedBox(
                              width: getScreenSize(context).width / 2,
                              child: const Center(child: Text("تعديل")),
                            ),
                          ),
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

/// A simple screen used to pick a single image from the gallery.
/// When an image is selected, it pops and returns the picked file.
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
