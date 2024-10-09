import 'dart:convert';
import 'dart:developer';

import 'package:holidays/src/controllers/database_controller.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef Holidays = Map<String, dynamic>;

class HolidaysController {
  static final Uri _publicHolidaysUri = Uri(
    scheme: 'https',
    host: 'calendrier.api.gouv.fr',
    path: '/jours-feries',
  );
  static final Uri _schoolHolidaysUri = Uri(
    scheme: 'https',
    host: 'data.education.gouv.fr',
    path:
        '/api/explore/v2.1/catalog/datasets/fr-en-calendrier-scolaire/records',
  );

  static const String _publicZoneStorageKey = 'public_holidays_zone';
  static const String _schoolZoneStorageKey = 'school_holidays_zone';
  static final _prefs = SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: {_publicZoneStorageKey, _schoolZoneStorageKey},
    ),
  );

  static Future<String?> get publicZone => Future(() async {
        final prefs = await _prefs;
        return prefs.getString(_publicZoneStorageKey);
      });

  static Future<String?> get schoolZone => Future(() async {
        final prefs = await _prefs;
        return prefs.getString(_schoolZoneStorageKey);
      });

  static Future<bool> get areZonesSet => Future(() async {
        return (await publicZone) != null && (await schoolZone) != null;
      });

  static Future<void> setZone({
    required String zone,
    bool public = true,
  }) async {
    final prefs = await _prefs;
    if (public) {
      await prefs.setString(_publicZoneStorageKey, zone);
    } else {
      await prefs.setString(_schoolZoneStorageKey, zone);
    }
  }

  static Future<Holidays> _saveToDB({
    required Holidays retrivedPublicHolidays,
    bool public = true,
  }) async {
    final db = await DatabaseController.database;
    final List<Holidays> publicHolidays = [];
    final prefs = await _prefs;
    final zone = public
        ? prefs.getString(_publicZoneStorageKey) ?? 'metropole'
        : prefs.getString(_schoolZoneStorageKey) ?? '';

    if (public) {
      for (var entry in retrivedPublicHolidays.entries) {
        final holiday = {
          'id':
              '${entry.key}_${entry.value}_${public ? 'public' : 'school'}_$zone',
          'name': entry.value,
          'start': entry.key,
          'zone': zone,
          'public': public ? 1 : 0,
        };
        await db.insert('holidays', holiday);

        publicHolidays.add(holiday);
      }
    } else {
      for (var entry in retrivedPublicHolidays['results']) {
        final holiday = {
          'id':
              '${entry['annee_scolaire']}_${entry['description']}_${public ? 'public' : 'school'}_${entry['zones']}',
          'name': entry['description'],
          'start': entry['start_date'],
          'end': entry['end_date'],
          'zone': entry['zones'],
          'public': public ? 1 : 0,
        };

        publicHolidays.add(holiday);
      }
    }
    log(publicHolidays.first.toString());

    return publicHolidays.first;
  }

  static Future<Holidays?> _fetchHolidays({bool public = true}) async {
    final prefs = await _prefs;
    final zone = public
        ? prefs.getString(_publicZoneStorageKey) ?? 'metropole'
        : prefs.getString(_schoolZoneStorageKey) ?? '';

    Uri requestURL;
    if (public) {
      requestURL = Uri(
        scheme: _publicHolidaysUri.scheme,
        host: _publicHolidaysUri.host,
        path: '${_publicHolidaysUri.path}/$zone.json',
      );
    } else {
      requestURL = Uri(
          scheme: _schoolHolidaysUri.scheme,
          host: _schoolHolidaysUri.host,
          path: _schoolHolidaysUri.path,
          queryParameters: {
            'limit': '5',
            'order_by': 'start_date',
            'where': 'end_date >= date\'${DateTime.now().toIso8601String()}\''
          });
    }
    final response = await get(requestURL);
    return _saveToDB(
        retrivedPublicHolidays: jsonDecode(response.body), public: public);
  }

  static Future<Holidays?> _loadFromDB({bool public = true}) async {
    final db = await DatabaseController.database;
    final prefs = await _prefs;
    final zone = public
        ? prefs.getString(_publicZoneStorageKey) ?? 'metropole'
        : prefs.getString(_schoolZoneStorageKey) ?? '-';
    List<Holidays> cachedHolidays = [];

    cachedHolidays.addAll(await db.query(
      'holidays',
      limit: 1,
      orderBy: 'start',
      where: 'start > date(\'now\') and zone LIKE ? and public = ?',
      whereArgs: ['%$zone%', public ? 1 : 0],
    ));

    if (cachedHolidays.isEmpty) {
      final retrieved = await _fetchHolidays(public: public);
      if (retrieved != null) {
        cachedHolidays.add(retrieved);
      }
    }

    return cachedHolidays.first;
  }

  static Future<Holidays?> loadPublicHolidays() async {
    return await _loadFromDB();
  }

  static Future<Holidays?> loadSchoolHolidays() async {
    return await _loadFromDB(public: false);
  }
}
