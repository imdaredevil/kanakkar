import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Sources.dart';
import 'package:kanakkar/db/Templates.dart';


class AddTemplateFormWidget extends StatefulWidget {
  

  AddTemplateFormWidget(Key k) : super(key : k);

   @override
  State<StatefulWidget> createState() {
    return AddTemplateFormWidgetState();
  }
}

class AddTemplateFormWidgetState extends State<AddTemplateFormWidget> {

  TextEditingController amountController,descController,nameController;
  int currentCategory,currentType = RecordType.EXPENSE["value"],templateId;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>(); 
  bool changed = true;
  List<Source> sources;
   int currentSource = 1;

  AddTemplateFormWidgetState(){
    amountController = new TextEditingController();
    descController = new TextEditingController();
    nameController = new TextEditingController();
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
        nameController.dispose();
        super.dispose();
  }

  setValues(Template template)
  {
    templateId = template.id;
      amountController.text = template.amount.toString();
      descController.text = template.reason;
      nameController.text = template.name;
      setState(() {
        currentCategory = template.category;
        currentType = template.type;
        if(template.sourceId != null)
          currentSource = template.sourceId;
      });
  }

  @override
  Widget build(BuildContext context) {

     Map<String,dynamic> arguments =   ModalRoute.of(context).settings.arguments;
                   if(arguments.containsKey("template") && changed)
                   {
                      setValues(arguments["template"]);
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
                  if(value == "")
                  return null;
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
                  setState((){
                      currentType = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: FormHints.DESCRIPTION + " to add more details. It Can be left blank",
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                validator: (value){
                  if(value.length > 1000)
                      return "Make your description shorter";
                  return null;
                },
                controller: descController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: FormHints.NAME,
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                validator: (value){
                  if(value.isEmpty)
                    return "Enter some name so that you can identfiy your template";
                  if(value.length > 1000)
                      return "Make your name shorter";
                  return null;
                },
                controller: nameController,
              ),
              DropdownButtonFormField(
                value: currentCategory ?? null,
                validator: (value) {
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
                ),
                DropdownButtonFormField(
                value: currentSource ?? 1,
                validator: (value) {
                  if(value == null)
                  return "choose the account";
                  return null;
                },
                decoration: InputDecoration(
                    hintText: FormHints.CATEGORY,
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


