import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String bookId;
  final String bookTitle;
  final String userId;
  final String userName;
  final String status;
  final DateTime reservedAt;
  final DateTime? returnedAt;

  Reservation({
    this.id = "",
    required this.bookId,
    required this.bookTitle,
    required this.userId,
    required this.userName,
    required this.status,
    required this.reservedAt,
    this.returnedAt,
  });

  factory Reservation.fromFirestore(
      Map<String, dynamic> data, String id) {
    return Reservation(
      id: id,
      bookId: data['bookId'],
      bookTitle: data['bookTitle'],
      userId: data['userId'],
      userName: data['userName'],
      status: data['status'],
      reservedAt: (data['reservedAt'] as Timestamp).toDate(),
      returnedAt: data['returnedAt'] != null
          ? (data['returnedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "bookId": bookId,
      "bookTitle": bookTitle,
      "userId": userId,
      "userName": userName,
      "status": status,
      "reservedAt": Timestamp.fromDate(reservedAt),
      "returnedAt": returnedAt != null
          ? Timestamp.fromDate(returnedAt!)
          : null,
    };
  }
}
