import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:kanakkar/widgets/loadingWidget.dart';
import 'package:kanakkar/widgets/recordsList.dart';
import 'package:kanakkar/db/Templates.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';

class AllTemplatesPage extends StatefulWidget {


  AllTemplatesPage(Key key) : super(key : key);

  State<StatefulWidget> createState() => AllTemplatesPageState();

}


 

class AllTemplatesPageState extends State<AllTemplatesPage> 
{
    int mode = 0;
    String message;
    List<Template> templates;
    GlobalKey<RecordsWidgetState> recordsKey = new GlobalKey<RecordsWidgetState>(); 


    void initState(){
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

    Widget _buildrow(Template template){
        return SwipeGestureRecognizer(
          child: GestureDetector(
            child: Row(
              children: [
                Container(
            width: 10,
            height: 10,
            child : Text(" ",
            ),
            decoration : BoxDecoration(
                color: categories[template.category]["color"],
                shape: BoxShape.circle
            )
          ),
          Expanded(
            child: Container(child: Text(message ?? template.reason ?? template.category,
            style: TextStyle(
              fontSize: 16,
            ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
            )
          ),
          Icon(Icons.add,color : Colors.black)  
              ],),
          onLongPress: () {
              message = "Tap to use. Swipe Right to quick add. Swipe left to edit the template";
          },
          onLongPressEnd: (details) => (message = null),
          onTap: (){
            enableLoader();
            Navigator.pushNamed(
          context, 
          RouteConstants.RECORD,
          arguments: {
            "mode" : FormMode.EDIT,
            "transactionRecord" : template,
          }
            ).then((content){
              disableLoader();
            });
          }
          ),
          onSwipeRight: () {
              enableLoader();
              if(template.amount == null || template.category == null || template.type == null)
              {
                    Navigator.pushNamed(
          context, 
          RouteConstants.RECORD,
          arguments: {
            "mode" : FormMode.EDIT,
            "transactionRecord" : template,
          }
            ).then((content){
              disableLoader();
            });
            return;
              }

          },
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
                    child: Text("All Records",
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
          )
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

