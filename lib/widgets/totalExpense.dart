import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Records.dart';

class TotalExpenseWidget extends StatefulWidget {

  TotalExpenseWidget(Key key) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return TotalExpenseWidgetState();
  }

}

class TotalExpenseWidgetState extends State<TotalExpenseWidget> {
  
  double remAmount = 0;

  void setexpense(){

    transactionRecordHome.getTotal().then((amount){
    setState(() {
       remAmount = amount ?? 0;
    });
    });
   
  }

  void initState(){

    setexpense();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
       return Container(
        decoration: BoxDecoration(
          color: Color(0xff0099cc),
          boxShadow: Decorations.boxshadow
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                    Text(remAmount.toString(),
                         style: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),),
                    Text("Remaining Amount in Hand",
                          style: TextStyle(color: Colors.white70)
                    )
          ]
        ));
  } 
  
}

// --------------------------------------OLD CODE-----------------------------------------------
// class TotalExpenseWidget extends StatefulWidget {

//   TotalExpenseWidget(Key key) : super(key : key);
//   @override
//   State<StatefulWidget> createState() {
//     return TotalExpenseWidgetState();
//   }

// }

// class TotalExpenseWidgetState extends State<TotalExpenseWidget> {
  
//   int expense = recordStore.total;
//   var dates = recordStore.dates;

//   void setexpense(){
//     setState(() {
//        expense = recordStore.dates[getToday()];
//        dates = recordStore.dates;
//     });
   
//   }
//   @override
//   Widget build(BuildContext context) {

//       return new Swiper(
//       itemCount: 2,
//       scrollDirection: Axis.vertical,
//       pagination: new SwiperPagination(),
//       itemBuilder: (context, index) {
//         if(index == 0)
//         {
//             return Container(
//         decoration: BoxDecoration(
//           color: Colors.cyan,
//           boxShadow: [BoxShadow(
//             color : Colors.grey.withOpacity(0.5),
//             spreadRadius: 5,
//             blurRadius: 7,
//             offset: Offset(0,3)
//             )]
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//                     Text(expense.toString(),
//                          style: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),),
//                     Text("Total expense today",
//                           style: TextStyle(color: Colors.white70)
//                     )
//           ]
//         ));
//         }
//         else
//         {
//             List<DateTime> temp = dates.keys.toList();
//             temp.sort();
//             return BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 barGroups: temp.map((DateTime d){
//                       return BarChartGroupData(
//                             x: temp.indexOf(d),
//                             barRods: [
//                               BarChartRodData(
//                               y: dates[d].toDouble()
//                               )
//                             ]
//                       );
//                 }).toList(),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: SideTitles(
//                     showTitles: true,
//                     getTitles: (value) => temp[value.floor()].day.toString() + "/" + temp[value.floor()].month.toString(),
//                   )
//                 )  
//               )
//             );
//         }
//       },

//       );
//   } 
  
// }
