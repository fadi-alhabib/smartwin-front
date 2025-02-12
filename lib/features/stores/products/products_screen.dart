import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sw/features/stores/all_stores/cubit/stores_cubit.dart';
import 'package:sw/features/stores/all_stores/cubit/stores_states.dart';
import '/common/components/grid_view_builder.dart';
import '/common/components/store_item_builder.dart';
import '/common/constants/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'product_details_screen.dart';

class ProductsScreen extends HookWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      // Initial fetch of products
      AllStoresCubit().get(context).getAllProducts();
      return null;
    }, const []);

    return BlocConsumer<AllStoresCubit, AllStoresStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AllStoresCubit().get(context);
        var products = cubit.allProductsModel?.products;

        return ConditionalBuilder(
          fallback: (context) => const Center(
            child: CircularProgressIndicator(
              color: Colors.yellow,
            ),
          ),
          condition: products != null,
          builder: (context) => NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              // Check if we are at the bottom of the list.
              if (scrollInfo is ScrollEndNotification &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !cubit.isLoading) {
                // Load more products when user reaches bottom.
                cubit.getAllProducts(loadMore: true);
              }
              return false;
            },
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "سلع المتاجر",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // GridView.builder inside ListView for products.
                GridView.builder(
                  itemCount: products!.length +
                      (state is AllStoresLoadingState
                          ? 1
                          : 0), // Add loading spinner
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    // Show loading spinner at the bottom when fetching more products.
                    if (state is AllStoresLoadingState &&
                        index == products.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    log(products[index].images[0].image!);
                    return GestureDetector(
                      onTap: () {
                        AllStoresCubit()
                            .get(context)
                            .getProductDetails(id: products[index].id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(),
                          ),
                        );
                      },
                      child: AnimationConfiguration.staggeredGrid(
                        duration: const Duration(milliseconds: 500),
                        columnCount: 2,
                        position: index,
                        child: ScaleAnimation(
                          child: StoreItemBuilder(
                            imageUrl: "${products[index].images[0].image}",
                            title: "${products[index].name}",
                            country: "${products[index].store?.address}",
                            description: "${products[index].description}",
                            rateWidget: false,
                            priceWidget: true,
                            price: "${products[index].price}",
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true, // Ensures GridView doesn't take extra space
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable grid scroll
                ),
                if (cubit.isLoading) ...[
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
