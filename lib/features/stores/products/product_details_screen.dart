import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:sw/common/components/helpers.dart';
import 'package:sw/common/components/loading.dart';
import 'package:sw/common/constants/colors.dart';

import '../all_stores/cubit/stores_cubit.dart';
import '../all_stores/cubit/stores_states.dart';

class ProductDetailsScreen extends HookWidget {
  final bool isProfile;
  final int productId;

  const ProductDetailsScreen({
    super.key,
    this.isProfile = false,
    required this.productId,
  });
  @override
  Widget build(BuildContext context) {
    var rate = useState(0.0);
    useEffect(() {
      AllStoresCubit().get(context).getProductDetails(id: productId);
      return null;
    }, const []);
    return BlocConsumer<AllStoresCubit, AllStoresStates>(
      listener: (context, state) {
        if (state is RatingProductSuccessState) {
          AllStoresCubit().get(context).getProductDetails(id: state.id);
        }
      },
      builder: (context, state) {
        var controller = AllStoresCubit().get(context);

        var product =
            AllStoresCubit().get(context).productDetailsModel?.product;
        print(product);
        var rating = AllStoresCubit()
            .get(context)
            .productDetailsModel
            ?.product
            ?.averageRating;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "معلومات المنتج",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: ConditionalBuilder(
            condition: product != null,
            fallback: (context) => Loading(),
            builder: (context) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    items: product?.images
                        .map(
                          (e) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5.0),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              e.imageUrl!,
                              height: getScreenSize(context).height / 3,
                              width: getScreenSize(context).width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      autoPlay: product!.images.isNotEmpty,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      viewportFraction: 0.9,
                    ),
                  ),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
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
                                    Lottie.asset('images/animations/coin.json',
                                        width: 40),
                                  ],
                                ),
                                Gap(4),
                                RatingStars(
                                  value: product.averageRating!.toDouble(),
                                  starOffColor: Colors.white,
                                  starColor: AppColors.primaryColor,
                                  starSpacing: 5,
                                  starSize: 20,
                                  maxValueVisibility: false,
                                  valueLabelVisibility: false,
                                  animationDuration:
                                      Duration(milliseconds: 1500),
                                  maxValue: 5,
                                  starCount: 5,
                                ),
                              ],
                            ),
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
                      : Center(
                          child: Column(
                            children: [
                              Text(
                                  product.userHasRated!
                                      ? "لقد قمت بتقييم المنتج"
                                      : "قم بتقييم المنتج",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              const Gap(10),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: RatingStars(
                                      value: product.userHasRated!
                                          ? product.yourRating!.toDouble()
                                          : rate.value,
                                      starOffColor:
                                          const Color.fromARGB(255, 36, 36, 42),
                                      starColor: Colors.white,
                                      starSpacing: 7,
                                      starSize: 30,
                                      maxValueVisibility: false,
                                      valueLabelVisibility: false,
                                      animationDuration:
                                          Duration(milliseconds: 1500),
                                      onValueChanged: product.userHasRated!
                                          ? null
                                          : (value) {
                                              controller.ratingProduct(
                                                  id: product.id!,
                                                  rating: value.round());

                                              rate.value = value;
                                            },
                                      maxValue: 5,
                                      starCount: 5,
                                    ),
                                  )),
                            ],
                          ),
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
