import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'register_view.dart';
import 'home_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final auth = AuthController();

  // 🔴 Erreurs sous champs
  String? emailError;
  String? passError;

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
        title: Text("Connexion", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primary,
        elevation: 0,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Card(
          elevation: 8,
          shadowColor: primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildField(
                  controller: emailCtrl,
                  label: "Email",
                  icon: Icons.email,
                  errorText: emailError,
                ),

                _buildField(
                  controller: passCtrl,
                  label: "Mot de passe",
                  icon: Icons.lock,
                  errorText: passError,
                  isPassword: true,
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("Se connecter",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  onPressed: validateLogin,
                ),

                SizedBox(height: 10),

                TextButton(
                  child: Text("Créer un compte",
                      style: TextStyle(color: primary, fontSize: 14)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterView()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔎 Validation individuelle
  void validateLogin() {
    setState(() {
      emailError = emailCtrl.text.contains("@") ? null : "Email invalide";
      passError = passCtrl.text.isEmpty ? "Mot de passe obligatoire" : null;
    });

    if (emailError != null || passError != null) return;

    bool ok = auth.login(emailCtrl.text, passCtrl.text);

    if (!ok) {
      setState(() {
        passError = "Email ou mot de passe incorrect";
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeView(email: emailCtrl.text)),
    );
  }

  // 🌿 Champ stylé + erreur
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            obscureText: isPassword,
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
