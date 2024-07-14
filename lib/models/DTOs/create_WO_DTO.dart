// ignore: file_names
class CreateWorkOrderDTO {
  int success;
  String message;
  int? jobNum;

  CreateWorkOrderDTO({required this.success, required this.message, this.jobNum});

  factory CreateWorkOrderDTO.fromJson(Map<String, dynamic> json) {
    return CreateWorkOrderDTO(
      success: json['success'],
      message: json['Message'],
      jobNum : json["JobNO"] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'jobNO' : jobNum
    };
  }
}
