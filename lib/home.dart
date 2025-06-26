import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'login.dart';
import 'categories.dart';
import 'addentrypage.dart';
import 'transactionhistorypage.dart';
import 'expensechartpage.dart';
import 'categorysummarypage.dart'; // Import the new CategorySummaryPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _totalBalance = 0.0;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  List<Map<String, dynamic>> _transactions = [];
  String _username = 'User';

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadUsername();
  }

  Future<void> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsString = prefs.getString('transactions');
    
    if (transactionsString != null) {
      setState(() {
        _transactions = List<Map<String, dynamic>>.from(jsonDecode(transactionsString));
        _totalBalance = _transactions.fold(0.0, (sum, item) {
          if (item['isExpense']) {
            _totalExpense += item['amount'];
            return sum - item['amount'];
          } else {
            _totalIncome += item['amount'];
            return sum + item['amount'];
          }
        });
      });
    }
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    if (storedUsername != null) {
      setState(() {
        _username = storedUsername;
      });
    }
  }

  Future<void> _saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String transactionsString = jsonEncode(_transactions);
    await prefs.setString('transactions', transactionsString);
  }

  void _deleteTransaction(int index) {
    setState(() {
      if (_transactions[index]['isExpense']) {
        _totalExpense -= _transactions[index]['amount'];
        _totalBalance += _transactions[index]['amount'];
      } else {
        _totalIncome -= _transactions[index]['amount'];
        _totalBalance -= _transactions[index]['amount'];
      }
      _transactions.removeAt(index);
      _saveTransactions();
    });
  }

  void _addTransaction(double amount, String description, DateTime date, bool isExpense) {
    setState(() {
      if (isExpense) {
        _totalExpense += amount;
        _totalBalance -= amount;
      } else {
        _totalIncome += amount;
        _totalBalance += amount;
      }
      _transactions.add({
        'amount': amount,
        'description': description,
        'date': date.toIso8601String(),
        'isExpense': isExpense,
      });
      _saveTransactions();
    });
  }

  void _clearTransactions() {
    setState(() {
      _transactions.clear();
      _totalBalance = 0.0;
      _totalIncome = 0.0;
      _totalExpense = 0.0;
      _saveTransactions();
    });
  }

  List<Map<String, dynamic>> _getTodaysTransactions() {
    DateTime now = DateTime.now();
    return _transactions.where((transaction) {
      DateTime transactionDate = DateTime.parse(transaction['date']);
      return transactionDate.year == now.year &&
             transactionDate.month == now.month &&
             transactionDate.day == now.day;
    }).toList();
  }

  Map<String, double> _getExpensePieChartData() {
    Map<String, double> data = {};
    for (var transaction in _transactions) {
      if (transaction['isExpense']) {
        data[transaction['description']] =
            (data[transaction['description']] ?? 0.0) + transaction['amount'];
      }
    }
    return data;
  }

  Map<String, double> _getIncomePieChartData() {
    Map<String, double> data = {};
    for (var transaction in _transactions) {
      if (!transaction['isExpense']) {
        data[transaction['description']] =
            (data[transaction['description']] ?? 0.0) + transaction['amount'];
      }
    }
    return data;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home page, no need to navigate
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseChartPage(
              expenseData: _getExpensePieChartData(),
              incomeData: _getIncomePieChartData(),
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategorySummaryPage(
              expenseSummary: _getExpensePieChartData(),
              incomeSummary: _getIncomePieChartData(),
              transactions: _transactions, // Pass transactions list
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0.0,
        
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black, // Set drawer background color to black
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.tealAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50.0,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Welcome, $_username',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.teal),
                title: Text('Home', style: TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.history, color: Colors.teal),
                title: Text('Transaction History', style: TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionHistoryPage(
                        transactions: _transactions,
                        onDeleteTransaction: _deleteTransaction,
                        onClearTransactions: _clearTransactions,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.teal),
                title: Text('Settings', style: TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Settings is currently unavailable.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text('Logout', style: TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.black, // Ensure the background color is black
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.teal,
                      size: 40.0,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $_username',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Your current balance:',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white70,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.tealAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      '\$${_totalBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                        letterSpacing: 3.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Total Income: \$${_totalIncome.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Total Expense: \$${_totalExpense.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Transactions',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Expanded(
                        child: ListView(
                          children: _getTodaysTransactions().map((transaction) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                transaction['description'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '${transaction['isExpense'] ? '-' : '+'}\$${transaction['amount'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: transaction['isExpense'] ? Colors.red : Colors.green,
                                ),
                              ),
                              trailing: Text(
                                DateFormat('hh:mm a').format(DateTime.parse(transaction['date'])),
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionPage(
                onAddTransaction: _addTransaction,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
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
}
