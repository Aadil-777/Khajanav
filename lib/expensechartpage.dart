import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'home.dart'; // Import your HomePage
import 'categories.dart'; // Import your CategoriesPage

class ExpenseChartPage extends StatefulWidget {
  final Map<String, double> expenseData;
  final Map<String, double> incomeData;

  ExpenseChartPage({required this.expenseData, required this.incomeData});

  @override
  _ExpenseChartPageState createState() => _ExpenseChartPageState();
}

class _ExpenseChartPageState extends State<ExpenseChartPage> {
  int _selectedIndex = 1; // Set the initial index to the Pie Chart Page

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        // Already on ExpenseChartPage, no action needed
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CategoriesPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasExpenseData = widget.expenseData.isNotEmpty;
    final hasIncomeData = widget.incomeData.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false, // Remove the back button
        toolbarHeight: 60.0, // Reduced the height of the AppBar
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildChartContainer(
                  title: 'Expenses',
                  hasData: hasExpenseData,
                  chart: PieChart(
                    dataMap: widget.expenseData,
                    chartType: ChartType.ring,
                    colorList: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.white, Colors.blue],
                    legendOptions: LegendOptions(
                      showLegends: true,
                      legendPosition: LegendPosition.right,
                      legendTextStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValues: false, // Hide chart values
                    ),
                    ringStrokeWidth: 40,
                    emptyColor: Colors.grey[300]!,
                    animationDuration: Duration(milliseconds: 1000),
                    baseChartColor: Colors.transparent,
                    centerText: null, // Remove the center text
                  ),
                ),
                SizedBox(height: 20.0),
                _buildChartContainer(
                  title: 'Income',
                  hasData: hasIncomeData,
                  chart: PieChart(
                    dataMap: widget.incomeData,
                    chartType: ChartType.ring,
                    colorList: [Colors.green, Colors.lightGreen, Colors.blueAccent, Colors.purple, Colors.pink, Colors.teal],
                    legendOptions: LegendOptions(
                      showLegends: true,
                      legendPosition: LegendPosition.right,
                      legendTextStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValues: false, // Hide chart values
                    ),
                    ringStrokeWidth: 40,
                    emptyColor: Colors.grey[300]!,
                    animationDuration: Duration(milliseconds: 1000),
                    baseChartColor: Colors.transparent,
                    centerText: null, // Remove the center text
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Chart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Income/Expense',
          ),
        ],
        selectedItemColor: Colors.teal,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildChartContainer({
    required String title,
    required bool hasData,
    required PieChart chart,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.tealAccent], // Matching gradient with LoginPage
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0, // Font size for headings
              fontWeight: FontWeight.bold, // Set font to bold
              letterSpacing: 3.0, // Added letter spacing
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.0),
          hasData
              ? SizedBox(
                  height: 200,
                  child: chart,
                )
              : Center(
                  child: Text(
                    'No data to display',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white70,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
