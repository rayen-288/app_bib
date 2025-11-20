import 'package:flutter/material.dart';
import '../controllers/book_controller.dart';
import '../models/book_model.dart';
import 'ajouter_livre_view.dart';

class HomeView extends StatefulWidget {
  final String email;

  HomeView({required this.email});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Color primary = Color(0xFF2E7D32);

  String searchQuery = "";
  String selectedCategory = "Tous";

  // Liste des catégories possibles (mise à jour automatique depuis Firestore)
  List<String> categories = ["Tous"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text("Bibliothèque CSFM"),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 30),
            onPressed: () {},
          )
        ],
      ),

      body: StreamBuilder<List<Book>>(
        stream: BookController.getBooksStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final books = snapshot.data!;

          // Mise à jour automatique de la liste catégories
          categories = ["Tous"];
          categories.addAll(
            books.map((b) => b.category).toSet(),
          );

          // 🔥 Filtrage par recherche + catégorie
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
              // 🔎 Barre de recherche
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Rechercher un livre...",
                    prefixIcon: Icon(Icons.search, color: primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
                ),
              ),

              // 🔽 Liste déroulante catégories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: primary, width: 1),
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

              SizedBox(height: 10),

              // 📚 Liste des livres filtrés
              Expanded(
                child: GridView.builder(
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AjouterLivreView()),
          );

          if (result == true) setState(() {});
        },
      ),
    );
  }

  // 📘 Carte Livre
  Widget _buildBookCard(Book book) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du livre
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
                      color: Colors.teal[700],
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
