class Employee {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? role;

  Employee({this.role, this.id, this.firstName, this.lastName, this.email});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['UserID'] ?? "N/A",
      email: json['Email'] ?? "N/A",
      role: json["EquipmentTypeID"] ?? "N/A",
      firstName: json['FirstName'] ?? "N/A",
      lastName: json['LastName'] ?? "N/A",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
    };
  }
}
