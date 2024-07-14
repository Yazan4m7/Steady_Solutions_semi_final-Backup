///Dart imports
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steady_solutions/app_config/app_theme.dart' as appTheme;

import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/pm_controller.dart';
import 'package:steady_solutions/models/pm/calendar_item.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Widget of the AgendaView Calendar.
class AgendaViewCalendar extends StatefulWidget {
  /// Create  default agenda view calendar
  const AgendaViewCalendar({Key? key}) : super(key: key);

  @override
  State<AgendaViewCalendar> createState() => _AgendaViewCalendarState();
}

class _AgendaViewCalendarState extends State<AgendaViewCalendar> {
  _AgendaViewCalendarState();
  final PMController _pmController = Get.find<PMController>();
  _PMWODataSource source = _PMWODataSource([]);
  //List<CalenderItem> calenderItems = <_PMWODataSource>[].obs;
  final CalendarController _calendarController = CalendarController();
  late Orientation _deviceOrientation;
  late CalendarController _controller;
  late String _customTimeLabelText;
  @override
  void initState() {
    _pmController.fetchCalendarItems();
    //_controller = CalendarController();
    _calendarController.selectedDate = DateTime.now();
    source = _PMWODataSource(_pmController.calendarItems.value.values.toList());
    //// print("events lingth: " + source.appointments.length.toString());
    // print(_pmController.calendarItems.values.length);
    _customTimeLabelText = 'Cell';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _deviceOrientation = MediaQuery.of(context).orientation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Theme(
        data: Theme.of(context),
        child: _getAgendaViewCalendar(_onViewChanged, _calendarController));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF4e7ca2)),
        title: Text(AppLocalizations.of(context).calendar,
           ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: calendar,
        ),
      ),
    );
  }

  /// Updated the selected date of calendar, when the months swiped, selects the
  /// current date when the calendar displays the current month, and selects the
  /// first date of the month for rest of the months.
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final DateTime currentViewDate = visibleDatesChangedDetails
          .visibleDates[visibleDatesChangedDetails.visibleDates.length ~/ 2];

      if (currentViewDate.month == DateTime.now().month &&
          currentViewDate.year == DateTime.now().year) {
        _calendarController.selectedDate = DateTime.now();
      } else {
        _calendarController.selectedDate =
            DateTime(currentViewDate.year, currentViewDate.month);
      }
    });
  }

  /// Returns the calendar widget based on the properties passed.
  Widget _getAgendaViewCalendar(
      [ViewChangedCallback? onViewChanged, CalendarController? controller]) {
    Widget CalenderCell(MonthCellDetails details) {
      return Container(
       
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
           // border: Border.all(width: 1, color: Colors.blueGrey),
            shape: BoxShape.circle,
           // borderRadius: BorderRadius.circular(400),

            // color: (details.date.day == DateTime.now().day) && (details.date.month == DateTime.now().month)
            //     ?  appTheme.primery_blue_color.withOpacity(0.3)
            //     : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(details.date.day.toString(),
                  style: GoogleFonts.hindVadodara(
                    
                    fontStyle: FontStyle.normal,
                     fontSize: 45.sp,
                    letterSpacing: 2,
                    
                    fontWeight: FontWeight.w200,
           
                    height: 1,
            
                    // decorationColor: Colors.black,
                    // decorationStyle: TextDecorationStyle.solid,
                
                   // foreground: Paint(),
                   // background: Paint(),
                    locale: Locale('en', 'US'),
                      
                      color: (details.date.day == DateTime.now().day) &&
                              (details.date.month == DateTime.now().month)
                          ? appTheme.primery_blue_color
                          : const Color.fromARGB(255, 55, 55, 55),
                )
                          
                          ),
              details.appointments.length.toString() == "0"
                  ? Container()
                  : Text(details.appointments.length.toString(),
                      style: TextStyle(color: Colors.redAccent)),
            ],
          ));
    }

    // print(_pmController.calendarItems.value.values.toList().length);
    // print(_pmController.calendarItems.value.values.toList());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Obx(
        () => SfCalendar(
          todayHighlightColor: appTheme.primery_dark_blue_color.withAlpha(400),
          timeZone: "Asia/Amman",
          headerDateFormat: "MMMM dd, yyyy",
      
          selectionDecoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 79, 79, 79), width: 2),
            backgroundBlendMode: BlendMode.overlay,
            shape: BoxShape.circle,
            
            color: appTheme.primery_dark_blue_color.withOpacity(0.9),
            //  borderRadius: BorderRadius.circular(400.0),
          ),
      
          // DateTime? minDate,
          // DateTime? maxDate,
      
          allowDragAndDrop: true,
          view: CalendarView.month,
          showDatePickerButton: true,
          showNavigationArrow: true,
          allowViewNavigation: true,
          dataSource:
              _PMWODataSource(_pmController.calendarItems.value.values.toList()),
          allowAppointmentResize: true,
          monthCellBuilder: (context, details) => CalenderCell(details),
          headerStyle: CalendarHeaderStyle(
            backgroundColor: Colors.white,
            textAlign: TextAlign.center,
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Color.fromARGB(255, 75, 75, 75),
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                  fontFamily: 'Poppins',
                ),
          ),
          monthViewSettings: MonthViewSettings(
            
            agendaItemHeight: 77.h,
            showTrailingAndLeadingDates: true,
            agendaViewHeight: MediaQuery.of(context).size.height / 2.5,
            monthCellStyle: const MonthCellStyle(),
            agendaStyle: AgendaStyle(
                         
              appointmentTextStyle: TextStyle(
                 letterSpacing: 2,
                  fontFamily: 'Poppins',
                fontSize: 40.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,),
            ),
            appointmentDisplayMode: MonthAppointmentDisplayMode.none,
            showAgenda: true,
            numberOfWeeksInView: 6,
          ),
        ),
      ),
    );
  }
}

/// An object to set the appointment collection data source to collection, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class _PMWODataSource extends CalendarDataSource {
  _PMWODataSource(this.source);

  List<CalendarItem> source;

  @override
  List<CalendarItem> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(appointments![index].start).toLocal();
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(appointments![index].endDate);
  }

  @override
  String getSubject(int index) {
    return appointments[index].cDesc.toString();
  }

  @override
  String? getStartTimeZone(int index) {
    return "GMT";
  }

  @override
  String? getEndTimeZone(int index) {
    return "GMT";
  }

////////// IMPORTANT , HIDES TIME IN CALENDAR
  @override
  bool isAllDay(int index) {
    return true;
  }

  @override
  Color getColor(int index) {
    return Color.fromARGB(255, 108, 108, 108);
  }
}
