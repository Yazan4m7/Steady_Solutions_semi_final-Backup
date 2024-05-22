import 'dart:async';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import 'package:steady_solutions/models/work_orders/site.dart';
import 'package:steady_solutions/models/work_orders/work_order_model.dart';
import 'package:steady_solutions/models/work_orders/call_type.dart';
import 'package:steady_solutions/models/work_orders/control_item_model.dart';
import 'package:steady_solutions/screens/home_screen.dart';
import 'package:steady_solutions/widgets/utils/qr_scanner.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
class NewEquipWorkOrderFrom extends StatefulWidget {
  const NewEquipWorkOrderFrom({Key? key}) : super(key: key);

  @override
  State<NewEquipWorkOrderFrom> createState() => _NewEquipWorkOrderFromState();
}

class _NewEquipWorkOrderFromState extends State<NewEquipWorkOrderFrom> {
  final WorkOrdersController _workOrderController =
      Get.find<WorkOrdersController>();
  final AuthController _authOrderController = Get.find<AuthController>();
  // Data to be sent to the server

  int? _type;
  Rx<CallType> callType = CallType().obs;
  Rx<Site> site = Site().obs;
  Rx<bool> isUrgent = false.obs;
  // int? requstedAttendEngEmpID;
  // String? callerName;
  // String? tel;
  String? faultStatus;
  // int? newOrEdit;
  // DateTime? failureDate = DateTime.now();
  PlatformFile? document;
  XFile? imageFile;
  /// Text editing controllers
  final TextEditingController controlNumberTEController =
      TextEditingController();
  final TextEditingController equipNameTEController = TextEditingController();
  final TextEditingController serialNumberTEController =
      TextEditingController();
  final TextEditingController faultStatusTEController = TextEditingController();
  StreamSubscription<ControlItem>? lisenter;
  @override
  void initState() {
    _workOrderController.fetchNewWorkOrderOptions();
    _workOrderController.controlItem.value = ControlItem();

     WidgetsBinding.instance.addPostFrameCallback((_) {
      print("INIT LISTENER");
      print(lisenter?.isPaused);
       print(lisenter.toString());
      if(lisenter == null )
      lisenter = _workOrderController.controlItem.listen((value) {
        print("LISENING TO CONTROL ITEM");
        print(value.toString());
        if (value.havePendingWO == true) {
          print("have pending work order");
              Dialogs.materialDialog(
              context: context,
              title: "Pending Work Order",
              msg: "There is a pending work order on this equipment. Do you wish to continue or cancel?",
              actions: [
                IconsButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
                text: "Continue",
                iconData: Icons.check,
                color: Colors.green,
                textStyle: TextStyle(color: Colors.white),
                ),
                IconsButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                },
                text: "Cancel",
                iconData: Icons.cancel,
                color: Colors.red,
                textStyle: TextStyle(color: Colors.white),
                ),
              ],
              barrierDismissible: false,
              );
        }
      });
     });
    super.initState();
  }

