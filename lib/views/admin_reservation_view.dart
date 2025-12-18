import 'package:flutter/material.dart';
import '../controllers/reservation_controller.dart';
import '../models/reservation_model.dart';

class AdminReservationView extends StatelessWidget {
  const AdminReservationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Réservations • Admin"),
        backgroundColor: Colors.deepPurple,
      ),

      body: StreamBuilder<List<Reservation>>(
        stream: ReservationController.getReservationsStream(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Aucune réservation trouvée"),
            );
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final r = reservations[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    r.bookTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Utilisateur : ${r.userName}\nStatut : ${r.status}",
                  ),
                  trailing: Text(
                    "${r.reservedAt.day}/${r.reservedAt.month}/${r.reservedAt.year}",
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
