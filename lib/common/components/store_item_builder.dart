import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gap/gap.dart';

class StoreItemBuilder extends HookWidget {
  StoreItemBuilder(
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
  String imageUrl;
  String title;
  String country;
  String description;
  double? rating;
  bool rateWidget;
  bool priceWidget;
  String? price;
  bool onlineWidget;
  bool? isOnline;
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
            height: boxConstraints.maxHeight / 2.7,
            clipBehavior: Clip.none,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              fontSize: 17),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        country,
                        style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Gap(2),
                  BuildCondition(
                    condition: rateWidget && rating != null,
                    builder: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ),
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
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 16,
                                  )
                                ],
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "$price ",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              CircleAvatar(
                                radius: 7,
                                backgroundColor:
                                    isOnline! ? Colors.green : Colors.grey,
                              )
                            ],
                          ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
