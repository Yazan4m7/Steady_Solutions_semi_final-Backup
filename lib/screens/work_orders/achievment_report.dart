import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/achievement_report_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/models/job_for_achievement.dart';
import 'package:steady_solutions/screens/home_screen.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
class NewAchievementReportFrom extends StatefulWidget {
  String? jobNum;
  NewAchievementReportFrom({super.key, this.jobNum});

  @override
  State<NewAchievementReportFrom> createState() =>
      _NewAchievementReportFromState();
}

class _NewAchievementReportFromState extends State<NewAchievementReportFrom> {
  final AchievementReportsController _achievementReportController =
      Get.find<AchievementReportsController>();
  // Data to be sent to the server

  DateTime _selectedDateTime = DateTime.now();
  TimeOfDay _travelTime = TimeOfDay.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
    bool _selectedRepairDateTime= false;
  /// Text editing controllers
  final TextEditingController remedyTEController = TextEditingController();
  final TextEditingController jobNumTEController = TextEditingController();
  final TextEditingController reasonForNotClosingJobTEController =
      TextEditingController();
  final TextEditingController actionTakenToClosePendingJoEController =
      TextEditingController();

  @override
  void initState() {
      _selectedRepairDateTime = false;
    print("Job num ${widget.jobNum}");
    _achievementReportController.selectedControlItem =
        ControlItemFromAchievement().obs;
    if (widget.jobNum != null) {
      jobNumTEController.text = widget.jobNum!;
      _achievementReportController.getWOJobINfo(widget.jobNum!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
  
    return Background(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF4e7ca2)),
          title: Text(AppLocalizations.of(context).generate_achiev_report,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Color(0xFF4e7ca2,))),
        ),
        body: Form(
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
                crossAxisAlignment: CrossAxisAlignment.start, // Thi
                mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  SizedBox(height: 50.h),
                  _textFormField(
                    keyboardType: TextInputType.number,
                    labelText: AppLocalizations.of(context).work_order_number,
                    prefixIcon: Icons.numbers,
                    controller: jobNumTEController,
                    suffexIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _achievementReportController
                            .getWOJobINfo(jobNumTEController.text);
                      },
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 2) {
                        return "Empty or too short fault status";
                      } else {
                        return "null";
                      }
                    },
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 5,
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
                              Obx(
                                () => Text(
                                  _achievementReportController
                                          .selectedControlItem
                                          .value
                                          .equipName ??
                                      "----",
                                  style: GoogleFonts.nunitoSans(
                                      color:
                                          const Color.fromARGB(255, 44, 44, 44),
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ]),
                      ),
                      // SizedBox(width: MediaQuery.of(context).size.width/4,),

                      Expanded(
                        flex: 5,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).failure_date,
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.grey[500],
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 5.h),
                              Obx(
                                () => Text(
                                  _achievementReportController
                                          .selectedControlItem
                                          .value
                                          .equipName ??
                                      "----",
                                  style: GoogleFonts.nunitoSans(
                                      color:
                                          const Color.fromARGB(255, 44, 44, 44),
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).caller + ":",
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.grey[500],
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 5.h),
                              Obx(
                                () => Text(
                                  _achievementReportController
                                          .selectedControlItem.value.caller ??
                                      "----",
                                  style: GoogleFonts.nunitoSans(
                                      color:
                                          const Color.fromARGB(255, 44, 44, 44),
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ]),
                      ),
                      //SizedBox(width: MediaQuery.of(context).size.width/4,),

                      Expanded(
                        flex: 5,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).fault_status,
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.grey[500],
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 5.h),
                              Obx(
                                () => Text(
                                  _achievementReportController
                                          .selectedControlItem
                                          .value
                                          .faultStatus ??
                                      "----",
                                  style: GoogleFonts.nunitoSans(
                                      color:
                                          const Color.fromARGB(255, 44, 44, 44),
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  _textFormField(
                      labelText: AppLocalizations.of(context).remedy,
                      prefixIcon: Icons.confirmation_number_outlined,
                      controller: remedyTEController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 2) {
                          return "Empty or too short fault status";
                        } else {
                          return "null";
                        }
                      },
                      keyboardType: TextInputType.name),
                  SizedBox(height: 30.h),
                  _textFormField(
                      labelText: AppLocalizations.of(context)
                          .reason_for_not_closing_job,
                      prefixIcon: Icons.remove_circle_outline_sharp,
                      controller: reasonForNotClosingJobTEController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 2) {
                          return "Empty or too short fault status";
                        } else {
                          return "null";
                        }
                      },
                      keyboardType: TextInputType.name),
                  SizedBox(height: 30.h),
                  _textFormField(
                      labelText: AppLocalizations.of(context)
                          .action_taken_to_close_pending_job,
                      prefixIcon: Icons.done_all_outlined,
                      controller: actionTakenToClosePendingJoEController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 2) {
                          return "Empty or too short fault status";
                        } else {
                          return "null";
                        }
                      },
                      keyboardType: TextInputType.name),
                  SizedBox(height: 30.h),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).travel_time,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),
                              ),
                              Text(
                                '${_travelTime.hour.toString().padLeft(2, '0')}:${_travelTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    fontSize: 50.sp, color: Colors.blue),
                              ),
                            ],
                          ),
                          onTap: () {
                            showTimePicker(
                              barrierLabel: "Hello",
                              initialEntryMode: TimePickerEntryMode.inputOnly,
                              context: context,
                              initialTime: TimeOfDay(hour: 0, minute: 0),
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                                },
                            ).then((pickedTime) {
                              if (pickedTime != null) {
                                setState(() {
                                  _travelTime =
                                      pickedTime; // Save value on change
                                });
                              }
                            });
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context).repaired_date +
                                        ":",
                                    style:
                                        Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              Text(
                                _selectedRepairDateTime ? '${_selectedDateTime.toString().substring(0, 10)}' : "NONE" ,
                                style: TextStyle(
                                    fontSize: 50.sp, color: const Color.fromARGB(255, 37, 37, 37)),
                              ),
                            ],
                          ),
                          onTap: () {
                            showDatePicker(
                              fieldHintText: AppLocalizations.of(context)
                                  .select_repair_date,
                              context: context,
                              initialDate: _selectedDateTime,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            ).then((pickedDate) {
                              if (pickedDate != null)  {
                                setState(() {
                                    print("SelectedDate: " +pickedDate.toString());
                                  _selectedRepairDateTime =
                                      true; // Save value on change
                                 // _selectedDateTime =
                                 //     pickedDate; // Save value on change
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).start_time,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),
                              ),
                              Text(
                                '${_startTime.format(context)}',
                                style: TextStyle(
                                    fontSize: 50.sp, color: Colors.blue),
                              ),
                            ],
                          ),
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((pickedTime) {
                              if (pickedTime != null) {
                                setState(() {
                                  _startTime =
                                      pickedTime; // Save value on change
                                });
                              }
                            });
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 70.w)  ,
                          child: GestureDetector(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).end_time,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),
                                ),
                                Text(
                                  '${_endTime.format(context)}',
                                  style: TextStyle(
                                      fontSize: 50.sp, color: Colors.blue),
                                ),
                              ],
                            ),
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((pickedTime) {
                                if (pickedTime != null) {
                                  setState(() {
                                    _endTime = pickedTime; // Save value on change
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      ])),
                  SizedBox(height: 50.h),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          print("Date: " +_travelTime.toString().substring(1,11));
                          String response = await _achievementReportController
                              .createAchievementReport(
                            jobNumber: jobNumTEController.text,
                            travelTime: _travelTime,
                            remedy: remedyTEController.text,
                            startTime: _startTime,
                            endTime: _endTime,
                          
                            repairDate: _selectedRepairDateTime ? DateFormat('HH:mm:ss').format(_selectedDateTime) : "",
                            reasonForNotClosingJob:
                                reasonForNotClosingJobTEController.text,
                            actionTakenToClosePendingJob:
                                actionTakenToClosePendingJoEController.text,
                          );

                          if (RegExp(r'\d').hasMatch(response)) {
                            Dialogs.materialDialog(
                                color: Colors.white,
                                msg: AppLocalizations.of(context)
                                    .generated_report_successfully,
                                title: AppLocalizations.of(context).success,
                                lottieBuilder: Lottie.asset(
                                  'assets/json_animations/success_blue.json',
                                  fit: BoxFit.contain,
                                ),
                                customView: Container(
                                  child: Text(
                                      AppLocalizations.of(context).report_id +
                                          ":" +
                                          response),
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
                                  //   textStyle: const Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                                  //   iconColor: Colors.white,
                                  // ),
                                  IconsButton(
                                    onPressed: () {
                                      Get.offAll(HomeScreen());
                                    },
                                    text: AppLocalizations.of(context).close,
                                    iconData: Icons.done,
                                    color: Colors.blue,
                                    textStyle:
                                         Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                                    iconColor: Colors.white,
                                  ),
                                ]);
                          } else {
                            Dialogs.materialDialog(
                                color: Colors.white,
                                msg: AppLocalizations.of(context)
                                    .failed_to_generate_report,
                                title: AppLocalizations.of(context).failed,
                                lottieBuilder: Lottie.asset(
                                  'assets/json_animations/fail_grey.json',
                                  fit: BoxFit.contain,
                                ),
                                customView: Container(child: Text(response)),
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
                                    textStyle:
                                         Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
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
                              fontSize: screenSize.width * .05),
                        )),
                  )
                ],
              ),
            ),
          ),
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
      maxLines: 3,
      minLines: 1,
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
          print("called in $selection");
          _achievementReportController.getWOJobINfo(selection);
          /* selectedControlItem.value = ControlItemFromAchievement(
            controlNumber: object.controlNumber,
            caller: object.caller,
            faultStatus: object.faultStatus,
            equipName: object.equipName,
            failureDate: object.failureDate,
          );*/
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
