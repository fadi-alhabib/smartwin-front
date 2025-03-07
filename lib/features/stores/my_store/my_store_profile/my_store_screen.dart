import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:sw/common/components/loading.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/stores/products/create/update_product_screen.dart';

import '../../../../common/components/app_dialog.dart';
import '../../../../common/components/grid_view_builder.dart';
import '../../../../common/components/helpers.dart';
import '../../../../common/components/store_item_builder.dart';
import '../../all_stores/cubit/stores_cubit.dart';
import '../../all_stores/cubit/stores_states.dart';
import '../../products/create/create_product_screen.dart';
import '../../products/product_details_screen.dart';
import '../creat_store/create_store_screen.dart';

class MyStoreScreen extends HookWidget {
  const MyStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      AllStoresCubit().get(context).getUserStore();
      return null;
    }, []);
    return BlocConsumer<AllStoresCubit, AllStoresStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = AllStoresCubit().get(context).ueserStoreModle;
        var image = AllStoresCubit().get(context).ueserStoreModle?.store?.image;
        var name = AllStoresCubit().get(context).ueserStoreModle?.store?.name;
        var type = AllStoresCubit().get(context).ueserStoreModle?.store?.type;
        var products =
            AllStoresCubit().get(context).ueserStoreModle?.store?.products;
        var isActive =
            AllStoresCubit().get(context).ueserStoreModle?.store?.isActive;
        var points =
            AllStoresCubit().get(context).ueserStoreModle?.store?.points;

        var address =
            AllStoresCubit().get(context).ueserStoreModle?.store?.address;

        return ConditionalBuilder(
          condition: model != null,
          fallback: (context) => AllStoresCubit().get(context).noStore
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("يمكنك إنشاء متجرك الخاص",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateStoreScreen(),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: getScreenSize(context).width / 3,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "إنشاء متجر",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Loading(),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(image.toString()),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "$name",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30),
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Text(
                                  "${model?.store?.country}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 210, 63),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                const Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Color.fromARGB(255, 255, 210, 63),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "$type",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 210, 63),
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
                                  body: [
                                    Text(
                                      isActive == 0
                                          ? 'متجرك غير مفعل يرجى التواصل معنا للتفعيل'
                                          : "متجرك مفعل و يظهر في قائمة المتاجر",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "إغلاق",
                                          style: TextStyle(
                                              color: AppColors.primaryColor),
                                        ))
                                  ],
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isActive == 0
                                      ? Icons.highlight_off_outlined
                                      : Icons.task_alt,
                                  size: 25,
                                  color:
                                      isActive == 0 ? Colors.red : Colors.green,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  isActive == 0 ? "غير مفعل" : "تم التفعيل",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('images/animations/coin.json',
                                  width: 40),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                "$points",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(color: Colors.white),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateStoreScreen(
                              update: true,
                              name: name,
                              address: address,
                              type: type,
                              phone: model?.store?.phone,
                              networkImage: image,
                              id: "${model?.store?.id}",
                              country: model?.store?.country,
                            ),
                          ));
                        },
                        child: Row(
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
                            Gap(5),
                            const Text(
                              "تعديل معلومات المتجر",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "منتجاتي",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CreateProductScreen(),
                                ));
                              },
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.blue,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      products!.isNotEmpty
                          ? GridViewBuilder(
                              itemBuilder: (context, index) =>
                                  AnimationConfiguration.staggeredGrid(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      columnCount: 2,
                                      position: index,
                                      child: ScaleAnimation(
                                          child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailsScreen(
                                                      isProfile: true,
                                                      productId:
                                                          products[index].id!,
                                                    ),
                                                  ));
                                            },
                                            child: StoreItemBuilder(
                                              imageUrl: products[index]
                                                  .images![0]
                                                  .image!,
                                              title: products[index].name!,
                                              country: "",
                                              description: "",
                                              rateWidget: false,
                                              priceWidget: true,
                                              price: products[index].price,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) => UpdateProductScreen(
                                                            name: products[
                                                                    index]
                                                                .name!,
                                                            price:
                                                                products[index]
                                                                    .price!,
                                                            description:
                                                                products[index]
                                                                    .description!,
                                                            originalImages:
                                                                products[index]
                                                                    .images!,
                                                            id: products[index]
                                                                .id
                                                                .toString())));
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ))
                                        ],
                                      ))),
                              crossAxisCount: 2,
                              itemCount: products.length)
                          : Center(
                              child: Column(
                                children: [
                                  const Text(
                                    "لم يتم إضافة منتجات",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            CreateProductScreen(),
                                      ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      width: getScreenSize(context).width / 3,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "أضف منتجاً",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
