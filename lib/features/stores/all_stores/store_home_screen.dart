import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '/common/components/grid_view_builder.dart';
import '/common/components/store_item_builder.dart';
import '/common/constants/constants.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'cubit/stores_cubit.dart';
import 'cubit/stores_states.dart';
import 'store_screen.dart';

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
                              AllStoresCubit()
                                  .get(context)
                                  .getStore(allStoresModel.stores[index].id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoreScreen(),
                                  ));
                            },
                            child: AnimationConfiguration.staggeredGrid(
                                duration: const Duration(milliseconds: 500),
                                columnCount: 2,
                                position: index,
                                child: ScaleAnimation(
                                    child: StoreItemBuilder(
                                  imageUrl:
                                      "https://i.ytimg.com/an_webp/9AmDta7HtmU/mqdefault_6s.webp?du=3000&sqp=CPz-o70G&rs=AOn4CLAdI3WOBOnBQ-cQE9lw_Tq50gGCzA",
                                  title: "${allStoresModel.stores[index].name}",
                                  country:
                                      "${allStoresModel.stores[index].country}",
                                  description:
                                      "${allStoresModel.stores[index].type}",
                                  rateWidget: true,
                                  rating: 3.toDouble(),
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
