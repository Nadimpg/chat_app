import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apis {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// for accesing cloud firestore database
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static get user => auth.currentUser!;

  ///for storing self information
  static late ChatUser me;

  ///for checking if user or not ?
  static Future<bool> userExists() async {
    return (await fireStore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }
  ///for getting current user info
  static Future<void> getSelfInfo() async {
   await fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get().then((value) async {

          if(value.exists){
          me = ChatUser.fromJson(value.data()!);
          }else{

            // await createUser().then((value) => getSelfInfo());
          }
   });
  }

  /// for creating a new user

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using We Chat!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await fireStore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }


  /// GetAllUsers
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return fireStore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }


}
