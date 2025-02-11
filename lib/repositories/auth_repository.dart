import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:training_example/constants/constants.dart';
import 'package:training_example/models/user_info/user.dart' as user;
import 'package:training_example/utils/firebase_error_list.dart';

@singleton
class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      return getErrorString(errorCode: error.code);
    }
    return Constants.loginSuccess;
  }

  Future<String> createAccount(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      return getErrorString(errorCode: error.code);
    }
    await signIn(email: email, password: password);
    await createNewUser(
        user: user.UserInfo(
            username: email,
            name: email,
            province: '',
            district: '',
            commune: '',
            detailAddress: '',
            phone: '',
            imageURL: Constants.defaultImageUrl));
    return Constants.loginSuccess;
  }

  Future<void> createNewUser({required user.UserInfo user}) async {
    try {
      await _fireStore.collection('User').doc(user.username).set(user.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  void signOut() async {
    await _firebaseAuth.signOut();
  }
}
