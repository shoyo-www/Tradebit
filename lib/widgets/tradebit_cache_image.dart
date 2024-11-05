import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';

class TradebitCacheImage extends StatelessWidget {
  final String image;
  const TradebitCacheImage({super.key,required this.image});

  @override
  Widget build(BuildContext context) {
    return  CachedNetworkImage(
      errorWidget: (context,url,error){
        return SizedBox(
          height: Dimensions.h_30,
            width: Dimensions.h_30,
            child: Image.asset(Images.appIcon,opacity: const AlwaysStoppedAnimation(.5)));
      },
      placeholder: (context, url) => SizedBox(
        height: Dimensions.h_30,
          width: Dimensions.h_30,
          child: const CircularProgressIndicator(
            color: AppColor.appColor,
          )),
      imageUrl: image,
    );
  }
}
