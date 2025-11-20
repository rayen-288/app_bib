import '../models/user_model.dart';

class AuthController {
  static List<UserModel> users = [];

  // Validation des champs
  String? validateRegister({
    required String fullName,
    required String age,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) {
    if (fullName.isEmpty) return "Le nom est obligatoire";
    if (int.tryParse(age) == null) return "L'âge doit être un nombre";
    if (int.parse(age) < 16) return "Vous devez avoir au moins 16 ans";
    if (!email.contains("@")) return "Email invalide";
    if (phone.length != 8) return "Le numéro doit contenir 8 chiffres";
    if (password.length < 6) return "Mot de passe trop court (min 6)";
    if (password != confirmPassword) return "Les mots de passe ne correspondent pas";

    for (var user in users) {
      if (user.email == email) return "Cet email existe déjà";
    }

    return null;
  }

  // Inscription
  bool register(UserModel user) {
    users.add(user);
    return true;
  }

  // Connexion
  bool login(String email, String password) {
    for (var user in users) {
      if (user.email == email && user.password == password) return true;
    }
    return false;
  }
}
