// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseScreen extends StatelessWidget {
  AddExpenseScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final containerWidth =
            constraints.maxWidth * 0.35; // Adjust for padding
        final containerHeight =
            constraints.maxHeight * 0.12; // Adjust height to maintain aspect

        return SingleChildScrollView(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save expense to Firebase
                          // Navigator.pop(context);
                          Get.back();
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                )),
          ),
        );
      }),
    );
  }
}
