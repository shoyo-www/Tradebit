import 'dart:async';

import 'package:get/get.dart';

class StreamMarketController extends GetxController {

  final _marketStreamController = StreamController.broadcast();
  Stream get marketStream => _marketStreamController.stream;
}