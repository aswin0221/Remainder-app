
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/remainderModel.dart';
import '../services/db_Service.dart';


class ScheduleProvider extends ChangeNotifier{
  ScheduleProvider(){
    getAllUsers();
    checkSessionAndNavigate();
    notifyListeners();
  }

  List<RemainderModel> remainderList = [];
  final dbService = DbService();

  Future<void> getAllUsers() async {
    var schedule = await dbService.getAllUsers();
    remainderList.clear(); // Clear the existing list

    schedule.forEach((schedule) {
      int now = DateTime.now().millisecondsSinceEpoch;
      int date = int.parse(schedule['dateTime']);
      var remaindermodel = RemainderModel();

      if (date > now) {
        remaindermodel.id = schedule['id'];
        remaindermodel.dateTime = int.parse(schedule['dateTime']);
        remaindermodel.title = schedule['title'];
        remaindermodel.description = schedule['description'];
        remainderList.add(remaindermodel);
      } else {
        // await dbService.deleteUser(remaindermodel.id);
      }
    });
    // Sort remainderList by date in ascending order
    remainderList.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

    notifyListeners();
  }

  bool notificationIsAllowed = false;

  //Todo: For Maintaining session -
  Future<void> checkSessionAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notificationisAllowed = prefs.getString('notification');
    if (notificationisAllowed == "true") {
      notificationIsAllowed = true;
    } else {
      notificationIsAllowed = false;
    }
    notifyListeners();
  }

}