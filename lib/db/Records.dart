import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kanakkar/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TransactionRecord {

  int id;
  double amount;
  String reason;
  DateTime date;
  int category;
  int type;

  TransactionRecord(double a,String r,DateTime d,int c,int t){
    amount = a;
    reason = r;
    date = DateTime(d.year,d.month,d.day);
    category = c;
    type = t;
  }

  TransactionRecord.fromMap(Map<String,dynamic> map)
  {
      id = map["id"];
      reason = map["reason"];
    category = map["category"];
    type = map["type"];
    amount = map["amount"];
    date = DateTime(map["year"],map["month"],map["day"]);
  } 
  

  void setId(int i)
  {
      id = i;
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reason': reason,
      'day' : date.day,
      'month' : date.month,
      'year' : date.year,
      'category' : category,
      'amount' : amount,
      'type' : type
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
      return prefs.setDouble(SHARED_PREF_INIT, value);

  }

  Future<bool> setTotal() async
  {
      final prefs = await SharedPreferences.getInstance();
      
      final Database db = await _database;
      var result = (await db.query("transactionrecord",
      columns : ["SUM(amount)","type"],
      groupBy : "type"));
      double current = 0;
      for(var record in result)
      {
          if(record["type"] == RecordType.INCOME["value"])
              current += record["SUM(amount)"];
          else  
              current -= record["SUM(amount)"];
      }
      if(prefs.containsKey(SHARED_PREF_INIT))
        current += prefs.getDouble(SHARED_PREF_INIT);
      return prefs.setDouble(SHARED_PREF_AMOUNT,current);
  }

  Future<double> getTotal() async
  {
      await setTotal();
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(SHARED_PREF_AMOUNT);
  }

    Future<Database> get _database async {

        return openDatabase(
    
    join(await getDatabasesPath(), 'doggie_database.db'),
    
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE transactionrecord (id INTEGER PRIMARY KEY, amount REAL, reason STRING,day INT,month INT,year INT, category INTEGER, type INTEGER)",
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
      await setTotal();
      return Future.value(1);
  }
  
  Future<Map<DateTime,List<TransactionRecord>>> readRecordsByMonth(int month,int year) async {
    
    final Database db = await _database;
    List<Map<String,dynamic> > result = (await db.query("transactionrecord", 
    where : "month = " + month.toString() + " AND " + "year = " + year.toString(),
    orderBy: "day"
    ));
    Map<DateTime,List<TransactionRecord> > resultt = new Map<DateTime,List<TransactionRecord> >();
    for(Map<String,dynamic> curr in result)
    {
        TransactionRecord transactionRecord = TransactionRecord.fromMap(curr);
        DateTime curday = transactionRecord.date;
        if(resultt.containsKey(curday))
        {
            resultt[curday].add(transactionRecord);
        }
        else
        {
            List<TransactionRecord> current = new List<TransactionRecord>();
            current.add(transactionRecord);
            resultt.putIfAbsent(curday, () => current);
        }
    }
    return resultt;
  }

  Future<Map<DateTime,List<TransactionRecord>>> getRecentRecords() async  {

      final Database db = await _database;
      
      Map<DateTime,List<TransactionRecord>> result = new Map<DateTime,List<TransactionRecord>>();
      List<Map<String,dynamic>> queryres = (await db.query("transactionrecord",
          orderBy: "year,month,day DESC",
          limit: 10));
          for(Map<String,dynamic> element in queryres)
          {
            TransactionRecord currentRecord = new TransactionRecord.fromMap(element);
            if(result.containsKey(currentRecord.date))
              result[currentRecord.date].add(currentRecord);
            else
              result.putIfAbsent(currentRecord.date, (){
                  List<TransactionRecord> currentList = new List<TransactionRecord>();
                  currentList.add(currentRecord);
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
      await setTotal();
      return Future.value(1);
  }

  Future<int> deleteRecord(int transactionRecordid) async
  {
      final Database db = await _database;
      
      await db.delete(
        'transactionrecord',
        where: "id = " + transactionRecordid.toString()
        );
      await setTotal();
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
