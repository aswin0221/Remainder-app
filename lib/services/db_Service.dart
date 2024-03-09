
import 'package:remainder_app/db_helper/reposetory.dart';
import '../model/remainderModel.dart';

class DbService {
  late Repository _repository;
  DbService() {
    _repository = Repository();
  }
  //add user
  saveUser(RemainderModel schedule) async {
    return await _repository.insertdata("schedules", schedule.remainderMap());
  }

  //read ALl Users
  getAllUsers() async {
    return await _repository.readData("schedules");
  }

  //
  // //update user
  // UpdateUser(User user) async {
  //   return await _repository.updateData('users', user.usermap());
  // }
  //

  //deleteuser
  deleteUser(id) async{
    return await _repository.deleteDataById('schedules', id);
  }

}
