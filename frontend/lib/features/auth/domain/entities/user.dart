class User {
  final String id;
  final String email;
  final String? name;
  final String rncCedula;
  final String userType;

  const User({
    required this.id,
    required this.email,
    this.name,
    required this.rncCedula,
    required this.userType,
  });
}
