import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';

class TradebitQrImage extends StatelessWidget {
  final String image;
  const TradebitQrImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final FutureBuilder<ui.Image> qrFutureBuilder = FutureBuilder<ui.Image>(
      future: _loadOverlayImage(),
      builder: (BuildContext ctx, AsyncSnapshot<ui.Image> snapshot) {
         double size = Dimensions.h_150;
        if (!snapshot.hasData) {
          return  SizedBox(width: size, height: size);
        }
        return CustomPaint(
          size:  Size.square(size),
          painter: QrPainter(
            data: image,
            version: QrVersions.max,
            eyeStyle:  QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Theme.of(context).highlightColor,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: Theme.of(context).highlightColor,
            ),
            // size: 320.0,
            embeddedImage: snapshot.data,
            embeddedImageStyle:  const QrEmbeddedImageStyle(
              size: Size.square(40),
            ),
          ),
        );
      },
    );
    return  TradeBitContainer(
      height: Dimensions.h_150,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor
      ),
      child: qrFutureBuilder,
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ByteData byteData =
    await rootBundle.load(Images.appIcon);
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}
