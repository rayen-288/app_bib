import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'home_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool isAdmin = false; // 🔥 AJOUT DU ROLE

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Card(
                elevation: 10,
                shadowColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(25),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Connexion",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7F00FF),
                        ),
                      ),
                      const SizedBox(height: 25),

                      TextField(
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon:
                              Icon(Icons.email, color: Color(0xFF7F00FF)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextField(
                        controller: passCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          prefixIcon:
                              Icon(Icons.lock, color: Color(0xFF7F00FF)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔥 Switch Admin
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Connexion Admin ?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7F00FF))),
                          Switch(
                            value: isAdmin,
                            activeColor: Color(0xFF7F00FF),
                            onChanged: (v) {
                              setState(() {
                                isAdmin = v;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7F00FF),
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Se connecter",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () async {
                          final result = await AuthController.loginWithRole(
                            emailCtrl.text.trim(),
                            passCtrl.text.trim(),
                            isAdmin,
                          );

                          if (result != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result)),
                            );
                            return;
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeView(email: emailCtrl.text),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 15),

                      TextButton(
                        child: Text(
                          "Créer un compte",
                          style: TextStyle(color: Color(0xFF7F00FF)),
                        ),
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
          ),
        ),
      ),
    );
  }
}
