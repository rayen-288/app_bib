import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../controllers/book_controller.dart';

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

  @override
  void dispose() {
    _titreCtrl.dispose();
    _auteurCtrl.dispose();
    _categorieCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un livre")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(_titreCtrl, "Titre", Icons.book),
              const SizedBox(height: 16),
              _buildField(_auteurCtrl, "Auteur", Icons.person),
              const SizedBox(height: 16),
              _buildField(_categorieCtrl, "Catégorie", Icons.category),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _addBook,
                child: const Text("Ajouter le livre"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Champ obligatoire";
        }
        return null;
      },
    );
  }

  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate()) return;

    final book = Book(
      title: _titreCtrl.text.trim(),
      author: _auteurCtrl.text.trim(),
      category: _categorieCtrl.text.trim(),
      image: "https://th.bing.com/th/id/R.7996bcb0bee8bcda2d1d554fdbe1c493?rik=E4YNjkSl5Obn0Q&riu=http%3a%2f%2flepassetempsderose.l.e.pic.centerblog.net%2fo%2f67c019e5.png&ehk=qShDEF3a%2fhZtKWKarnlSRa%2f08fKeaX%2bH7dWprgBajE8%3d&risl=&pid=ImgRaw&r=0",
      available: true,
    );

    try {
      await BookController.addBook(book);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Livre ajouté !")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout : $e")),
      );
    }
  }
}
