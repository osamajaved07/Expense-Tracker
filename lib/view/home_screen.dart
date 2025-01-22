import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Weekly Expense: \$100'),
                  Text('Monthly Expense: \$500'),
                  Text('Annual Expense: \$6000'),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => AddExpenseScreen()),
              // );
              Get.to("/addexpense_screen");
            },
            child: Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}
