import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Expense Tracker'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('expenses').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final expenses = snapshot.data!.docs;
          double totalAmount = 0;
          for (var expense in expenses) {
            totalAmount += expense['amount'];
          }
          return Column(
            children: [
              Card(
                color: tPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      //------------Budget-------
                      Row(
                        children: [
                          Text(
                            "⬇️Total Budget:",
                            style: TextStyle(
                                fontSize: tmidfontsize(context),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' \Rs ${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: tsmallfontsize(context),
                                fontWeight: FontWeight.w400,
                                color: tin),
                          ),
                        ],
                      ),

                      //--------Expense-----
                      Row(
                        children: [
                          Text(
                            "🔺Total Expense:",
                            style: TextStyle(
                                fontSize: tmidfontsize(context),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' \Rs ${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: tsmallfontsize(context),
                                fontWeight: FontWeight.w400,
                                color: tout),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return ListTile(
                          title: Text(expense['description']),
                          subtitle: Text('\Rs ${expense['amount']}'),
                        );
                      }))
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/addexpense_screen");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
