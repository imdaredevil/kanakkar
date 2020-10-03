import 'package:flutter/material.dart';
import 'package:kanakkar/constants.dart';
import 'package:kanakkar/db/Records.dart';
import 'package:kanakkar/db/Sources.dart';
import 'package:kanakkar/widgets/loadingWidget.dart';
import 'package:kanakkar/widgets/recordsList.dart';

class AllRecordsPage extends StatefulWidget {
  AllRecordsPage(Key key) : super(key: key);

  State<StatefulWidget> createState() => AllRecordsPageState();
}

class AllRecordsPageState extends State<AllRecordsPage> {
  int curMonth=getToday().month, curYear=getToday().year;
  double curIncome=0, curExpense=0;
  int mode = 0;
  GlobalKey<RecordsWidgetState> recordsKey =
      new GlobalKey<RecordsWidgetState>();
  List<Source> sources = new List<Source>();
  List<int> currCategories = new List<int>(), currSources = new List<int>();
  Map<DateTime, List<Map<String, dynamic>>> allRecords;
  List<bool> checkboxes = new List<bool>();

  void initState() {
    super.initState();
    setSources();
    
  }

  List<int> _generateMonthList() {
    int end = 12;
    if (curYear == getToday().year) end = getToday().month;
    List<int> result = new List<int>();
    for (int i = 0; i < end; i++) result.add(i);

    return result;
  }

  List<String> _generateYearList() {
    List<String> result = new List<String>();
    int year = getToday().year;
    for (; year > 2000; year--) result.add(year.toString());
    return result;
  }

  updateMonthYear(int month, int year) {
    enableLoader();
    curMonth = month;
    curYear = year;
    transactionRecordHome.readRecordsByMonth(month, year).then((value) {
      setState(() {
        allRecords = value;
      });

      filterCategoryAndSource();
      disableLoader();
    });
  }

  setSources() {
    enableLoader();
    sourceHome.readLiveSources().then((value) {
      setState(() {
        sources = value;
        checkboxes.clear();
        for (var i = 0; i < sources.length; i++) {
          checkboxes.add(true);
          currSources.add(sources[i].id);
        }
        for (var i = 0; i < categories.length; i++) {
          checkboxes.add(true);
          currCategories.add(i);
        }
      });
      disableLoader();
      updateMonthYear(getToday().month, getToday().year);
    });
  }

  filterCategoryAndSource() {
    List<TransactionRecord> allValues = new List<TransactionRecord>();
    Map<DateTime, List<Map<String, dynamic>>> filteredRecords =
        new Map<DateTime, List<Map<String, dynamic>>>();
    allRecords.forEach((key, recordAndSources) {
      List<Map<String, dynamic>> filtered = new List<Map<String, dynamic>>();
      for (var recordSource in recordAndSources) {
        if (currCategories.indexOf(recordSource["transactionRecord"].category) >
                -1 &&
            currSources.indexOf(recordSource["transactionRecord"].sourceId) >
                -1) filtered.add(recordSource);
      }
      for (var recordSource in filtered)
        allValues.add(recordSource["transactionRecord"]);
      filteredRecords.putIfAbsent(key, () => filtered);
    });
    List<double> values = transactionRecordHome.getConsolidated(allValues);
    setState(() {
      curIncome = values[0];
      curExpense = values[1];
    });
    recordsKey.currentState.updateRecords(filteredRecords);
  }

  enableLoader() {
    setState(() {
      mode = 1;
    });
  }

  disableLoader() {
    setState(() {
      mode = 0;
    });
  }

  Widget buildWidget(BuildContext context) {
    return Scaffold(
        endDrawer: Drawer(
            child: Container(
                padding: EdgeInsets.all(16.0),
                child: ListView.builder(
                    itemCount: categories.length + sources.length + 2,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Text("Categories",
                            style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0));
                      } else if (index == categories.length + 1) {
                        return Text("Sources",
                            style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0));
                      } else {
                        return CheckboxListTile(
                          value: (index <= categories.length)
                              ? checkboxes[index - 1]
                              : checkboxes[index - 2],
                          title: (index <= categories.length)
                              ? Row(children: [
                                  Container(
                                      width: 10,
                                      height: 10,
                                      child: Text(
                                        " ",
                                      ),
                                      decoration: BoxDecoration(
                                          color: categories[index - 1]["color"],
                                          shape: BoxShape.circle)),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(16.0, 0, 0,0),
                                   child: Text(categories[index - 1]["name"],
                                  style: TextStyle(fontSize: 16))
                                )]
                              )
                              : Text(
                                  sources[index - categories.length - 2].name,
                                  style: TextStyle(fontSize: 16),
                                ),
                          onChanged: (newvalue) {
                            setState(() {
                              if (newvalue) {
                                if (index <= categories.length) {
                                  checkboxes[index - 1] = true;
                                  currCategories.add(index - 1);
                                } else {
                                  checkboxes[index - 2] = true;
                                  currSources.add(
                                      sources[index - categories.length - 2]
                                          .id);
                                }
                              } else {
                                if (index <= categories.length) {
                                  checkboxes[index - 1] = false;
                                  currCategories.remove(index - 1);
                                } else {
                                  checkboxes[index - 2] = false;
                                  currSources.remove(
                                      sources[index - categories.length - 2]
                                          .id);
                                }
                              }
                            });
                            filterCategoryAndSource();
                          },
                        );
                      }
                    }))),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
                iconTheme:
                    IconThemeData(color: ColorConstants.primaryContentColor),
                backgroundColor: Color(0xff0099cc),
                title: Center(
                  child: Text("All Records",
                      style: TextStyle(
                          color: ColorConstants.primaryContentColor,
                          fontWeight: FontWeight.bold)),
                )),
            Row(
              children: [
                Expanded(
                    child: DropdownButton(
                  value: curMonth - 1,
                  iconEnabledColor: ColorConstants.primaryColor,
                  items: _generateMonthList().map((month) {
                    return DropdownMenuItem(
                      value: month,
                      child: Text(
                        MonthList[month],
                        style: TextStyle(
                            color: ColorConstants.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (month) {
                    updateMonthYear(month + 1, curYear);
                  },
                )),
                Expanded(
                    child: DropdownButton(
                  iconEnabledColor: ColorConstants.primaryColor,
                  value: curYear,
                  items: _generateYearList().map((year) {
                    return DropdownMenuItem(
                      value: int.parse(year),
                      child: Text(
                        year,
                        style: TextStyle(
                            color: ColorConstants.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (year) {
                    updateMonthYear(curMonth, year);
                  },
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                            (curIncome == 0)
                                ? "0.00"
                                : "+ " + curIncome.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorConstants.incomeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)))),
                Expanded(
                    child: Center(
                        child: Text(
                            (curExpense == 0)
                                ? "0.00"
                                : "- " + curExpense.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorConstants.expenseColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))))
              ],
            ),
            Expanded(child: RecordsWidget(recordsKey))
          ],
        ));
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          disableLoader();
          return Future.value(true);
        },
        child: (mode == 0)
            ? buildWidget(context)
            : Stack(children: [buildWidget(context), Loader()]));
  }
}
