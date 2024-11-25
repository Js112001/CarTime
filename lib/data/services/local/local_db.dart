import 'dart:developer';

import 'package:car_time/domain/models/car_entry_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Database? _instance;
  static String tableName = 'car_entry';

  LocalDatabase._();

  static Database getDatabaseInstance() {
    if (_instance == null) {
      initialize();
    }
    return _instance!;
  }

  static Future<void> initialize() async {
    try {
      final database = await openDatabase(
        join(await getDatabasesPath(), 'car_entry.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, car_number TEXT NOT NULL, check_in_time TEXT NOT NULL, check_out_time TEXT)',
          );
        },
        version: 1,
      );

      _instance = database;
    } catch (e) {
      log('[Exception][Initialize]: $e');
    }
  }

  static Future<int> checkIn({required CarEntryModel carEntry}) async {
    try {
      final existingEntry = await getDatabaseInstance().rawQuery(
        'SELECT * FROM car_entry WHERE car_number = ?',
        [carEntry.carNumber],
      );

      if (existingEntry.isNotEmpty) {
        final firstEntry = existingEntry.first as Map<String, dynamic>;
        final newCarEntry = CarEntryModel.fromMap(firstEntry);
        if (newCarEntry.checkOutTime == null) {
          return -1;
        }
      }

      return await getDatabaseInstance().insert(
        tableName,
        carEntry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } catch (e, stackTrace) {
      log('[Exception][CheckIn]: $e stackTrace: $stackTrace');
      return 0;
    }
  }

  static Future<List<CarEntryModel>> getAllUncheckedCars() async {
    try {
      final allEntries = await getDatabaseInstance()
          .rawQuery('SELECT * FROM car_entry WHERE check_out_time = "null"');

      log('[Entries]: $allEntries');
      return allEntries
          .map(
            (item) => CarEntryModel.fromMap(item),
          )
          .toList();
    } catch (e, stackTrace) {
      log('[Exception][Get]: $e stackTrace: $stackTrace');
      return [];
    }
  }

  static Future<int> checkOut({
    required CarEntryModel carEntryModel,
  }) async {
    try {
      final existingEntry = await getDatabaseInstance().rawQuery(
        'SELECT * FROM car_entry WHERE id = ?',
        [carEntryModel.id],
      );

      var map = Map<String, dynamic>.from(existingEntry.first);

      map.update(
        'check_out_time',
        (value) => DateTime.now().toString(),
      );

      return await getDatabaseInstance().update(
        'car_entry',
        map,
        where: 'id = ?',
        whereArgs: [existingEntry.first['id']],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } catch (e, stackTrace) {
      log('[Exception][CheckOut]: $e stackTrace: $stackTrace');
      return 0;
    }
  }
}
