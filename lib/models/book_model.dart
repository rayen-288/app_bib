class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final String image;
  final bool available;

  Book({
    this.id = '',
    required this.title,
    required this.author,
    required this.category,
    required this.image,
    required this.available,
  });

  // Crée un livre depuis un document Firestore
  factory Book.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      available: data['available'] ?? true,
    );
  }

  // Convertit un livre en map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'image': image,
      'available': available,
    };
  }
}
