import 'dart:developer';

import 'package:anonim_io/firebase_options.dart';
import 'package:anonim_io/injector.dart';
import 'package:anonim_io/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupInjection();
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}

class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log(transition.toString());
  }
}
