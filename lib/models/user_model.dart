class UserModel {
  String fullName;
  int age;
  String email;
  String phone;
  String password;
  String role; // 🔥 Ajout important pour admin/user

  UserModel({
    required this.fullName,
    required this.age,
    required this.email,
    required this.phone,
    required this.password,
    this.role = "user", // 🔥 valeur par défaut
  });

  // 🔄 Convertir en map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      "fullName": fullName,
      "age": age,
      "email": email,
      "phone": phone,
      "role": role,
    };
  }
}
