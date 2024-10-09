import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holidays/src/app.dart';
import 'package:holidays/src/controllers/holidays_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(Main(
    areZonesSet: await HolidaysController.areZonesSet,
  ));
}

class Main extends StatelessWidget {
  final bool areZonesSet;

  const Main({super.key, required this.areZonesSet});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        locale: Locale(Platform.localeName),
        restorationScopeId: 'app',
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        home: App(
          areZonesSet: areZonesSet,
        ),
      ),
    );
  }
}
