import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class StoreItemBuilder extends HookWidget {
  const StoreItemBuilder(
      {super.key,
      required this.imageUrl,
      required this.title,
      this.country = "",
      this.description = "",
      this.rating,
      required this.rateWidget,
      required this.priceWidget,
      this.onlineWidget = false,
      this.isOnline,
      this.price})
      : assert(rateWidget ? rating != null : true),
        assert(priceWidget ? price != null : true),
        assert(onlineWidget ? isOnline != null : true);
  final String imageUrl;
  final String title;
  final String country;
  final String description;
  final double? rating;
  final bool rateWidget;
  final bool priceWidget;
  final String? price;
  final bool onlineWidget;
  final bool? isOnline;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    offset: Offset(1, 1), color: Colors.white24, blurRadius: 3)
              ],
              image: DecorationImage(
                  image: NetworkImage(
                    imageUrl,
                  ),
                  fit: BoxFit.cover),
              color: const Color.fromARGB(255, 68, 68, 65),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            height: priceWidget
                ? boxConstraints.maxHeight / 2.1
                : boxConstraints.maxHeight / 4.7,
            clipBehavior: Clip.none,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          country,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const Gap(2),
                  BuildCondition(
                      condition: rateWidget && rating != null,
                      builder: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   description,
                              //   style: const TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 10,
                              //       fontWeight: FontWeight.w500),
                              // ),
                              RatingStars(
                                valueLabelVisibility: false,
                                starSize: 8,
                                valueLabelColor: Colors.red,
                                starColor: Colors.yellow,
                                starOffColor: Colors.transparent,
                                starCount: 5,
                                maxValue: 5,
                                value: rating ?? 0,
                              ),
                            ],
                          ),
                      fallback: (context) => priceWidget && price != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    description,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "$price",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Lottie.asset('images/animations/coin.json',
                                        width: 40),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox())
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
