



///Dart imports
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
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
  @override
  void initState() {
    _pmController.fetchCalendarItems();
    //_controller = CalendarController();
    _calendarController.selectedDate = DateTime.now();
    source = _PMWODataSource(_pmController.calendarItems.value.values.toList());
    //// print("events lingth: " + source.appointments.length.toString());
    // print(_pmController.calendarItems.values.length);
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
        child: _getAgendaViewCalendar(
            _onViewChanged, _calendarController));

            
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimerWhite,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF4e7ca2)),
        title: Text(AppLocalizations.of(context).calendar,
            style:  Theme.of(context).textTheme.displayLarge?.copyWith(color: Color(0xFF4e7ca2,))),
      ),
      body: SafeArea(
        child: Container(
          color: kPrimerWhite,
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
      [
      ViewChangedCallback? onViewChanged,
      CalendarController? controller]) {

  Widget CalenderCell(MonthCellDetails  details){
      return Container(
        color:secondary_light_blue,
        child: Column(
          children: [
            Text(details.date.day.toString() ,style: TextStyle(color: Colors.white)),
            Text(details.appointments.length.toString(),style: TextStyle(color: Colors.redAccent)),
       
          ],
        )
        
     
      );
   }

 


       // print(_pmController.calendarItems.value.values.toList().length);
       // print(_pmController.calendarItems.value.values.toList());
   return 
   Obx(()
     => SfCalendar(
            view: CalendarView.month,
            showDatePickerButton: true,
            showNavigationArrow: true,
            allowViewNavigation: true,
            dataSource:_PMWODataSource(_pmController.calendarItems.value.values.toList()),
            allowAppointmentResize: true,
            monthCellBuilder: (context, details) => CalenderCell(details),
            headerStyle:  CalendarHeaderStyle(
              textAlign: TextAlign.center,
              textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color:appTheme.primery_dark_blue_color,
                fontWeight: FontWeight.w700,
              ),
            ),
            monthViewSettings: const MonthViewSettings(
              
              dayFormat: 'EEE',
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              showAgenda: true,
              numberOfWeeksInView:6,
            ),
            // timeSlotViewSettings: const TimeSlotViewSettings(
            //   minimumAppointmentDuration: Duration(minutes: 60),
            // ),
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
    return appointments![index].cDesc;
  }



  @override
  String? getStartTimeZone(int index) {
    return "UTC";
  }

  @override
  String? getEndTimeZone(int index) {
    return "UTC";
  }

  @override
  Color getColor(int index) {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

}
