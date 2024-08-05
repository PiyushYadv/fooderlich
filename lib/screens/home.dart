import 'package:flutter/material.dart';
import 'package:fooderlich/models/models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'explore_screen.dart';
import 'grocery_screen.dart';
import 'recipes_screen.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.currentTab,
  });

  //// LEGACY CODE ////
  // static MaterialPage page(int currentTab) {
  //   return MaterialPage(
  //     name: FooderlichPages.home,
  //     key: ValueKey(FooderlichPages.home),
  //     child: Home(
  //       currentTab: currentTab,
  //     ),
  //   );
  // }

  final int currentTab;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  static List<Widget> pages = <Widget>[
    ExploreScreen(),
    RecipesScreen(),
    const GroceryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Fooderlich',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            actions: [
              profileButton(widget.currentTab),
            ],
          ),
          body: IndexedStack(index: widget.currentTab, children: pages),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor:
                Theme.of(context).textSelectionTheme.selectionColor,
            currentIndex: widget.currentTab,
            onTap: (index) {
              // Update user's selected tab
              Provider.of<AppStateManager>(context, listen: false)
                  .goToTab(index);

              context.goNamed(
                'home',
                pathParameters: {
                  'tab': '$index',
                },
              );
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Recipes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'To Buy',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget profileButton(int currentTab) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        child: const CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(
            'assets/profile_pics/person_stef.jpeg',
          ),
        ),
        onTap: () {
          // Navigate to profile screen
          context.goNamed(
            'profile',
            pathParameters: {
              'tab': '$currentTab',
            },
          );
          // Provider.of<ProfileManager>(context, listen: false)
          //     .tapOnProfile(true);
        },
      ),
    );
  }
}