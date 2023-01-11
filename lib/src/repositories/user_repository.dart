import 'package:anonim_io/src/core/services/database_service.dart';
import 'package:anonim_io/src/models/user/user.dart';

abstract class UserRepository {
  Future<void> addUserToCollection(User user);
  Future<User?> getUserByEmail(String email);
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<void> addUserToCollection(User user) async {
    try {
      await DatabaseService.userCollection.doc(user.email).set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      final user = await DatabaseService.userCollection.doc(email).get();
      if (user.data() != null) {
        return User.fromJson(user.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
