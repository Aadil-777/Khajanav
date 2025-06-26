import 'package:flutter/material.dart';

class TransactionDetailsPage extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> transactions;

  TransactionDetailsPage({required this.category, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$category Transactions',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0, // Match letter spacing
          ),
        ),
        backgroundColor: Colors.teal, // Match CategoriesPage theme
        elevation: 0, // No shadow for a cleaner look
        toolbarHeight: 60.0, // Match CategoriesPage AppBar height
      ),
      body: Container(
        color: Colors.black, // Match the background color of CategoriesPage
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  var transaction = transactions[index];
                  bool isExpense = transaction['isExpense'] ?? true; // Default to true if not provided
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.grey[850], // Darker shade to match CategoriesPage
                    child: ListTile(
                      leading: Icon(Icons.monetization_on, color: Colors.teal), // Match with theme
                      title: Text(
                        transaction['description'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0, // Adjust font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      trailing: Text(
                        '\$${transaction['amount'].toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isExpense ? Colors.red : Colors.green, // Red for expenses, green for income
                          fontSize: 18.0, // Adjust font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
