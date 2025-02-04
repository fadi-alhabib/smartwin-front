import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sw/common/constants/constants.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

class ProductDetailsScreen extends HookWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
              items: images.map((e) => Image.asset(e)).toList(),
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 1.0,
              )),
          const Gap(10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("اسم المنتج"),
                    Row(
                      children: [
                        Text("السعر"),
                        Icon(Icons.favorite),
                      ],
                    )
                  ],
                ),
                Gap(10),
                Text("الوصف"),
                Text(
                    "Eiusmod est exercitation proident ea aliquip esse occaecat commodo aliquip ipsum labore ea. Ut nulla Lorem adipisicing laboris elit culpa laborum consectetur anim adipisicing esse cillum. Esse sint ullamco elit proident veniam magna. Incididunt enim nostrud reprehenderit mollit adipisicing nostrud fugiat officia laboris in aliquip occaecat nisi. Sunt sint excepteur commodo tempor. Ea laboris duis eu fugiat in et esse eu eiusmod reprehenderit anim anim. Elit veniam proident in ullamco mollit qui adipisicing.")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
