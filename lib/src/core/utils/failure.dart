class Failure implements Exception {
  const Failure([this.message]);

  final String? message;
}

class WrongCredentialsException extends Failure {
  const WrongCredentialsException([super.msg]);
}

class UserExistsException extends Failure {
  const UserExistsException([super.msg]);
}

class WeakPasswordException extends Failure {
  const WeakPasswordException([super.msg]);
}
