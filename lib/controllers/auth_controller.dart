import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =====================================================
  // 🔥 INSCRIPTION AVEC RÔLE (user par défaut)
  // =====================================================
  static Future<String?> register(UserModel user, {String role = "user"}) async {
    try {
      // 1️⃣ Créer un compte Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      String uid = cred.user!.uid;

      // 2️⃣ Enregistrer le profil + RÔLE dans Firestore
      await _db.collection("users").doc(uid).set({
        "fullName": user.fullName,
        "age": user.age,
        "email": user.email,
        "phone": user.phone,
        "role": role, // 🔥 Rôle ici
      });

      return null; // success
    } catch (e) {
      return e.toString();
    }
  }

  // =====================================================
  // 🔥 CONNEXION AVEC VERIFICATION DU ROLE
  // =====================================================
  static Future<String?> loginWithRole(
      String email, String password, bool isAdmin) async {
    try {
      // 1️⃣ Connexion
      UserCredential cred =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      String uid = cred.user!.uid;

      // 2️⃣ Récupérer le rôle depuis Firestore
      DocumentSnapshot doc =
          await _db.collection("users").doc(uid).get();

      if (!doc.exists) return "Profil utilisateur introuvable";

      String role = doc["role"];

      // 3️⃣ Vérification du rôle attendu
      if (isAdmin && role != "admin") {
        return "Ce compte n'est pas un compte ADMIN";
      }

      if (!isAdmin && role != "user") {
        return "Veuillez vous connecter en mode Admin";
      }

      return null; // OK
    } catch (e) {
      return e.toString();
    }
  }

  // =====================================================
  // 🔥 CONNEXION SIMPLE (sans rôle)
  // =====================================================
  static Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // =====================================================
  // 🔥 DÉCONNEXION
  // =====================================================
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // =====================================================
  // 🔥 UTILISATEUR ACTUEL
  // =====================================================
  static User? get currentUser => _auth.currentUser;
}
