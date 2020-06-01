import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:kanakkar/widgets/loadingWidget.dart';
import 'package:kanakkar/widgets/recordsList.dart';

class AllRecordsPage extends StatefulWidget {


  AllRecordsPage(Key key) : super(key : key);

  State<StatefulWidget> createState() => AllRecordsPageState();

}


 

class AllRecordsPageState extends State<AllRecordsPage> 
{
    int curMonth,curYear;
    double curIncome,curExpense;
    int mode = 0;
    GlobalKey<RecordsWidgetState> recordsKey = new GlobalKey<RecordsWidgetState>(); 


    void initState(){
      updateMonthYear( getToday().month, getToday().year);  
      super.initState();
    }

    List<int> _generateMonthList(){

        int end = 12;
        if(curYear == getToday().year)
            end = getToday().month;
      List<int> result = new List<int>();
      for(int i=0;i<end;i++)
            result.add(i);
          
       return result;
    }

    List<String> _generateYearList(){

        List<String> result = new List<String>();
        int year = getToday().year;
        for(;year>2000;year--)
            result.add(year.toString());
        return result;
    }

    updateMonthYear(int month,int year){
        
                  enableLoader();
                  curMonth = month;
                  curYear = year;
                  transactionRecordHome.readRecordsByMonth(month,year).then((value){
                     List<TransactionRecord> allValues = new List<TransactionRecord>();
                     value.forEach((key, value) {
                        allValues.addAll(value);
                     });
                     List<double> values = transactionRecordHome.getConsolidated(allValues);
                     setState((){
                        curIncome = values[0];
                        curExpense = values[1];
                     });
                      
                    recordsKey.currentState.updateRecords(value);
                    disableLoader();
                  });
    }

     enableLoader(){
    setState(() {
      mode = 1;
    });
  }
  disableLoader(){
    setState(() {
      mode = 0;
    });
    
  }

    Widget buildWidget(BuildContext context)
    {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              iconTheme: IconThemeData(
                color: ColorConstants.primaryContentColor
              ),
              backgroundColor: Color(0xff0099cc),
              title : Center(
                    child: Text("All Records",
                    style: TextStyle(color : ColorConstants.primaryContentColor,
                    fontWeight: FontWeight.bold)),
                  )
            ),        
          Row(

          children: [ 
           Expanded(
             child: DropdownButton(
                value: curMonth - 1,
                iconEnabledColor: ColorConstants.primaryColor,
                items: _generateMonthList().map((month){
                      return DropdownMenuItem(
                        value: month,
                        child: Text(MonthList[month], style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                        ),),
                      );
                  }).toList(),
                onChanged: (month) {
                    updateMonthYear(month+1, curYear);
                },
          
          )),
          Expanded(
            child: DropdownButton(
            iconEnabledColor: ColorConstants.primaryColor,
            value: curYear,
            items:_generateYearList().map((year){
                      return DropdownMenuItem(
                        value: int.parse(year),
                        child: Text(year, style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                        ),),
                        );
                  }).toList(),
            onChanged: (year) {
                  updateMonthYear(curMonth, year);
            },
            ))
          ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Center(
                child: Text(
                  (curIncome == 0) ? "0.00" : "+ " + curIncome.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ColorConstants.incomeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)
              )
              )),
              Expanded(
                child: Center(
                child: Text(
                  (curExpense == 0) ? "0.00" : "- " + curExpense.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ColorConstants.expenseColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)
              )
              ))
            ],),
          Expanded(

          child: RecordsWidget(recordsKey)
          )
          ],
        );
    }

    Widget build(BuildContext context){

       return WillPopScope(
        onWillPop: () {
          disableLoader();
          return Future.value(true);
        },
        child: (mode == 0) ? buildWidget(context) :
        Stack(
          children: [
            buildWidget(context),
            Loader()
          ]
        )
       );

    }
}

