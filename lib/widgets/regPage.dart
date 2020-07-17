import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/widgets/bottomButton.dart';
import 'package:kanakkar/widgets/loadingWidget.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:kanakkar/keys.dart';

class AddRecordButton extends WideButtonWidget {

  AddRecordButton(Key k) : super(k);

  createState() => AddRecordButtonState();
}

class AddRecordButtonState extends WideButtonWidgetState {

    AddRecordButtonState(){
      message = "CONTINUE";
    }

      ontap(BuildContext context){
          if(!registerPageKey.currentState.formkey.currentState.validate())
            return;
          registerPageKey.currentState.enableLoader();
          transactionRecordHome.setInit(double.parse(registerPageKey.currentState.amountController.text)).then((value){
                            Navigator.pushReplacementNamed(context,  RouteConstants.HOME).then(
                              (value) {
                                registerPageKey.currentState.disableLoader();
                              }
                            );
          });

        }
}




class RegisterPage extends StatefulWidget {

RegisterPage(Key k) : super(key : k);

createState() => RegisterPageState();

}

class RegisterPageState extends State<RegisterPage> {

  int mode = 1;
  GlobalKey<AddRecordButtonState> continueKey =  new GlobalKey<AddRecordButtonState>();
  TextEditingController amountController  = new TextEditingController();
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();

  void dispose()
  {
      amountController.dispose();
      super.dispose();
  }

   Widget buildWidget(){

     return Column(
       crossAxisAlignment : CrossAxisAlignment.stretch,
       children: [
         
         Expanded(
           child: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                  padding: const EdgeInsets.all(32.0),
                  child: Icon(Icons.account_balance,
                  size: 96,
                  color : ColorConstants.primaryColor)
                 ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Hi! I am Kanakkar, your personal auditor. I will record your income and expenses.",
                  style : TextStyle(
                    color : ColorConstants.primaryColor,
                    fontSize : 32,
                    fontWeight: FontWeight.w100
                  ))),
                   Form(
                  key : formkey,
                 child : TextFormField(
                    textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Enter the cash amount you currently have",
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                keyboardType: TextInputType.number,
                validator: (value){
                  if(double.tryParse(value) == null)
                    return "Enter valid amount";
                  double val = double.parse(value);
                  if(val >= 10000000)
                    return "we cannot handle these many zeros";
                  return null;
                },
                controller: amountController,
                  ))
               ],
             )
           ),
           ),
           AddRecordButton(continueKey),
       ]);
   
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

  void initState(){
    checkForExisting();
    super.initState();
  }

  checkForExisting(){
      (transactionRecordHome.checkForExisting()).then((exists){
          if(exists)
          {
              Navigator.pushReplacementNamed(context,RouteConstants.HOME).then((value)=>disableLoader());
          }
          else
          disableLoader();
      });

 }

  @override
  Widget build(BuildContext context) {


      return  (mode == 0) ? buildWidget() : 
      Stack(
        children : [
            buildWidget(),
            Loader()
        ]
      );
  }

}