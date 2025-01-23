// ignore_for_file: unused_local_variable, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseScreen extends StatelessWidget {
  AddExpenseScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('expenses').add({
        'amount': double.parse(_amountController.text),
        'description': _descriptionController.text,
        'date': DateTime.now(),
      });
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
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
                      onPressed: _saveExpense,
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
