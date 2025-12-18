import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'home_view.dart';          // Admin
import 'user_home_view.dart';     // User
import 'visitor_home_view.dart';  // 🔥 Visiteur
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool isAdmin = false;

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
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Connexion",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7F00FF),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // EMAIL
                      TextField(
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon:
                              const Icon(Icons.email, color: Color(0xFF7F00FF)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // PASSWORD
                      TextField(
                        controller: passCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          prefixIcon:
                              const Icon(Icons.lock, color: Color(0xFF7F00FF)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ADMIN SWITCH
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Connexion Admin ?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7F00FF),
                            ),
                          ),
                          Switch(
                            value: isAdmin,
                            activeColor: const Color(0xFF7F00FF),
                            onChanged: (v) => setState(() => isAdmin = v),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // LOGIN BUTTON
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7F00FF),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _loginUser,
                        child: const Text(
                          "Se connecter",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // REGISTER
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>  RegisterView()),
                          );
                        },
                        child: const Text(
                          "Créer un compte",
                          style: TextStyle(color: Color(0xFF7F00FF)),
                        ),
                      ),

                      const Divider(height: 30),

                      // 🔥 VISITOR BUTTON
                      OutlinedButton.icon(
                        icon: const Icon(Icons.visibility),
                        label: const Text("Continuer en tant que visiteur"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF7F00FF),
                          side:
                              const BorderSide(color: Color(0xFF7F00FF)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VisitorHomeView(),
                            ),
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

  // 🔐 LOGIN LOGIC
  Future<void> _loginUser() async {
    final result = await AuthController.loginWithRole(
      emailCtrl.text.trim(),
      passCtrl.text.trim(),
      isAdmin,
    );

    if (result != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
      return;
    }

    if (isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeView(email: emailCtrl.text),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserHomeView(userName: emailCtrl.text),
        ),
      );
    }
  }
}
