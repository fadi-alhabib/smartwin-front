import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gap/gap.dart';

import '../all_stores/cubit/stores_cubit.dart';
import '../all_stores/cubit/stores_states.dart';

class ProductDetailsScreen extends HookWidget {
  bool isProfile;

  ProductDetailsScreen({super.key, this.isProfile = false});
  @override
  Widget build(BuildContext context) {
    var rate = useState(0.0);

    return BlocConsumer<AllStoresCubit, AllStoresStates>(
      listener: (context, state) {
        if (state is RatingProductSuccessState) {
          AllStoresCubit().get(context).getProductDetails(id: state.id);
        }
      },
      builder: (context, state) {
        var controller = AllStoresCubit().get(context);
        var model = AllStoresCubit().get(context).productDetailsModel;
        var product =
            AllStoresCubit().get(context).productDetailsModel?.product;
        var rating =
            AllStoresCubit().get(context).productDetailsModel?.product?.rate;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "معلومات المنتج",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
              Row(
                children: [
                  Text("${rating ?? 0.0}"),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ],
              )
            ],
          ),
          body: ConditionalBuilder(
            condition: model != null,
            fallback: (context) => const Center(
              child: CircularProgressIndicator(
                color: Colors.yellow,
              ),
            ),
            builder: (context) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                      items:
                          product?.images.map((e) => Image.network(e)).toList()
                            ?..add(Image.network("${product?.image}")),
                      options: CarouselOptions(
                        autoPlay: product!.images.isNotEmpty,
                        viewportFraction: 1.0,
                      )),
                  const Gap(10),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${product.name}",
                              style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${product.price}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Gap(5),
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ],
                            )
                          ],
                        ),
                        const Divider(color: Colors.white),
                        const Gap(10),
                        const Text(
                          "الوصف",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "${product.description}",
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  Gap(60),
                  isProfile
                      ? const SizedBox()
                      : !(model!.product!.userHasRated!)
                          ? Center(
                              child: Column(
                                children: [
                                  const Text("قم بتقييم المنتج",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  const Gap(10),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: RatingStars(
                                          value: rate.value,
                                          starOffColor: const Color.fromARGB(
                                              255, 36, 36, 42),
                                          starColor: Colors.white,
                                          starSpacing: 7,
                                          starSize: 30,
                                          maxValueVisibility: false,
                                          valueLabelVisibility: false,
                                          animationDuration:
                                              Duration(milliseconds: 1500),
                                          onValueChanged: (value) {
                                            controller.ratingProduct(
                                                id: product.id!,
                                                rating: value.round());

                                            rate.value = value;
                                            print(rate.value);
                                          },
                                          maxValue: 5,
                                          starCount: 5,
                                        ),
                                      )),
                                ],
                              ),
                            )
                          : SizedBox()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
