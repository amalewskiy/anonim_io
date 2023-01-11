import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static CollectionReference get userCollection =>
      FirebaseFirestore.instance.collection('users');

  static CollectionReference get chatCollection =>
      FirebaseFirestore.instance.collection('chat');
}
