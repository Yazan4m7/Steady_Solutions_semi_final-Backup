import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/controllers/wo_controller.dart';
import 'package:steady_solutions/models/DTOs/create_wo_DTO.dart';
import 'package:steady_solutions/models/department.dart';
import 'package:steady_solutions/models/work_orders/room.dart';
import 'package:steady_solutions/models/work_orders/service_info.dart';
import 'package:steady_solutions/models/work_orders/site.dart';
import 'package:steady_solutions/models/work_orders/work_order_model.dart';
import 'package:steady_solutions/models/work_orders/category.dart';
import 'package:steady_solutions/screens/home_screen.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class NewServiceWorkOrderFrom extends StatefulWidget {
  const NewServiceWorkOrderFrom({Key? key}) : super(key: key);

  @override
  State<NewServiceWorkOrderFrom> createState() =>
      _NewServiceWorkOrderFromState();
}

class _NewServiceWorkOrderFromState extends State<NewServiceWorkOrderFrom> {
  final WorkOrdersController _workOrderController =
      Get.find<WorkOrdersController>();
  final AuthController _authOrderController = Get.find<AuthController>();
  // Data to be sent to the server

  // Needed : Lists of : Sites,departments,categories,rooms

  Rx<Site> site = Site().obs;
  Rx<bool> isUrgent = false.obs;
  Rx<Department> department = Department().obs;
  Rx<ServiceInfo> service = ServiceInfo().obs;
  Rx<Category> category = Category().obs;
  Rx<Room> room = Room().obs;
  String? faultStatus;
File? _image; 
  final ImagePicker _picker = ImagePicker();

  /// Text editing controllers
  final TextEditingController controlNumberTEController =
      TextEditingController();
  final TextEditingController equipNameTEController = TextEditingController();
  final TextEditingController serialNumberTEController =
      TextEditingController();
  final TextEditingController faultStatusTEController = TextEditingController();
  Rx roomId = "".obs;
  @override
  void initState() {
   // _workOrderController.clearData();
    _workOrderController.fetchNewWorkOrderOptions();
  
    //_workOrderController.controlItem.value = ControlItem();
    super.initState();
  }

