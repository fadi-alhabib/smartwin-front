import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwin/common/components/grid_view_builder.dart';
import 'package:smartwin/features/stores/widgets/store_item_builder.dart';
import 'package:smartwin/common/constants/constants.dart';
import 'package:smartwin/features/stores/cubit/stores_cubit.dart';
import 'package:smartwin/features/stores/cubit/stores_states.dart';
import 'package:smartwin/features/stores/screens/store_products_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class StoreHomeScreen extends HookWidget {
  const StoreHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllStoresCubit, AllStoresStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AllStoresCubit().get(context);
        var allStoresModel = AllStoresCubit().get(context).allStoresModel;

        return ConditionalBuilder(
          fallback: (context) => const Center(
              child: CircularProgressIndicator(
            color: Colors.yellow,
          )),
          condition: allStoresModel != null,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "المتاجر",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GridViewBuilder(
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoreProductsScreen(
                                      index: index,
                                    ),
                                  ));
                            },
                            child: AnimationConfiguration.staggeredGrid(
                                duration: const Duration(milliseconds: 500),
                                columnCount: 2,
                                position: index,
                                child: ScaleAnimation(
                                    child: StoreItemBuilder(
                                  imageUrl: baseUrl +
                                      allStoresModel.stores[index].image!,
                                  title: "${allStoresModel.stores[index].name}",
                                  country:
                                      "${allStoresModel.stores[index].country}",
                                  description:
                                      "${allStoresModel.stores[index].type}",
                                  rateWidget: true,
                                  rating: allStoresModel.stores[index].rating!
                                      .toDouble(),
                                  priceWidget: false,
                                ))),
                          ),
                      crossAxisCount: 2,
                      itemCount: allStoresModel!.stores.length)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
