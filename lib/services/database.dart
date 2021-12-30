import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonylist/screens/builders/friend_item.dart';
import 'package:anonylist/templates/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:quiver/collection.dart';

class DatabaseService {
  final FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://anonylist-app.appspot.com');

  String? _uid;
  String? _name;
  String? _profilePicUrl;
  bool languageType = false;

  bool _lock = false;
  bool _lockName = false;

  static final DatabaseService _databaseService = DatabaseService._internal();
  DatabaseService._internal();

  factory DatabaseService({String? uid}) {
    if (!_databaseService._lock) {
      _databaseService._uid = uid;
      _databaseService._lock = true;
    }

    return _databaseService;
  }

  String get uid => _uid!;
  String get name => _name!;
  String? get profilePicUrl => _profilePicUrl;


  String uidHash(String s1, String s2) =>
      (<String>[s1, s2]..sort()).join();

  //Do not use this method, it should only ever be touched upon signout
  void unlockDatabase() {
    _lock = false;
    _lockName = false;
  }

  void setName(String name) {
    if (!_databaseService._lockName) {
      _databaseService._name = name;
      _databaseService._lockName = true;
    }
  }

  void setLanguageType(bool type) {
    languageType = type;
  }

  void setPic(String url) {
      _databaseService._profilePicUrl = url;
  }

  String? get currentProfilePicUrl {
    return _profilePicUrl;
  }

  Future<void> updateProfilePicUrl() async {
    var storageReference = storage.ref().child('user/pics/${uid}');
    var downloadTask = storageReference.getDownloadURL();
    _profilePicUrl = await downloadTask;
  }

  Future<String> findProfilePicUrl(String uid) async {
    var storageReference = storage.ref().child('user/pics/${uid}');
    var downloadTask = storageReference.getDownloadURL();
    return await downloadTask;
  }

  Future<void> uploadProfilePic(PickedFile file) async {
    var storageReference = storage.ref().child('user/pics/${uid}');
    var uploadTask = storageReference.putData(await file.readAsBytes(), SettableMetadata(contentType: 'image/jpeg'));
    uploadTask.whenComplete(() async {
      _profilePicUrl = await storageReference.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });
  }
  //DatabaseService({this.uid});
  
  // Get reference to a collection in the database
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
  final CollectionReference groupsCollection = FirebaseFirestore.instance.collection('groups');

  Future createUser(String uid, String name) async {
    await userCollection.doc(uid).set({
      'name': name,
      'groups': [],
    });
  }

  Future editUser(String? name) async {
    Map<String, Object> data = new HashMap();
    if (name != null) {
      data['name'] = name;
      _name = name;
    }
    await userCollection.doc(uid).set(
        data, SetOptions(merge: true)
    );
  }

  //get userPreferences Stream
  Stream<DocumentSnapshot> get userDetailsStream {
    return userCollection.doc(uid).snapshots();

    //return userPreferencesCollection.doc(uid).snapshots().map((DocumentSnapshot documentSnapshot) => AppUser(name: documentSnapshot.data()['name']))
    //return userPreferencesCollection.snapshots().map((QuerySnapshot querySnapshot) => querySnapshot.docs.map((e) => ));
  }

  Stream<QuerySnapshot> get userCollectionStream {
    return userCollection.snapshots();
  }

  Stream<QuerySnapshot> get friendsCollectionStream {
    return userCollection.doc(uid).collection('friends').snapshots();
  }

  Future<DocumentSnapshot> getUserDocFuture(String uid) {
    return userCollection.doc(uid).get();
  }

  Stream<DocumentSnapshot> getUserDocStream(String uid) {
    return userCollection.doc(uid).snapshots();
  }

  Future<DocumentSnapshot<Object?>> get userDataFuture {
    return userCollection.doc(uid).get();
  }

  Future<DocumentSnapshot<Object?>> getSpecificUserDataFuture(String? uid) {
    return userCollection.doc(uid).get();
  }

