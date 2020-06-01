import 'package:flutter/material.dart';

class RecordType
{
    static const  INCOME = {"name" : "Income","value" : 0};
    static const EXPENSE = {"name" : "Expense","value" : 1}; 
}

 var categories = [ 
  {"name" : "Miscellaneous", "color" : Colors.black},
  {"name" : "Fuel","color" : Colors.orange },
  {"name" : "Salary", "color" : Colors.green},
  {"name" : "Recharge", "color" : Colors.blue},
  {"name" : "Electronics", "color" : Colors.yellow },
  {"name" : "Food", "color" : Colors.red},
  {"name" : "Vehicle", "color" : Colors.brown},
  {"name" : "Grocery", "color" : Colors.grey},
  {"name" : "clothing and accessories" , "color" : Colors.pink},
  {"name" : "Taxes and Bills" , "color" : Colors.deepPurple},
  

];

const SHARED_PREF_AMOUNT = "total";
const SHARED_PREF_INIT = "initial";


class ColorConstants
{
    static final primaryColor = Color(0xff0099cc);
    static final primaryContentColor = Colors.white;

    static final expenseColor = Colors.red[300];
    static final incomeColor = Colors.green[300];

    static final dateBgColor = Colors.grey[300];
    static final dateColor = Colors.black87;

    static final dividerColor = Colors.black54;

} 

class PaddingConstants
{
    static const PRIMARY_PADDING = EdgeInsets.all(16.0);
}

class RouteConstants
{
  static const String HOME = "/";
  static const String  ALL_RECORDS = "/ALL_RECORDS";
  static const String RECORD = "/RECORD"; 
  static const String INIT = "/INIT";
  static const String TEMPLATE = "/TEMPLATE";
  static const String ALL_TEMPLATES  = "/ALL_TEMPLATES";
}


class Decorations {
static final boxshadow = [BoxShadow(
            color : Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0,3)
            )];
}

DateTime getToday()
{
      DateTime d = DateTime.now();
      return DateTime(d.year,d.month,d.day);
}

const MonthList = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

class AddRecordWdigetTextConstants {
  static const ADD_RECORD = "ADD RECORD";
  static const SUBMIT = "SUBMIT";
  static const DELETE = "DELETE";
  static const ADDING = "ADDING";
  
}

class FormMode {
  static const ADD = 0;
  static const EDIT = 1;
}

 String dateToStringForUI(DateTime date) {

   return date.day.toString() + "/" + date.month.toString() + "/" + date.year.toString();

 }  

 class FormHints {
    static const DESCRIPTION = "Description";
    static const AMOUNT = "Amount";
    static const CATEGORY = "Category";
    static const NAME = "Name";
 }
