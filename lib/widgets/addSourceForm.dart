import 'package:flutter/material.dart';
import 'package:kanakkar/db/Sources.dart';


class AddSourceFormWidget extends StatefulWidget {
  

  AddSourceFormWidget(Key k) : super(key : k);

   @override
  State<StatefulWidget> createState() {
    return AddSourceFormWidgetState();
  }
}

class AddSourceFormWidgetState extends State<AddSourceFormWidget> {

  TextEditingController amountController,nameController;
  int sourceId;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>(); 
  bool changed = true;

  AddSourceFormWidgetState(){
    amountController = new TextEditingController();
    nameController = new TextEditingController();
  }


  @override
  void dispose(){
        amountController.dispose();
        super.dispose();
  }

  setValues(Map<String,dynamic> data)
  {
    Source source = data["source"];
    double amount = data["remainingAmount"];
    sourceId = source.id;
    if(amount != null)
      amountController.text = amount.toString();
    if(source.name != null)
      nameController.text = source.name;
  }

  @override
  Widget build(BuildContext context) {

     Map<String,dynamic> arguments =   ModalRoute.of(context).settings.arguments;
                   if(arguments.containsKey("source") && changed)
                   {
                      setValues(arguments["source"]);
                      changed = false;
                   }
              

    return Form(
          key : formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Amount in Account",
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                keyboardType: TextInputType.number,
                validator: (value){
                  if(double.tryParse(value) == null)
                    return "Enter valid amount";
                  double val = double.parse(value);
                  if(val > 1e8)
                    return "we cannot handle these many zeros";
                  return null;
                },
                controller: amountController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Name of the account",
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                validator: (value){
                  if(value == "")
                    return "Enter some account name for you to remember";
                  if(value.length > 1000)
                      return "Please use a shorter account name";
                  return null;
                },
                controller: nameController,
              ),
            ],
            )
      );
  } 

}


