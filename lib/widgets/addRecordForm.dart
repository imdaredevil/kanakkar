import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:kanakkar/db/Sources.dart';


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
  int currentSource = 1;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>(); 
  bool changed = true;
  DateTime curDate;
  List<Source> sources;

  AddRecordFormWidgetState(){
    amountController = new TextEditingController();
    descController = new TextEditingController();
    dateController = new TextEditingController();
    sources = new List<Source>();
  }

 updateSources(currSources) {
     setState(() {
        sources = currSources;
     });
   
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
    if(transactionRecord.amount != null)
      amountController.text = transactionRecord.amount.toString();
    if(transactionRecord.reason != null)
      descController.text = transactionRecord.reason;
    if(transactionRecord.date != null)
    {
      dateController.text = dateToStringForUI(transactionRecord.date);
      curDate = transactionRecord.date;
    }
      setState(() {
        if(transactionRecord.category != null)
        currentCategory = transactionRecord.category;
        if(transactionRecord.type != null)
        currentType = transactionRecord.type;
        if(transactionRecord.sourceId != null)
          currentSource = transactionRecord.sourceId;
        if(transactionRecord.date != null)
    {
      dateController.text = dateToStringForUI(transactionRecord.date);
      curDate = transactionRecord.date;
    }
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
                  if(val > 1e8)
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
                      currentType = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: FormHints.DESCRIPTION + "You can leave it as blank if you want",
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                validator: (value){
                  
                  if(value.length > 1000)
                      return "Make your description shorter";
                  return null;
                },
                controller: descController,
              ),
              DateTimeField(
                format: DateFormat("dd/MM/yyyy"),
                initialValue: curDate ?? null,
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
                validator: (value) {
                  if(value == null)
                    return "Choose a date";
                    return null;
                },
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
                 currentCategory = value;
                }
                ),
          DropdownButtonFormField(
                value: currentSource ?? 1,
                validator: (value) {
                  if(value == null)
                  return "choose the account";
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Enter account",
                    contentPadding: const EdgeInsets.all(16.0),
                ),
                items: sources.map((source){
                      return DropdownMenuItem(
                          value: source.id,
                          child: Text(source.name) );
                }).toList(),
                onChanged: (value) {
                      currentSource = value; 
                }
                )
            ],
            )
      );
  } 

}


