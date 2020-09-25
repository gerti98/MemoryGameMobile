import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'utils.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Stream<GoogleSignInAccount> userStream;
  GoogleSignInAccount googleSignInAccount;

  AuthService() {
    userStream = googleSignIn.onCurrentUserChanged;
  }

  Future<String> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    final User user = userCredential.user;

    googleSignInAccount = googleUser;

    updateUserData(googleUser);
    // Once signed in, return the UserCredential
    return '$user';
  }

  void signOutWithGoogle() async {
    gameController.finishGameNoFocus();
    googleSignIn.signOut();
    print(" +++++ SIGNED OUT WITH GOOGLE +++++");
  }

  void signOut() {
    auth.signOut();
    print(" +++++ SIGNED OUT +++++");
  }

  void updateUserData(GoogleSignInAccount user) async {
    DocumentReference ref = db.collection('users').doc(user.id);
    SetOptions setOptions = SetOptions(merge: true);

    return ref.set({
      'uid': user.id,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, setOptions);
  }

  void updateScoreData(GoogleSignInAccount user, int score) async {
    DocumentReference ref =
        db.collection('scores').doc(user.id + " " + Timestamp.now().toString());
    SetOptions setOptions = SetOptions(merge: true);

    return ref.set({
      'uid': user.id,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'score': score,
      'matchTime': DateTime.now()
    }, setOptions);
  }

  void updateMessageData(GoogleSignInAccount user, String msg) async {
    DocumentReference ref = db
        .collection('messages')
        .doc(user.id + " " + Timestamp.now().toString());
    SetOptions setOptions = SetOptions(merge: true);

    return ref.set({
      'uid': user.id,
      'displayName': user.displayName,
      'message': msg,
      'matchTime': DateTime.now()
    }, setOptions);
  }

  Future<int> getMatchPlayed(GoogleSignInAccount user) async {
    return 0;
  }

  Future<int> getBestScore(GoogleSignInAccount user) async {
    return 0;
  }
}

AuthService authService = AuthService();

// VECCHIA VERSIONE AUTH
// class AuthService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final Firestore _db = Firestore.instance;

//   Observable<FirebaseUser> user;
//   Observable<Map<String, dynamic>> profile;
//   PublishSubject loading = PublishSubject();

//   AuthService() {
//     user = Observable(_auth.onAuthStateChanged);

//     profile = user.switchMap((FirebaseUser u) {
//       if (u != null) {
//         return _db
//             .collection('users')
//             .document(u.uid)
//             .snapshots()
//             .map((snap) => snap.data);
//       } else {
//         return Observable.just({});
//       }
//     });
//   }

//   Future<FirebaseUser> googleSignIn() async {
//     // Start
//     loading.add(true);

//     // Step 1
//     GoogleSignInAccount googleUser = await _googleSignIn.signIn();

//     // Step 2
//     GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     final AuthResult authResult = await _auth.signInWithCredential(credential);
//     FirebaseUser user = authResult.user;

//     // Step 3
//     updateUserData(user);

//     // Done
//     loading.add(false);
//     print("signed in " + user.displayName);
//     return user;
//   }

//   void updateUserData(FirebaseUser user) async {
//     DocumentReference ref = _db.collection('users').document(user.uid);

//     return ref.setData({
//       'uid': user.uid,
//       'email': user.email,
//       'photoURL': user.photoUrl,
//       'displayName': user.displayName,
//       'lastSeen': DateTime.now()
//     }, merge: true);
//   }

//   void signOut() {
//     _auth.signOut();
//   }
// }
