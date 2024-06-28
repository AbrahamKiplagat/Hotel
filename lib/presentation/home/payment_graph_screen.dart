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
              borderRadius: BorderRadius.circular(4),
              rodStackItems: [
                BarChartRodStackItem(0, amount * 0.25, Colors.blue),
                BarChartRodStackItem(amount * 0.25, amount * 0.5, Colors.green),
                BarChartRodStackItem(amount * 0.5, amount, Colors.red),
              ],
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
        title: Text('Payment Graph', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF009688),
      ),
      drawer: AdminDrawer(),
      backgroundColor: Colors.grey[200], // Set the background color of the screen
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
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.start,
                  groupsSpace: 16,
                  backgroundColor: Colors.white, // Set the background color of the chart
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text("Date & Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      axisNameSize: 30,
                      sideTitles: SideTitles(
                        reservedSize: 120,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('yyyy-MM-dd\nHH:mm:ss.SSS').format(dateTime),
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Text("Total Amount", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      axisNameSize: 50,
                      sideTitles: SideTitles(
                        reservedSize: 44,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: chartData,
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey, strokeWidth: 1);
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(color: Colors.grey, strokeWidth: 1);
                    },
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
