import 'package:expense_tracker/Database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Expanded(
              child: FutureBuilder(
                  future: DatabaseHelper.instance.queryAll(),
                  builder: (context, snapshot) {
                    List<Map<String, dynamic>> data = snapshot.data ?? [];
                    int cash = 0;
                    for (int i = 1; i < data.length; i++) {
                      cash =
                          cash + int.parse(data[i]['money'].toString());
                    }
                    int save;
                    save = data[0]['money'] - cash;
                    Map<String,double> dataMap = {
                      'Saving' : double.parse(save.toString()),
                    };
                    for(int i=1;i<data.length;i++){
                      dataMap[data[i]['name']] = double.parse(data[i]['money'].toString());
                    }
                    if(cash<=data[0]['money']){
                      return Column(
                        children: [
                          PieChart(
                            dataMap: dataMap,
                            chartType: ChartType.disc,
                            chartValuesOptions: ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            legendOptions: LegendOptions(
                              legendPosition: LegendPosition.bottom,
                            ),
                            ringStrokeWidth: 30,
                          ),
                        ],
                      );
                    }
                    else{
                      return Center(
                        child: Text('Budget is lower than expenditure'),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
