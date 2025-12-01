import 'package:flutter/material.dart';
import '../controllers/book_controller.dart';
import '../models/book_model.dart';

class UserHomeView extends StatefulWidget {
  final String userName;

  UserHomeView({required this.userName});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  final Color primary = Color(0xFF7F00FF);
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          "Bibliothèque • Utilisateur",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: StreamBuilder<List<Book>>(
        stream: BookController.getBooksStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          // 📌 Tous les livres Firestore
          final books = snapshot.data!;

          // 📌 On garde UNIQUEMENT les livres ajoutés par ADMIN
          final adminBooks = books.where((b) => b.addedByRole == "admin").toList();

          // 📌 Recherche
          final filtered = adminBooks.where((book) {
            return book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                   book.author.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              // 🔎 BARRE DE RECHERCHE
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Rechercher un livre...",
                    prefixIcon: Icon(Icons.search, color: primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
                ),
              ),

              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          "Aucun livre ajouté par l’administrateur.",
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return _buildBookCard(filtered[index]);
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }

  // 📘 CARTE LIVRE
  Widget _buildBookCard(Book book) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              book.image,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text(book.author,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                SizedBox(height: 6),
                Text(book.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