  var QRResult = "";
Future<void> _getImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // You can use the '_image' File object here to do something with the captured photo
    }
}
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF4e7ca2)),
          title:  Text( AppLocalizations.of(context).create_work_order,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Color(0xFF4e7ca2),fontWeight: FontWeight.w600)),
        ),
        body: SingleChildScrollView(
          child: Form(
              child: Container(
            width: double.infinity,
            height: screenSize.height * .81,
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0), // Add rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // Add subtle shadow
                  spreadRadius: 2.0, // Adjust shadow spread
                  blurRadius: 5.0, // Adjust shadow blur
                )
              ],
            ),
            margin: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  _autoCompleteTextField(
                    labelText:  AppLocalizations.of(context).site_name,
                    prefixIcon: Icons.home,
                    options: _workOrderController.siteNames,
                    onChanged: (value) {
                      
                      _workOrderController.getDepartments(
                          siteId: site.value.value!);
                    },
                  ),
                  SizedBox(height: 30.h),
                  _autoCompleteTextField(
                      labelText:  AppLocalizations.of(context).category,
                      prefixIcon: Icons.category,
                      options: _workOrderController.categories,
                      onChanged: (value) {}),
                  SizedBox(height: 30.h),
                  Obx(
                    () => _autoCompleteTextField(
                      labelText:  AppLocalizations.of(context).departments,
                      prefixIcon: Icons.corporate_fare,
                      options: _workOrderController.departments.value, // Value is needed to prevent getx error
                      onChanged: (value) {
                        _workOrderController.getRoomsList(departmentId:value.toString() );
                      },
                    ),
                  ),
                   SizedBox(height: 30.h),
                  Obx(
                    () => site.value.value == null ?
                    SizedBox(child:Text("Select SIte"))
                    :_autoCompleteTextField(
                      labelText:  AppLocalizations.of(context).rooms,
                      prefixIcon: Icons.meeting_room,
                      options: _workOrderController.rooms,
                      onChanged: (value) {
                        // siteName.value = value!;
                      },
                    ),
                  ),
                 
                  SizedBox(height: 20.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                    //height: 50.h,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: const Icon(
                            Icons.corporate_fare,
                            color: Color(0xFF4e7ca2),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => Text(
                              _workOrderController.serviceInfo.value.controlNo ??
                                   AppLocalizations.of(context).control_number,
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.grey[500],
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              
              
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                    //height: 50.h,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: const Icon(
                            Icons.description_outlined,
                            color: Color(0xFF4e7ca2),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => Text(
                              _workOrderController
                                      .serviceInfo.value.serviceDesc ??
                                   AppLocalizations.of(context).service_desc,
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.grey[500],
                                  fontSize: 50.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  SizedBox(height: 50.h),
                  _textFormField(
                      labelText:  AppLocalizations.of(context).fault_status,
                      prefixIcon: Icons.error_outline,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 2) {
                          return "Empty or too short fault status";
                        } else {
                          return "null";
                        }
                      },
                      keyboardType: TextInputType.name),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.3,
                            child: Obx(
                              () => Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  side: const BorderSide(
                                      width: 9, color: Color.fromARGB(255, 178, 178, 178)),
                                ),
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected))
                                      return Color.fromARGB(255, 185, 18, 18);
                                    return Color.fromARGB(255, 213, 213, 213);
                                  },
                                ),
                                checkColor: Colors.white,
                                activeColor: Theme.of(context).primaryColor,
                                value: isUrgent.value,
                                onChanged: (newValue) {
                                  isUrgent.value = newValue!;
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text( AppLocalizations.of(context).is_urgent,
                                style: GoogleFonts.nunitoSans(
                                    color: const Color(0xFF4e7ca2),
                                    fontWeight: FontWeight.w800,
                                    fontSize: screenSize.width * .04)),
                          ),
                        ],
                      ),
                     SizedBox(height: 10),
                      _image == null ?   ElevatedButton(
                        style: kSmallSecondaryBtnStyle(context),
                        onPressed: () async {
                         await _getImageFromCamera();
                        setState(() {
                         
                          print("Image is ${_image?.path}");
                        });
                        },
                        //style: kSmallBtnStyle(context),
                        child:  Text(
                           AppLocalizations.of(context).upload_picture,
                          
                        ),
                      ) : Image.file(_image!),
                    ],
                  ),
                  SizedBox(height: 50.h),
              
                  //Save Btn
                  ElevatedButton(
                      onPressed: () async {
                        WorkOrder WO = WorkOrder()
                            .setEquipmentID(
                                _workOrderController.serviceInfo.value.Id)
                            .setCallTypeID("0")
                            .setIsUrgent(isUrgent.value.toString())
                            .setFaultStatues(faultStatusTEController.text)
                            .setImageFile(_image)
                            .setRoomId(room.value.id)
                            .setEquipTypeId(_authOrderController
                                .employee.value.role
                                .toString())
                            .setType('2')
                            .build();
                        CreateWorkOrderDTO response =
                            await _workOrderController.createWorkOrder(WO);
                        if (response.success == 1) {
                          Dialogs.materialDialog(
                              color: Colors.white,
                              msg:  AppLocalizations.of(context).work_order_created_successfully,
                              title:  AppLocalizations.of(context).success,
                              lottieBuilder: Lottie.asset(
                                'assets/json_animations/success_blue.json',
                                fit: BoxFit.contain,
                              ),
                              customView: Container(
                                  child: Text(
                                      "${ AppLocalizations.of(context).job_no}:  ${response.jobNum ?? "N/A"}")),
                              customViewPosition:
                                  CustomViewPosition.BEFORE_ACTION,
                              context: context,
                              actions: [
                                IconsButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  text: AppLocalizations.of(context).back_to_form,
                                  iconData: Icons.arrow_back_rounded,
                                  color: Colors.blue,
                                  textStyle:  Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                                  iconColor: Colors.white,
                                ),
                                IconsButton(
                                  onPressed: () {
                                    Get.offAll(HomeScreen());
                                  },
                                  text:  AppLocalizations.of(context).close,
                                  iconData: Icons.done,
                                  color: Colors.blue,
                                  textStyle:  Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                                  iconColor: Colors.white,
                                ),
                              ]);
                        } else {
                          Dialogs.materialDialog(
                              color: Colors.white,
                              msg:  AppLocalizations.of(context).failed_to_create_work_order,
                              title: 'Failed',
                              lottieBuilder: Lottie.asset(
                                'assets/json_animations/fail_grey.json',
                                fit: BoxFit.contain,
                              ),
                              customView: Text(response.message),
                              customViewPosition:
                                  CustomViewPosition.BEFORE_ACTION,
                              context: context,
                              actions: [
                                IconsButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  text:AppLocalizations.of(context).back_to_form,
                                  iconData: Icons.arrow_back_rounded,
                                  color: const Color.fromARGB(255, 75, 75, 75),
                                  textStyle:  Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                                  iconColor: Colors.white,
                                ),
                                IconsButton(
                                  onPressed: () {
                                    Get.to(() => HomeScreen());
                                  },
                                  text: AppLocalizations.of(context).go_to_dashboard,
                                  iconData: Icons.dashboard,
                                  color: Colors.blue,
                                  textStyle:  Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                                  iconColor: Colors.white,
                                ),
                              ]);
                        }
                      },
                      // },
                      style: kPrimeryBtnStyle(context),
                      child: Text(
                         AppLocalizations.of(context).save,
                        style: GoogleFonts.nunitoSans(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.w600,
                            fontSize: screenSize.width * .04),
                      ))
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  TextFormField _textFormField({
    required String labelText,
    required IconData prefixIcon,
    required TextInputType keyboardType,
    TextEditingController? controller,
    bool? enabled = true,
    Widget? suffexIcon,
    String? value,
    Null Function(dynamic value)? onChanged,
    String Function(String?)? validator,
  }) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      style: inputTextStyle,
      cursorColor: kPrimaryColor3BrightBlue,
      onChanged: onChanged ?? (_) {},
      initialValue: value,
      decoration: kTextFieldDecoration.copyWith(
        labelText: labelText,
        suffixIcon: suffexIcon ?? const SizedBox(),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                color: const Color(0xFF104065),
              ),
      ),
      validator: validator,
    );
  }

  Widget _autoCompleteTextField({
    required String labelText,
    IconData? prefixIcon,
      bool? enabled = true,
    required Map<String, dynamic> options,
    void Function(int?)? onChanged,
  }) {
    return Autocomplete<String>(
      
      // ID needed to post : "Value"
      // Displayed to user : "Text"
      // Key of the map    : "Text"
      optionsBuilder: (TextEditingValue textEditingValue) {
      
        if (textEditingValue.text == '') {
          return options.keys;
        }
        return options.keys.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        }).toList();
      },
      onSelected: (String selection) {
        {
          dynamic object = options[selection];
          if (object is Site) {
            site.value = object;
            _workOrderController.getDepartments(siteId: site.value.value!);

            //debugPrintnt("Site Selected");
          } else if (object is Category) {
            category.value = object;

            //debugPrintnt("category Selected");
          } else if (object is Department) {
            department.value = object;
            _workOrderController.getRoomsList(
                 departmentId: department.value.value!);
            _workOrderController.getServiceInfo(
                categoryId: category.value.value!,
                departmentId: department.value.value!);
            //debugPrintnt("department Selected");
          } else if (object is Room) {
            room.value = object;
            //debugPrintnt("room Selected");
          }
          // if (object is CallType) {
          //   callType.value = object;
          // }
        }
      },
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          color: const Color.fromARGB(255, 255, 255, 255),
          elevation: 4.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 250.0,
              maxWidth: 250,
            ),
            child: SingleChildScrollView(
              // height: 200.0,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(option,style:dropDownTextStyle),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          enabled: enabled,
          controller: textEditingController,
          focusNode: focusNode,
          style: inputTextStyle,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: kTextFieldDecoration.copyWith(
            labelText: labelText,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, color: const Color(0xFF104065)),
          ),
        );
      },
    );
  }
}
