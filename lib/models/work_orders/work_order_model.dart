import 'dart:convert';
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
  XFile? imageFile;
  String? newOrEdit;
  String? type;
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
      //this.imageFile,
      this.newOrEdit,
      this.type});

  factory WorkOrder.fromJson(Map<String, dynamic> json)  {
    return WorkOrder(
      serialNumber: json['SerNO'],
      equipName: json['equipName'],
      equipTypeID: json['equipTypeID'],
      controlNumber: json['controlNumber'],
      equipmentID: json['equipmentID'],
      callTypeID: json['callTypeID'],
      isUrgent: json['isUrgent'],
      roomId: json["RoomID"],
      requstedAttendEngEmpID: json['requstedAttendEngEmpID'],
      callerName: json['callerName'],
      tel: json['tel'],
      faultStatues: json['faultStatues'],
     // imageFile: json['imageFile'],
      newOrEdit: json['newOrEdit'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SerNO': serialNumber,
      "equipName": equipName,
      "equipTypeID": equipTypeID,
      'controlNumber': controlNumber,
      'equipmentID': equipmentID,
      'callTypeID': callTypeID,
      'isUrgent': isUrgent,
      "RoomID": roomId,
      'requstedAttendEngEmpID': requstedAttendEngEmpID,
      'callerName': callerName,
      'tel': tel,
      'faultStatues': faultStatues,
     // 'imageFile': imageFile,
      'newOrEdit': newOrEdit,
      "type": type
    };
  }

  WorkOrderBuilder({WorkOrder? workOrder}) {
    if (workOrder != null) {
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
     // imageFile = workOrder.imageFile;
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

  setEquipName(String? equipmentName) {
    this.equipName = equipmentName;
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
     // imageFile: imageFile,
      newOrEdit: newOrEdit,
      type:   type
    );
  }
}
