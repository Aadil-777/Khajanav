import 'package:flutter/material.dart';

class TransactionDetailsPage extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> transactions;

  const TransactionDetailsPage({super.key, required this.category, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$category Transactions',
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
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

                  // Parse and format the date
                  String date = transaction['date'] ?? 'No date'; // Handle missing date
                  DateTime parsedDate = DateTime.tryParse(date) ?? DateTime.now();
                  String formattedDate = "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}"; // Format as DD/MM/YYYY

                  // Determine the color and icon for 'Others' category
                  Color textColor = isExpense ? Colors.red : Colors.green;
                  IconData leadingIcon = Icons.monetization_on; // Default icon for other categories
                  
                  if (category == 'Others') {
                    textColor = isExpense ? Colors.redAccent : Colors.lightGreen;
                    leadingIcon = isExpense ? Icons.cancel : Icons.check_circle; // Different icons for 'Others'
                  }

                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.grey[850], // Darker shade to match CategoriesPage
                    child: ListTile(
                      leading: Icon(leadingIcon, color: Colors.teal), // Match with theme
                      title: Text(
                        transaction['description'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0, // Adjust font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      subtitle: Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey[400], // Lighter color for the date
                          fontSize: 16.0, // Adjust font size
                        ),
                      ),
                      trailing: Text(
                        '${isExpense ? '-' : '+'}\$${transaction['amount'].toStringAsFixed(2)}',
                        style: TextStyle(
                          color: textColor, // Different color for 'Others'
                          fontSize: 18.0, // Adjust font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
