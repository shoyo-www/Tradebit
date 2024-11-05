// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:tradebit_app/constants/images.dart';
//
//
// class CheckInternetConnectionWidget extends StatelessWidget {
//   final AsyncSnapshot<ConnectivityResult> snapshot;
//   final Widget widget ;
//   const CheckInternetConnectionWidget({
//     Key? key,
//     required this.snapshot,
//     required this.widget
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     switch (snapshot.connectionState) {
//       case ConnectionState.active:
//         final state = snapshot.data!;
//         switch (state) {
//           case ConnectivityResult.none:
//             return Center(child: Lottie.asset(Images.noInternet));
//           default:
//             return widget;
//         }
//       default:
//         return  widget;
//     }
//   }
// }
//
//
// class InternetConnectivityScreen extends StatefulWidget {
//   final Widget widget;
//    const InternetConnectivityScreen({Key? key, required this.widget}) : super(key: key);
//
//   @override
//   State<InternetConnectivityScreen> createState() => _InternetConnectivityScreenState();
// }
//
// class _InternetConnectivityScreenState extends State<InternetConnectivityScreen> {
//   Connectivity connectivity = Connectivity() ;
//    @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//       body: StreamBuilder<ConnectivityResult>(
//         stream: connectivity.onConnectivityChanged,
//         builder: (_, snapshot){
//           return CheckInternetConnectionWidget(
//             snapshot: snapshot,
//             widget: widget.widget,
//           ) ;
//         },
//       ),
//     );
//   }
// }