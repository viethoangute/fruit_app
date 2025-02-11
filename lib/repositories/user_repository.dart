import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:training_example/models/user_info/user.dart' as user_model;

@singleton
class UserRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<user_model.UserInfo> getCurrentUserInfo() async {
    String? username = auth.currentUser?.email;
    final docRef = db.collection('User').doc(username);
    return await docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      return user_model.UserInfo.fromJson(data);
    });
  }

  Future<bool> changeName({required String name}) async {
    String? username = auth.currentUser?.email;
    try {
      await db.collection('User').doc(username).update({'name': name});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateAddress({required String province, required String district, required String commune, required detail}) async {
    String? username = auth.currentUser?.email;
    try {
      await db.collection('User').doc(username).update({
        'province': province,
        'district': district,
        'commune': commune,
        'detailAddress': detail
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
