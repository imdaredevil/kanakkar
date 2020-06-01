import 'package:flutter/material.dart';
import 'package:kanakkar/widgets/addRecordFormPage.dart';
import 'package:kanakkar/widgets/allRecordsPage.dart';
import 'package:kanakkar/widgets/basicAppPage.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/keys.dart';
import 'package:kanakkar/widgets/regPage.dart';
import 'package:kanakkar/widgets/addTemplateFormPage.dart';
import 'package:kanakkar/widgets/templatePage.dart';

void main() {
  
  runApp(MyApp());
  
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  Widget routeConstructor(Widget wid,BuildContext context)
  {
      return Scaffold(
        body: wid
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanakkar',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        primaryTextTheme: TextTheme(
          bodyText1 : TextStyle(
            fontSize: 18
          )
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      initialRoute: RouteConstants.INIT,
      routes: {

        RouteConstants.HOME : (context){
            basicAppPageKey = new GlobalKey<BasicAppState>();
           return Scaffold(body : BasicApp(basicAppPageKey));
        },
        RouteConstants.ALL_RECORDS : (context){
          allRecordsPageKey = new GlobalKey<AllRecordsPageState>();
          return Scaffold(body : AllRecordsPage(allRecordsPageKey));
        },
        RouteConstants.RECORD : (context){
          addRecordFormPageKey = new GlobalKey<AddRecordFormPageState>();
          return Scaffold(body : AddRecordFormPage(addRecordFormPageKey));
        },
        RouteConstants.INIT : (context){
          registerPageKey = new GlobalKey<RegisterPageState>();
          return Scaffold(body : RegisterPage(registerPageKey));
        },
        RouteConstants.ALL_TEMPLATES : (context) {
            allTemplatesPageKey = new GlobalKey<AllTemplatesPageState>();
            return Scaffold(body: AllTemplatesPage(allTemplatesPageKey));
        },
        RouteConstants.TEMPLATE : (context) {
          addTemplateFormPageKey = new GlobalKey<AddTemplateFormPageState>();
          return Scaffold(body : AddTemplateFormPage(addTemplateFormPageKey));
        }
      }
    );
  }
}

