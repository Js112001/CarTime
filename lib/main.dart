import 'package:car_time/app.dart';
import 'package:car_time/data/services/local/local_db.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase.initialize();
  runApp(const MyApp());
}
