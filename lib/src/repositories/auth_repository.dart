import 'dart:async';

import 'package:anonim_io/src/core/utils/failure.dart';
import 'package:anonim_io/src/models/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:rxdart/subjects.dart';

abstract class AuthRepository {
  Stream<User> get user;
  void addUserToStream(User user);
  Future<User> signInOrSignUp(String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required BehaviorSubject<User> controller,
  }) : _controller = controller;

  final StreamController<User> _controller;

  @override
  Stream<User> get user => _controller.stream;

  @override
  void addUserToStream(User user) => _controller.add(user);

  @override
  Future<User> signInOrSignUp(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((credential) => credential.user!);
      return User(id: user.uid, email: user.email!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        try {
          final newUser = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: email,
                password: password,
              )
              .then((credential) => credential.user!);
          return User(id: newUser.uid, email: newUser.email!);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            throw const WeakPasswordException();
          } else {
            throw const UserExistsException();
          }
        }
      } else {
        throw const WrongCredentialsException();
      }
    }
  }
}
