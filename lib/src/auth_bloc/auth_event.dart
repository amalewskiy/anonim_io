part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.appStarted() = _AppStarted;
  const factory AuthEvent.loggedIn({
    required User user,
    //required bool rememberUser,
  }) = _LoggedIn;
  const factory AuthEvent.userChanged({required User user}) = _UserChanged;
  const factory AuthEvent.loggedOut() = _LoggedOut;
}
