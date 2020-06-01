import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Template {

  int id;
  String name;
  double amount;
  String reason;
  int category;
  int type;

  Template(String n,double a,String r,int c,int t){
    name = n;
    amount = a;
    reason = r;
    category = c;
    type = t;
  }

  Template.fromMap(Map<String,dynamic> map)
  {
      id = map["id"];
      reason = map["reason"];
    category = map["category"];
    type = map["type"];
    amount = map["amount"];
    name = map["name"];
  } 
  

  void setId(int i)
  {
      id = i;
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reason': reason,
      'category' : category,
      'amount' : amount,
      'type' : type,
      'name' : name,
    };
  }

  String toString() {
      return this.toMap().toString();
  }

}




class TemplateHome{



  Future<Database> get _database async {

        return openDatabase(
    
    join(await getDatabasesPath(), 'doggie_database.db'),
    
    onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE transactionrecord (id INTEGER PRIMARY KEY, amount REAL, reason STRING,day INT,month INT,year INT, category INTEGER, type INTEGER)"
      );
      return db.execute(
                "CREATE TABLE template (id INTEGER PRIMARY KEY, amount REAL, reason STRING,name STRING, category INTEGER, type INTEGER)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

    }


  Future<int> addRecord(Template template) async
  {
       final Database db = await _database;
      
      int count = (await db.rawQuery("SELECT COUNT(id) AS count FROM template"))[0]["count"];

      template.setId(count + 1);
      await db.insert(
        'template',
        template.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, 
        );
      return Future.value(1);
  }
  
  Future<List<Template>> readTemplates() async {
    
    final Database db = await _database;
    List<Map<String,dynamic> > result = (await db.query("template"));
    List<Template> resultt = new List<Template>();
    for(Map<String,dynamic> curr in result)
    {
        Template template = Template.fromMap(curr);
        resultt.add(template);
    }
    return resultt;
  }


  Future<int> updateRecord(Template template) async
  {
      final Database db = await _database;
      
      await db.update(
        'template',
        template.toMap(),
        where: "id = " + template.id.toString()
        );
      return Future.value(1);
  }

  Future<int> deleteRecord(int templateid) async
  {
      final Database db = await _database;
      
      await db.delete(
        'template',
        where: "id = " + templateid.toString()
        );
      return Future.value(1);
  }

}

TemplateHome templateHome = new TemplateHome();
