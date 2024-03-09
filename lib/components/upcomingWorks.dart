import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remainder_app/helper/dateFormater.dart';

class UpcomingWorks extends StatefulWidget {
  String title;
  String discreption;
  int dateTime;

  UpcomingWorks({super.key , required this.title , required this.discreption , required this.dateTime});

  @override
  State<UpcomingWorks> createState() => _UpcomingWorksState();
}

class _UpcomingWorksState extends State<UpcomingWorks> {

  String? time;
  String? date;
  String? weekday;

  void datetime() {
    DateTime schduleDate = DateTime.fromMillisecondsSinceEpoch(widget.dateTime);

    setState(() {
      time = DateFormat("h:mm a").format(schduleDate);
      date = DateFormat("dd/MM/yyyy").format(schduleDate);
      weekday = DateFormat('EEEE').format(schduleDate);
    });
  }

  @override
  void didUpdateWidget(covariant UpcomingWorks oldWidget) {
    if (widget.dateTime != oldWidget.dateTime) {
      datetime();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    datetime();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String titleToShow = widget.title.isNotEmpty ? widget.title : 'Remainder';
    String discreptionToShow = widget.discreption.isNotEmpty ? widget.discreption : 'You have some work on this time';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      //width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xffebf2fa),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date!,style: const TextStyle(color: Colors.grey),),
              Text(weekday!,style: const TextStyle(color: Colors.grey),),
            ],
          ),
          const SizedBox(height: 3,),
          Text( time!,style: const TextStyle(color: Colors.black , fontSize: 26 , fontWeight:  FontWeight.w500), ),
          Text(titleToShow,style: const TextStyle(color: Colors.black , fontWeight:  FontWeight.w400), ),
          const SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(top: MediaQuery.sizeOf(context).height*0.005),
                child: Icon(Icons.speaker_notes,color: Colors.grey[400],size: 15,),
              ),
              const SizedBox(width: 5,),
              Expanded(child: Text(discreptionToShow,style: const TextStyle(color: Colors.grey))),
            ],
          )
        ],
      ),
    );
  }
}
