import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kanakkar/keys.dart';

class TotalExpenseWidget extends StatefulWidget {

  TotalExpenseWidget(Key key) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return TotalExpenseWidgetState();
  }

}

class TotalExpenseWidgetState extends State<TotalExpenseWidget> {
  
  List<Map<String,dynamic>> sources;
  

  void setexpense(){

    transactionRecordHome.getTotal().then((currSources){
    setState(() {
       sources = currSources ?? new List<Map<String,dynamic>>();
    });
    });
   
  }

  void initState(){

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
       return Stack(
         children: [Container(
        decoration: BoxDecoration(
          color: Color(0xff0099cc),
          boxShadow: Decorations.boxshadow
        ),
        child: Swiper(
          loop: false,
          pagination: new SwiperPagination(
            builder: new DotSwiperPaginationBuilder(activeColor: Colors.white,color: Color(0xff0077aa))
          ),
          itemCount: sources != null ? sources.length : 0,
          itemBuilder: (context,index) {
         return GestureDetector(
           onTap: () {
             basicAppPageKey.currentState.enableLoader();
            Navigator.pushNamed(context, RouteConstants.SOURCE,arguments: {
              "mode" : FormMode.EDIT,
              "source" : sources[index]
            }).then((value){
               basicAppPageKey.currentState.updateData();
               basicAppPageKey.currentState.disableLoader();
            });
           },
           child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                    Text(   sources[index]["remainingAmount"].toString(),
                         style: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),),
                    Text(sources[index]["source"].name,
                          style: TextStyle(color: Colors.white70)
                    )
          ]
        ));
          }
        )),
        GestureDetector(
          onTap: (){
            basicAppPageKey.currentState.enableLoader();
            Navigator.pushNamed(context, RouteConstants.SOURCE,arguments: {
              "mode" : FormMode.ADD
            }).then((value){
               basicAppPageKey.currentState.updateData();
               basicAppPageKey.currentState.disableLoader();
            });
          },
          child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 50,
            )
          )
        )
        )]
       );
  } 
  
}

