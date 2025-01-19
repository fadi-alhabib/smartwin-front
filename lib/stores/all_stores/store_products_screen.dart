import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwin/components/app_dialog.dart';
import 'package:smartwin/components/grid_view_builder.dart';
import 'package:smartwin/components/store_item_builder.dart';
import 'package:smartwin/constants.dart';
import 'package:smartwin/stores/all_stores/cubit/stores_cubit.dart';
import 'package:smartwin/stores/all_stores/cubit/stores_states.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:smartwin/theme/colors.dart';

class StoreProductsScreen extends HookWidget {
  StoreProductsScreen({super.key, required this.index});
  int index;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllStoresCubit, AllStoresStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // ignore: non_constant_identifier_names
        var AllStoresModel = AllStoresCubit().get(context).allStoresModel;
        var isActive = AllStoresModel!.stores[index].isActive;
        var image = AllStoresModel.stores[index].image;
        var points = AllStoresModel.stores[index].points;
        var rating = AllStoresModel.stores[index].rating;
        var products = AllStoresModel.stores[index].products;
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 36, 36, 42),
            appBar: AppBar(
              foregroundColor: AppColors.primaryColor,
              centerTitle: false,
              title: const Text(
                "Smart win",
                style: TextStyle(
                    color: AppColors.primaryColor, fontStyle: FontStyle.italic),
              ),
              actions: const [
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "نقاطي:",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "2",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ))
              ],
            ),
            body: Padding(
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
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(baseUrl + image!),
                        radius: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${AllStoresModel.stores[index].name}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        ),
                        Text(
                          "${AllStoresModel.stores[index].type}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.primaryColor,
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                rating == 0
                                    ? const Icon(
                                        Icons.star,
                                        size: 25,
                                        color:
                                            Color.fromARGB(255, 117, 106, 76),
                                      )
                                    : const Icon(
                                        Icons.star,
                                        size: 25,
                                        color: Colors.amber,
                                      ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "$rating",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 25,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AllStoresModel.stores[index].country!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                points == 0
                                    ? const Icon(
                                        Icons.heart_broken,
                                        size: 25,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite,
                                        size: 25,
                                        color: Colors.red,
                                      ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "$points نقطة",
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
                        // const Divider(color: Colors.white),

                        const Text(
                          "المنتجات",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GridViewBuilder(
                            itemBuilder: (context, index) =>
                                AnimationConfiguration.staggeredGrid(
                                    duration: const Duration(milliseconds: 500),
                                    columnCount: 2,
                                    position: index,
                                    child: ScaleAnimation(
                                        child: StoreItemBuilder(
                                      imageUrl:
                                          baseUrl + products[index].image!,
                                      title: "${products[index].name}",
                                      country: "",
                                      description:
                                          "${products[index].description}",
                                      rateWidget: false,
                                      priceWidget: true,
                                      price: "${products[index].price}",
                                    ))),
                            crossAxisCount: 2,
                            itemCount: products.length)
                      ],
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
