import 'package:flutter/material.dart';
import 'package:smartwin/components/grid_view_builder.dart';
import 'package:smartwin/components/store_item_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProductsScreen extends HookWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "سلع المتاجر",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            GridViewBuilder(
                itemBuilder: (context, index) =>
                    AnimationConfiguration.staggeredGrid(
                        duration: const Duration(milliseconds: 500),
                        columnCount: 2,
                        position: index,
                        child: ScaleAnimation(
                            child: StoreItemBuilder(
                          imageUrl:
                              "https://th.bing.com/th/id/OIP.HlMkQ5ocVv5uP0i1zMjiYAHaHa?rs=1&pid=ImgDetMain",
                          title: "أيفون 14",
                          country: "السعودية العربية",
                          description: "سييررزز",
                          rateWidget: false,
                          priceWidget: true,
                          price: "12",
                        ))),
                crossAxisCount: 2,
                itemCount: 15)
          ],
        ),
      ),
    );
  }

  Widget buildProduct(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: const DecorationImage(
                image: NetworkImage(
                  "https://th.bing.com/th/id/OIP.HlMkQ5ocVv5uP0i1zMjiYAHaHa?rs=1&pid=ImgDetMain",
                ),
              )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "آيفون 14 برو",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              Text(
                "❤️1000",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              )
            ],
          ),
        )
      ],
    );
  }
}
