// ignore: file_names
class LoginDTO {
  int success;
  String message;

  LoginDTO({required this.success, required this.message});

  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    return LoginDTO(
      success: json['success'],
      message: json['Message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
