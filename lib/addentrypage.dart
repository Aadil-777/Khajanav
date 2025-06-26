import 'package:flutter/material.dart';

class AddTransactionPage extends StatefulWidget {
  final Function(double, String, DateTime, bool) onAddTransaction;

  AddTransactionPage({required this.onAddTransaction});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isDateValid = true;
  bool _isExpense = true; // Default to expense
  String _selectedCategory = 'Select Category'; // Initial value for category

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        _isDateValid = true;
      });
    }
  }

  void _submit() {
    setState(() {
      _isDateValid = _dateController.text.isNotEmpty &&
          DateTime.tryParse(_dateController.text) != null;
    });

    if (_amountController.text.isNotEmpty &&
        _selectedCategory != 'Select Category' &&
        _isDateValid) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final date = DateTime.parse(_dateController.text);

      widget.onAddTransaction(amount, _selectedCategory, date, _isExpense);
      Navigator.of(context).pop();
    } else if (!_isDateValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid date'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _selectCategory(BuildContext context) async {
    final List<Map<String, dynamic>> categories = _isExpense
        ? [
            {'label': 'Food & Dining', 'icon': Icons.fastfood},
            {'label': 'Groceries', 'icon': Icons.shopping_cart},
            {'label': 'Transportation', 'icon': Icons.directions_car},
            {'label': 'Housing', 'icon': Icons.home},
            {'label': 'Healthcare', 'icon': Icons.health_and_safety},
            {'label': 'Others', 'icon': Icons.more_horiz},
          ]
        : [
            {'label': 'Salary', 'icon': Icons.attach_money},
            {'label': 'Freelance', 'icon': Icons.work},
            {'label': 'Investments', 'icon': Icons.trending_up},
            {'label': 'Others', 'icon': Icons.more_horiz},
          ];

    final selectedCategory = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return ListView(
          padding: EdgeInsets.all(8.0),
          children: categories
              .map((category) => ListTile(
                    leading: Icon(category['icon']),
                    title: Text(category['label']),
                    onTap: () {
                      Navigator.pop(context, category['label']);
                    },
                  ))
              .toList(),
        );
      },
    );

    if (selectedCategory != null) {
      setState(() {
        _selectedCategory = selectedCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.teal, // Match the color of HomePage
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Transaction Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Match the color of HomePage
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectCategory(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category, color: Colors.teal),
                  ),
                  child: Text(
                    _selectedCategory,
                    style: TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date (yyyy-mm-dd)',
                  border: OutlineInputBorder(),
                  hintText: 'Enter date or pick a date',
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.teal),
                  errorText: !_isDateValid ? 'Please enter a valid date' : null,
                ),
                onTap: _pickDate,
                readOnly: true,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction Type:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  Row(
                    children: [
                      Text('Expense', style: TextStyle(color: Colors.teal)),
                      Switch(
                        value: !_isExpense,
                        onChanged: (value) {
                          setState(() {
                            _isExpense = !value;
                          });
                        },
                      ),
                      Text('Income', style: TextStyle(color: Colors.teal)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.teal, // Match the color of HomePage
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Submit', style: TextStyle(fontSize: 18, color: Colors.teal)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
