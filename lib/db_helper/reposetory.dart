
import 'package:remainder_app/db_helper/database_connection.dart';
import 'package:sqflite/sqflite.dart';


class Repository {
  late DatabaseConnection _databaseconnection;
  Repository() {
    _databaseconnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseconnection.setDatabase();
      return _database;
    }
  }

  //insert data into db
  insertdata(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  //Read all data
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  //Read single data
  readDataById(table, id) async {
    var connection = await database;
    return await connection?.query(table, where: "id=?", whereArgs: [id]);
  }

  //update data in db
  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: "id=?", whereArgs: [data['id']]);
  }

  //delete data from db
  deleteDataById(table, id) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=$id");
  }
}
