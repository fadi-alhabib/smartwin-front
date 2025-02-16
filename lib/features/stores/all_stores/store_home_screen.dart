import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '/common/components/store_item_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'cubit/stores_cubit.dart';
import 'cubit/stores_states.dart';
import 'store_screen.dart';

class StoreHomeScreen extends HookWidget {
  const StoreHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      AllStoresCubit().get(context).getAllStores();
      return null;
    }, []);

    return BlocConsumer<AllStoresCubit, AllStoresStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AllStoresCubit().get(context);
        var allStoresModel = cubit.allStoresModel;

        return ConditionalBuilder(
          fallback: (context) => const Center(
              child: CircularProgressIndicator(
            color: Colors.yellow,
          )),
          condition: allStoresModel != null,
          builder: (context) => NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              // Check if we are at the bottom of the list.
              if (scrollInfo is ScrollEndNotification &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !cubit.isLoading) {
                // Load more data when user reaches bottom.
                cubit.getAllStores();
              }
              return false;
            },
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "المتاجر",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                GridView.builder(
                  itemCount: allStoresModel!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      //TODO::

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StoreScreen(allStoresModel[index].id!),
                        ),
                      );
                    },
                    child: AnimationConfiguration.staggeredGrid(
                      duration: const Duration(milliseconds: 500),
                      columnCount: 2,
                      position: index,
                      child: ScaleAnimation(
                        child: StoreItemBuilder(
                          imageUrl: "${allStoresModel[index].image}",
                          title: "${allStoresModel[index].name}",
                          country: "${allStoresModel[index].country}",
                          description: "${allStoresModel[index].type}",
                          rateWidget: true,
                          rating: 3.toDouble(),
                          priceWidget: false,
                        ),
                      ),
                    ),
                  ),
                  shrinkWrap: true, // Ensures GridView doesn't take extra space
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable grid scroll
                ),
                if (state is AllStoresLoadingState) ...[
                  const Center(child: CircularProgressIndicator()),
                ],
                // Show a loading indicator at the bottom when more data is being loaded
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
