import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:kanakkar/widgets/loadingWidget.dart';
import 'package:kanakkar/widgets/totalExpense.dart';
import 'package:kanakkar/widgets/addRecordForm.dart';
import 'package:kanakkar/widgets/bottomButton.dart';
import 'package:kanakkar/keys.dart';


class TemplateButton extends WideButtonWidget {

  TemplateButton(Key k) : super(k);
  
  createState() => new TemplateButtonState();

}

class TemplateButtonState extends WideButtonWidgetState {

    TemplateButtonState(){
      message = "TEMPLATES"; 
    }
    ontap(BuildContext context){

        addRecordFormPageKey.currentState.enableLoader();
        Navigator.pushNamed(context,RouteConstants.ALL_TEMPLATES).then((value) => addRecordFormPageKey.currentState.disableLoader());
    }

}

class DeleteButton extends WideButtonWidget {

  DeleteButton(Key k) : super(k);
  
  createState() => new DeleteButtonState();

}

class DeleteButtonState extends WideButtonWidgetState {

    DeleteButtonState(){
      message = "DELETE RECORD"; 
    }
    ontap(BuildContext context){

        addRecordFormPageKey.currentState.enableLoader();
        transactionRecordHome.deleteRecord(addRecordFormPageKey.currentState.addRecordKey.currentState.transactionRecordId).then(
            (value){
                Navigator.pop(context,true);
            }
        );
    }

}

class AddButton extends WideButtonWidget {

  AddButton(Key k) : super(k);
  
  createState() => new AddButtonState();

}

class AddButtonState extends WideButtonWidgetState {


    AddButtonState(){
      message = "ADD RECORD";
    }

    ontap(BuildContext context){

      if(addRecordFormPageKey.currentState.addRecordKey.currentState.formKey.currentState.validate() == false)
          return;
        addRecordFormPageKey.currentState.enableLoader();
        double amount = double.parse(addRecordFormPageKey.currentState.addRecordKey.currentState.amountController.text);
        String reason = addRecordFormPageKey.currentState.addRecordKey.currentState.descController.text;
        List<String> datePair = addRecordFormPageKey.currentState.addRecordKey.currentState.dateController.text.split("/");
        DateTime date = DateTime(int.parse(datePair[2]),int.parse(datePair[1]),int.parse(datePair[0]));
        int category = addRecordFormPageKey.currentState.addRecordKey.currentState.currentCategory;
        int type = addRecordFormPageKey.currentState.addRecordKey.currentState.currentType;
        if(reason.isEmpty)
            reason = categories[category]["name"];
        transactionRecordHome.addRecord(new TransactionRecord(amount,reason,date,category,type)).then(
            (value){
                  Navigator.pop(context,true);
            }
        );
    }

}

class UpdateButton extends WideButtonWidget {

  UpdateButton(Key k) : super(k);
  
  createState() => new UpdateButtonState();

}

class UpdateButtonState extends WideButtonWidgetState {


    UpdateButtonState(){
      message = "EDIT RECORD";
    }

    ontap(BuildContext context){

        if(addRecordFormPageKey.currentState.addRecordKey.currentState.formKey.currentState.validate() == false)
          return;
        addRecordFormPageKey.currentState.enableLoader();
        double amount = double.parse(addRecordFormPageKey.currentState.addRecordKey.currentState.amountController.text);
        String reason = addRecordFormPageKey.currentState.addRecordKey.currentState.descController.text;
        List<String> datePair = addRecordFormPageKey.currentState.addRecordKey.currentState.dateController.text.split("/");
        DateTime date = DateTime(int.parse(datePair[2]),int.parse(datePair[1]),int.parse(datePair[0]));
        int category = addRecordFormPageKey.currentState.addRecordKey.currentState.currentCategory;
        int type = addRecordFormPageKey.currentState.addRecordKey.currentState.currentType;
        int id = addRecordFormPageKey.currentState.addRecordKey.currentState.transactionRecordId;
        if(reason.isEmpty)
            reason = categories[category]["name"];
        TransactionRecord temp = new TransactionRecord(amount,reason,date,category,type);
        temp.setId(id);
        transactionRecordHome.updateRecord(temp).then(
            (value){
                  Navigator.pop(context,true);
                  
            }
        );
    }

}


class AddRecordFormPage extends StatefulWidget {

  AddRecordFormPage(Key k) : super(key : k);

  @override
  State<StatefulWidget> createState() => AddRecordFormPageState();

}


class AddRecordFormPageState extends State<AddRecordFormPage> {

  GlobalKey<TotalExpenseWidgetState> totalKey = new GlobalKey<TotalExpenseWidgetState>();
  GlobalKey<AddRecordFormWidgetState> addRecordKey = new GlobalKey<AddRecordFormWidgetState>();
  GlobalKey<WideButtonWidgetState> wideButtonKey = new GlobalKey<WideButtonWidgetState>();
  GlobalKey<WideButtonWidgetState> deleteButtonKey = new GlobalKey<WideButtonWidgetState>();
  GlobalKey<WideButtonWidgetState> templateButtonKey = new GlobalKey<WideButtonWidgetState>();
  int mode = 0;

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

  @override 
  Widget build(BuildContext context){

      return WillPopScope(
        onWillPop: () {
          disableLoader();
          return Future.value(true);
        },
        child:(mode == 0) ? buildWidget(context)
      : Stack(
        children: [
          buildWidget(context),
          Loader()
        ],
      )
      );

  }

  Widget buildWidget(BuildContext context){

        final Map<String,dynamic> arguments = ModalRoute.of(context).settings.arguments;
        int mode = arguments["mode"];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        AppBar(
              iconTheme: IconThemeData(
                color: ColorConstants.primaryContentColor
              ),
              backgroundColor: Color(0xff0099cc),
              title : Center(
                    child: Text( "Record",
                    style: TextStyle(color : ColorConstants.primaryContentColor,
                    fontWeight: FontWeight.bold)),
                  )
            ),
        Expanded(
          child : Column(
            children: [
              Expanded(child: AddRecordFormWidget(addRecordKey),),
              (mode == FormMode.EDIT) ? DeleteButton(deleteButtonKey) : TemplateButton(templateButtonKey)
            ],)
          ),
          (mode == FormMode.EDIT) ? UpdateButton(wideButtonKey) : AddButton(wideButtonKey)
      ]);

  }
  
}