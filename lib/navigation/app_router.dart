//NAVIGATOR 2.0////////////////
//LEGACY CODE//////////////////
//ROUTER /////////////////////

// import 'package:flutter/material.dart';

// import 'package:fooderlich/models/models.dart';
// import 'package:fooderlich/screens/screens.dart';

// class AppRouter extends RouterDelegate
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin {
//   @override
//   final GlobalKey<NavigatorState> navigatorKey;

//   final AppStateManager appStateManager;
//   final GroceryManager groceryManager;
//   final ProfileManager profileManager;

//   AppRouter(
//       {required this.appStateManager,
//       required this.groceryManager,
//       required this.profileManager})
//       : navigatorKey = GlobalKey<NavigatorState>() {
//     appStateManager.addListener(notifyListeners);
//     groceryManager.addListener(notifyListeners);
//     profileManager.addListener(notifyListeners);
//   }

//   @override
//   void dispose() {
//     appStateManager.removeListener(notifyListeners);
//     groceryManager.removeListener(notifyListeners);
//     profileManager.removeListener(notifyListeners);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: navigatorKey,
//       onPopPage: _handlePopPage,
//       pages: [
//         if (!appStateManager.isInitialized) SplashScreen.page(),
//         if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
//           LoginScreen.page(),
//         if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
//           OnboardingScreen.page(),
//         if (appStateManager.isOnboardingComplete)
//           Home.page(appStateManager.getSelectedTab),
//         if (groceryManager.isCreatingNewItem)
//           GroceryItemScreen.page(onCreate: (item) {
//             groceryManager.addItem(item);
//           }, onUpdate: (item) {
//             groceryManager.updateItem(item);
//           }),
//         if (groceryManager.selectedIndex != -1)
//           GroceryItemScreen.page(
//             item: groceryManager.selectedGroceryItem,
//             index: groceryManager.selectedIndex,
//             onCreate: (_) {},
//             onUpdate: (item) {
//               groceryManager.updateItem(item);
//             },
//           ),
//         if (profileManager.didSelectUser)
//           ProfileScreen.page(profileManager.getUser, 1),
//         if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
//       ],
//     );
//   }

//   bool _handlePopPage(Route<dynamic> route, result) {
//     if (!route.didPop(result)) {
//       return false;
//     }
//     if (route.settings.name == FooderlichPages.onboardingPath) {
//       appStateManager.logout();
//     }
//     if (route.settings.name == FooderlichPages.groceryItemDetails) {
//       groceryManager.groceryItemTapped(-1);
//     }
//     if (route.settings.name == FooderlichPages.profilePath) {
//       profileManager.tapOnProfile(false);
//     }
//     if (route.settings.name == FooderlichPages.raywenderlich) {
//       profileManager.tapOnRaywenderlich(false);
//     }

//     return true;
//   }

//   @override
//   Future<void> setNewRoutePath(configuration) async {}
// }

import 'package:flutter/material.dart';
import 'package:fooderlich/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:fooderlich/models/models.dart';

class AppRouter {
  final AppStateManager appStateManager;
  final GroceryManager groceryManager;
  final ProfileManager profileManager;

  AppRouter(
    this.appStateManager,
    this.groceryManager,
    this.profileManager,
  );

  late final router = GoRouter(
    debugLogDiagnostics: true, // ONLY FOR DEBUGGING REMOVE BEFORE DEPLOYING
    refreshListenable: appStateManager,
    initialLocation: '/login',
    routes: [
      // Add Login Route
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Add Onboarding Route
      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Add Home Route
      GoRoute(
        name: 'home',
        path: '/:tab',
        builder: (context, state) {
          final tab = int.tryParse(state.pathParameters['tab'] ?? '') ?? 0;
          return Home(
            currentTab: tab,
            key: state.pageKey,
          );
        },
        routes: [
          // Add Item Subroute
          GoRoute(
            name: 'item',
            path: 'item/:id',
            builder: (context, state) {
              final itemId = state.pathParameters['id'] ?? '';
              final item = groceryManager.getGroceryItem(itemId);

              return GroceryItemScreen(
                originalItem: item,
                onCreate: (item) {
                  groceryManager.addItem(item);
                },
                onUpdate: (item) {
                  groceryManager.updateItem(item);
                },
              );
            },
          ),
          // Add Profile Subroute
          GoRoute(
            name: 'profile',
            path: 'profile',
            builder: (context, state) {
              final tab = int.tryParse(state.pathParameters['tab'] ?? '') ?? 0;
              return ProfileScreen(
                user: profileManager.getUser,
                currentTab: tab,
              );
            },
            routes: [
              // Add Webview subroute
              GoRoute(
                name: 'rw',
                path: 'rw',
                builder: (context, state) => const WebViewScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    // Add Error Handler
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
    // Add Redirect Handler
    redirect: (context, state) {
      final loggedIn = appStateManager.isLoggedIn;
      final loggingIn = state.path == '/login';

      if (!loggedIn) return loggingIn ? null : '/login';

      final isOnboardingComplete = appStateManager.isOnboardingComplete;

      final onboarding = state.path == '/onboarding';

      if (!isOnboardingComplete) {
        return onboarding ? null : '/onboarding';
      }

      if (loggingIn || onboarding) {
        return '/${FooderlichTab.explore}';
      }

      return null;
    },
  );
}
