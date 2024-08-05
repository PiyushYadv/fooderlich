// ////////////////////////////////////////////////////////////
// /////////////////NAVIGATOR 2.0 LEGACY CODE//////////////////
// ////////////THIS SCREEN IS NOT USED IN FINAL APP////////////
// ////////////////////////////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:fooderlich/models/fooderlich_pages.dart';
// import 'package:fooderlich/models/models.dart';

// class SplashScreen extends StatefulWidget {
//   static MaterialPage page() {
//     return MaterialPage(
//       name: FooderlichPages.splashPath,
//       key: ValueKey(FooderlichPages.splashPath),
//       child: const SplashScreen(),
//     );
//   }

//   const SplashScreen({super.key});

//   @override
//   SplashScreenState createState() => SplashScreenState();
// }

// class SplashScreenState extends State<SplashScreen> {
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     Provider.of<AppStateManager>(context, listen: false).initializeApp();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image(
//               height: 200,
//               image: AssetImage('assets/fooderlich_assets/rw_logo.png'),
//             ),
//             Text('Initializing...'),
//           ],
//         ),
//       ),
//     );
//   }
// }
