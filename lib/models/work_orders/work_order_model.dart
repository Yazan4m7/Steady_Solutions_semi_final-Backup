import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class WorkOrder {
  String? controlNumber;
  String? serialNumber;
  String? equipmentID;
  String? equipTypeID;
  String? equipName;
  String? callTypeID;
  String? isUrgent;
  String? roomId;
  String? requstedAttendEngEmpID;
  String? callerName;
  String? tel;
  String? faultStatues;
  File? imageFile;
  String? newOrEdit;
  String? type;
  String? userId;
  WorkOrder({
      this.serialNumber,
      this.equipName,
      this.equipTypeID,
      this.controlNumber,
      this.equipmentID,
      this.callTypeID,
      this.isUrgent,
      this.roomId,
      this.requstedAttendEngEmpID,
      this.callerName,
      this.tel,
      this.faultStatues,
      this.imageFile,
      this.newOrEdit,
      this.type,
      this.userId
      });
  WorkOrder build() {
    return WorkOrder(
      controlNumber: controlNumber,
      equipmentID: equipmentID,
      equipTypeID: equipTypeID,
      callTypeID: callTypeID,
      isUrgent: isUrgent,
      roomId: roomId,
      requstedAttendEngEmpID: requstedAttendEngEmpID,
      callerName: callerName,
      tel: tel,
      faultStatues: faultStatues,
      imageFile: imageFile,
      newOrEdit: newOrEdit,
      type:   type,
      userId: userId
    );
  }
  factory WorkOrder.fromJson(Map<String, dynamic> json)  {
    print("user id factory : ${json['UserID']} ");
    return WorkOrder(
      serialNumber: json['SerNO'],
      equipName: json['EquipName'],
      equipTypeID: json['EquipmentTypeID'],
      controlNumber: json['ControlNumber'],
      equipmentID: json['EquipmentID'],
      callTypeID: json['CallTypeID'],
      isUrgent: json['IsUrgent'],
      roomId: json["RoomID"],
      //requstedAttendEngEmpID: json['requstedAttendEngEmpID'],
      callerName: json['callerName'],
      tel: json['tel'],
      faultStatues: json['faultStatues'],
      imageFile: json['ImageFile'],
      newOrEdit: json['NewOrEdit'],
      type: json['Type'],
      userId : json['UserID']
    );
  }

  Map<String, dynamic> toJson() {
    print("user id : $userId");
    return {
      'SerNO': serialNumber,
      "EquipName": equipName,
      "EquipmentTypeID": equipTypeID,
      'ControlNumber': controlNumber,
      'EquipmentID': equipmentID,
      'CallTypeID': callTypeID,
      'IsUrgent': isUrgent,
      "RoomID": roomId,
      'RequstedAttendEngEmpID': requstedAttendEngEmpID,
      'CallerName': callerName,
      'Tel': tel,
      'FaultStatus': faultStatues,
      'ImageFile': imageFile,
      'NewOrEdit': newOrEdit,
      "Type": type,
      "UserID": userId
    };
  }

  WorkOrderBuilder({WorkOrder? workOrder}) {
     print("BUILDER user id : $userId");
    if (workOrder != null) {
       print("work order not null");
      serialNumber = workOrder.serialNumber;
      controlNumber = workOrder.controlNumber;
      equipName = workOrder.equipName;
      equipmentID = workOrder.equipmentID;
      equipTypeID = workOrder.equipTypeID;
      controlNumber = workOrder.controlNumber;
      callTypeID = workOrder.callTypeID;
      isUrgent = workOrder.isUrgent;
      roomId = workOrder.roomId;
      callerName = workOrder.callerName;
      tel = workOrder.tel;
      faultStatues = workOrder.faultStatues;
      imageFile = workOrder.imageFile;
      userId = workOrder.userId;
      newOrEdit = workOrder.newOrEdit;
      type = workOrder.type;
    }
  }

  setControlNumber(String? controlNumber) {
    this.controlNumber = controlNumber;
    return this;
  }

  setEquipmentID(String? equipmentID) {
    this.equipmentID = equipmentID;
    return this;
  }

  setEquipTypeId(String? equipTypeId) {
    this.equipTypeID = equipTypeId;
    return this;
  }

  setSerialNumber(String? serialNumber) {
    this.serialNumber = serialNumber;
    return this;
  }

  setType(String? type) {
    this.type = type;
    return this;
  }

  setImageFile(File? imageFile) {
    this.imageFile = imageFile;
    return this;
  }

  setEquipName(String? equipmentName) {
    this.equipName = equipmentName;
    
    return this;
  }
 setUserId(String id) {
  print("setting user id : $id");
    this.userId = id;
    return this;
  }

  setCallTypeID(String? callTypeID) {
    this.callTypeID = callTypeID;
    return this;
  }

  setIsUrgent(String? isUrgent) {
    this.isUrgent = isUrgent;
    return this;
  }

  setRoomId(String? roomId) {
    this.roomId = roomId;
    return this;
  }

  setCallerName(String? callerName) {
    this.callerName = callerName;
    return this;
  }

  setTel(String? tel) {
    this.tel = tel;
    return this;
  }

  setFaultStatues(String? faultStatues) {
    this.faultStatues = faultStatues;
    return this;
  }

  // setImageFile(File? imageFile) async{
  //   if(imageFile != null)
  //   this.imageFile = await base64Encode(imageFile.readAsBytesSync());
  //   else
  //   this.imageFile = "";
  //   return this;
  // }

  setNewOrEdit(String? newOrEdit) {
    this.newOrEdit = newOrEdit;
    return this;
  }


}
