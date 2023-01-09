part of 'auth_bloc.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.uninitialized() = _Uninitialized;
  const factory AuthState.authenticated({required User user}) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.loading() = _Loading;
}
