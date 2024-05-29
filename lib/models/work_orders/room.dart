class Room {
  String? disabled;
  String? group;
  String? selected;
  String? text;
  String? value;

  Room({this.disabled, this.group, this.selected, this.text, this.value});

  Room.fromJson(Map<String, dynamic> json) {
    disabled = json['Disabled'].toString() ?? "";
    group = json['Group'].toString()  ?? "";
    selected = json['Selected'].toString() ?? "";
    text = json['Text'].toString() ?? "";
    value = json['Value'].toString() ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Disabled'] = this.disabled;
    data['Group'] = this.group;
    data['Selected'] = this.selected;
    data['Text'] = this.text;
    data['Value'] = this.value;
    return data;
  }
}
