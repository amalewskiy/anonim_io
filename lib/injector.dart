import 'package:anonim_io/src/auth_bloc/auth_bloc.dart';
import 'package:anonim_io/src/config/app_router.dart';
import 'package:anonim_io/src/models/user/user.dart';
import 'package:anonim_io/src/repositories/auth_repository.dart';
import 'package:anonim_io/src/screens/auth/cubit/login_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';

final GetIt sl = GetIt.instance;

Future<void> setupInjection() async {
  _injectConfig();
  _injectRepositories();
  _injectBlocs();
}

void _injectConfig() {
  sl.registerSingleton<BehaviorSubject<User>>(BehaviorSubject<User>());
}

void _injectRepositories() {
  sl.registerSingleton<AuthRepository>(
    AuthRepository(controller: sl<BehaviorSubject<User>>()),
  );
}

void _injectBlocs() {
  sl
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        authRepository: sl<AuthRepository>(),
      )..add(const AuthEvent.appStarted()),
    )
    ..registerSingleton<AppRouter>(AppRouter(authBloc: sl<AuthBloc>()))
    ..registerSingleton<LoginCubit>(
      LoginCubit(
        authRepository: sl<AuthRepository>(),
        authBloc: sl<AuthBloc>(),
      ),
    );
}
