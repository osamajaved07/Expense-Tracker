import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:expense_tracker/view/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Expense Tracker'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final transactions = snapshot.data!.docs;
          double totalBudget = 0;
          double totalExpense = 0;

          for (var transaction in transactions) {
            final amount = transaction['amount'];
            if (amount > 0) {
              totalBudget += amount;
            } else {
              totalExpense += amount.abs();
            }
          }

          final remainingBalance = totalBudget - totalExpense;

          return Container(
            height: tfullheight(context),
            width: tfullwidth(context),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/back.jpg'),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 16, right: 8, left: 8, top: 106),
              child: Column(
                children: [
                  Card(
                    elevation: 8.0, // Add a subtle shadow
                    margin: EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0), // Add margin
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16.0), // Rounded corners
                    ),
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
                                ' \Rs ${totalBudget.toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontSize: tsmallfontsize(context),
                                    fontWeight: FontWeight.w400,
                                    color: tSecondaryColor),
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
                                ' \Rs ${totalExpense.toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontSize: tsmallfontsize(context),
                                    fontWeight: FontWeight.w400,
                                    color: tSecondaryColor),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                "             Remaining Balance:",
                                style: TextStyle(
                                    fontSize: tmidfontsize(context),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' \Rs ${remainingBalance.toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontSize: tsmallfontsize(context),
                                    fontWeight: FontWeight.w400,
                                    color: tSecondaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            final amount = transaction['amount'];
                            final description = transaction['description'];
                            final date = transaction['date'].toDate();

                            final formattedDate = DateFormat('dd MMM yyyy')
                                .format(date); // e.g., "01 Oct 2023"
                            final formattedTime =
                                DateFormat('hh:mm a').format(date);

                            return Card(
                              elevation: 2.0, // Add a subtle shadow
                              margin: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0), // Add margin
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddExpenseScreen(
                                        isCashIn: transaction['amount'] > 0,
                                        transactionId: transaction.id,
                                        existingAmount: transaction['amount'],
                                        existingDescription:
                                            transaction['description'],
                                      ),
                                    ),
                                  );
                                },
                                leading: Icon(
                                  amount > 0
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: amount > 0 ? Colors.green : Colors.red,
                                  size: 24.0,
                                ),
                                title: Text(description,
                                    style: TextStyle(
                                        fontSize: tsmallfontsize(context))),
                                subtitle:
                                    Text('$formattedDate at $formattedTime'),
                                trailing: Text(
                                  '\Rs ${amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: tverysmallfontsize(context),
                                    color:
                                        amount > 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                            );
                          })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: tbuttoncolor),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddExpenseScreen(isCashIn: true),
                            ),
                          );
                        },
                        child: Text(
                          'Add Cash In',
                          style: TextStyle(color: ttextcolor),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: tbuttoncolor),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddExpenseScreen(isCashIn: false),
                            ),
                          );
                        },
                        child: Text(
                          'Add Cash Out',
                          style: TextStyle(color: ttextcolor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.toNamed("/addexpense_screen");
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
