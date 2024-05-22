class PMCMPerformance {
  List<int>? success;
  String? rate;

  PMCMPerformance({this.success, this.rate});

  PMCMPerformance.fromJson(Map<String, dynamic> json) {
    success = json['success'].cast<int>();
    rate = json['Rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['Rate'] = this.rate;
    return data;
  }
}