import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';


class AddRecordFormWidget extends StatefulWidget {
  

  AddRecordFormWidget(Key k) : super(key : k);

   @override
  State<StatefulWidget> createState() {
    return AddRecordFormWidgetState();
  }
}

class AddRecordFormWidgetState extends State<AddRecordFormWidget> {

  TextEditingController amountController,descController,dateController;
  int currentCategory,currentType = RecordType.EXPENSE["value"],transactionRecordId;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>(); 
  bool changed = true;

  AddRecordFormWidgetState(){
    amountController = new TextEditingController();
    descController = new TextEditingController();
    dateController = new TextEditingController();

  }

  @override
  void dispose(){
        amountController.dispose();
        descController.dispose();
        dateController.dispose();
        super.dispose();
  }

  setValues(TransactionRecord transactionRecord)
  {
    transactionRecordId = transactionRecord.id;
      amountController.text = transactionRecord.amount.toString();
      descController.text = transactionRecord.reason;
      dateController.text = dateToStringForUI(transactionRecord.date);
      setState(() {
        currentCategory = transactionRecord.category;
        currentType = transactionRecord.type;
      });
  }

  @override
  Widget build(BuildContext context) {

     Map<String,dynamic> arguments =   ModalRoute.of(context).settings.arguments;
                   if(arguments.containsKey("transactionRecord") && changed)
                   {
                      setValues(arguments["transactionRecord"]);
                      changed = false;
                   }
                  

    return Form(
          key : formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: FormHints.AMOUNT,
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                keyboardType: TextInputType.number,
                validator: (value){
                  if(double.tryParse(value) == null)
                    return "Enter valid amount";
                  double val = double.parse(value);
                  if(val > 1e6)
                    return "we cannot handle these many zeros";
                  return null;
                },
                controller: amountController,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    hintText: "type",
                    contentPadding: const EdgeInsets.all(16.0),
                ),
                value: currentType ?? RecordType.EXPENSE["value"],
                validator: (value) {
                  if(value == null)
                    return "Choose whether it is income or expense";
                  return null;
                },
                items: [
                  RecordType.INCOME,
                  RecordType.EXPENSE
                ].map((e){
                  return DropdownMenuItem(
                    value: e["value"],
                    child: Text(e["name"]) 
                    );
                }).toList(), 
                onChanged: (value) {
                  setState((){
                      currentType = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: FormHints.DESCRIPTION,
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                validator: (value){
                  if(value.isEmpty)
                    return "Enter some description";
                  if(value.length > 1000)
                      return "Make your description shorter";
                  return null;
                },
                controller: descController,
              ),
              DateTimeField(
                format: DateFormat("dd/MM/yyyy"),
                initialValue: getToday(),
                onShowPicker: (context, currentValue) {
                        return showDatePicker(context: context, 
                        initialDate: currentValue ?? DateTime.now(), 
                        firstDate: DateTime(1900,1,1),
                        lastDate: DateTime.now());
                },
                decoration: InputDecoration(
                  hintText: "Date",
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                keyboardType: TextInputType.datetime,
                controller: dateController,
              ),
              DropdownButtonFormField(
                value: currentCategory ?? null,
                validator: (value) {
                  if(value == null)
                  return "choose some category";
                  return null;
                },
                decoration: InputDecoration(
                    hintText: FormHints.CATEGORY,
                    contentPadding: const EdgeInsets.all(16.0),
                ),
                items: categories.map((category){
                      return DropdownMenuItem(
                          value: categories.indexOf(category),
                          child: Row(children: [
                            Container(
            width: 10,
            height: 10,
            child : Text(" ",
            ),
            decoration : BoxDecoration(
                color: category["color"],
                shape: BoxShape.circle
            )
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
          child :  Text(category["name"]))
                          ])
                      );
                }).toList(),
                onChanged: (value) {
                  setState((){
                      currentCategory = value; 
                  });
                }
                )
            ],
            )
      );
  } 

}


