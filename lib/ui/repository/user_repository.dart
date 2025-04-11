import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_exam_app/models/user_model.dart';

class UserRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser(String userId, User user) {
    return usersCollection.doc(userId).set(user.toJson());
  }

  Future<User?> readUser(String userId) async {
    final doc = await usersCollection.doc(userId).get();
    if (doc.exists) {
      return User.fromDocumentSnapshot(doc);
    }
    return null;
  }

  Future<void> updateUser(String userId, User user) {
    return usersCollection.doc(userId).update(user.toJson());
  }

  Future<void> deleteUser(String userId) {
    return usersCollection.doc(userId).delete();
  }
}
