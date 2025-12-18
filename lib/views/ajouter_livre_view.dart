import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';
import '../controllers/book_controller.dart';
import '../controllers/auth_controller.dart';

class AjouterLivreView extends StatefulWidget {
  const AjouterLivreView({super.key});

  @override
  State<AjouterLivreView> createState() => _AjouterLivreViewState();
}

class _AjouterLivreViewState extends State<AjouterLivreView> {
  final _formKey = GlobalKey<FormState>();

  final _titreCtrl = TextEditingController();
  final _auteurCtrl = TextEditingController();
  final _categorieCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();

  @override
  void dispose() {
    _titreCtrl.dispose();
    _auteurCtrl.dispose();
    _categorieCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Colors.deepPurple;
    final secondary = Colors.purple.shade50;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Ajouter un livre"),
        backgroundColor: primary,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(_titreCtrl, "Titre du livre", Icons.book, primary),
              const SizedBox(height: 16),
              _buildField(_auteurCtrl, "Auteur", Icons.person, primary),
              const SizedBox(height: 16),
              _buildField(_categorieCtrl, "Catégorie", Icons.category, primary),
              const SizedBox(height: 16),

              // Champ URL Image
              TextFormField(
                controller: _imageUrlCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.image),
                  labelText: "URL de l’image",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: primary, width: 2),
                  ),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "URL obligatoire";
                  if (!Uri.tryParse(value)!.isAbsolute) return "URL invalide";
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 20),

              // Aperçu image dans une card
              if (_imageUrlCtrl.text.isNotEmpty &&
                  Uri.tryParse(_imageUrlCtrl.text)?.isAbsolute == true)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  shadowColor: Colors.black12,
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    _imageUrlCtrl.text,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Text(
                          "Impossible de charger l'image",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Bouton Ajouter
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: primary.withOpacity(0.3),
                  ),
                  onPressed: _addBook,
                  child: const Text(
                    "Ajouter le livre",
                    style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Champ stylisé moderne
  Widget _buildField(
      TextEditingController ctrl, String label, IconData icon, Color primary) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primary),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      validator: (value) =>
          value == null || value.trim().isEmpty ? "Champ obligatoire" : null,
    );
  }

  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate()) return;

    final user = AuthController.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final role = doc.exists ? doc["role"] : "user";

    if (role != "admin") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Accès réservé à l’admin")),
      );
      return;
    }

    final book = Book(
      title: _titreCtrl.text.trim(),
      author: _auteurCtrl.text.trim(),
      category: _categorieCtrl.text.trim(),
      image: _imageUrlCtrl.text.trim(),
      available: true,
      addedByRole: "admin",
    );

    try {
      await BookController.addBook(book);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Livre ajouté avec succès 📚")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }
}