@override
  void dispose() {
    lisenter?.cancel();
    super.dispose();
  }
  var QRResult = "";
  bool isLoading = false;
 // Function to capture image from camera
  Future<void> captureImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageFile = pickedFile;
    });
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
          iconTheme:  IconThemeData(color: Color(0xFF4e7ca2)),
          title:  Text("${AppLocalizations.of(context).create} ${AppLocalizations.of(context).create_work_order}",
              style: TextStyle(color: Color(0xFF4e7ca2),fontWeight: FontWeight.w600)),
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
                  color: const Color.fromARGB(255, 44, 44, 44).withOpacity(0.2), // Add subtle shadow
                  spreadRadius: 2.0, // Adjust shadow spread
                  blurRadius: 5.0, // Adjust shadow blur
                )
              ],
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                _autoCompleteTextField(
                  labelText: AppLocalizations.of(context).site_name,
                  prefixIcon: Icons.home,
                  options: _workOrderController.siteNames,
                  onChanged: (value) {
                    // siteName.value = value!;
                  },
                ),

                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _textFormField(
                          labelText: AppLocalizations.of(context).control_number,
                          prefixIcon: Icons.confirmation_number_outlined,
                          controller: controlNumberTEController,
                          suffexIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              _workOrderController.getControlItem(
                                  equipmentID: controlNumberTEController.text);
                            },
                          ),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 2) {
                              return "Empty or too short fault status";
                            } else {
                              return "null";
                            }
                          },
                          keyboardType: TextInputType.name),
                      //width:  mediaQuery.width*0.7,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    IconButton(
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(50.w)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color(0xFF4e7ca2)),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        icon:
                            const Icon(Icons.qr_code, color: Color(0xFF4e7ca2)),
                        onPressed: () async {
                          Get.to(() => const QRScannerView());
                        }),
                  ],
                ),
                SizedBox(height: 50.h),
                Obx(
                  () => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                    //height: 50.h,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: const Icon(
                            Icons.desktop_access_disabled_rounded,
                            color: Color(0xFF4e7ca2),
                          ),
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).equip_name,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.grey[500],
                                      fontSize: 40.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  _workOrderController
                                          .controlItem.value.equipName ??
                                      "----",
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.grey[500],
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Obx(
                  () => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                    //height: 50.h,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: const Icon(
                            Icons.numbers,
                            color: Color(0xFF4e7ca2),
                          ),
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).serial_no,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.grey[500],
                                      fontSize: 40.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  _workOrderController
                                          .controlItem.value.serNO ??
                                      "----",
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.grey[500],
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.h),

                _autoCompleteTextField(
                  labelText: AppLocalizations.of(context).call_type,
                  prefixIcon: Icons.call_rounded,
                  options: _workOrderController.callTypes,
                  onChanged: (value) {
                    //siteName = value!;
                  },
                ),

                SizedBox(height: 50.h),
                _textFormField(
                    labelText: AppLocalizations.of(context).fault_status,
                    prefixIcon: Icons.error_outline,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 2) {
                        return "Empty or too short fault status";
                      } else {
                        return "null";
                      }
                    },
                    keyboardType: TextInputType.name),

                SizedBox(height: 50.h),

                SizedBox(
                  height: screenSize.height * .05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Obx(
                          () => Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    side: const BorderSide(
                                        width: 9, color: Color(0xFF4e7ca2)),
                                  ),
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.selected))
                                        return Color(0xFF4e7ca2);
                                      return Color.fromARGB(255, 226, 226, 226);
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
                              Expanded(
                                  child: Container(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(AppLocalizations.of(context).is_urgent,
                                    style: GoogleFonts.nunitoSans(
                                        color: Color(0xFF4e7ca2),
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenSize.width * .04)),
                              )),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: ElevatedButton(
                          style: kSmallSecondaryBtnStyle(context),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf', 'doc'],
                            );

                            if (result != null) {
                              document = result.files.first;
                            } else {
                              // User canceled the file selection
                            }
                          },
                          //style: kSmallBtnStyle(context),
                          child: (imageFile != null) ?
                          Image.file(File(imageFile!.path)) :  // Display captured image if any
                        ElevatedButton(
                          onPressed: captureImage,
                          child: Text(AppLocalizations.of(context).upload_picture),
                              
                           
                            
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),

                //Save Btn
                ElevatedButton(
                    onPressed: () async {
                      WorkOrder WO = WorkOrder()
                          .setEquipmentID(controlNumberTEController.text)
                          .setCallTypeID(callType.value.value.toString())
                          .setIsUrgent(isUrgent.value.toString())
                          .setFaultStatues(faultStatusTEController.text)
                      
                          .setRoomId("0")
                          .setEquipTypeId(_authOrderController
                              .employee.value.role
                              .toString())
                          .setType("1")
                          .build();
                          WO.imageFile = imageFile;
                      CreateWorkOrderDTO response =
                          await _workOrderController.createWorkOrder(WO);
                      if (response.success == 1) {
                        Dialogs.materialDialog(
                            color: Colors.white,
                            msg: AppLocalizations.of(context).work_order_created_successfully,
                            title: AppLocalizations.of(context).success,
                            lottieBuilder: Lottie.asset(
                              'assets/json_animations/success_blue.json',
                              fit: BoxFit.contain,
                            ),
                            customView: Container(
                                child: Text(
                                    "${AppLocalizations.of(context).job_no}: ${response.jobNum ?? "N/A"}"),
                                    ),
                            customViewPosition:
                                CustomViewPosition.BEFORE_ACTION,
                            context: context,
                            actions: [
                              // IconsButton(
                              //   onPressed: () {
                              //     Get.back();
                              //   },
                              //   text: 'Close',
                              //   iconData: Icons.copy,
                              //   color: Colors.blue,
                              //   textStyle: const TextStyle(color: Colors.white),
                              //   iconColor: Colors.white,
                              // ),
                              IconsButton(
                                onPressed: () {
                                  Get.offAll(HomeScreen());
                                },
                                text: AppLocalizations.of(context).close,
                                iconData: Icons.done,
                                color: Colors.blue,
                                textStyle: const TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                            ]);
                      } else {
                        Dialogs.materialDialog(
                          titleStyle: TextStyle(fontSize:50.sp, color: Colors.red),
                          msgStyle: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.redAccent),
                            //color: Colors.white,
                            msg:AppLocalizations.of(context).failed_to_create_work_order,
                            title: AppLocalizations.of(context).failed,
                            lottieBuilder: Lottie.asset(
                              'assets/json_animations/fail_grey.json',
                              fit: BoxFit.contain,
                            ),
                            customView:
                                Container(child: Text(response.message,style: TextStyle(fontSize: 30.sp),)),
                            customViewPosition:
                                CustomViewPosition.BEFORE_ACTION,
                            context: context,
                            actions: [
                              IconsButton(
                                onPressed: () {
                                  Get.back();
                                },
                                text: AppLocalizations.of(context).close,
                                iconData: Icons.close,
                                color: Colors.red,
                                textStyle: const TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                            ]);
                      }
                    },
                    // },
                    style: kPrimeryBtnStyle(context),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.white,
                            backgroundColor: Colors.blueAccent,
                          )
                        : Text(
                            AppLocalizations.of(context).save,
                            style: GoogleFonts.nunitoSans(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w600,
                                fontSize: screenSize.width * .04),
                          ))
              ],
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
    bool enabled = true,
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
          }
          if (object is CallType) {
            callType.value = object;
          }
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
                      child: Text((option)),
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
