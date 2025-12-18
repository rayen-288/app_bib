import 'package:flutter/material.dart';
import '../controllers/book_controller.dart';
import '../models/book_model.dart';
import 'login_view.dart';

class VisitorHomeView extends StatefulWidget {
  const VisitorHomeView({super.key});

  @override
  State<VisitorHomeView> createState() => _VisitorHomeViewState();
}

class _VisitorHomeViewState extends State<VisitorHomeView> {
  final Color primary = const Color(0xFF7F00FF);
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Bibliothèque • Visiteur",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginView()),
              );
            },
            child: const Text(
              "Connexion",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),

      body: StreamBuilder<List<Book>>(
        stream: BookController.getBooksStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          final adminBooks = snapshot.data!
              .where((b) => b.addedByRole == "admin")
              .toList();

          final filtered = adminBooks.where((book) {
            return book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                   book.author.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              const SizedBox(height: 12),

              // 🔍 SEARCH
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _searchField(),
              ),

              const SizedBox(height: 16),

              // 📚 GRID
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          "Aucun livre disponible",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.60,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => _bookCard(filtered[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 🔍 SEARCH FIELD
  Widget _searchField() {
    return TextField(
      onChanged: (v) => setState(() => searchQuery = v),
      decoration: InputDecoration(
        hintText: "Rechercher un livre...",
        prefixIcon: Icon(Icons.search, color: primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // 📘 CARD LIVRE (VISITEUR)
  Widget _bookCard(Book book) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // 🖼 IMAGE
            Positioned.fill(
              child: Image.network(
                book.image,
                fit: BoxFit.cover,
              ),
            ),

            // 🌈 OVERLAY
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),

            // 🏷 STATUS
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: book.available ? primary : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  book.available ? "Disponible" : "Indisponible",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 📘 INFOS + BOUTON LOGIN
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: _goToLogin,
                      child: Text(
                        "Se connecter pour réserver",
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginView()),
    );
  }
}
