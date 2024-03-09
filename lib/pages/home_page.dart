import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:remainder_app/components/upcomingWorks.dart';
import 'package:remainder_app/pages/addEvent.dart';
import 'package:remainder_app/providers/scheduleProviders.dart';
import 'package:remainder_app/services/db_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final dbService = DbService();

   // bool notifificationIsAllowed = true;
  @override
  void initState() {
    // TODO: implement initState
    checkNotificationAllowed();
    super.initState();
  }
  Future<void> checkNotificationAllowed() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notificationisAllowed = prefs.getString('notification');
      if(notificationisAllowed == null)
        {
          diologbox();
        }
  }

  //if Notification is Allowed
  Future<void>addNotificationisAllowed() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("notification", "true");
  }

  //if Notification is Not Allowed
  Future<void>addNotificationisNotAllowed() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("notification", "false");
  }


  diologbox() async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final yourProvider = Provider.of<ScheduleProvider>(context);
        return Theme(
          data: ThemeData(canvasColor: Colors.orange),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            backgroundColor: const Color(0xffebf2fa),
            title: const Text('Enable Notifications'),
            content: const Text('To receive reminders, please enable notifications for this app.'
                'Notifications allow you to stay updated and receive timely reminders.',style: TextStyle(color: Colors.black45),),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel',style: TextStyle(color: Color(0xff3475db)),),
                onPressed: () async{
                  await addNotificationisNotAllowed();
                  await yourProvider.checkSessionAndNavigate();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Ok',style: TextStyle(color: Color(0xff3475db)),),
                onPressed: () async{
                  await addNotificationisAllowed();
                  await yourProvider.checkSessionAndNavigate();
                  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
                  FlutterLocalNotificationsPlugin();
                  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(
      builder: (context, ScheduleProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.alarm ,color: Colors.white,),
              SizedBox(width: 10,),
              Text("Daily Remainder",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
            ],
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff3475db),
          elevation: 0,
           toolbarHeight: MediaQuery.sizeOf(context).height*0.12,
           shape: const RoundedRectangleBorder(
             borderRadius: BorderRadius.vertical(
               bottom: Radius.circular(30),
             ),
           ),
          scrolledUnderElevation: 0,
        ),
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.only(top: 20 , left: 20 , right: 20),
          child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(!ScheduleProvider.notificationIsAllowed)
                  GestureDetector(
                    onTap: (){
                      diologbox();
                      ScheduleProvider.checkSessionAndNavigate();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]
                      ),
                      child:
                      const Text("Notifications is Disabled Click Here to Enable Notifications",textAlign: TextAlign.center , style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                    ),
                  ),
                const SizedBox(height: 10,),
                ScheduleProvider.remainderList.isEmpty
                    ? const Center(child: Text("No Works to do !!" , style: TextStyle(color: Colors.black54,fontSize: 18 , fontWeight:FontWeight.bold),))
                    : const Text(
                  "Upcoming Works",
                  style: TextStyle(color: Colors.black54,fontSize: 18 , fontWeight:FontWeight.bold),
                ),
               // Text("Upcoming Works",style: TextStyle(color: Colors.black54,fontSize: 18 , fontWeight:FontWeight.bold),),
                const SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                      itemCount: ScheduleProvider.remainderList.length,
                      itemBuilder: (context,index)
                  {
                    return UpcomingWorks(title: ScheduleProvider.remainderList[index].title ?? "",dateTime: ScheduleProvider.remainderList[index].dateTime ?? 1, discreption: ScheduleProvider.remainderList[index].description ?? "",);
                  }
                  ),
                )
            ],
          ),
        ),
         floatingActionButton: FloatingActionButton(
       backgroundColor: const Color(0xff3475db),
           child: const Icon(Icons.add,color: Colors.white,),
           onPressed: () async{
             await ScheduleProvider.checkSessionAndNavigate();
              Navigator.push(context, PageTransition(child: AddEvent(), type: PageTransitionType.rightToLeft )).then((data) => {
             // getAllUsers()
           });
         },
         ),
      ),
    );
  }
}