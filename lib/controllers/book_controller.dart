import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookController {
  static final CollectionReference _books =
      FirebaseFirestore.instance.collection("books");

  static final CollectionReference _reservations =
      FirebaseFirestore.instance.collection("reservations");

  // ➕ Ajouter un livre
  static Future<void> addBook(Book book) async {
    await _books.add(book.toMap());
  }

  // 🔄 Stream des livres
  static Stream<List<Book>> getBooksStream() {
    return _books.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // 🔥 METTRE À JOUR DISPONIBILITÉ (FIX ERREUR)
  static Future<void> updateAvailability(
      String bookId, bool available) async {
    await _books.doc(bookId).update({
      "available": available,
    });
  }

  // 🔥 Réserver un livre (OPTIONNEL si tu veux tout ici)
  static Future<void> reserveBook({
    required Book book,
    required String userId,
    required String userEmail,
  }) async {
    await _reservations.add({
      "bookId": book.id,
      "bookTitle": book.title,
      "userId": userId,
      "userEmail": userEmail,
      "reservedAt": Timestamp.now(),
      "status": "reserved",
    });

    await updateAvailability(book.id, false);
  }
}
