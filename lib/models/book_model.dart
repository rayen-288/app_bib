class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final String image;
  final bool available;
  final String addedByRole;

  Book({
    this.id = '',
    required this.title,
    required this.author,
    required this.category,
    required this.image,
    required this.available,
    required this.addedByRole,
  });

  factory Book.fromFirestore(Map<String, dynamic> data, String docId) {
    return Book(
      id: docId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      available: data['available'] ?? true,
      addedByRole: data['addedByRole'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'image': image,
      'available': available,
      'addedByRole': addedByRole,
    };
  }
}
