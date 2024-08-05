import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../components/circle_image.dart';
import '../models/models.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final User user;
  final int currentTab;

  //// LEGACY CODE ////

  // static MaterialPage page(User user, int currentTab) {
  //   return MaterialPage(
  //     name: FooderlichPages.profilePath,
  //     key: ValueKey(FooderlichPages.profilePath),
  //     child: ProfileScreen(
  //       user: user,
  //       currentTab: currentTab,
  //     ),
  //   );
  // }

  const ProfileScreen(
      {super.key, required this.user, required this.currentTab});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Provider.of<ProfileManager>(context, listen: false)
                .tapOnProfile(false);
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            buildProfile(),
            Expanded(
              child: buildMenu(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenu() {
    return ListView(
      children: [
        buildDarkModeRow(),
        ListTile(
          title: const Text('View raywenderlich.com'),
          onTap: () async {
            if (kIsWeb || Platform.isMacOS) {
              await launchUrl(Uri.parse('https://www.raywenderlich.com/'));
            } else {
              // Navigate to WebView
              context.goNamed(
                'rw',
                pathParameters: {
                  'tab': '${widget.currentTab}',
                },
              );
              // Provider.of<ProfileManager>(context, listen: false)
              //     .tapOnRaywenderlich(true);
            }
          },
        ),
        ListTile(
          title: const Text('Log out'),
          onTap: () {
            // Logout user
            Provider.of<AppStateManager>(context, listen: false).logout();
            // Provider.of<ProfileManager>(context, listen: false)
            //     .tapOnProfile(false);
          },
        )
      ],
    );
  }

  Widget buildDarkModeRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Dark Mode'),
          Switch(
            value: widget.user.darkMode,
            onChanged: (value) {
              Provider.of<ProfileManager>(context, listen: false).darkMode =
                  value;
            },
          )
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        CircleImage(
          imageProvider: AssetImage(widget.user.profileImageUrl),
          imageRadius: 60.0,
        ),
        const SizedBox(height: 16.0),
        Text(
          widget.user.firstName,
          style: const TextStyle(
            fontSize: 21,
          ),
        ),
        Text(widget.user.role),
        Text(
          '${widget.user.points} points',
          style: const TextStyle(
            fontSize: 30,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
