class Control {
bool? disabled;
int? group = null;
bool? selected;
String? text;
String? value;

Control({this.disabled, this.group, this.selected, this.text, this.value});

factory Control.fromJson(Map<String, dynamic> json) {
  return Control(
    disabled: json['Disabled'],
    group: json['group'],
    selected: json['selected'],
    text: json['text'],
    value: json['value'],
  );
}

Map<String, dynamic> toJson() {
  return {
    'Disabled': disabled,
    'group': group,
    'selected': selected,
    'text': text,
    'value': value,
  };
}

}