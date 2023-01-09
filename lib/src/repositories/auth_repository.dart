import 'dart:async';

import 'package:anonim_io/src/core/utils/failure.dart';
import 'package:anonim_io/src/models/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:rxdart/subjects.dart';

class AuthRepository {
  const AuthRepository({
    required BehaviorSubject<User> controller,
  }) : _controller = controller;

  final StreamController<User> _controller;

  Stream<User> get user => _controller.stream;

  void addUserToStream(User user) => _controller.add(user);

  Future<User> signInOrSignUp(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return User(id: credential.user!.uid, email: credential.user!.email!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          return User(id: credential.user!.uid, email: credential.user!.email!);
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
