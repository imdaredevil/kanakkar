
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {

  Widget build(BuildContext context){
    return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8)
          ),
          child: Center(
            child: Image.asset("images/486.gif")
          )
          );
  }

}
