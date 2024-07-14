import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/department.dart';
import 'package:steady_solutions/models/work_orders/category.dart';
import 'package:steady_solutions/models/work_orders/room.dart';
import 'package:steady_solutions/models/work_orders/service_info.dart';
import 'package:steady_solutions/models/work_orders/site.dart';
import 'package:steady_solutions/models/work_orders/work_order_model.dart';
import 'package:steady_solutions/screens/home_screen.dart';
import 'package:steady_solutions/widgets/utils/background.dart';

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

  /// Text editing controllers for drop downs
  final TextEditingController siteTEController = TextEditingController();
  final TextEditingController categoriesTEController = TextEditingController();
  final TextEditingController departmentsTEController = TextEditingController();
  final TextEditingController roomsTEController = TextEditingController();

  /// Text editing controllers
  final TextEditingController controlNumberTEController =
      TextEditingController();
  final TextEditingController equipNameTEController = TextEditingController();
  final TextEditingController serialNumberTEController =
      TextEditingController();
  final TextEditingController faultStatusTEController = TextEditingController();
  SuggestionsController<Room> roomsSuggestionsController =
      SuggestionsController();
  SuggestionsController<Department> departmentsSuggestionsController =
      SuggestionsController();
  Rx roomId = "".obs;
  Rx<bool> isRoomsLoading = false.obs;
  late AnimationController _loginButtonController;
  bool isLoading = false;
  @override
  void initState() {
    // _workOrderController.clearData();
    _workOrderController.fetchNewWorkOrderOptions();
 _workOrderController.isCreating.value=false;
    //_workOrderController.controlItem.value = ControlItem();
    super.initState();
  }

  var QRResult = "";
  Future<void> _getImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // You can use the '_image' File object here to do something with the captured photo
    }
  }

  Future _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {
      debugPrint('[_playAnimation] error');
    }
  }

  Future _stopAnimation() async {
    try {
      if (mounted) {
        await _loginButtonController.reverse();
        setState(() {
          isLoading = false;
        });
      }
    } on TickerCanceled {
      debugPrint('[_stopAnimation] error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Background(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          extendBody: false,
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Color(0xFF4e7ca2)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(AppLocalizations.of(context).create_work_order,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Color(
                          0xFF4e7ca2,
                        ),
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                child: Container(
                  width: double.infinity,
                  height: screenSize.height * .81,
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * .05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(10.0), // Add rounded corners
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.2), // Add subtle shadow
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
                      ///////////////////////////
                      /// START OF NEW SCREEN

                      ///   SITES
                      /// //////////////////
                      TypeAheadField<Site>(
                        decorationBuilder: (context, child) => DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: Colors.grey),
                            color: Colors.white,
                          ),
                          child: child,
                        ),
                        suggestionsCallback: (search) => _workOrderController
                            .siteNames.values
                            .toList()
                            .where((site) => site.text!
                                .toLowerCase()
                                .contains(search.toLowerCase()))
                            .toList(),
                        controller: siteTEController,
                        builder: (context, siteTEController, focusNode) {
                          return TextField(
                              controller: siteTEController,
                              focusNode: focusNode,
                              // autofocus: true,
                              decoration: kTextFieldDecoration.copyWith(
                                  label: Text("Site"),
                                  prefixIcon: Icon(Icons.location_on)));
                        },
                        itemBuilder: (context, site) {
                          return ListTile(
                            title: Text(site.text ?? "x"),
                          );
                        },
                        onSelected: (siteI) {
                          setState(() {
                            siteTEController.value =
                                TextEditingValue(text: siteI.value!);
                            siteTEController.text = siteI.text!;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              site.value = siteI;
                              await _workOrderController.getDepartments(
                                  siteId: site.value.value!);
                              departmentsSuggestionsController.refresh();
                            });
                          });
                        },
                      ),
                      SizedBox(height: 30.h),
                      ///// CATEGORIES
                      ///////////////////////////
                      TypeAheadField<Category>(
                        decorationBuilder: (context, child) => DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: Colors.grey),
                            color: Colors.white,
                          ),
                          child: child,
                        ),
                        suggestionsCallback: (search) => _workOrderController
                            .categories.values
                            .toList()
                            .where((cat) => cat.text!
                                .toLowerCase()
                                .contains(search.toLowerCase()))
                            .toList(),
                        loadingBuilder: (context) => const Text('Loading...'),
                        errorBuilder: (context, error) => const Text('Error!'),
                        emptyBuilder: (context) =>
                            const Text('No items found!'),
                        controller: categoriesTEController,
                        transitionBuilder: (context, animation, child) {
                          return FadeTransition(
                            opacity: CurvedAnimation(
                                parent: animation, curve: Curves.fastOutSlowIn),
                            child: child,
                          );
                        },
                        builder: (context, categoriesTEController, focusNode) {
                          return TextField(
                              controller: categoriesTEController,
                              focusNode: focusNode,
                              autofocus: false,
                              decoration: kTextFieldDecoration.copyWith(
                                  label: Text("Category"),
                                  prefixIcon: Icon(Icons.category)));
                        },
                        itemBuilder: (context, category) {
                          return ListTile(
                            title: Text(category.text ?? "x"),
                          );
                        },
                        onSelected: (categoryI) {
                          setState(() {
                            //clearing department suggestions
                            //_workOrderController.departments = RxMap<String, Department>();
                            //departmentsSuggestionsController.refresh();
                            departmentsTEController.text = "";
                            departmentsTEController.value =
                                TextEditingValue(text: "");

                            categoriesTEController.value =
                                TextEditingValue(text: categoryI.text!);
                          });
                          category.value = categoryI;
                          print(categoryI.text);
                        },
                      ),
                      SizedBox(height: 30.h),

                      ///   DEPARTMENT
                      /// //////////////////
                      TypeAheadField<Department>(
                        suggestionsController: departmentsSuggestionsController,
                        suggestionsCallback: (search) => _workOrderController
                            .departments.values
                            .toList()
                            .where((cat) => cat.text!
                                .toLowerCase()
                                .contains(search.toLowerCase()))
                            .toList(),
                        controller: departmentsTEController,
                        decorationBuilder: (context, child) => DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: Colors.grey),
                            color: Colors.white,
                          ),
                          child: child,
                        ),
                        builder: (context, departmentsTEController, focusNode) {
                          return TextField(
                              controller: departmentsTEController,
                              focusNode: focusNode,
                              autofocus: false,
                              decoration: kTextFieldDecoration.copyWith(
                                  label: Text("Department"),
                                  prefixIcon: Icon(
                                      Icons.screen_lock_portrait_rounded)));
                        },
                        itemBuilder: (context, department) {
                          return ListTile(
                            title: Text(department.text ?? "x"),
                          );
                        },
                        onSelected: (departmentI) async {
                          setState(() {
                            departmentsTEController.value =
                                TextEditingValue(text: departmentI.value!);
                            departmentsTEController.text = departmentI.text!;

                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              // get first element of type "Department" from the map "options"

                              department.value = departmentI;

                              roomsTEController.text = "";
                              roomsTEController.value =
                                  TextEditingValue(text: "");
                              roomsSuggestionsController.refresh();
                              await _workOrderController.getRoomsList(
                                  departmentId: department.value.value!);

                              print(
                                  "selected department: ${department.value.value}");
                              print(
                                  "selected categoryId: ${category.value.value}");
                              _workOrderController.getAssetItemByCatAndDept(
                                  categoryId: category.value.value!,
                                  departmentId: department.value.value!);
                              print(_workOrderController.assetItem.value
                                  .toJson());
                            });
                          });
                        },
                      ),
                      SizedBox(height: 30.h),

                      /// ROOMS
                      /// ////////////////
                      TypeAheadField<Room>(
                        retainOnLoading: false,
                        suggestionsCallback: (search) => isRoomsLoading.value
                            ? []
                            : _workOrderController.rooms.values
                                .toList()
                                .where((roomI) => roomI.text!
                                    .toLowerCase()
                                    .contains(search.toLowerCase()))
                                .toList(),
                        decorationBuilder: (context, child) => DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: Colors.grey),
                            color: Colors.white,
                          ),
                          child: child,
                        ),
                        suggestionsController: roomsSuggestionsController,
                        controller: roomsTEController,
                        loadingBuilder: (context) => const Text('Loading...'),
                        errorBuilder: (context, error) => const Text('Error!'),
                        emptyBuilder: (context) =>
                            const Text('No items found!'),
                        builder: (context, roomsTEController, focusNode) {
                          return TextField(
                              controller: roomsTEController,
                              focusNode: focusNode,
                              autofocus: false,
                              decoration: kTextFieldDecoration.copyWith(
                                  label: Text("Room"),
                                  prefixIcon:
                                      Icon(Icons.meeting_room_outlined)));
                        },
                        itemBuilder: (context, room) {
                          return ListTile(
                            title: Text(room.text ?? "x"),
                          );
                        },
                        onSelected: (roomI) {
                          setState(() {
                            roomsTEController.value =
                                TextEditingValue(text: roomI.text!);
                            room.value = roomI;
                            print(
                                "sent room ${room.value}  recieved : ${roomI}");
                          });
                        },
                      ),
                      SizedBox(height: 30.h),

                      /////// END OF NEW SCREEN
                      ////////////////////////

                      // SizedBox(height: 50.h),
                      // _autoCompleteTextField(
                      //   labelText: AppLocalizations.of(context).site_name,
                      //   prefixIcon: Icons.home,
                      //   options: _workOrderController.siteNames,
                      //   onChanged: (value) {},
                      // ),
                      // SizedBox(height: 30.h),
                      // _autoCompleteTextField(
                      //     labelText: AppLocalizations.of(context).category,
                      //     prefixIcon: Icons.category,
                      //     options: _workOrderController.categories,
                      //     onChanged: (value) {}),
                      // SizedBox(height: 30.h),
                      // Obx(
                      //   () => _autoCompleteTextField(
                      //     labelText: AppLocalizations.of(context).departments,
                      //     prefixIcon: Icons.corporate_fare,
                      //     options: _workOrderController.departments
                      //         .value, // Value is needed to prevent getx error
                      //     onChanged: (value) {
                      //       // _workOrderController.getRoomsList(departmentId:value.toString() );
                      //     },
                      //   ),
                      // ),
                      // SizedBox(height: 30.h),
                      // Obx(
                      //   () => _autoCompleteTextField(
                      //     labelText: AppLocalizations.of(context).rooms,
                      //     prefixIcon: Icons.meeting_room,
                      //     options: _workOrderController.rooms,
                      //     onChanged: (value) {
                      //       debugPrint(
                      //           _workOrderController.rooms.length.toString());
                      //     },
                      //   ),
                      // ),

                      SizedBox(height: 20.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 15.h),
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
                                  _workOrderController
                                          .assetItem.value.controlNo ??
                                      AppLocalizations.of(context)
                                          .control_number,
                                  // controller: controlNumberTEController,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 15.h),
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
                                          .assetItem.value.serviceDesc ??  
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
                          labelText: AppLocalizations.of(context).fault_status,
                          prefixIcon: Icons.error_outline,
                          controller: faultStatusTEController,
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
                                          width: 9,
                                          color: Color.fromARGB(
                                              255, 178, 178, 178)),
                                    ),
                                    fillColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.selected))
                                          return Color.fromARGB(
                                              255, 185, 18, 18);
                                        return Color.fromARGB(
                                            255, 213, 213, 213);
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
                                child: Text(
                                    AppLocalizations.of(context).is_urgent,
                                    style: GoogleFonts.nunitoSans(
                                        color: const Color(0xFF4e7ca2),
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenSize.width * .04)),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          _image == null
                              ? ElevatedButton(
                                  style: kSmallSecondaryBtnStyle(context),
                                  onPressed: () async {
                                    await _getImageFromCamera();
                                    setState(() {
                                      // print("Image is ${_image?.path}");
                                    });
                                  },
                                  //style: kSmallBtnStyle(context),
                                  child: Text(
                                    AppLocalizations.of(context).upload_picture,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    await _getImageFromCamera();
                                    setState(() {
                                      // print("Image is ${_image?.path}");
                                    });
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(_image!)),
                                  ),
                                )
                        ],
                      ),
                      SizedBox(height: 50.h),

                      //Save Btn
                      Obx(
                        () => ElevatedButton(
                          child: Text(
                            AppLocalizations.of(context).save,
                            style: GoogleFonts.nunitoSans(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w600,
                                fontSize: screenSize.width * .04),
                          ),
                          onPressed: _workOrderController.isCreating.value
                              ? () {}
                              : () async {
                                  WorkOrder WO = WorkOrder()
                                      .setEquipmentID(_workOrderController
                                          .assetItem.value.id)
                                      .setCallTypeID("0")
                                      .setControlNumber(_workOrderController
                                          .assetItem.value.controlNo)
                                      .setIsUrgent(isUrgent.value.toString())
                                      .setFaultStatues(
                                          faultStatusTEController.text)
                                      .setImageFile(_image)
                                      .setRoomId(room.value.value)
                                      .setEquipName(_workOrderController
                                          .assetItem.value.equipName)
                                      .setEquipTypeId(_authOrderController
                                          .employee.value.role
                                          .toString())
                                      .setUserId(
                                          storageBox.read("id").toString())
                                      .setType('2')
                                      .build();
                                  print(WO.toJson());
                                  final response = await _workOrderController
                                      .createWorkOrder(WO);
                                 // log("Create service response : ${response.toJson()}");
                                  if (response.success == 1) {
                                    Dialogs.materialDialog(
                                        color: Colors.white,
                                        msg: AppLocalizations.of(context)
                                            .work_order_created_successfully,
                                        title: AppLocalizations.of(context)
                                            .success,
                                        lottieBuilder: Lottie.asset(
                                          'assets/json_animations/success_blue.json',
                                          fit: BoxFit.contain,
                                        ),
                                        //  customView: Container(
                                        //      child:Text("hi" as Function(dynamic context))

                                        customViewPosition:
                                            CustomViewPosition.BEFORE_ACTION,
                                        context: context,
                                        actions: [
                                          IconsButton(
                                            onPressed: () {
                                              Get.offAll(HomeScreen());
                                            },
                                            text: AppLocalizations.of(context)
                                                .close,
                                            iconData: Icons.done,
                                            color: Colors.blue,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .displayLarge
                                                ?.copyWith(
                                                  color: Colors.white,
                                                ),
                                            iconColor: Colors.white,
                                          ),
                                        ]);
                                  } else {
                                    Dialogs.materialDialog(
                                        color: Colors.white,
                                        msg: AppLocalizations.of(context)
                                            .failed_to_create_work_order,
                                        title: 'Failed',
                                        lottieBuilder: Lottie.asset(
                                          'assets/json_animations/fail_grey.json',
                                          fit: BoxFit.contain,
                                          
                                        ),
                                        customView: Column(
                                          children: [
                                            Text(response.message),
                                            Text("Job number: ${response.jobNum}"),
                                          ],
                                        ),
                                        customViewPosition:
                                            CustomViewPosition.BEFORE_ACTION,
                                        context: context,
                                        actions: [
                                          Row(
                                            children: [
                                              IconsButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                text:
                                                    AppLocalizations.of(context)
                                                        .back_to_form,
                                                iconData:
                                                    Icons.arrow_back_rounded,
                                                color: const Color.fromARGB(
                                                    255, 75, 75, 75),
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                iconColor: Colors.white,
                                              ),
                                              IconsButton(
                                                onPressed: () {
                                                  Get.to(() => HomeScreen());
                                                },
                                                text:
                                                    AppLocalizations.of(context)
                                                        .go_to_dashboard,
                                                iconData: Icons.dashboard,
                                                color: Colors.blue,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                iconColor: Colors.white,
                                              ),
                                            ],
                                          )
                                        ]);
                                  }
                                },
                          style: _workOrderController.isCreating.value
                              ? kPrimeryBtnStyle(context).copyWith(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.grey))
                              : kPrimeryBtnStyle(context),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ),
          )),
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
    bool required = false,
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
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a value';
              }
              return null;
            }
          : null,
    );
  }
}