  Stream<DocumentSnapshot> getGroupStream(String groupName) {
    return groupsCollection.doc(groupName).snapshots();
  }

  Future<DocumentSnapshot> getGroupFuture(String groupName) {
    return groupsCollection.doc(groupName).get();
  }

  void addFriend(String uid) {
    userCollection.doc(this.uid).collection('friends').doc(uid).set({
      'time_added': Timestamp.now(),
    });
    userCollection.doc(uid).collection('friends').doc(this.uid).set({
      'time_added': Timestamp.now(),
    });
  }

  Future createGroupGlobal(String name) async {
    await groupsCollection.doc(uid + name).set({
      'name': name,
      'owner': uid,
    }, SetOptions(merge: true));
    await userCollection.doc(uid).update({
      'groups': FieldValue.arrayUnion([uid + name])
    });
  }

  void deleteGroupGlobal(String name, bool endEarly) {
    groupsCollection.doc(name).update({
      'active': false,
    });
  }

  void addUserToGroup(String groupName, String uid) async {
    await groupsCollection.doc(groupName).collection('lists').doc(uid).set({
      'time_added': Timestamp.now(),
    });
    await userCollection.doc(uid).update({
      'groups': FieldValue.arrayUnion([groupName])
    });
    var res = await groupsCollection.doc(groupName).collection('lists').doc(uid).collection('items').get();
    dev.log(res.toString(), name: 'Add to Group');
  }

  void modifyList(String groupName, String uid, String? itemName, String origin, String? link, bool? taken, String? takenBy) async {
    Map<String, Object> data = new HashMap();
    data['origin'] = origin;
    if (itemName != null) data['name'] = itemName;
    if (link != null) data['link'] = link;
    if (taken != null) data['taken'] = taken;
    if (takenBy != null) data['taken_by'] = takenBy;
    await groupsCollection.doc(groupName).collection('lists').doc(uid).collection('items').doc(origin).set(
        data, SetOptions(merge: true)
    );
  }

  void deleteItem(String groupName, String uid, String origin) async {
    await groupsCollection.doc(groupName).collection('lists').doc(uid).collection('items').doc(origin).delete();
  }

  Stream<QuerySnapshot> getLists(String groupName) {
    return groupsCollection.doc(groupName).collection('lists').snapshots();
  }

  Stream<QuerySnapshot> getItems(String groupName, String uid) {
    return groupsCollection.doc(groupName).collection('lists').doc(uid).collection('items').snapshots();
  }

  Future setSessionState(String modifyUid, bool state, String otherUid) async {
    await userCollection.doc(modifyUid).update({
      'session_active': state,
      'session_uid': otherUid,
    });
  }

  Future<bool> safelyAddFriend(String uid) async {

    // same user
    if (uid == DatabaseService().uid) {
      dev.log("Spidermen meme.");
      return false;
    }

    DocumentSnapshot friend = await getUserSnapshot(uid);
    if (!friend.exists) { // no such user
      dev.log("This friend isn't real. (User doesn't exist.)");
      return false;
    }

    DocumentSnapshot user = await DatabaseService().userDataFuture;

    // Check friend already in friends list
    var friendRecord = await userCollection.doc(DatabaseService().uid).collection("friends").doc(uid).get();
    if (friendRecord.exists) {
      dev.log("You're already friends!");
      return false;
    }

    dev.log("This friend completely new ... and they're real!");
    addFriend(uid);
    return true; // TODO: restructure -- return false as default exist condition
  }

  Future<DocumentSnapshot> getUserSnapshot(String uid) async {
    DocumentSnapshot userSnapshot = await DatabaseService().getUserDocFuture(uid);
    return userSnapshot;
  }

  Future<AppUser?> getAppUser(String uid) async {
    DocumentSnapshot friendInfo = await DatabaseService().getUserDocFuture(uid);

    var userInfo = friendInfo.data() as Map<String,
        dynamic>; //TODO Find out how to reference a doc cell

    return AppUser(
      uid: uid,
      name: userInfo['name'],
    );
  }

}