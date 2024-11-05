import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/banner_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/crypto_response.dart';

class LocalStorage {
  static final box = GetStorage();

  static void writeString(String key, String v) {
    box.write(key, v);
  }

  static String getString(String key) {
    return box.read(key) ?? "";
  }

  static void writeBool(String key, bool v) {
    box.write(key, v );
  }

  static bool getBool(String key) {
    return box.read(key) ?? false;
  }

  static bool savedTheme() {
    return box.read(GetXStorageConstants.darkTheme) ?? false;
  }

  ThemeMode getTheme() {
    return savedTheme() ? ThemeMode.light : ThemeMode.dark;
  }

  void saveTheme(bool v) {
    box.write(GetXStorageConstants.darkTheme, v);
  }

  void changeTheme() {
    Get.changeThemeMode(savedTheme() ? ThemeMode.dark : ThemeMode.light);
    saveTheme(!savedTheme());
  }

  static void clearValueByKey(String key) {
    box.remove(key);
  }

  static void setAuthToken(String token) {
    box.write(GetXStorageConstants.authToken, token);
  }

  static String getAuthToken() {
    return box.read(GetXStorageConstants.authToken) ?? "";
  }

  static void saveList(List<Banners> banner) {
    final encodedList = banner.map((banner) => banner.toJson()).toList();
    box.write(GetXStorageConstants.banner, encodedList);
  }

  static List<Banners> getList() {
    final List<dynamic> encodedList = box.read(GetXStorageConstants.banner) ?? [];
    return encodedList.map((json) => Banners.fromJson(json)).toList();
  }

  static void saveListCrypto(List<Btc> crypto) {
    final encodedList = crypto.map((crypto) => crypto.toJson()).toList();
    box.write(GetXStorageConstants.cryptoList, encodedList);
  }

  static List<Btc> getListCrypto() {
    final List<dynamic> encodedList = box.read(GetXStorageConstants.cryptoList) ?? [];
    return encodedList.map((json) => Btc.fromJson(json)).toList();
  }

  static void saveListBtc(List<Btc>? crypto) {
    final encodedList = crypto!.map((crypto) => crypto.toJson()).toList();
    box.write(GetXStorageConstants.cryptoBtc, encodedList);
  }

  static List<Btc> getListBtc() {
    final List<dynamic> encodedList = box.read(GetXStorageConstants.cryptoBtc) ?? [];
    return encodedList.map((json) => Btc.fromJson(json)).toList();
  }

  static void saveListEth(List<Btc>? crypto) {
    final encodedList = crypto!.map((crypto) => crypto.toJson()).toList();
    box.write(GetXStorageConstants.cryptoEth, encodedList);
  }

  static List<Btc> getListEth() {
    final List<dynamic> encodedList = box.read(GetXStorageConstants.cryptoEth) ?? [];
    return encodedList.map((json) => Btc.fromJson(json)).toList();
  }

  static void saveListTbc(List<Btc>? crypto) {
    final encodedList = crypto!.map((crypto) => crypto.toJson()).toList();
    box.write(GetXStorageConstants.cryptoTbc, encodedList);
  }

  static List<Btc> getListTbc() {
    final List<dynamic> encodedList = box.read(GetXStorageConstants.cryptoTbc) ?? [];
    return encodedList.map((json) => Btc.fromJson(json)).toList();
  }

  static void saveListTrx(List<Btc>? crypto) {
    final encodedList = crypto!.map((crypto) => crypto.toJson()).toList();
    box.write(GetXStorageConstants.cryptoTrx, encodedList);
  }

  static List<Btc> getListTrx() {
    final List<dynamic> encodedList = box.read(GetXStorageConstants.cryptoTrx) ?? [];
    return encodedList.map((json) => Btc.fromJson(json)).toList();
  }

  static void saveListTickers(List<dynamic> tickers,String key) {
    box.write(key, tickers);
  }

  static List<dynamic> getListTickers(String key) {
   return box.read(key);
  }

  static void clear() {
    box.erase();
  }
}
