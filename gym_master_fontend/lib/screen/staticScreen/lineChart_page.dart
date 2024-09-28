import 'dart:developer';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_master_fontend/model/WeigthModel.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LineChartPage extends StatefulWidget {
  const LineChartPage({super.key});

  @override
  State<LineChartPage> createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  List<WeightModel> weights = [];
  late Future<void> loadData;
  String url = AppConstants.BASE_URL;
  late SharedPreferences prefs;
  int? uid;
  int weightNum = 5;
  double? maxWeight;
  double? minWeight;
  late String tokenJWT;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    loadData = loadDataAsync();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt("uid");
    tokenJWT = prefs.getString("tokenJwt")!;
    if (uid != null) {
      loadData = loadDataAsync();
    } else {
      // Handle the case where UID is not set
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found')),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              // Ensure weightNum does not exceed the available number of weights
                              if (weightNum < weights.length) {
                                weightNum += 1;
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFFFAC41)),
                          ),
                          child: const Text("<")),
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              // Ensure weightNum does not go below 5
                              if (weightNum != 5) {
                                weightNum -= 1;
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFFFAC41)),
                          ),
                          child: const Text(">")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.0),
                      color: Colors.amber[200],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("น้ำหนัก"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                                "ปัจจุบัน : ${weights[weights.length - 1].weight}"),
                            Text("สูงสุด : $maxWeight"),
                            Text("ต่ำสุด : $minWeight")
                          ],
                        ),
                        const SizedBox(height: 20),
                        AspectRatio(
                          aspectRatio: 1.70,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.amber[200]),
                            child: LineChart(
                              weigthCharts(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton.icon(
                    onPressed: () {
                      // Add your onPressed action here
                      _showWeightPick();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFFFAC41)),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('บันทึกน้ำหนัก'),
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            );
          }
        });
  }

  void _showWeightPick() async {
    final TextEditingController weightController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('บันทึกน้ำหนัก'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                child: TextField(
                  controller: weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'ใส่ค่าน้ำหนัก',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                double? weight = double.tryParse(weightController.text);

                if (weight != null) {
                  // Do something with the weight value
                  weightInsert(weight);
                  log("Weight entered: $weight");
                } else {
                  // Handle the error if input is not a valid float
                  log("Invalid weight entered");
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void weightInsert(double weightAdd) async {
    final dio = Dio();

    // Ensure you have access to the correct data for comparison
    DateTime now = DateTime.now();
    String formattedNow =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} 00:00:00.000Z";

    log(formattedNow);
    log(weights.last.dataProgressThai.toString());
    // Assume weights is a list of some class that has dataProgress property
    // Ensure weights and dataProgress are correctly accessible
    if (weights.last.dataProgressThai.toString() == formattedNow) {
      try {
        String date =
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        log(date);
        final updateWeigth = await dio.post(
          '$url/progress/updateWeigth',
          data: {"newWeight": weightAdd, "uid": uid, "dataProgress": date},
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJWT',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ),
        );
        if (updateWeigth.statusCode == 200) {
          setState(() {
            loadData = loadDataAsync();
          });
        }
      } catch (e) {}
    } else {
      try {
        final progressRes = await dio.post(
          '$url/progress/weightInsert',
          data: {
            'uid': uid, // Assuming you have the user ID available
            'weight': weightAdd, // The weight data you want to insert
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJWT',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ),
        );

        // Check if weight progress insertion was successful
        if (progressRes.statusCode == 200) {
          // Update the state or perform an action after successful insertion
          setState(() {
            loadData = loadDataAsync();
          });
        } else {
          log('Failed to insert weight progress. Status code: ${progressRes.statusCode}');
        }
      } catch (e) {
        // Handle any exceptions that occur during the HTTP request
        log('Error while inserting weight progress: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    // Calculate the start index for the weights to display based on weightNum
    int startIndex =
        weights.length > weightNum ? weights.length - weightNum : 0;

    // Adjust the index based on the value (which corresponds to x-axis position)
    int adjustedIndex = value.toInt() + startIndex;

    // Check if the adjusted index is out of bounds
    if (adjustedIndex < 0 || adjustedIndex >= weights.length) {
      return const SizedBox.shrink(); // Return an empty widget if out of bounds
    }

    final dataProgress = weights[adjustedIndex].dataProgressThai;
    final date =
        DateTime(dataProgress.year, dataProgress.month, dataProgress.day);
    final dateFormatter =
        DateFormat('d MMM'); // Format as day and abbreviated month

    String formattedDate = dateFormatter.format(date);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(formattedDate, style: style),
    );
  }

  LineChartData weigthCharts() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      minY: weights.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 3,
      maxY: weights.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 3,
      lineBarsData: [
        LineChartBarData(
          spots: getWeightSpots(),
          isCurved: true,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
      showingTooltipIndicators: getWeightSpots().asMap().entries.map((entry) {
        return ShowingTooltipIndicators([
          LineBarSpot(
            LineChartBarData(spots: getWeightSpots()),
            0,
            entry.value,
          ),
        ]);
      }).toList(),
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              const textStyle = TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem(
                '${touchedSpot.y} kg',
                textStyle,
              );
            }).toList();
          },
        ),
        getTouchedSpotIndicator: (barData, indicators) {
          return indicators.map((int index) {
            final line = FlLine(color: Colors.orange, strokeWidth: 4);
            return TouchedSpotIndicatorData(line, FlDotData(show: true));
          }).toList();
        },
      ),
    );
  }

  List<FlSpot> getWeightSpots() {
    // If there are no weights, return an empty list to avoid errors
    if (weights.isEmpty) {
      return [];
    }

    // Calculate the start index based on weightNum
    int startIndex =
        weights.length > weightNum ? weights.length - weightNum : 0;

    // Ensure startIndex is within valid range
    if (startIndex < 0 || startIndex >= weights.length) {
      startIndex = 0;
    }

    // Determine the number of points to take, taking all if less than 5
    int numPointsToTake =
        weights.length - startIndex >= 5 ? 5 : weights.length - startIndex;

    return weights
        .asMap()
        .entries
        .skip(startIndex)
        .take(numPointsToTake)
        .map((entry) {
      int adjustedIndex =
          entry.key - startIndex; // Adjust the index to start from 0
      WeightModel weight = entry.value;
      return FlSpot(adjustedIndex.toDouble(), weight.weight);
    }).toList();
  }

  List<Color> gradientColors = [
    const Color.fromARGB(255, 235, 193, 103),
    Colors.orange,
  ];

  Future<void> loadDataAsync() async {
    final dio = Dio();

    try {
      final String endpoint = '$url/progress/getWeightProgress?uid=$uid';
      final response = await dio.get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJWT',
          },
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );

      final List<dynamic> jsonData = response.data as List<dynamic>;
      setState(() {
        weights = jsonData.map((item) => WeightModel.fromJson(item)).toList();

        // Ensure that maxWeight and minWeight are calculated from the weights list
        maxWeight = weights.map((entry) => entry.weight).reduce(math.max);
        minWeight = weights.map((entry) => entry.weight).reduce(math.min);
      });
    } catch (e) {}
  }
}
