import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, "db_curd");
    var database =
    await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database,int version)async{
    await _createSchedulesTable(database);
  }

  Future<void> _createSchedulesTable (Database database) async{
    String sql="CREATE TABLE schedules(id INTEGER PRIMARY KEY, dateTime TEXT,title TEXT,description TEXT);";
    await database.execute(sql);
  }

}
