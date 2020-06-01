import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:kanakkar/keys.dart';
import 'package:kanakkar/widgets/loadingWidget.dart';
import 'package:kanakkar/db/Templates.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:kanakkar/widgets/bottomButton.dart';

class AddTemplateButton extends WideButtonWidget {

  AddTemplateButton(Key k) : super(k);

  createState() => AddTemplateButtonState();
}

class AddTemplateButtonState extends WideButtonWidgetState {

    AddTemplateButtonState(){
      message = "ADD TEMPLATE";
    }

      ontap(BuildContext context){

        allTemplatesPageKey.currentState.enableLoader();
        Navigator.pushNamed(

              context,
              RouteConstants.TEMPLATE,
              arguments: {
                "mode": FormMode.ADD
              }
        ).then((value){
          allTemplatesPageKey.currentState.updateTemplates();
          allTemplatesPageKey.currentState.disableLoader();
          
        });
      }
}




class AllTemplatesPage extends StatefulWidget {


  AllTemplatesPage(Key key) : super(key : key);

  State<StatefulWidget> createState() => AllTemplatesPageState();

}


 

class AllTemplatesPageState extends State<AllTemplatesPage> 
{
    int mode = 0;
    String message;
    List<Template> templates;
    GlobalKey<WideButtonWidgetState> addTemplateButtonKey = new GlobalKey<WideButtonWidgetState>();

    void initState(){
      templates = new List<Template>();
      updateTemplates();
      message = null;
      super.initState();
    }

    updateTemplates(){
        
                  enableLoader();
                  templateHome.readTemplates().then((value){
                     setState((){
                        templates = value;
                     });
                      
                    disableLoader();
                  });
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

  loadEditTemplate(template){
    enableLoader();
            Navigator.pushNamed(context,
            RouteConstants.TEMPLATE,
            arguments: {
              "mode" : FormMode.EDIT,
              "template" : template
            }
            ).then((value){
              updateTemplates();
              disableLoader();
            });
  }


  useTemplate(template){
    enableLoader();
            Navigator.pushNamed(
          context, 
          RouteConstants.RECORD,
          arguments: {
            "mode" : FormMode.ADD,
            "transactionRecord" : new TransactionRecord.fromTemplate(template),
          }
            ).then((content){
              disableLoader();
            });
  }

  quickAddTemplate(template){
     enableLoader();
              if(template.amount == null || template.category == null || template.type == null)
              {
                    Navigator.pushNamed(
          context, 
          RouteConstants.RECORD,
          arguments: {
            "mode" : FormMode.EDIT,
            "transactionRecord" : TransactionRecord.fromTemplate(template),
          }
            ).then((content){
              disableLoader();
            });
            return;
              }
              TransactionRecord transactionRecord = TransactionRecord.fromTemplate(template);
              transactionRecord.setDate(getToday());
              print(transactionRecord);
              transactionRecordHome.addRecord(transactionRecord).then((value){
                  basicAppPageKey.currentState.updateData();
                  Navigator.pushNamed(context,RouteConstants.HOME).then((value){
                      disableLoader();
                  });
              });
  }

  

    Widget _buildrow(Template template){
        return  GestureDetector(
            child: 
            SwipeGestureRecognizer(
            child: Row(
              children: [
                Container(
            width: 10,
            height: 10,
            child : Text(" ",
            ),
            decoration : BoxDecoration(
                color: categories[template.category ?? 0]["color"],
                shape: BoxShape.circle
            )
          ),
          Expanded(
            child: Container(child: Text(template.name,
            style: TextStyle(
              fontSize: 16,
            ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
            )
          ),
          IconButton(
          tooltip: "use this template to create a new record",
          icon: Icon(Icons.add,color : Colors.black),
          onPressed: () {
            useTemplate(template);
          },
          ),
          IconButton(
          tooltip: "edit template",
          icon: Icon(Icons.edit,color : Colors.black),
          onPressed: () {
            loadEditTemplate(template);
          }
          ),
          IconButton(
          tooltip: "quick add for today",
          icon: Icon(Icons.playlist_add,color : Colors.black),
          onPressed: () {
            quickAddTemplate(template);
          } 
          ) 
              ],),
          onSwipeLeft: () => quickAddTemplate(template),
          ),
          );
    } 

    Widget buildWidget(BuildContext context)
    {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              iconTheme: IconThemeData(
                color: ColorConstants.primaryContentColor
              ),
              backgroundColor: Color(0xff0099cc),
              title : Center(
                    child: Text("All Templates",
                    style: TextStyle(color : ColorConstants.primaryContentColor,
                    fontWeight: FontWeight.bold)),
                  )
            ),        
          Expanded(

          child: ListView.separated(
            itemBuilder: (context,index){
              return _buildrow(templates[index]);
            }, 
            separatorBuilder: (context,index){
              return Divider(
                  color : Colors.grey
              );
            }, 
            itemCount: templates.length)
          ),
          AddTemplateButton(addTemplateButtonKey)
          ],
        );
    }

    Widget build(BuildContext context){

       return WillPopScope(
        onWillPop: () {
          disableLoader();
          return Future.value(true);
        },
        child: (mode == 0) ? buildWidget(context) :
        Stack(
          children: [
            buildWidget(context),
            Loader()
          ]
        )
       );

    }
}

