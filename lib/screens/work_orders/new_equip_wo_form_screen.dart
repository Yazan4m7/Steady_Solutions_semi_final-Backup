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
import 'package:steady_solutions/models/department.dart';
import 'package:steady_solutions/models/work_orders/site.dart';
import 'package:steady_solutions/models/work_orders/work_order_model.dart';
import 'package:steady_solutions/models/work_orders/call_type.dart';
import 'package:steady_solutions/models/work_orders/control_item_model.dart';
import 'package:steady_solutions/screens/home_screen.dart';
import 'package:steady_solutions/widgets/utils/qr_scanner.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';

// required paramaters from user roomID, EquipmentID, Call type
// required paramaters for API : uisUrgent,  roomID, EquipmentID, CallTypeID, Type
class NewEquipWorkOrderFrom extends StatefulWidget {
   NewEquipWorkOrderFrom({Key? key,this.controlNumber}) : super(key: key);
  String? controlNumber;
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
    File? _image; 
      final ImagePicker _picker = ImagePicker();
  /// Text editing controllers
  final TextEditingController controlNumberTEController =
      TextEditingController();
  final TextEditingController equipNameTEController = TextEditingController();
  final TextEditingController serialNumberTEController =
      TextEditingController();
  final TextEditingController faultStatusTEController = TextEditingController();
  StreamSubscription<ControlItem>? lisenter;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
  void initState() {
    _workOrderController.fetchNewWorkOrderOptions();
  
    if(widget.controlNumber != null){
   _workOrderController.getControlItem(
                                  controlNum: widget.controlNumber!);
      controlNumberTEController.text = widget.controlNumber!;              
                    }
     WidgetsBinding.instance.addPostFrameCallback((_) {
  _workOrderController.controlItem.value = ControlItem();
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
                textStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                ),
                IconsButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                },
                text: "Cancel",
                iconData: Icons.cancel,
                color: Colors.red,
                textStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
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
    // final imagePicker = ImagePicker();
    // final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    // setState(() {
    //   imageFile = pickedFile;
    // });
  }
 
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Background(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
           backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme:  IconThemeData(color: Color(0xFF4e7ca2)),
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // TODO remove /s on production
              Text( AppLocalizations.of(context).create_work_order ,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Color(0xFF4e7ca2,),fontWeight: FontWeight.w600)),
                     Text( "/E" ,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize:35.sp,color: Color.fromARGB(255, 116, 35, 35),fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
      
          child: Form(
            key: _formKey,
              child: Container(
            width: double.infinity,
            height: screenSize.height * .81,
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0), // Add rounded corners
              boxShadow: [
                BoxShadow(
                  color:  Color.fromARGB(255, 44, 44, 44).withOpacity(0.2), // Add subtle shadow
                  spreadRadius: 2.0, // Adjust shadow spread
                  blurRadius: 5.0, // Adjust shadow blur
                )
              ],
            ),
            margin:  EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                _autoCompleteTextField(
                  labelText: AppLocalizations.of(context).site_name,
                  prefixIcon: Icons.home,
                  required: true,
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
                          required: true,
                          prefixIcon: Icons.confirmation_number_outlined,
                          controller: controlNumberTEController,
                         // enabled: widget.controlNumber != null ? true : false,
                         
                          suffexIcon: IconButton(
                            icon:  Icon(Icons.search ,color: widget.controlNumber != null ? Color.fromARGB(255, 95, 95, 95): Color(0xFF4e7ca2)),
                            onPressed: () {
                              _workOrderController.getControlItem(
                                  controlNum: controlNumberTEController.text);
                            },
                          ),
                         
                          keyboardType: TextInputType.text,
                          ),
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
                                  side:  BorderSide(
                                      color: Color(0xFF4e7ca2)),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        icon:
                             Icon(Icons.qr_code, color: widget.controlNumber != null ? Color.fromARGB(255, 42, 42, 42): Color(0xFF4e7ca2)),
                        onPressed: widget.controlNumber != null ?  null: () async {
                          Navigator.push( context, MaterialPageRoute(builder :(context) => QRScannerView()));
                       
                         
                        
                        
                        
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
                          child:  Icon(
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
                                  style: Theme.of(context).textTheme.titleSmall,
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
                          child:  Icon(
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
                    controller: faultStatusTEController,
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
                                    borderRadius: BorderRadius.circular(5),
                                    side:  BorderSide(
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
                                padding:  EdgeInsets.only(left: 8.0),
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
                      ) : GestureDetector(
                          onTap: ()async{
                             await _getImageFromCamera();
                          setState(() {
                           
                            print("Image is ${_image?.path}");
                          });
                          },
                           child: Container(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(_image!)),
                                               ),
                         ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),

                //Save Btn
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                      WorkOrder WO = WorkOrder()
                          .setEquipmentID(controlNumberTEController.text)
                          .setCallTypeID(callType.value.value.toString())
                          .setIsUrgent(isUrgent.value.toString())
                          .setFaultStatues(faultStatusTEController.text)
                          .setImageFile(_image)
                          .setRoomId("0")
                          .setEquipTypeId(_authOrderController
                              .employee.value.role
                              .toString())
                          .setType("1")
                          .build();
                        
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
                              //   textStyle:  Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                              //   iconColor: Colors.white,
                              // ),
                              IconsButton(
                                onPressed: () {
                                  Get.offAll(HomeScreen());
                                },
                                text: AppLocalizations.of(context).close,
                                iconData: Icons.done,
                                color: Colors.blue,
                                textStyle:  Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                                iconColor: Colors.white,
                              ),
                            ]);
                      } else {
                        Dialogs.materialDialog(
                          titleStyle: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.red,),
                          msgStyle: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.redAccent),
                            //color: Colors.white,
                            msg:AppLocalizations.of(context).failed_to_create_work_order,
                            title: AppLocalizations.of(context).failed,
                            lottieBuilder: Lottie.asset(
                              'assets/json_animations/fail_grey.json',
                              fit: BoxFit.contain,
                            ),
                            customView:
                                Container(child: Text(response.message,style: Theme.of(context).textTheme.displayLarge?.copyWith(),)),
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
                                textStyle:  Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                                iconColor: Colors.white,
                              ),
                            ]);
                      }
                    }},
                    // },
                    style: kPrimeryBtnStyle(context),
                    child: isLoading
                        ?  CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.white,
                            backgroundColor: Colors.blueAccent,
                          )
                        : Text(
                            AppLocalizations.of(context).save,
                            style: GoogleFonts.nunitoSans(
                                color:  Color.fromARGB(255, 255, 255, 255),
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
    bool required = false,
    Widget? suffexIcon,
    String? value,
    Null Function(dynamic value)? onChanged,
  
   
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
        suffixIcon: suffexIcon ??  SizedBox(),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                color:  Color(0xFF104065),
              ),
      ),
       validator:required ?  (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a value';
                      }
                      return null;
                    }
                   : null,
    );
  }

  Widget _autoCompleteTextField({
    required String labelText,
    IconData? prefixIcon,
    required Map<String, dynamic> options,
    bool required = false,
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
          if (object is Department) {
            _workOrderController.getRoomsList(departmentId: object.value ?? '0');
          }


        }
      },
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          color:  Color.fromARGB(255, 241, 241, 241),
          elevation: 4.0,
          child: ConstrainedBox(
            constraints:  BoxConstraints(
              maxHeight: 250.0,
              maxWidth: 250,
            ),
            child: SingleChildScrollView(
              // height: 200.0,
              child: ListView.builder(
                shrinkWrap: true,
                physics:  NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Padding(
                      padding:  EdgeInsets.all(16.0),
                      child: Text((option),style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black,)),
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
            if(options.length == 1 && options.keys.first != ''){
               site.value = options.entries.first.value;
            return TextFormField(
          controller: textEditingController,
          //initialValue: options.keys.first,
          focusNode: focusNode,
          style: inputTextStyle,
           enabled: false,
         
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: kTextFieldDecoration.copyWith(
            labelText: options.keys.first,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, color:  Color(0xFF104065)),
          ),
        );
            }
     else{
        return TextFormField(
          controller: textEditingController,
       
          focusNode: focusNode,
          style: inputTextStyle,
          validator:required ?  (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a value';
                      }
                      return null;
                    }
                   : null,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: kTextFieldDecoration.copyWith(
            labelText: labelText,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, color:  Color(0xFF104065)),
          ),
        );
     }
      },
    );
  }
}
