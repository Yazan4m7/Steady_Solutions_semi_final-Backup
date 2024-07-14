import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/pm_controller.dart';

import 'package:steady_solutions/models/pm/calendar_item.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Calendar extends StatefulWidget   {
  const Calendar({super.key});
  @override
  State<Calendar> createState() => _CalendarState();
}
Map<String, int> counts2 = <String, int>{};
class _CalendarState extends State<Calendar> {
  final PMController _pmController = Get.find<PMController>();
  Map<String, int?> counts = <String, int?>{};  
  @override
  initState() {
    
    _pmController.fetchCalendarItems().then((value) 
    {
      // print("dpne");
      // print(_pmController.calendarItems.length.toString() + "000000");
      

      setState(() {
        start();
    });
    });
    super.initState();
  }

  Future start () async {// print("stary");
    
//       int count = 0;
//       _pmController.calendarItems.value["2024-01-17"].forEach((key, value) {
//         // print("key: $key, value: $value");
//         if (value.start == "2024-01-17") {
//           count++;
//         }
//       });
      
//   for (var item in _pmController.calendarItems.value.keys) {
      
//       counts[item] = counts[item] != null ?  1  : counts[item] = counts[item]! + 1; 
     
// }

      // print("COOOOOUNT" + _pmController!.calendarItems!.value!["2024-01-17"]!.start!);
  // Your code here

  }


  final CalendarController _calendarController = CalendarController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: /*_selectedDate  ??*/  DateTime.now(),
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _calendarController.displayDate = _selectedDate!;
      });
    }
  }

