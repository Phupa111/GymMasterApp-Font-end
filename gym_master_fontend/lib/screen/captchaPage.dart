// import 'package:flutter/material.dart';
// import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';

// class MyCaptchaPage extends StatefulWidget {
//   @override
//   _MyCaptchaPageState createState() => _MyCaptchaPageState();
// }

// class _MyCaptchaPageState extends State<MyCaptchaPage> {
//   final RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("reCAPTCHA Verification"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             RecaptchaV2(
//               apiKey:
//                   "6LckiZspAAAAAP1gTpPk7heMvVliaG10CCXMNBhy", // Replace with your API site key
//               apiSecret:
//                   "6LckiZspAAAAAMOYUolugBAy6AEe20zd79Q-wD6R", // API secret key, better handled server-side
//               controller: recaptchaV2Controller,
//               onVerifiedError: (String error) {
//                 print("Verification failed: $error");
//               },
//               onVerifiedSuccessfully: (bool success) {
//                 if (success) {
//                   print("Verified successfully");
//                 } else {
//                   print("Failed to verify");
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
