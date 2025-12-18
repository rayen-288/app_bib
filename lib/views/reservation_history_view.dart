import 'package:flutter/material.dart';
import '../controllers/reservation_controller.dart';
import '../models/reservation_model.dart';

class ReservationHistoryView extends StatelessWidget {
  final String userId;

  const ReservationHistoryView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF7F00FF);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique des réservations"),
        backgroundColor: primary,
      ),
      body: StreamBuilder<List<Reservation>>(
        stream: ReservationController.getUserReservationsStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune réservation trouvée"));
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservations.length,
            itemBuilder: (_, i) {
              final r = reservations[i];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: const EdgeInsets.only(bottom: 14),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.bookTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),
                      Text("Statut : ${r.status}"),
                      Text(
                        "Réservé le : ${r.reservedAt.toLocal().toString().split(' ')[0]}",
                      ),

                      const SizedBox(height: 10),

                      // ❌ BOUTON ANNULER
                      if (r.status == "reserved")
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.cancel),
                            label: const Text("Annuler"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              await ReservationController.cancelReservation(r);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Réservation annulée ❌"),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
