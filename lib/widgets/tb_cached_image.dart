import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tradebit_app/constants/appcolor.dart';

class TbCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  const TbCachedNetworkImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        );
      },
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(
          color: AppColor.appColor,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error,color: AppColor.red,),
    );
  }
}
