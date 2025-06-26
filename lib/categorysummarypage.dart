import 'package:flutter/material.dart';
import 'transactiondetailspage.dart'; // Ensure you have this import
import 'home.dart'; // Import HomePage
import 'expensechartpage.dart'; // Import ExpenseChartPage

class CategorySummaryPage extends StatefulWidget {
  final Map<String, double> expenseSummary;
  final Map<String, double> incomeSummary;
  final List<Map<String, dynamic>> transactions; // Add this parameter

  CategorySummaryPage({
    required this.expenseSummary,
    required this.incomeSummary,
    required this.transactions, // Initialize this parameter
  });

  @override
  _CategorySummaryPageState createState() => _CategorySummaryPageState();
}

class _CategorySummaryPageState extends State<CategorySummaryPage> {
  int _selectedIndex = 2; // Default to CategorySummaryPage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 4.0,
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Container(
        color: Colors.black, // Ensure background color is black
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[900], // Set background color
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: _buildCategorySection('Expenses', widget.expenseSummary, Colors.redAccent, context),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[900], // Set background color
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: _buildCategorySection('Income', widget.incomeSummary, Colors.greenAccent, context),
                    ),
                  ],
                ),
              ),
            ],
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
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildCategorySection(String title, Map<String, double> summary, Color color, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0, // Adjusted letter spacing
          ),
        ),
        SizedBox(height: 8.0),
        Column(
          children: summary.entries.map((entry) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[850], // Set background color
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: color, width: 2.0), // Border color to match category color
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                title: Text(
                  entry.key,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                trailing: Text(
                  '\$${entry.value.toStringAsFixed(2)}',
                  style: TextStyle(color: color, fontSize: 18.0),
                ),
                onTap: () {
                  // Navigate to TransactionDetailsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailsPage(
                        category: entry.key,
                        transactions: _filterTransactions(entry.key),
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseChartPage(
              expenseData: widget.expenseSummary, // Pass expense data
              incomeData: widget.incomeSummary, // Pass income data
            ),
          ), // Navigate to ExpenseChartPage
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CategorySummaryPage(
              expenseSummary: widget.expenseSummary,
              incomeSummary: widget.incomeSummary,
              transactions: widget.transactions,
            ),
          ), // Navigate to CategorySummaryPage
        );
        break;
    }
  }

  List<Map<String, dynamic>> _filterTransactions(String category) {
    return widget.transactions.where((transaction) {
      return transaction['description'] == category;
    }).toList();
  }
}
