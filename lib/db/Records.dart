import 'dart:async';
import 'package:kanakkar/db/Templates.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kanakkar/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kanakkar/db/Sources.dart';


class TransactionRecord {

  int id;
  double amount;
  String reason;
  DateTime date;
  int category;
  int type;
  int sourceId;

  TransactionRecord(double a,String r,DateTime d,int c,int t,int s){
    amount = a;
    reason = r;
    date = DateTime(d.year,d.month,d.day);
    category = c;
    type = t;
    sourceId = s;
  }


  TransactionRecord.fromTemplate(Template template)
  {
      if(template.reason.isEmpty)
      reason = template.name;
      else
      reason = template.reason;
      amount = template.amount;
      type = template.type;
      category = template.category;
      sourceId = template.sourceId;
  }

  setDate(DateTime d)
  {
      date = d;
  }

  TransactionRecord.fromMap(Map<String,dynamic> map)
  {
      id = map["id"];
      reason = map["reason"];
    category = map["category"];
    type = map["type"];
    amount = map["amount"];
    date = DateTime(map["year"],map["month"],map["day"]);
    sourceId = map["sourceId"];
  } 
  

  void setId(int i)
  {
      id = i;
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reason': reason,
      'day' : (date == null) ? 0 : date.day,
      'month' : (date == null) ? 0 : date.month,
      'year' : (date == null) ? 0 : date.year,
      'category' : category,
      'amount' : amount,
      'type' : type,
      'sourceId' : sourceId 
    };
  }

  String toString() {
      return this.toMap().toString();
  }

}




class TransactionRecordHome{



  Future<bool> checkForExisting() async{
    final prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(SHARED_PREF_INIT);

  } 

  Future<bool> setInit(value) async {

        final prefs  = await SharedPreferences.getInstance();
        prefs.setBool(SHARED_PREF_INIT,true);

        await sourceHome.initCash(value);
        return Future.value(true);
  }

  Future<List<Map<String,dynamic>>> getTotal() async
  {
      
      final Database db = await _database;
      var sources = (await db.query("source",where: "DELETED = 0",orderBy: "id"));
      List<Map<String,dynamic>> resultt = new List<Map<String,dynamic>>();
      for(var sourceMap in sources)
      {
          var source = Source.fromMap(sourceMap);
          resultt.add({
            "source" : source,
            "remainingAmount" : source.amount
          });
      }
      var result = (await db.query("transactionrecord"));
      for(var record in result)
      {
          for(var sourceMap in resultt)
          {
              if(sourceMap["source"].id == record["sourceId"])
            {
                  if(record["type"] == RecordType.INCOME["value"])
                  {
                      sourceMap["remainingAmount"] += record["amount"];
                  }
                  else  
                  {
                     sourceMap["remainingAmount"]  -= record["amount"];
                  }
                  break;
            }
          }
      }

      return resultt;
      
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


  Future<int> addRecord(TransactionRecord transactionRecord) async
  {
       final Database db = await _database;
      int count = (await db.rawQuery("SELECT COUNT(id) AS count FROM transactionrecord"))[0]["count"];

      transactionRecord.setId(count + 1);
      await db.insert(
        'transactionrecord',
        transactionRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, 
        );
      return Future.value(1);
  }
  
  Future<Map<DateTime,List<Map<String,dynamic>>>> readRecordsByMonth(int month,int year) async {
    
    final Database db = await _database;
    List<Map<String,dynamic> > result = (await db.query("transactionrecord", 
    where : "month = " + month.toString() + " AND " + "year = " + year.toString(),
    orderBy: "day"
    ));
    Map<DateTime,List<Map<String,dynamic>> > resultt = new Map<DateTime,List<Map<String,dynamic>> >();
    for(Map<String,dynamic> curr in result)
    {
        TransactionRecord transactionRecord = TransactionRecord.fromMap(curr);
        DateTime curday = transactionRecord.date;
        Source curSource = (await sourceHome.readSourceById(transactionRecord.sourceId));
        if(resultt.containsKey(curday))
        {
            resultt[curday].add(
              {
                "transactionRecord" : transactionRecord,
                "source" : curSource
              });
        }
        else
        {
            List<Map<String,dynamic>> current = new List<Map<String,dynamic>>();
            current.add({
                "transactionRecord" : transactionRecord,
                "source" : curSource
              });
            resultt.putIfAbsent(curday, () => current);
        }
    }
    return resultt;
  }

  Future<Map<DateTime,List<Map<String,dynamic>>>> getRecentRecords() async  {

      final Database db = await _database;
      
      Map<DateTime,List<Map<String,dynamic>>> result = new Map<DateTime,List<Map<String,dynamic>>>();
      List<Map<String,dynamic>> queryres = (await db.query("transactionrecord",
          orderBy: "year,month,day DESC",
          limit: 10));
          for(Map<String,dynamic> element in queryres)
          {
            TransactionRecord currentRecord = new TransactionRecord.fromMap(element);
             Source curSource = (await sourceHome.readSourceById(currentRecord.sourceId));
            if(result.containsKey(currentRecord.date))
              result[currentRecord.date].add(
                  {
                "transactionRecord" : currentRecord,
                "source" : curSource
              }
              );
            else
              result.putIfAbsent(currentRecord.date, (){
                  List<Map<String,dynamic>> currentList = new List<Map<String,dynamic>>();
                  currentList.add({
                "transactionRecord" : currentRecord,
                "source" : curSource
              });
                  return currentList;
              });
      }
      return result;
  }

  Future<int> updateRecord(TransactionRecord transactionRecord) async
  {
      final Database db = await _database;
      
      await db.update(
        'transactionrecord',
        transactionRecord.toMap(),
        where: "id = " + transactionRecord.id.toString()
        );
      return Future.value(1);
  }

  Future<int> deleteRecord(int transactionRecordid) async
  {
      final Database db = await _database;
      
      await db.delete(
        'transactionrecord',
        where: "id = " + transactionRecordid.toString()
        );
      return Future.value(1);
  }

  List<double> getConsolidated(List<TransactionRecord> transactionrecords)
  {
      double income = 0, expense = 0;
      for(TransactionRecord transactionRecord in transactionrecords)
      {
          if(transactionRecord.type == RecordType.INCOME["value"])
            income += transactionRecord.amount;
          else
            expense += transactionRecord.amount;
      }
      return [income,expense];
  }

}

TransactionRecordHome transactionRecordHome = new TransactionRecordHome();
