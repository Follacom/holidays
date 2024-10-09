import 'package:flutter/material.dart';
import 'package:holidays/src/controllers/holidays_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          FutureBuilder(
            future: HolidaysController.publicZone,
            builder: (context, snapshot) {
              final zoneController = TextEditingController();

              if (snapshot.hasData) {
                zoneController.text = snapshot.data!;
              }

              return Center(
                child: DropdownMenu(
                  label: const Text('Public Holidays Zone'),
                  controller: zoneController,
                  onSelected: (value) {
                    if (value != null) {
                      HolidaysController.setZone(
                        zone: value,
                        public: true,
                      );
                    }
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                        label: 'Alsace-Moselle', value: 'alsace-moselle'),
                    DropdownMenuEntry(label: 'Guadeloupe', value: 'guadeloupe'),
                    DropdownMenuEntry(label: 'Guyane', value: 'guyane'),
                    DropdownMenuEntry(label: 'La Réunion', value: 'la-reunion'),
                    DropdownMenuEntry(label: 'Martinique', value: 'martinique'),
                    DropdownMenuEntry(label: 'Mayotte', value: 'mayotte'),
                    DropdownMenuEntry(label: 'Metropole', value: 'metropole'),
                    DropdownMenuEntry(
                        label: 'Nouvelle Calédonie',
                        value: 'nouvelle-caledonie'),
                    DropdownMenuEntry(
                        label: 'Polynésie Française',
                        value: 'polynesie-francaise'),
                    DropdownMenuEntry(
                        label: 'Saint Barthélemy', value: 'saint-barthelemy'),
                    DropdownMenuEntry(
                        label: 'Saint Martin', value: 'saint-martin'),
                    DropdownMenuEntry(
                        label: 'Saint-Pierre-et-Miquelon',
                        value: 'saint-pierre-et-miquelon'),
                    DropdownMenuEntry(
                        label: 'Wallis et Futuna', value: 'wallis-et-futuna'),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          FutureBuilder(
            future: HolidaysController.schoolZone,
            builder: (context, snapshot) {
              final zoneController = TextEditingController();

              if (snapshot.hasData) {
                zoneController.text = snapshot.data!;
              }

              return Center(
                child: DropdownMenu(
                  label: const Text('School Holidays Zone'),
                  controller: zoneController,
                  onSelected: (value) {
                    if (value != null) {
                      HolidaysController.setZone(
                        zone: value,
                        public: false,
                      );
                    }
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(label: 'Zone A', value: 'Zone A'),
                    DropdownMenuEntry(label: 'Zone B', value: 'Zone B'),
                    DropdownMenuEntry(label: 'Zone C', value: 'Zone C'),
                    DropdownMenuEntry(label: 'Corse', value: 'Corse'),
                    DropdownMenuEntry(label: 'Guadeloupe', value: 'Guadeloupe'),
                    DropdownMenuEntry(label: 'Guyane', value: 'Guyane'),
                    DropdownMenuEntry(label: 'Martinique', value: 'Martinique'),
                    DropdownMenuEntry(label: 'Mayotte', value: 'Mayotte'),
                    DropdownMenuEntry(
                        label: 'Nouvelle Calédonie',
                        value: 'Nouvelle Calédonie'),
                    DropdownMenuEntry(label: 'Polynésie', value: 'Polynésie'),
                    DropdownMenuEntry(label: 'La Réunion', value: 'La Réunion'),
                    DropdownMenuEntry(
                        label: 'Saint-Pierre-et-Miquelon',
                        value: 'Saint-Pierre-et-Miquelon'),
                    DropdownMenuEntry(
                        label: 'Wallis et Futuna', value: 'Wallis et Futuna'),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
