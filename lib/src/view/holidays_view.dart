import 'dart:io';

import 'package:flutter/material.dart';
import 'package:holidays/src/controllers/holidays_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HolidaysView extends StatefulWidget {
  const HolidaysView({super.key});

  @override
  State<HolidaysView> createState() => _HolidaysViewState();
}

class _HolidaysViewState extends State<HolidaysView> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting(Platform.localeName);
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.yMd(Platform.localeName);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Holidays'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: HolidaysController.loadPublicHolidays(),
                builder: (context, snapshot) {
                  return Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {},
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (snapshot.hasData) ...[
                              Text(snapshot.data!['name']),
                              Text(format.format(
                                  DateTime.tryParse(snapshot.data!['start'])!)),
                            ] else
                              const Text('Loading')
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: FutureBuilder(
                future: HolidaysController.loadSchoolHolidays(),
                builder: (context, snapshot) {
                  return Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {},
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (snapshot.hasData) ...[
                              Text(snapshot.data!['name']),
                              Text(
                                  '${format.format(DateTime.tryParse(snapshot.data!['start'])!)} - ${format.format(DateTime.tryParse(snapshot.data!['end'])!)}'),
                            ] else
                              const Text('Loading')
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
