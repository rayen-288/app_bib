class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final String image;
  final bool available;
  final String addedBy; // 🔥 admin ID ou user ID

  Book({
    this.id = '',
    required this.title,
    required this.author,
    required this.category,
    required this.image,
    required this.available,
    required this.addedBy, // 🔥 obligatoire
  });

  // Crée un livre depuis Firestore
  factory Book.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      available: data['available'] ?? true,
      addedBy: data['addedBy'] ?? "", // 🔥 récupère l'admin ou user
    );
  }

  // Convertit un livre en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'image': image,
      'available': available,
      'addedBy': addedBy, // 🔥 sauvegarde l'auteur du livre
    };
  }
}
