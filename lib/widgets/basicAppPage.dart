import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:kanakkar/widgets/loadingWidget.dart';
import 'package:kanakkar/widgets/totalExpense.dart';
import 'package:kanakkar/widgets/recordsList.dart';
import 'package:kanakkar/widgets/bottomButton.dart';
import 'package:kanakkar/keys.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
 

class AddRecordButton extends WideButtonWidget {

  AddRecordButton(Key k) : super(k);

  createState() => AddRecordButtonState();
}

class AddRecordButtonState extends WideButtonWidgetState {

    AddRecordButtonState(){
      message = "ADD RECORD";
    }

      ontap(BuildContext context){

        basicAppPageKey.currentState.enableLoader();
        Navigator.pushNamed(

              context,
              RouteConstants.RECORD,
              arguments: {
                "mode": FormMode.ADD
              }
        ).then((value){
          basicAppPageKey.currentState.updateData();
          basicAppPageKey.currentState.disableLoader();
        });
      }
}


class BasicApp extends StatefulWidget{

  BasicApp(Key k) : super(key : k);

  createState() => BasicAppState();
}

class BasicAppState extends State<BasicApp> {

  GlobalKey<TotalExpenseWidgetState> totalKey = new GlobalKey<TotalExpenseWidgetState>();
  GlobalKey<RecordsWidgetState> recentRecordKey = new GlobalKey<RecordsWidgetState>();
  GlobalKey<WideButtonWidgetState> wideButtonKey = new GlobalKey<WideButtonWidgetState>();
  int mode = 0;


  initState()
  {
      super.initState();
      updateData();
  }

  loadAllRecords(){
    enableLoader();
    Navigator.pushNamed(context, RouteConstants.ALL_RECORDS).then((value){
          updateData();
          disableLoader();
    });
  }

  loadAllTemplates(){
    enableLoader();
    Navigator.pushNamed(context, RouteConstants.ALL_TEMPLATES).then((value){
          updateData();
          disableLoader();
    });
  }
  

  Widget buildWidget(){
    return SwipeGestureRecognizer(
      onSwipeLeft: () => loadAllRecords(),
      onSwipeRight: () => loadAllTemplates(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Expanded(
          flex: 3,
          child: TotalExpenseWidget(totalKey),
        ),
        Expanded(
          flex: 5,
          child:
          Column(
            children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
              child: Container(
              padding: const EdgeInsets.fromLTRB( 0, 8.0, 0,0),
              child: Row(
                children: [
                  Icon(Icons.arrow_back,
                        color: ColorConstants.primaryColor),
                  Text("  All Templates", 
                  textAlign: TextAlign.left,
                  style: TextStyle(color: ColorConstants.primaryColor, fontSize: 18, fontWeight: FontWeight.bold)
                )
                ])),
              onTap: (){
                loadAllTemplates();
              },),
              GestureDetector(
              child: Container(
              padding: const EdgeInsets.fromLTRB( 0, 8.0, 0,0),
              child: Row(
                children: [
                  Text("All Records   ", 
                  textAlign: TextAlign.right,
                  style: TextStyle(color: ColorConstants.primaryColor, fontSize: 18, fontWeight: FontWeight.bold)
                ),
                Icon(Icons.arrow_forward,
                        color: ColorConstants.primaryColor)
                ])),
              onTap: (){
                loadAllRecords();
              },)
              ]
            ) ,
            Expanded(
              child: RecordsWidget(recentRecordKey)
            )
            ]
          )
          ),
          AddRecordButton(wideButtonKey)
      ]
      )
      ) ;
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

  updateData() {
    transactionRecordHome.getRecentRecords().then((value){
            recentRecordKey.currentState.updateRecords(value);
            totalKey.currentState.setexpense();
      });
  }

  @override
  Widget build(BuildContext context) {

      return (mode == 0) ? buildWidget() : 
      Stack(
        children : [
            buildWidget(),
            Loader()
        ]
      );
  }


}


