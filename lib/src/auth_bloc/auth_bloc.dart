import 'dart:async';

import 'package:anonim_io/src/models/user/user.dart';
import 'package:anonim_io/src/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const _Uninitialized()) {
    _userStreamSubscription =
        _authRepository.user.listen((user) => add(_UserChanged(user: user)));

    on<_AppStarted>(_onAppStarted);
    on<_LoggedIn>(_onLoggedIn);
    on<_LoggedOut>(_onLoggedOut);
    on<_UserChanged>(_onUserChanged);
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User> _userStreamSubscription;

  Future<void> _onAppStarted(_AppStarted event, Emitter<AuthState> emit) async {
    emit(const _Loading());
    //final user = await _localUserRepository.getMainUser();
    _authRepository.addUserToStream(User.empty());
  }

  Future<void> _onLoggedIn(_LoggedIn event, Emitter<AuthState> emit) async {
    emit(const _Loading());
    // await SecureStorageService.setToken(event.token);
    // final user = await _remoteUserRepository.getMainUser();
    // if (event.rememberUser) _localUserRepository.writeMainUser(user);
    _authRepository.addUserToStream(event.user);
  }

  Future<void> _onLoggedOut(_LoggedOut event, Emitter<AuthState> emit) async {
    // emit(const _Loading());
    // await _authRepository.logOut();
    // _authRepository.addUserToStream(User.empty());
  }

  void _onUserChanged(_UserChanged event, Emitter<AuthState> emit) => emit(
        event.user != User.empty()
            ? _Authenticated(user: event.user)
            : const _Unauthenticated(),
      );

  @override
  Future<void> close() {
    _userStreamSubscription.cancel();
    return super.close();
  }
}
