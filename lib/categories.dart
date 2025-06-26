import 'package:flutter/material.dart';
import 'home.dart'; // Import HomePage
import 'categories.dart'; // Import CategoriesPage
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'expensechartpage.dart';
import 'transactiondetailspage.dart'; // Import the new TransactionDetailsPage

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedIndex = 2; // To keep track of selected index for the BottomNavigationBar
  Map<String, double> _expenseTotals = {};
  Map<String, double> _incomeTotals = {};
  Map<String, List<Map<String, dynamic>>> _transactionsByCategory = {};

  @override
  void initState() {
    super.initState();
    _loadCategoryTotals();
  }

  Future<void> _loadCategoryTotals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsString = prefs.getString('transactions');
    
    if (transactionsString != null) {
      List<Map<String, dynamic>> transactions = List<Map<String, dynamic>>.from(jsonDecode(transactionsString));
      Map<String, double> expenseTotals = {};
      Map<String, double> incomeTotals = {};
      Map<String, List<Map<String, dynamic>>> transactionsByCategory = {};

      for (var transaction in transactions) {
        String category = transaction['description'];
        double amount = transaction['amount'];
        if (transaction['isExpense']) {
          if (expenseTotals.containsKey(category)) {
            expenseTotals[category] = expenseTotals[category]! + amount;
          } else {
            expenseTotals[category] = amount;
          }
        } else {
          if (incomeTotals.containsKey(category)) {
            incomeTotals[category] = incomeTotals[category]! + amount;
          } else {
            incomeTotals[category] = amount;
          }
        }

        if (transactionsByCategory.containsKey(category)) {
          transactionsByCategory[category]!.add(transaction);
        } else {
          transactionsByCategory[category] = [transaction];
        }
      }

      setState(() {
        _expenseTotals = expenseTotals;
        _incomeTotals = incomeTotals;
        _transactionsByCategory = transactionsByCategory;
      });
    }
  }

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ExpenseChartPage(
            expenseData: _expenseTotals,
            incomeData: _incomeTotals,
          )),
        );
        break;
      case 2:
        // Already on CategoriesPage
        break;
      // Add more cases if you have more pages
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false, // Remove the back button
        toolbarHeight: 60.0, // Reduced the height of the AppBar
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Ensure the page is scrollable
          child: Column(
            children: [
              _buildSection('Expenses', _expenseTotals, isExpense: true),
              SizedBox(height: 20),
              _buildSection('Income', _incomeTotals, isExpense: false),
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
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildSection(String title, Map<String, double> totals, {required bool isExpense}) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.tealAccent],
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
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 3.0,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.0),
          ...totals.entries.map((entry) {
            return Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              color: Colors.grey[850],
              child: ListTile(
                leading: Icon(_getCategoryIcon(entry.key), color: Colors.teal),
                title: Text(entry.key, style: TextStyle(color: Colors.white)),
                trailing: Text(
                  '\$${entry.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isExpense ? Colors.red : Colors.green, // Set color based on category type
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                onTap: () {
                  List<Map<String, dynamic>> transactions = _transactionsByCategory[entry.key] ?? [];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailsPage(
                        category: entry.key,
                        transactions: transactions,
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food & Dining':
        return Icons.fastfood;
      case 'Groceries':
        return Icons.local_grocery_store;
      case 'Transportation':
        return Icons.directions_car;
      case 'Housing':
        return Icons.home;
      case 'Healthcare':
        return Icons.health_and_safety;
      case 'Salary':
        return Icons.attach_money;
      case 'Freelance':
        return Icons.work;
      case 'Investments':
        return Icons.trending_up;
      // Add more categories as needed
      default:
        return Icons.more_horiz;
    }
  }
}
