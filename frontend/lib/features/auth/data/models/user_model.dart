import "../../domain/entities/user.dart";

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    required super.rncCedula,
    required super.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as String,
      email: json["email"] as String,
      name: json["name"] as String?,
      rncCedula: json["rncCedula"] as String,
      userType: json["userType"] as String,
    );
  }
}
