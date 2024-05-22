class InstalledBase {
	String? controlNO;
	String? equipName;
	String? modelNO;
	String? serNO;
	String? className;
	String? manufacturer;
	String? departmentDesc;
	String? installDate;
	String? expirationDate;
	String? purcheseCost;
	String? depreciatedValue;
	String? equipmentID;
	String? hospID;
	String? hosp;
	String? departmentID;
	String? manufID;
	String? warranty;
	String? iSUnderWarranty;
	String? expiryDate;

	InstalledBase({this.controlNO, this.equipName, this.modelNO, this.serNO, this.className, this.manufacturer, this.departmentDesc, this.installDate, this.expirationDate, this.purcheseCost, this.depreciatedValue, this.equipmentID, this.hospID, this.hosp, this.departmentID, this.manufID, this.warranty, this.iSUnderWarranty, this.expiryDate});

	InstalledBase.fromJson(Map<String, dynamic> json) {
		controlNO = json['ControlNO'].toString();
		equipName = json['EquipName'].toString();
		modelNO = json['ModelNO'].toString();
		serNO = json['SerNO'].toString();
		className = json['Class'].toString();
		manufacturer = json['Manufacturer'].toString();
		departmentDesc = json['DepartmentDesc'].toString();
		installDate = json['InstallDate'].toString();
		expirationDate = json['ExpirationDate'].toString();
		purcheseCost = json['PurcheseCost'].toString();
		depreciatedValue = json['DepreciatedValue'].toString();
		equipmentID = json['EquipmentID'].toString();
		hospID = json['HospID'].toString();
		hosp = json['Hosp'].toString();
		departmentID = json['DepartmentID'].toString();
		manufID = json['ManufID'].toString();
		warranty = json['Warranty'].toString();
		iSUnderWarranty = json['ISUnderWarranty'].toString();
		expiryDate = json['ExpiryDate'].toString();
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['ControlNO'] = this.controlNO;
		data['EquipName'] = this.equipName;
		data['ModelNO'] = this.modelNO;
		data['SerNO'] = this.serNO;
		data['Class'] = this.className;
		data['Manufacturer'] = this.manufacturer;
		data['DepartmentDesc'] = this.departmentDesc;
		data['InstallDate'] = this.installDate;
		data['ExpirationDate'] = this.expirationDate;
		data['PurcheseCost'] = this.purcheseCost;
		data['DepreciatedValue'] = this.depreciatedValue;
		data['EquipmentID'] = this.equipmentID;
		data['HospID'] = this.hospID;
		data['Hosp'] = this.hosp;
		data['DepartmentID'] = this.departmentID;
		data['ManufID'] = this.manufID;
		data['Warranty'] = this.warranty;
		data['ISUnderWarranty'] = this.iSUnderWarranty;
		data['ExpiryDate'] = this.expiryDate;
		return data;
	}
}