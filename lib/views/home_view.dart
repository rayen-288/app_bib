import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/book_controller.dart';
import '../models/book_model.dart';
import 'ajouter_livre_view.dart';
import 'login_view.dart';

class HomeView extends StatefulWidget {
  final String email;

  HomeView({required this.email});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Color purple1 = Color(0xFF7F00FF);
  final Color purple2 = Color(0xFFE100FF);

  String searchQuery = "";
  String selectedCategory = "Tous";
  List<String> categories = ["Tous"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌈 AppBar violet moderne
      appBar: AppBar(
        title: Text(
          "Bibliothèque CSFM",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: purple1,
        actions: [
          IconButton(
            icon: Icon(Icons.person, size: 28),
            onPressed: () {
              // futur écran profil
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthController.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginView()),
              );
            },
          ),
        ],
      ),

      // 🔥 Stream Firebase
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [purple1.withOpacity(0.10), purple2.withOpacity(0.10)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: StreamBuilder<List<Book>>(
          stream: BookController.getBooksStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(color: purple1));
            }

            final books = snapshot.data!;

            // Mettre à jour automatiquement les catégories
            categories = ["Tous"];
            categories.addAll(
              books.map((b) => b.category).toSet(),
            );

            // Filtrage
            final filtered = books.where((book) {
              final matchSearch =
                  book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  book.author.toLowerCase().contains(searchQuery.toLowerCase());

              final matchCategory = selectedCategory == "Tous"
                  ? true
                  : book.category == selectedCategory;

              return matchSearch && matchCategory;
            }).toList();

            return Column(
              children: [
                const SizedBox(height: 12),

                // 🔍 Barre de recherche modernisée
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Rechercher un livre...",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: purple1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // 🔽 Dropdown Catégorie stylisé
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: purple1, width: 1.2),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      underline: SizedBox(),
                      items: categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedCategory = value!);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 📚 Grille des livres
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(15),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildBookCard(filtered[index]);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: purple1,
        child: Icon(Icons.add, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AjouterLivreView()),
          );
        },
      ),
    );
  }

  // 📘 Carte Livre modernisée
  Widget _buildBookCard(Book book) {
    return Card(
      elevation: 7,
      shadowColor: purple1.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du livre
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              book.image,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                ),
                SizedBox(height: 5),

                Text(
                  book.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                SizedBox(height: 5),

                Text(
                  book.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: purple1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
