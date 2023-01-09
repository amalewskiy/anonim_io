import 'package:anonim_io/firebase_options.dart';
import 'package:anonim_io/injector.dart';
import 'package:anonim_io/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupInjection();
  runApp(const App());
}
