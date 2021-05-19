
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meenforquei/services/firestore_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  User _firebaseUser;
  bool get userLogged => _firebaseUser != null;

  UserModel _currentUser;
  UserModel get currentUser => _currentUser;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUpWithEmailUserPar(email, password) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.signOut();
      return authResult.user.uid;
    } catch (e) {
      return e.message;
    }
  }

  Future<String> signUpWithEmailUser(email, password) async {
    User user;
    String errorMessage;
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      user = result.user;
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return user.uid;
  }

  Future<String> createWedding({
    @required String tagCasal,
    @required String nomePar1,
    @required String nomePar2})
  async {
    try {
      return await _firestoreService.createWedding(tagCasal: tagCasal, nomePar1: nomePar1, nomePar2: nomePar2);
    } catch (e) {
      return e.message;
    }
  }

  Future<String> createUser(Map<String, dynamic> userData, String userID) async {
    try {
      var authResult = await _firestoreService.createUsuario(userData, userID);
      return authResult.user.uid;
    } catch (e) {
      return e.toString();
    }
  }

  Future saveCasal(String wedID, String uid, Map<String, dynamic> userData) async {
    try {
      await _firestoreService.createCasal(wedID.trim(), uid.trim(), userData);
    } catch (e) {
      return e.toString();
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String role,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      /* ToDo: Tratar o user model
      _currentUser = UserModel(
        uid: authResult.user.uid,
        email: email,
        fullName: fullName,
        userRole: role,
      );
      */

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  Future<bool> isUserLoggedIn() async {
    if (_firebaseUser == null) {
      _firebaseUser = _firebaseAuth.currentUser;
      await _populateCurrentUser(_firebaseUser);
    }

    return _firebaseUser != null;
  }

  Future<bool> isUserViewIntro(String userId) async{
    return true; // ToDo: Pegar do lugar certo para aparecer 1 vez apenas
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);

      if (_currentUser.name == null){
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        _currentUser = UserModel.fromData(docUser.data(), user.uid);
      }

      _currentUser.isAdmin = await verifyPrivileges(user.uid);
      _currentUser.isCasal = true;

      // Se sou convidado
      if (_currentUser.wedding == null || _currentUser.wedding.isEmpty){
        _currentUser.isCasal = false;

        // ToDo: Lista todos os casamentos que sou convidado e o usuário deve escolher o casamento para prosseguir
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("wedding")
            .get();

        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var a = querySnapshot.docs[i];
          _currentUser.wedding = a.data()["wedding"];

          print('Check Login');
          print(a.data()["wedding"]);

          if ("ZEcjdTjdjSG79GX96u3K" == a.data()["wedding"]) { // ToDo: ID do wedding - escolher em uma lista para os convidados
            _currentUser.nomecasal = await nomeCasal(a.data()["wedding"]);
            _currentUser.data = await dataCasal(a.data()["wedding"]);
          }
        }

      }else{
        _currentUser.nomecasal = await nomeCasal(_currentUser.wedding);
      }
    }
  }

  Future populateCurrentUserId(String uid) async {
    if (uid.isNotEmpty) {
      _currentUser = await _firestoreService.getUser(uid);

      if (_currentUser.name == null){
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(_firebaseUser.uid)
            .get();

        _currentUser = UserModel.fromData(docUser.data(), uid);
      }

      _currentUser.isAdmin = await verifyPrivileges(uid);
      _currentUser.isCasal = true;

      // Se sou convidado
      if (_currentUser.wedding == null || _currentUser.wedding.isEmpty){
        _currentUser.isCasal = false;

        // ToDo: Lista todos os casamentos que sou convidado e o usuário deve escolher o casamento para prosseguir
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(_firebaseUser.uid)
            .collection("wedding")
            .get();

        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var a = querySnapshot.docs[i];
          _currentUser.wedding = a.data()["wedding"];

          if ("ZEcjdTjdjSG79GX96u3K" == a.data()["wedding"]) { // ToDo: ID do wedding
            _currentUser.nomecasal = await nomeCasal(a.data()["wedding"]);
            _currentUser.data = await dataCasal(a.data()["wedding"]);
          }
        }

      }else{
        _currentUser.nomecasal = await nomeCasal(_currentUser.wedding);
      }
    }
  }

  Future<bool> verifyPrivileges(String uid) async {
    return await FirebaseFirestore.instance.collection("admins").doc(uid).get().then((doc){
      if (doc.data != null){
        return true;
      }else{
        return false;
      }
    }).catchError((e){
      return false;
    });
  }

  Future<String> nomeCasal(String wedding) async {
    String retorno = "";

    await FirebaseFirestore.instance.collection("wedding").doc(wedding).get().then((doc){
      if (doc.data != null){
        retorno = doc.data()["nome1"] + " & " + doc.data()["nome2"];
      }else{
        retorno = "";
      }
    }).catchError((e){
      retorno = "";
    });

    return retorno;
  }

  Future<String> dataCasal(String wedding) async {
    String retorno = "";

    await FirebaseFirestore.instance.collection("wedding").doc(wedding).get().then((doc){
      if (doc.data != null){
        retorno = doc.data()["data"];
      }else{
        retorno = "";
      }
    }).catchError((e){
      retorno = "";
    });

    return retorno;
  }

  Future<String> verifyWedding(String wedding) async {
    String retorno = "";

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("wedding").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      if (wedding == a.data()["tagcasal"]) {
        return a.id;
      }
    }

    return retorno;
  }

  Future<String> listConvidadoWedding(String wedding) async {
    String retorno = "";

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("users").doc(_firebaseUser.uid).collection("wedding").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      if (wedding == a.data()["wedding"]) {
        return a.id;
      }
    }

    return retorno;
  }

  Future<Null> saveUserDataWedding(String wedding, String userId) async {
    Map<String, dynamic> weddingData = {"wedding": wedding};

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("wedding")
        .add(weddingData);
  }

  Future<Null> saveUserConvidadoWedding(String wedding, String uid, Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection("wedding")
        .doc(wedding)
        .collection("convidados")
        .doc(uid)
        .set(userData);
  }
}
