import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final fullNameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌈 Fond dégradé moderne violet
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Card(
              elevation: 10,
              shadowColor: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

              child: Padding(
                padding: const EdgeInsets.all(25),

                child: Form(
                  key: _formKey,  // ✅ FORMULIARE ACTIVÉ
                  child: Column(
                    children: [
                      Text(
                        "Créer un compte",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7F00FF),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _field(fullNameCtrl, "Nom complet", Icons.person),
                      const SizedBox(height: 15),

                      _field(ageCtrl, "Âge", Icons.cake, number: true),
                      const SizedBox(height: 15),

                      _field(emailCtrl, "Email", Icons.email),
                      const SizedBox(height: 15),

                      _field(phoneCtrl, "Téléphone", Icons.phone, number: true),
                      const SizedBox(height: 15),

                      _field(passCtrl, "Mot de passe", Icons.lock, password: true),
                      const SizedBox(height: 15),

                      _field(
                        confirmCtrl,
                        "Confirmer Mot de passe",
                        Icons.lock_outline,
                        password: true,
                      ),

                      const SizedBox(height: 25),

                      isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF7F00FF),
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                "Créer un compte",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              onPressed: _registerUser,
                            ),

                      const SizedBox(height: 10),

                      TextButton(
                        child: Text(
                          "Déjà un compte ? Connexion",
                          style: TextStyle(color: Color(0xFF7F00FF)),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginView()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // CHAMPS DE TEXTE
  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {bool password = false, bool number = false}) {
    return TextFormField(
      controller: ctrl,
      obscureText: password,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF7F00FF)),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "Champ obligatoire";

        if (label == "Âge") {
          final age = int.tryParse(value);
          if (age == null || age < 10) return "Âge invalide";
        }

        if (label == "Email" && !value.contains("@")) {
          return "Email invalide";
        }

        if (label == "Téléphone" && value.length != 8) {
          return "Le numéro doit contenir 8 chiffres";
        }

        if (label == "Confirmer Mot de passe" &&
            value != passCtrl.text) {
          return "Les mots de passe ne correspondent pas";
        }

        return null;
      },
    );
  }

  // LOGIQUE D'INSCRIPTION
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final user = UserModel(
      fullName: fullNameCtrl.text.trim(),
      age: int.parse(ageCtrl.text.trim()),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      password: passCtrl.text.trim(),
      role: "user", // 🔥 IMPORTANT
    );

    final error = await AuthController.register(user);

    setState(() => isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Compte créé avec succès !")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginView()),
    );
  }
}
