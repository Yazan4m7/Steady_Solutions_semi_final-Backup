import 'package:get_storage/get_storage.dart';

final storageBox = GetStorage();


void removeDashboardElement(dynamic element) {
  List<dynamic> list = storageBox.read("prefHomeElements") ?? [];
  list.remove(element);
  storageBox.write("prefHomeElements", list);
}

void addDashboardElement(dynamic element) {
  List<dynamic> list = storageBox.read("prefHomeElements") ?? [];
  list.add(element);
  storageBox.write("prefHomeElements", list);
}
List<String> readDashboardElementsList() {
  return storageBox.read("prefHomeElements") ?? [];
}