import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final storageBox = GetStorage();


RxList<int> seenNotificationsIds = <int>[].obs;

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
List<int> loadIds() {
    return storageBox.read("seenNotificationsIds") ?? []; // Load IDs or empty list if not found
  }

  void saveIds(List<int> ids) {
    storageBox.write("seenNotificationsIds", ids); // Save IDs
  }

  void addSeenNotification(int id) {
    List<int> ids = loadIds();
    if (!ids.contains(id)) {
      ids.add(id);
    } 
    saveIds(ids);
  }