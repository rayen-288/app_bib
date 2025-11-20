import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final auth = AuthController();

  final fullNameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  // Messages d'erreur
  String? fullNameError;
  String? ageError;
  String? emailError;
  String? phoneError;
  String? passError;
  String? confirmError;

  // 🎨 Couleurs thème bibliothèque
  final Color primary = Color(0xFF2E7D32);      // Vert foncé bibliothèque
  final Color secondary = Color(0xFF4CAF50);    // Vert clair
  final Color accent = Color(0xFFFF9800);       // Orange marque-page
  final Color background = Color(0xFFF3F7F2);   // Blanc cassé

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: Text("Créer un compte", style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shadowColor: primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildField(fullNameCtrl, "Nom complet", Icons.person, fullNameError),
                _buildField(ageCtrl, "Âge", Icons.cake, ageError, isNumber: true),
                _buildField(emailCtrl, "Email", Icons.email, emailError),
                _buildField(phoneCtrl, "Téléphone", Icons.phone, phoneError, isNumber: true),
                _buildField(passCtrl, "Mot de passe", Icons.lock, passError, isPassword: true),
                _buildField(confirmCtrl, "Confirmer mot de passe", Icons.lock_outline, confirmError, isPassword: true),

                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text("Créer un compte", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: validateForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔎 Validation
  void validateForm() {
    setState(() {
      fullNameError = fullNameCtrl.text.isEmpty ? "Le nom est obligatoire" : null;

      if (ageCtrl.text.isEmpty) {
        ageError = "L'âge est obligatoire";
      } else if (int.tryParse(ageCtrl.text) == null) {
        ageError = "L'âge doit être un nombre";
      } else if (int.parse(ageCtrl.text) < 16) {
        ageError = "Vous devez avoir au moins 16 ans";
      } else {
        ageError = null;
      }

      emailError = emailCtrl.text.contains("@") ? null : "Email invalide";

      phoneError = phoneCtrl.text.length == 8 ? null : "Le numéro doit contenir 8 chiffres";

      passError = passCtrl.text.length >= 6 ? null : "Mot de passe trop court";

      confirmError = passCtrl.text == confirmCtrl.text ? null : "Les mots de passe ne correspondent pas";
    });

    if (fullNameError != null ||
        ageError != null ||
        emailError != null ||
        phoneError != null ||
        passError != null ||
        confirmError != null) {
      return;
    }

    auth.register(
      UserModel(
        fullName: fullNameCtrl.text,
        age: int.parse(ageCtrl.text),
        email: emailCtrl.text,
        phone: phoneCtrl.text,
        password: passCtrl.text,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Compte créé avec succès !")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginView()),
    );
  }

  // 🌿 Champ stylé bibliothèque + message d'erreur
  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon,
    String? errorText, {
    bool isPassword = false,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: primary),
              labelText: label,
              labelStyle: TextStyle(color: primary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: secondary, width: 2),
              ),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: Text(
                errorText,
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
