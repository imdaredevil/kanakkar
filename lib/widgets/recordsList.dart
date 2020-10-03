import 'package:flutter/material.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/keys.dart';

class RecordsWidget extends StatefulWidget {
 
 
  RecordsWidget(Key key) : super(key : key);
  @override
  State<StatefulWidget> createState() {
        return RecordsWidgetState();
  }


} 

class RecordsWidgetState extends State<RecordsWidget> {
  
  Map<DateTime,List<Map<String,dynamic>>> records = new Map<DateTime,List<Map<String,dynamic>>>();
  
  void updateRecords(Map<DateTime,List<Map<String,dynamic>>> currRecords){
    setState(() {
          records = currRecords;
  });
}
 
  Widget _buildRecord(Map<String,dynamic> currRecord){

    return GestureDetector( 
    onTap: (){
        if(ModalRoute.of(context).settings.name == RouteConstants.HOME)
          basicAppPageKey.currentState.enableLoader();
        else
          allRecordsPageKey.currentState.enableLoader();  
        Navigator.pushNamed(
          context, 
          RouteConstants.RECORD,
          arguments: {
            "mode" : FormMode.EDIT,
            "transactionRecord" : currRecord["transactionRecord"],
          }
          ).then((value){
                if(ModalRoute.of(context).settings.name == RouteConstants.HOME)
              {
                  basicAppPageKey.currentState.updateData();
                  basicAppPageKey.currentState.disableLoader();
              }
              else
              {
                  allRecordsPageKey.currentState.updateMonthYear(allRecordsPageKey.currentState.curMonth,allRecordsPageKey.currentState.curYear);
                  allRecordsPageKey.currentState.disableLoader();
              }

            });
    },
    child: Container(
      padding: PaddingConstants.PRIMARY_PADDING,
      child: Row(  
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
          Container(
            width: 10,
            height: 10,
            child : Text(" ",
            ),
            decoration : BoxDecoration(
                color: categories[currRecord["transactionRecord"].category]["color"],
                shape: BoxShape.circle
            )
          ),
          Expanded(
            child: Container(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(currRecord["transactionRecord"].reason,
            style: TextStyle(
              fontSize: 16,
            ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0,3.0,0,0),
            child: Text(currRecord["source"].name.toString().toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey 
            )))
            ]),
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
            )
          ),
          Text(
            ((currRecord["transactionRecord"].type == RecordType.INCOME["value"]) ? "+" : "-") + currRecord["transactionRecord"].amount.toString(),
            style: TextStyle(
              color:  ((currRecord["transactionRecord"].type == RecordType.INCOME["value"]) ? ColorConstants.incomeColor : ColorConstants.expenseColor),
              fontWeight: FontWeight.bold,
              fontSize: 16
              ),
          )
      ],
    )
    )
    );

  }

  Widget _buildDate(DateTime date,List<Map<String,dynamic>> currRecords){

    // return Text("testing");
    List<TransactionRecord> recordList = new List<TransactionRecord>();
    for(var recordAndSource in currRecords)
    {
        recordList.add(recordAndSource["transactionRecord"]);
    }
    var consolidated = transactionRecordHome.getConsolidated(recordList);
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            decoration: BoxDecoration(
              color: ColorConstants.dateBgColor
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
              dateToStringForUI(date),
                            style: TextStyle(
                              color: ColorConstants.dateColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          )),
              Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                children: [ 
                  Expanded(
                    child : Text(
                  consolidated[0] == 0 ? "0.00" : "+" + consolidated[0].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color : ColorConstants.incomeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
                )),
                Expanded(              
                child: Text(
                  consolidated[1] == 0 ? "0.00" : " -" + consolidated[1].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color : ColorConstants.expenseColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
                )
                )
              ])
              )
              ]
            )
            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: currRecords.map((element){
                                return _buildRecord(element);   
                            }).toList(),
                          )
                      
                        ],
                    );
              
                }
               
                @override
                Widget build(BuildContext context) {

                  

                    //DateTime minDate = getMin();
                    return ListView.builder(
                      itemCount: records.keys.length,
                      itemBuilder: (context, index) {
                          DateTime current = records.keys.toList()[index]; 
                          return _buildDate(current,records[current]);
                      }
                    );
              
                }
              
               
}
