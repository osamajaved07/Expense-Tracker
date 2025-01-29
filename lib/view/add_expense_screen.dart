// ignore_for_file: unused_local_variable, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseScreen extends StatefulWidget {
  final String entry;
  final bool isCashIn;
  final String? transactionId;
  final double? existingAmount;
  final String? existingDescription;

  AddExpenseScreen(
      {super.key,
      required this.isCashIn,
      this.transactionId,
      this.existingAmount,
      this.existingDescription,
      required this.entry});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();

  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.transactionId != null) {
      // Pre-fill the fields for editing
      _amountController.text = widget.existingAmount?.toString() ?? '';
      _descriptionController.text = widget.existingDescription ?? '';
    }
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text;
      final date = DateTime.now();

      if (widget.transactionId == null) {
        // Add new transaction
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(widget.entry)
            .collection('expenses')
            .add({
          'amount': widget.isCashIn ? amount : -amount,
          'description': description,
          'date': date,
          'type': widget.isCashIn ? 'Cash In' : 'Cash Out',
        });
      } else {
        // Update existing transaction
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(widget.entry)
            .collection('expenses')
            .doc(widget.transactionId)
            .update({
          'amount': widget.isCashIn ? amount : -amount,
          'description': description,
          'date': date,
          'type': widget.isCashIn ? 'Cash In' : 'Cash Out',
        });
      }
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(widget.transactionId == null
              ? (widget.isCashIn ? 'Add Cash In' : 'Add Cash Out')
              : 'Edit Transaction'),
        ),
        body: Padding(
          padding: EdgeInsets.all(tsmallspace(context)),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: tsmallspace(context),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: tsmallspace(context),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: tbuttoncolor,
                        padding: EdgeInsets.symmetric(
                            horizontal: tfullwidth(context) * 0.15)),
                    onPressed: _saveTransaction,
                    child: Text(
                      'Save',
                      style: TextStyle(
                          fontSize: tsmallfontsize(context), color: ttextcolor),
                    ),
                  ),
                ],
              )),
        ));
  }
}
