import 'package:get/get.dart';
import 'package:steady_solutions/models/work_orders/room.dart';

class SiteRoomsRepository{
  String id = "";
  static RxMap<String, RxMap<String, Room>> allRooms = <String, RxMap<String, Room>>{}.obs;


  RxMap<String, Room> getRoomsList(String siteId) {
    print("returning rooms list ${allRooms[siteId]}");
  return allRooms[siteId] ==  null ? <String, Room>{}.obs : allRooms[siteId]!;
  }

  setRoomsList() {
  
    
  }
  addRoom(String siteId, Map<String, dynamic> roomJson){
    Room room = Room.fromJson(roomJson);
    if(allRooms[siteId] == null){
      allRooms[siteId] = <String, Room>{}.obs;
    }
    print("setting room ${room.value}");
    allRooms[siteId]![room.value!] = room;
    print("setting room ${allRooms[siteId]?.length.toString()}");
  }
}