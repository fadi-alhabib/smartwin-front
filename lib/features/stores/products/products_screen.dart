import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../common/components/grid_view_builder.dart';
import '../../../common/components/store_item_builder.dart';
import '../../../common/constants/constants.dart';
import '../all_stores/cubit/stores_cubit.dart';
import '../all_stores/cubit/stores_states.dart';
import 'product_details_screen.dart';

class ProductsScreen extends HookWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllStoresCubit, AllStoresStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = AllStoresCubit().get(context).allProductsModel?.products;
        var model = AllStoresCubit().get(context).allProductsModel;
        return ConditionalBuilder(
          fallback: (context) => const Center(
              child: CircularProgressIndicator(
            color: Colors.yellow,
          )),
          condition: model != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "سلع المتاجر",
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
                                  child: GestureDetector(
                                onTap: () {
                                  AllStoresCubit()
                                      .get(context)
                                      .getProductDetails(id: cubit[index].id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsScreen(),
                                      ));
                                },
                                child: StoreItemBuilder(
                                  imageUrl: baseUrl + "${cubit[index].image}",
                                  title: "${cubit[index].name}",
                                  country: "${cubit[index].store?.address}",
                                  description: "${cubit[index].description}",
                                  rateWidget: false,
                                  priceWidget: true,
                                  price: "${cubit[index].price}",
                                ),
                              ))),
                      crossAxisCount: 2,
                      itemCount: cubit!.length)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildProduct(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: const DecorationImage(
                image: NetworkImage(
                  "https://th.bing.com/th/id/OIP.HlMkQ5ocVv5uP0i1zMjiYAHaHa?rs=1&pid=ImgDetMain",
                ),
              )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "آيفون 14 برو",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              Text(
                "❤️1000",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              )
            ],
          ),
        )
      ],
    );
  }
}
