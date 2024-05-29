class Notification {
  int? iD;
  int? forID1;
  int? forID2;
  int? fromUserID;
  int? toUser;
  String? notificationDate;
  String? passedParDate;
  int? passedPar1;
  String? msgNotes;
  String? typeOfMessage;
  int? yearID;
  int? equipmentTypeID;
  int? notificationTypeID;
  String? notificationTypeDesc;
  int? isMedicine;
  int? companyID;
  Null faFont;
  int? countNotifications;
  int? maxNotificationsPassedHour;
  int? minNotificationsPassedHour;
  Null imagePath;
  int? mainTypeID;
  bool? isSeen;
  Notification(
      {this.iD,
      this.forID1,
      this.forID2,
      this.fromUserID,
      this.toUser,
      this.notificationDate,
      this.passedParDate,
      this.passedPar1,
      this.msgNotes,
      this.typeOfMessage,
      this.yearID,
      this.equipmentTypeID,
      this.notificationTypeID,
      this.notificationTypeDesc,
      this.isMedicine,
      this.companyID,
      this.faFont,
      this.countNotifications,
      this.maxNotificationsPassedHour,
      this.minNotificationsPassedHour,
      this.imagePath,
      this.mainTypeID});

  Notification.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    forID1 = json['ForID1'];
    forID2 = json['ForID2'];
    fromUserID = json['FromUserID'];
    toUser = json['ToUser'];
    notificationDate = json['NotificationDate'];
    passedParDate = json['PassedParDate'];
    passedPar1 = json['PassedPar1'];
    msgNotes = json['MsgNotes'];
    typeOfMessage = json['TypeOfMessage'];
    yearID = json['YearID'];
    equipmentTypeID = json['EquipmentTypeID'];
    notificationTypeID = json['NotificationTypeID'];
    notificationTypeDesc = json['NotificationTypeDesc'];
    isMedicine = json['IsMedicine'];
    companyID = json['CompanyID'];
    faFont = json['FaFont'];
    countNotifications = json['CountNotifications'];
    maxNotificationsPassedHour = json['MaxNotificationsPassedHour'];
    minNotificationsPassedHour = json['MinNotificationsPassedHour'];
    imagePath = json['ImagePath'];
    mainTypeID = json['MainTypeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ForID1'] = this.forID1;
    data['ForID2'] = this.forID2;
    data['FromUserID'] = this.fromUserID;
    data['ToUser'] = this.toUser;
    data['NotificationDate'] = this.notificationDate;
    data['PassedParDate'] = this.passedParDate;
    data['PassedPar1'] = this.passedPar1;
    data['MsgNotes'] = this.msgNotes;
    data['TypeOfMessage'] = this.typeOfMessage;
    data['YearID'] = this.yearID;
    data['EquipmentTypeID'] = this.equipmentTypeID;
    data['NotificationTypeID'] = this.notificationTypeID;
    data['NotificationTypeDesc'] = this.notificationTypeDesc;
    data['IsMedicine'] = this.isMedicine;
    data['CompanyID'] = this.companyID;
    data['FaFont'] = this.faFont;
    data['CountNotifications'] = this.countNotifications;
    data['MaxNotificationsPassedHour'] = this.maxNotificationsPassedHour;
    data['MinNotificationsPassedHour'] = this.minNotificationsPassedHour;
    data['ImagePath'] = this.imagePath;
    data['MainTypeID'] = this.mainTypeID;
    return data;
  }
}