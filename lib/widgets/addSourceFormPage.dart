import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/widgets/loadingWidget.dart';
import 'package:kanakkar/widgets/addSourceForm.dart';
import 'package:kanakkar/widgets/bottomButton.dart';
import 'package:kanakkar/keys.dart';
import 'package:kanakkar/db/Sources.dart';



class DeleteButton extends WideButtonWidget {

  DeleteButton(Key k) : super(k);
  
  createState() => new DeleteButtonState();

}

class DeleteButtonState extends WideButtonWidgetState {

    DeleteButtonState(){
      message = "DELETE ACCOUNT"; 
    }
    ontap(BuildContext context){

        addSourceFormPageKey.currentState.enableLoader();
        sourceHome.deleteRecord(addSourceFormPageKey.currentState.addSourceKey.currentState.sourceId).then(
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
      message = "ADD ACCOUNT";
    }

    ontap(BuildContext context){

      if(addSourceFormPageKey.currentState.addSourceKey.currentState.formKey.currentState.validate() == false)
          return;
        addSourceFormPageKey.currentState.enableLoader();
        double amount = double.parse(addSourceFormPageKey.currentState.addSourceKey.currentState.amountController.text);
        String name = addSourceFormPageKey.currentState.addSourceKey.currentState.nameController.text;
        sourceHome.addRecord(new Source(name,amount)).then(
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
      message = "EDIT ACCOUNT";
    }

    ontap(BuildContext context){

        if(addSourceFormPageKey.currentState.addSourceKey.currentState.formKey.currentState.validate() == false)
          return;
        addSourceFormPageKey.currentState.enableLoader();
        double amount = double.parse(addSourceFormPageKey.currentState.addSourceKey.currentState.amountController.text);
        String name = addSourceFormPageKey.currentState.addSourceKey.currentState.nameController.text;
        int id = addSourceFormPageKey.currentState.addSourceKey.currentState.sourceId;
        
        Source temp = new Source(name,amount);
        temp.setId(id);
        sourceHome.updateRecord(temp).then(
            (value){
                  Navigator.pop(context,true);
            }
        );
    }

}


class AddSourceFormPage extends StatefulWidget {

  AddSourceFormPage(Key k) : super(key : k);

  @override
  State<StatefulWidget> createState() => AddSourceFormPageState();

}


class AddSourceFormPageState extends State<AddSourceFormPage> {

  GlobalKey<AddSourceFormWidgetState> addSourceKey = new GlobalKey<AddSourceFormWidgetState>();
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
        int sourceId;
        if(mode == FormMode.EDIT)
        {
          sourceId = arguments["source"]["source"].id;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        AppBar(
              iconTheme: IconThemeData(
                color: ColorConstants.primaryContentColor
              ),
              backgroundColor: Color(0xff0099cc),
              title : Center(
                    child: Text( "Source",
                    style: TextStyle(color : ColorConstants.primaryContentColor,
                    fontWeight: FontWeight.bold)),
                  )
            ),
        Expanded(
          child : Column(
            children: [
              Expanded(child: AddSourceFormWidget(addSourceKey),),
              (mode == FormMode.EDIT && sourceId != 1) ? DeleteButton(deleteButtonKey) : Column(children: [])
            ],)
          ),
          (mode == FormMode.EDIT) ? UpdateButton(wideButtonKey) : AddButton(wideButtonKey)
      ]);

  }
  
}