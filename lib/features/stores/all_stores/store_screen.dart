import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sw/features/stores/all_stores/models/all_stores_model.dart';

import '../../../common/components/app_dialog.dart';
import '../../../common/components/grid_view_builder.dart';
import '../../../common/components/store_item_builder.dart';
import '../../../common/constants/constants.dart';
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
                  Share.share("http://127.0.0.1:8000/api/stores/$id");
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
                fallback: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
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
                                      GestureDetector(
                                        onTap: () {
                                          showGeneralDialog(
                                            context: context,
                                            transitionBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) =>
                                                Transform.scale(
                                              scale: animation.value,
                                              alignment: Alignment.bottomCenter,
                                              child: child,
                                            ),
                                            transitionDuration: const Duration(
                                                milliseconds: 200),
                                            pageBuilder: (context, animation,
                                                    secondryAnimation) =>
                                                HookBuilder(builder: (context) {
                                              var rate = useState(0.0);
                                              return BlocListener<
                                                  AllStoresCubit,
                                                  AllStoresStates>(
                                                listener: (context, state) {
                                                  if (state
                                                      is RatingSroreSuccessState) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: AppDialog(
                                                  body: [
                                                    Column(
                                                      children: [
                                                        const Text(
                                                            "قم بتقييم المتجر",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white)),
                                                        const Gap(10),
                                                        Center(
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12),
                                                                child:
                                                                    RatingStars(
                                                                  value: rate
                                                                      .value,
                                                                  starOffColor:
                                                                      const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          36,
                                                                          36,
                                                                          42),
                                                                  starColor:
                                                                      Colors
                                                                          .white,
                                                                  starSpacing:
                                                                      7,
                                                                  starSize: 30,
                                                                  maxValueVisibility:
                                                                      false,
                                                                  valueLabelVisibility:
                                                                      false,
                                                                  animationDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              1500),
                                                                  onValueChanged:
                                                                      (value) {
                                                                    // putRate(
                                                                    //     id: id,
                                                                    //     rating:
                                                                    //         value.round());

                                                                    rate.value =
                                                                        value;
                                                                    print(rate
                                                                        .value);
                                                                  },
                                                                  maxValue: 5,
                                                                  starCount: 5,
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                  actions: [],
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                        child: Icon(
                                          Icons.star,
                                          size: 25,
                                          color: model?.store?.rating == 0
                                              ? const Color.fromARGB(
                                                  255, 117, 106, 76)
                                              : Colors.amber,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "${model?.store?.rating}",
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
                                          : const Icon(
                                              Icons.favorite,
                                              size: 25,
                                              color: Colors.red,
                                            ),
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
                                              AllStoresCubit()
                                                  .get(context)
                                                  .getProductDetails(
                                                      id: model?.store
                                                          ?.products[index].id);

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailsScreen(),
                                                  ));
                                            },
                                            child: StoreItemBuilder(
                                              imageUrl:
                                                  "${model?.store!.products[index].images![0].image!}",
                                              title:
                                                  "${model?.store?.products[index].name}",
                                              country: "",
                                              description:
                                                  "${model?.store?.products[index].description}",
                                              rateWidget: false,
                                              priceWidget: true,
                                              price:
                                                  "${model?.store?.products[index].price}",
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
