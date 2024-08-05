import 'package:flutter/material.dart';
import 'package:fooderlich/navigation/app_router.dart';
import 'package:provider/provider.dart';
// import 'package:fooderlich/screens/screens.dart';

import 'fooderlich_theme.dart';
import 'models/models.dart';
// import 'screens/screens.dart';
//Import app_router

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appStateManager = AppStateManager();
  await appStateManager.initializeApp();
  runApp(Fooderlich(appStateManager: appStateManager));
}

class Fooderlich extends StatefulWidget {
  final AppStateManager appStateManager;

  const Fooderlich({
    super.key,
    required this.appStateManager,
  });

  @override
  FooderlichState createState() => FooderlichState();
}

class FooderlichState extends State<Fooderlich> {
  late final _groceryManager = GroceryManager();
  late final _profileManager = ProfileManager();
  //Initialize AppRoute
  late final _appRouter = AppRouter(
    widget.appStateManager,
    _groceryManager,
    _profileManager,
  );
  // late AppRouter _appRouter;

  // @override
  // void initState() {
  //   _appRouter = AppRouter(
  //       appStateManager: widget.appStateManager,
  //       groceryManager: _groceryManager,
  //       profileManager: _profileManager);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _groceryManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        ),
        ChangeNotifierProvider(
          create: (context) => widget.appStateManager,
        ),
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = FooderlichTheme.dark();
          } else {
            theme = FooderlichTheme.light();
          }

          // Replace with Router
          final router = _appRouter.router;
          return MaterialApp.router(
            theme: theme,
            title: 'Fooderlich',
            routerConfig: router,
            // routerDelegate: router.routerDelegate,
            // routeInformationProvider: router.routeInformationProvider,
            // routeInformationParser: router.routeInformationParser,

            ////LEGACY CODE////
            //Router(
            //   routerDelegate: _appRouter,
            //   backButtonDispatcher: RootBackButtonDispatcher(),
            // ),
          );
        },
      ),
    );
  }
}
