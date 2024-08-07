class CallType {
  bool? disabled;
  Null? group;
  bool? selected;
  String? text;
  String? value;

  CallType({this.disabled, this.group, this.selected, this.text, this.value});

  CallType.fromJson(Map<String, dynamic> json) {
    disabled = json['Disabled'];
    group = json['Group'];
    selected = json['Selected'];
    text = json['Text'];
    value = json['Value'];
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