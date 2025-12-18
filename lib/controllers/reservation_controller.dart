import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservation_model.dart';
import 'book_controller.dart';

class ReservationController {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* ===================== STREAM ADMIN ===================== */
  static Stream<List<Reservation>> getReservationsStream() {
    return _db
        .collection("reservations")
        .orderBy("reservedAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Reservation.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  /* ===================== STREAM USER ===================== */
  static Stream<List<Reservation>> getUserReservationsStream(String userId) {
    return _db
        .collection("reservations")
        .where("userId", isEqualTo: userId)
        .orderBy("reservedAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Reservation.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  /* ===================== CRÉER RÉSERVATION ===================== */
  static Future<void> reserveBook(Reservation reservation) async {
    await _db.collection("reservations").add(reservation.toMap());

    // rendre le livre indisponible
    await BookController.updateAvailability(reservation.bookId, false);
  }

  /* ===================== ❌ ANNULER RÉSERVATION ===================== */
  static Future<void> cancelReservation(Reservation reservation) async {
    // 1️⃣ Supprimer la réservation
    await _db.collection("reservations").doc(reservation.id).delete();

    // 2️⃣ Rendre le livre disponible
    await BookController.updateAvailability(reservation.bookId, true);
  }
}
