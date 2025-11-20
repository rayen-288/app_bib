import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookController {
  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection('books');

  // Ajoute un livre à Firestore
  static Future<void> addBook(Book book) async {
    await _collection.add(book.toMap());
  }

  // Stream de livres en temps réel
  static Stream<List<Book>> getBooksStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Book.fromFirestore(data, doc.id);
      }).toList();
    });
  }
}
