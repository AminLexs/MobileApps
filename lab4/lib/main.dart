import 'package:flutter/material.dart';
import 'package:laba3/AppTabBar.dart';
import 'package:laba3/LoginScreen.dart';

import 'package:laba3/models/locale.modal.dart';
import 'package:laba3/models/theme.model.dart';
import 'package:laba3/models/user.modal.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserModel()),
      ChangeNotifierProvider(create: (context) => LocaleModel(context)),
      ChangeNotifierProvider(create: (context) => ThemeModel()),
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: Provider.of<LocaleModel>(context).getString("screen_login"),
            theme: Provider.of<ThemeModel>(context).getTheme(),
            home: Consumer<UserModel>(
              builder: (context, user, child) {
                return user.isLoggedIn ? AppTabBar() : LoginsScreen();
              },
            ),
          );
        }

        return Text("Loading...");
      },
    );
  }
}
