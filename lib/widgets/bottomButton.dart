import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';

class WideButtonWidget extends StatefulWidget{

  WideButtonWidget(Key k) : super(key : k);
  @override
  State<StatefulWidget> createState() {
    
    return WideButtonWidgetState();
  }
}


class WideButtonWidgetState extends State<WideButtonWidget> {
 
  String message;
  

  updateWidget(String mess,Function ont) {
        setState((){
                  message = mess; 
                });
  }

  ontap(BuildContext context){

  }

  @override
  Widget build(BuildContext context) {

        return GestureDetector(
          onTap: () => ontap(context),
          child: Container(
          padding: PaddingConstants.PRIMARY_PADDING,
          decoration: BoxDecoration(
              color: ColorConstants.primaryColor,
              boxShadow: Decorations.boxshadow
          ),
          child : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message,
                  style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.primaryContentColor))
          ],
          )));
  }

} 

//----- OLD CODE -------
//  addRecord = () {
              
//               setState((){
//                 message = "SUBMIT";
//                 ontap = submit;
//               });
//               recordsAndFormKey.currentState.changetoForm();
              
//           };
//     submit = () {
//       if(addFormKey.currentState.validate() == false)
//             return;
//           setState(() {
//                 message = "ADDING .....";
//           });
//           List<String> dateString = addRecordFormKey.currentState.dateController.text.split("/");
//           if(dateString.length != 3)
//           {
//               return;
//           }
//           DateTime da = DateTime(int.parse(dateString[2]),int.parse(dateString[1]),int.parse(dateString[0]));
//           //print("amount to be added:" + addRecordFormKey.currentState.amountController.text);
//           //print("desc to be added:" + addRecordFormKey.currentState.descController.text);
//           //print("date to be added:" + addRecordFormKey.currentState.dateController.text);
//           recordStore.addRecord(new ExpenseRecord(int.parse(addRecordFormKey.currentState.amountController.text),addRecordFormKey.currentState.descController.text,da)).then((File f){
//                 addRecordFormKey.currentState.amountController.text = "";
//                 addRecordFormKey.currentState.descController.text = "";
//                 addRecordFormKey.currentState.dateController.text = "";
//                 recordsAndFormKey.currentState.changetoRecords();
//                 if(da.difference(DateTime.now()).inDays == 0)
//                   totalKey.currentState.setexpense();

//                 updateWidget();

//           });
//     };
//     ontap = addRecord;