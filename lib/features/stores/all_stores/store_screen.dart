import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sw/common/components/loading.dart';

import '../../../common/components/grid_view_builder.dart';
import '../../../common/components/store_item_builder.dart';
import '../products/product_details_screen.dart';
import 'cubit/stores_cubit.dart';
import 'cubit/stores_states.dart';

class StoreScreen extends HookWidget {
  final int id;
  const StoreScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<AllStoresCubit>().getStore(id);
      return null;
    }, const []);
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 36, 36, 42),
        appBar: AppBar(
          foregroundColor: const Color.fromARGB(255, 255, 210, 63),
          centerTitle: false,
          title: const Text(
            "Smart win",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Share.share("https://fazetarab.com/api/stores/$id");
                },
                icon: Icon(Icons.share))
          ],
        ),
        body: BlocConsumer<AllStoresCubit, AllStoresStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var controller = AllStoresCubit().get(context);
            var model = controller.storeDetails;
            return BuildCondition(
                condition: model != null,
                fallback: (context) => Loading(),
                builder: (context) {
                  return Padding(
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
                              backgroundImage:
                                  NetworkImage("${model?.store?.image}"),
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
                                "${model?.store?.name}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30),
                              ),
                              Text(
                                "${model?.store?.type}",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 25,
                                        color:
                                            Color.fromARGB(255, 255, 210, 63),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${model?.store?.country}",
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
                                      model?.store?.points == 0
                                          ? const Icon(
                                              Icons.heart_broken,
                                              size: 25,
                                              color: Colors.red,
                                            )
                                          : Lottie.asset(
                                              'images/animations/coin.json'),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "${model?.store?.points}",
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

                              const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "المنتجات",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GridViewBuilder(
                                  itemBuilder: (context, index) =>
                                      AnimationConfiguration.staggeredGrid(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          columnCount: 2,
                                          position: index,
                                          child: ScaleAnimation(
                                              child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailsScreen(
                                                            productId: model
                                                                .store!
                                                                .products[index]
                                                                .id!),
                                                  ));
                                            },
                                            child: StoreItemBuilder(
                                              imageUrl: model
                                                  .store!
                                                  .products[index]
                                                  .images![0]
                                                  .image!,
                                              title:
                                                  "${model.store?.products[index].name}",
                                              country: "",
                                              description:
                                                  "${model.store?.products[index].description}",
                                              rateWidget: false,
                                              priceWidget: true,
                                              price:
                                                  "${model.store?.products[index].price}",
                                            ),
                                          ))),
                                  crossAxisCount: 2,
                                  itemCount: model!.store!.products.length)
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
