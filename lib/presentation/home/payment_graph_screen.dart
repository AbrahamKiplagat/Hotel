import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import './admin_drawer.dart';

class PaymentGraphScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchPayments() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('payments').get();

    List<Map<String, dynamic>> paymentsList =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    return paymentsList;
  }

  List<BarChartGroupData> prepareChartData(List<Map<String, dynamic>> payments) {
    List<BarChartGroupData> bars = [];
    payments.forEach((payment) {
      double amount = payment['amount'].toDouble();
      Timestamp timestamp = payment['timestamp'];
      DateTime dateTime = timestamp.toDate();
      String formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(dateTime); // Format DateTime

      // Print formatted timestamp and amount to console
      print('Formatted DateTime: $formattedDateTime, Amount: $amount');

      // Convert DateTime to milliseconds since epoch for x-axis value
      int xValue = dateTime.millisecondsSinceEpoch;
      bars.add(
        BarChartGroupData(
          x: xValue,
          barRods: [
            BarChartRodData(
              toY: amount,
              width: 40,
              color: Color(0xFF009688),
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    });
    return bars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Graph'),
        backgroundColor: Colors.purple[700],
      ),
      drawer: AdminDrawer(),
      backgroundColor: Colors.purple[100], // Light purple background color
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPayments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Map<String, dynamic>> payments = snapshot.data ?? [];
          List<BarChartGroupData> chartData = prepareChartData(payments);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
              aspectRatio: 1.5, // Adjust the aspect ratio as needed
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the chart area
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.start,
                      groupsSpace: 16,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          axisNameWidget: Text(
                            "Day",
                            style: TextStyle(
                              color: Colors.purple[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          axisNameSize: 30,
                          sideTitles: SideTitles(
                            reservedSize: 44,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              // Convert numeric value (milliseconds since epoch) to formatted date
                              DateTime dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(value.toInt());
                              return Text(
                                DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(dateTime),
                                style: TextStyle(color: Colors.purple[700]),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: Text(
                            "Total amount",
                            style: TextStyle(
                              color: Colors.purple[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          axisNameSize: 50,
                          sideTitles: SideTitles(
                            reservedSize: 44,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toString(),
                                style: TextStyle(color: Colors.purple[700]),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: chartData,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _calculateInterval(List<BarChartGroupData> chartData) {
    // Calculate a suitable interval for leftTitles
    return (chartData.length / 5).toDouble();
  }
}
