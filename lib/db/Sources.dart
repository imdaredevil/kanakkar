import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Source {

  int id;
  String name;
  double amount;
  int deleted;

  Source(String n,double a){
    name = n;
    deleted = 0;
    amount = a;
  }


  

  

Source.fromMap(Map<String,dynamic> map)
  {
      id = map["id"];
      name = map["name"];
      amount = map["amount"];
      deleted = map["deleted"];
  } 
  

  void setId(int i)
  {
      id = i;
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name' : name,
      'deleted' : deleted,
      'amount' : amount
    };
  }

  String toString() {
      return this.toMap().toString();
  }

}




class SourceHome{

    Future<bool> initCash(double value) async {
        
        final Database db = await _database;
        Source cashSource = new Source("Cash",value);
        //cashSource.setId(0);
        await db.insert(
          'source',
          cashSource.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
          );
        return Future.value(true);
    }

    Future<Database> get _database async {

        return openDatabase(
    
    join(await getDatabasesPath(), 'doggie_database.db'),
    
    onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE transactionrecord (id INTEGER PRIMARY KEY, amount REAL, reason STRING,day INT,month INT,year INT, category INTEGER, type INTEGER,sourceId INTEGER)"
      );
      await db.execute(
        "CREATE TABLE source (id INTEGER PRIMARY KEY, name STRING, deleted INT, amount REAL)"
      );
      return db.execute(
                "CREATE TABLE template (id INTEGER PRIMARY KEY, amount REAL, reason STRING,name STRING, category INTEGER, type INTEGER,sourceId INTEGER)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

    }


  Future<int> addRecord(Source source) async
  {
       final Database db = await _database;
      
      int count = (await db.rawQuery("SELECT COUNT(id) AS count FROM source"))[0]["count"];

      source.setId(count + 1);
      await db.insert(
        'source',
        source.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, 
        );
      return Future.value(1);
  }
  
  Future<List<Source>> readLiveSources() async {
    
    final Database db = await _database;
    List<Map<String,dynamic> > result = (await db.query("source", 
    where : "deleted = 0",
    orderBy: "id"
    ));
    List<Source> resultt = new List<Source>(); 
    for(Map<String,dynamic> curr in result)
    {
        Source source = Source.fromMap(curr);
        resultt.add(source);
    }
    return resultt;
  }

  Future<Source> readSourceById(int sourceId) async {
    final Database db = await _database;
    List<Map<String,dynamic> > result = (await db.query("source",
    where : "id=" + sourceId.toString()));
    return Source.fromMap(result[0]);
  }

  

  Future<int> updateRecord(Source source) async
  {
      final Database db = await _database;
      
      await db.update(
        'source',
        source.toMap(),
        where: "id = " + source.id.toString()
        );
      return Future.value(1);
  }

  Future<int> deleteRecord(int sourceId) async
  {
      final Database db = await _database;
      List<Map<String,dynamic>> source = await db.query('source',where: "id = " + sourceId.toString());
      Map<String,dynamic> result = source[0];
      Source src = Source.fromMap(result);
      src.deleted = 1;
      await db.update(
        'source',
        src.toMap(),
        where: "id = " + sourceId.toString()
        );
      return Future.value(1);
  }


}


SourceHome sourceHome = new SourceHome();
