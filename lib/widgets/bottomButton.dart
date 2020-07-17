import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';

class WideButtonWidget extends StatefulWidget{

  WideButtonWidget(Key k) : super(key : k);
  @override
  State<StatefulWidget> createState() {
    
    return WideButtonWidgetState();
  }
}


class WideButtonWidgetState extends State<WideButtonWidget> {
 
  String message;
  

  updateWidget(String mess,Function ont) {
        setState((){
                  message = mess; 
                });
  }

  ontap(BuildContext context){

  }

  @override
  Widget build(BuildContext context) {

        return GestureDetector(
          onTap: () => ontap(context),
          child: Container(
          padding: PaddingConstants.PRIMARY_PADDING,
          decoration: BoxDecoration(
              color: ColorConstants.primaryColor,
              boxShadow: Decorations.boxshadow
          ),
          child : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message,
                  style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.primaryContentColor))
          ],
          )));
  }

} 

