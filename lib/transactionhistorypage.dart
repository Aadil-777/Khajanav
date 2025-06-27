import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(int) onDeleteTransaction;
  final VoidCallback onClearTransactions;

  const TransactionHistoryPage({super.key, 
    required this.transactions,
    required this.onDeleteTransaction,
    required this.onClearTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            
          ),
        ),
        backgroundColor: Colors.teal, // Match CategoriesPage theme
        elevation: 0, // No shadow for a cleaner look
        toolbarHeight: 60.0, // Match CategoriesPage AppBar height
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              // Show confirmation dialog before clearing all transactions
              bool? confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Transactions'),
                  content: const Text('Are you sure you want to clear all transactions?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Yes', style: TextStyle(color: Colors.teal)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No', style: TextStyle(color: Colors.teal)),
                    ),
                  ],
                ),
              );

              // Clear transactions if confirmed
              if (confirm == true) {
                onClearTransactions(); // Invoke the callback to clear transactions
                Navigator.of(context).pop(); // Go back to the previous screen after clearing
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black, // Match CategoriesPage background color
        padding: const EdgeInsets.all(16.0),
        child: transactions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 100, color: Colors.grey[300]),
                    const SizedBox(height: 20),
                    Text(
                      'No transactions available.',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final amount = transaction['amount'];
                  final description = transaction['description'];
                  final date = DateTime.parse(transaction['date']); // Ensure parsing DateTime correctly
                  final isExpense = transaction['isExpense'];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800], // Grey box color
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: isExpense ? Colors.redAccent : Colors.greenAccent,
                        child: Icon(
                          isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        description,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        date.toLocal().toString().substring(0, 10),
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: isExpense ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              // Show a confirmation dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Transaction'),
                                  content: const Text('Are you sure you want to delete this transaction?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        onDeleteTransaction(index); // Invoke the callback to delete the transaction
                                        Navigator.of(context).pop(); // Close the dialog
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Transaction deleted'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
