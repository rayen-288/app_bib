import 'package:flutter/material.dart';
import '../controllers/book_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/reservation_controller.dart';
import '../models/book_model.dart';
import '../models/reservation_model.dart';
import 'reservation_history_view.dart';
import 'login_view.dart';

class UserHomeView extends StatefulWidget {
  final String userName;

  const UserHomeView({super.key, required this.userName});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
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
          "Bibliothèque • Utilisateur",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Déconnexion",
            onPressed: () async {
              await AuthController.logout();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginView()),
              );
            },
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

              // 🔍 RECHERCHE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _searchField(),
              ),

              const SizedBox(height: 12),

              // 📜 HISTORIQUE DES RÉSERVATIONS (BLANC)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.history, color: Colors.white),
                  label: const Text(
                    "Historique des réservations",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    final userId = AuthController.currentUser?.uid;
                    if (userId == null) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ReservationHistoryView(userId: userId),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 📚 LIVRES
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          "Aucun livre disponible",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
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

  // 🔍 CHAMP DE RECHERCHE
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

  // 📘 CARTE LIVRE
  Widget _bookCard(Book book) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                book.image,
                fit: BoxFit.cover,
              ),
            ),

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
                        backgroundColor:
                            book.available ? primary : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: book.available
                          ? () async {
                              final user =
                                  AuthController.currentUser;
                              if (user == null) return;

                              await ReservationController.reserveBook(
                                Reservation(
                                  id: "",
                                  bookId: book.id,
                                  bookTitle: book.title,
                                  userId: user.uid,
                                  userName: widget.userName,
                                  status: "reserved",
                                  reservedAt: DateTime.now(),
                                  returnedAt: null,
                                ),
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Livre réservé avec succès 📚"),
                                ),
                              );
                            }
                          : null,
                      child: const Text(
                        "Réserver",
                        style: TextStyle(color: Colors.white),
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
}