//  _calendarController.selectedDate = DateTime(2022, 02, 05);
//    _calendarController.displayDate = DateTime(2022, 02, 05);
  // SfCalendar(
  //        view: CalendarView.month,
  //        controller: _calendarController,
  //      ),
  final DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      //setState(() {
        _calendarController.displayDate = args.value;
     // });
      
    });
    // print("selected date: ${args.value}");
  }

  void viewChanged(ViewChangedDetails viewChangedDetails) {
     // print(viewChangedDetails.toString());
    // print("viewChangedDetails"+ viewChangedDetails.visibleDates[0].toString());
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _dateRangePickerController.selectedDate =
          viewChangedDetails.visibleDates[0];
      _dateRangePickerController.displayDate =
          viewChangedDetails.visibleDates[0];
    });
  }
   
  @override
  Widget build(BuildContext context) {
    
    Size screenSize = MediaQuery.of(context).size;
    return Background(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100,
                child: SfDateRangePicker(
                  controller: _dateRangePickerController,
                  showNavigationArrow: true,
                  allowViewNavigation: false,
                  initialSelectedDate : DateTime.now(),
                 // monthViewSettings:
                  //    DateRangePickerMonthViewSettings(numberOfWeeksInView: 1),
                  onSelectionChanged: selectionChanged,
                ),
              ),
              // SfCalendar(screenSize),
              TextButton(
                  onPressed: () => _selectDate(context),
                    child: Text(_calendarController.displayDate != null ?
                     _calendarController.displayDate.toString().substring(0,10) 
                     : '',
                      style: blueClickableText)),
              calendar(screenSize)
            ],
          ),
        ),
      ),
    );
  }

  Widget calendar(Size screenSize)  {
   // print("returning");
    return Container(
      width: double.infinity,
      height: screenSize.height * .81,
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0), // Add rounded corners
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 44, 44, 44)
                .withOpacity(0.2), // Add subtle shadow
            spreadRadius: 2.0, // Adjust shadow spread
            blurRadius: 5.0, // Adjust shadow blur
          )
        ],
      ),
      margin: const EdgeInsets.all(16),
      child: SfCalendar(
        controller: _calendarController,
        headerHeight: 0,
        onViewChanged: viewChanged,
        allowViewNavigation: true,
        headerStyle: CalendarHeaderStyle(
          textStyle: Theme.of(context).textTheme.displayLarge?.copyWith(),
        ),
        scheduleViewSettings: ScheduleViewSettings(
          appointmentItemHeight: 100.h,
          appointmentTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(),
          dayHeaderSettings: DayHeaderSettings(
            dayFormat: 'EEE',
            dateTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(),
          ),
          monthHeaderSettings: MonthHeaderSettings(
            monthFormat: 'MMMM yyyy',
            height: 100.h,
            monthTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(),
          ),
          weekHeaderSettings: WeekHeaderSettings(
            weekTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(),
          ),
        ),
        monthCellBuilder: monthCellBuilder,
         dataSource:
            EventsDataSource(_pmController.calendarItems.values.toList()),
        view: CalendarView.month,
        monthViewSettings: MonthViewSettings(
            // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            //appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: true,
            agendaItemHeight: 120.h,
            appointmentDisplayMode: MonthAppointmentDisplayMode.none,
            appointmentDisplayCount: 100),
      ),
    );
    
  }
}

  
  Widget monthCellBuilder(BuildContext context, MonthCellDetails details)  {
     final PMController _pmController = Get.find<PMController>();
    // print("building " + details.date.toString().substring(0,10).trim());  
   
//     // print(details.date.toString().substring(0,10) + "details");
//     // print (_pmController!.calendarItems[details.date.toString().substring(0,10).trim()]);
//   _pmController!.calendarItems!.values.where((element) =>  (
//   element.start!.trim().contains(details.date.toString().substring(0,10).trim()))).length.toString();
 
//  // print(
//   _pmController.calendarItems[details.date.toString().substring(0,10).trim()]?.start?.contains(details.date.toString().substring(0,10).trim())
//   );  
// print("checking ${details.date.toString().substring(0,10).trim()}");
  if(counts2[details.date.toString().substring(0,10).trim()] == null)
    // ignore: curly_braces_in_flow_control_structures
    if(_pmController.calendarItems[details.date.toString().substring(0,10).trim()] != null) {
      // ignore: curly_braces_in_flow_control_structures
     if(_pmController.calendarItems[details.date.toString().substring(0,10).trim()]!.start!.contains(details.date.toString().substring(0,10).trim())) {
       /// count occourancess
      for (var element in _pmController.calendarItems.keys) {
        if(_pmController.calendarItems[element]!.start!.contains(details.date.toString().substring(0,10).trim()))
        {
          // print("elemnt : ${element} date : ${details.date.toString().substring(0,10).trim()}");
          //setState(() {
           counts2[details.date.toString().substring(0,10).trim()] = counts2[details.date.toString().substring(0,10).trim()] == null? 1 : counts2[details.date.toString().substring(0,10).trim()]!+1;
          //});
          //count++;
        }
      }
      // if(element.contains(details.date.toString().substring(0,10).trim()))
      // {
      //   // print("elemnt : ${element} date : ${details.date.toString().substring(0,10).trim()}");
      //    count++;
      // }
    // }
     }
    }
                   
                  // counts[details.date.toString().substring(0,11)].toString(),
                 
    return 
       Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0), 
            color: Color.fromARGB(255, 228, 228, 228),
           
            border: Border.all(color: kPrimeryColor2NavyDark, width: 1, ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                details.date.day.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(color: kPrimeryColor2NavyDark,),
              
              
                  ),
                  Text(counts2[details.date.toString().substring(0,10).trim()].toString()),
                  
                                 
              const Divider(
                color: Colors.transparent,
              ),
            ],
          ),
        ),
      ) ;
    
 // }
  // return Container(
  //   decoration: BoxDecoration(
  //     border: Border.all(color: Colors.grey, width: 1),
  //   ),
  //   child: Container(
  //     decoration: BoxDecoration(
  //       color: Color.fromARGB(255, 228, 228, 228),
  //       borderRadius: BorderRadius.circular(4.0),
  //     ),
  //     child: Center(
  //       child: Text(
  //         details.date.day.toString(),
  //         textAlign: TextAlign.center,
  //         style: Theme.of(context).textTheme.displayLarge?.copyWith(color: kPrimeryColor2NavyDark,),
  //       ),
  //     ),
  //   ),
  // );
}


class EventsDataSource extends CalendarDataSource {
  EventsDataSource(List<CalendarItem> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(appointments![index].start);
    // return appointments![index].start;
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(appointments![index].endDate);
    // return appointments![index].endDate;
  }

  @override
  String getSubject(int index) {
    return appointments![index].cDesc;
  }

  // @override
  // Color getColor(int index) {
  //   return appointments![index].background;
  // }

  @override
  bool isAllDay(int index) {
    return true; //appointments![index].isAllDay;
  }
}
