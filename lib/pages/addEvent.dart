import 'dart:math';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:remainder_app/helper/dateFormater.dart';
import 'package:remainder_app/model/remainderModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Notification/notificationControl.dart';
import '../providers/scheduleProviders.dart';
import '../services/db_Service.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
   DateTime selectedDate = DateTime.now();
   TextEditingController title = TextEditingController();
   TextEditingController discreption = TextEditingController();
  String time(){
    var formatter = DateFormat.yMMMd('ar');
    return formatter.format(DateTime.now());
  }

   var dbService = DbService();

  datePicker()
  {
    BottomPicker.dateTime(
      title: 'schedule Your Work',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.white,
      ),
      onSubmit: (date) {
        Fluttertoast.showToast(
            msg: "Date Selected",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        setState(() {
            selectedDate = date;
        });
      },
      onClose: () {
      },
      minDateTime: DateTime.now(),
      maxDateTime: DateTime.now().add(const Duration(minutes: 43800)),
      initialDateTime:DateTime.now(),
      backgroundColor: Colors.white,
      buttonSingleColor: const Color(0xff3475db),
    ).show(context);
  }

   var result =1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedDate;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(
        builder: (context, ScheduleProvider, child) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Row(
            children: [
              Text(
                "Add Works",style: TextStyle(color: Colors.white , ),
              ),
              SizedBox(width: 5,),
              Icon(Icons.add_comment ,size: 10,)
            ],
          ),
          elevation: 0,
          backgroundColor: const Color(0xff3475db),
        ),body: Container(

        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.only(top: 40 , left: 20 , right: 20),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffebf2fa)

              ),
              child: TextField(
                controller: title,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                  border: InputBorder.none,
                  hintText: "Work title",
                  hintStyle: TextStyle(color: Colors.grey , fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 100,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:const Color(0xffebf2fa)

              ),
              child: TextField(
                controller: discreption,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    border: InputBorder.none,
                    hintText: "Description",
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey ,fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Container(
              margin: const  EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.only(left: 20),
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xffebf2fa)

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text("${DateFormater.convertDate(selectedDate)}", style: const TextStyle(color: Colors.black54 , fontWeight: FontWeight.w600 ,fontSize: 18),),
                  Container(
                    height:double.infinity,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xff3475db),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(-2,0),
                          blurRadius: 3
                        )
                      ]
                    ),
                    child: TextButton(
                      onPressed: (){
                        datePicker();
                      },
                      child: const Icon(Icons.calendar_month_rounded,color: Colors.white,),
                    ),
                  )
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 50,
              width: MediaQuery.sizeOf(context).width*0.7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:const Color(0xff3475db)
              ),
              child: TextButton(
                onPressed: () async{
                  if(selectedDate.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch)
                    {
                      ScheduleProvider.remainderList.clear();
                      var remainder = RemainderModel();
                      remainder.title = title.text;
                      remainder.description = discreption.text;
                      remainder.dateTime = selectedDate.millisecondsSinceEpoch;
                      //print(remainder.dateTime);
                      var result = await dbService.saveUser(remainder);
                      await ScheduleProvider.getAllUsers();
                      if(ScheduleProvider.notificationIsAllowed)
                      {
                        Random random =  Random();
                        int randomNumber = random.nextInt(100);
                        if(title.text.isNotEmpty || discreption.text.isNotEmpty)
                          {
                            NotificationControl().scheduleNotification(randomNumber,title.text , discreption.text, selectedDate);
                          }
                        else
                          {
                            NotificationControl().scheduleNotification(randomNumber,"Remainder", "${DateFormater.convertDate(selectedDate)}", selectedDate);

                          }
                      }
                      Navigator.pop(context,result);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Work Added Successfully"),backgroundColor: Color(0xff3475db),));
                    }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text("Oops! Your scheduled event has already passed."),backgroundColor: Colors.red[200],));
                  }
                },
                child: const Text("Add Work +" ,style: TextStyle(color: Colors.white,fontSize: 15),),
              )
            ),
          ],
        ),
      ),
      ),
    );
  }
}
