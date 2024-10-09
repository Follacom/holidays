import 'package:flutter/material.dart';
import 'package:holidays/src/controllers/holidays_controller.dart';
import 'package:holidays/src/view/holidays_view.dart';
import 'package:holidays/src/view/settings_view.dart';

class App extends StatefulWidget {
  final bool areZonesSet;

  const App({super.key, required this.areZonesSet});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = widget.areZonesSet ? 0 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (currentIndex) {
      case 1:
        page = const SettingsView();
      case 0:
      default:
        page = const HolidaysView();
    }

    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) async {
          final zonesSet = await HolidaysController.areZonesSet;
          if (zonesSet) {
            setState(() {
              currentIndex = value;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Holidays'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
