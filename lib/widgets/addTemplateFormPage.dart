import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Templates.dart';
import 'package:kanakkar/widgets/loadingWidget.dart';
import 'package:kanakkar/widgets/totalExpense.dart';
import 'package:kanakkar/widgets/addTemplateForm.dart';
import 'package:kanakkar/widgets/bottomButton.dart';
import 'package:kanakkar/keys.dart';


class DeleteButton extends WideButtonWidget {

  DeleteButton(Key k) : super(k);
  
  createState() => new DeleteButtonState();

}

class DeleteButtonState extends WideButtonWidgetState {

    DeleteButtonState(){
      message = "DELETE TEMPLATE"; 
    }
    ontap(BuildContext context){

        addTemplateFormPageKey.currentState.enableLoader();
        templateHome.deleteRecord(addTemplateFormPageKey.currentState.addTemplateKey.currentState.templateId).then(
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
      message = "ADD TEMPLATE";
    }

    ontap(BuildContext context){

      if(addTemplateFormPageKey.currentState.addTemplateKey.currentState.formKey.currentState.validate() == false)
          return;
        addTemplateFormPageKey.currentState.enableLoader();
        double amount = double.tryParse(addTemplateFormPageKey.currentState.addTemplateKey.currentState.amountController.text);
        String reason = addTemplateFormPageKey.currentState.addTemplateKey.currentState.descController.text;
        String name = addTemplateFormPageKey.currentState.addTemplateKey.currentState.nameController.text;
        int category = addTemplateFormPageKey.currentState.addTemplateKey.currentState.currentCategory;
        int type = addTemplateFormPageKey.currentState.addTemplateKey.currentState.currentType;
        templateHome.addRecord(new Template(name,amount,reason,category,type)).then(
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
      message = "EDIT TEMPLATE";
    }

    ontap(BuildContext context){

        if(addTemplateFormPageKey.currentState.addTemplateKey.currentState.formKey.currentState.validate() == false)
          return;
        addTemplateFormPageKey.currentState.enableLoader();
        double amount = double.parse(addTemplateFormPageKey.currentState.addTemplateKey.currentState.amountController.text);
        String reason = addTemplateFormPageKey.currentState.addTemplateKey.currentState.descController.text;
        String name = addTemplateFormPageKey.currentState.addTemplateKey.currentState.nameController.text;
        int category = addTemplateFormPageKey.currentState.addTemplateKey.currentState.currentCategory;
        int type = addTemplateFormPageKey.currentState.addTemplateKey.currentState.currentType;
        int id = addTemplateFormPageKey.currentState.addTemplateKey.currentState.templateId;
        Template temp = new Template(name,amount,reason,category,type);
        temp.setId(id);
        templateHome.updateRecord(temp).then(
            (value){
                  Navigator.pop(context,true);
                  
            }
        );
    }

}


class AddTemplateFormPage extends StatefulWidget {

  AddTemplateFormPage(Key k) : super(key : k);

  @override
  State<StatefulWidget> createState() => AddTemplateFormPageState();

}


class AddTemplateFormPageState extends State<AddTemplateFormPage> {

  GlobalKey<TotalExpenseWidgetState> totalKey = new GlobalKey<TotalExpenseWidgetState>();
  GlobalKey<AddTemplateFormWidgetState> addTemplateKey = new GlobalKey<AddTemplateFormWidgetState>();
  GlobalKey<WideButtonWidgetState> wideButtonKey = new GlobalKey<WideButtonWidgetState>();
  GlobalKey<WideButtonWidgetState> deleteButtonKey = new GlobalKey<WideButtonWidgetState>();
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
                    child: Text( "Template",
                    style: TextStyle(color : ColorConstants.primaryContentColor,
                    fontWeight: FontWeight.bold)),
                  )
            ),
        Expanded(
          child: (mode == FormMode.ADD) ?  AddTemplateFormWidget(addTemplateKey) :
          Column(
            children: [
              Expanded(child: AddTemplateFormWidget(addTemplateKey),),
              DeleteButton(deleteButtonKey)
            ],)
          ),
          (mode == FormMode.EDIT) ? UpdateButton(wideButtonKey) : AddButton(wideButtonKey)
      ]);

  }
  
}