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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  right: tverysmallspace(context),
                  left: tverysmallspace(context),
                  top: tlargespace(
                    context,
                  ),
                  bottom: tsmallspace(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(
                      horizontal: tverysmallspace(context),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: tPrimaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "⬇️Total Budget:",
                                style: TextStyle(
                                  fontSize: tmidfontsize(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' \Rs ${totalBudget.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: tsmallfontsize(context),
                                  fontWeight: FontWeight.w400,
                                  color: tSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "🔺Total Expense:",
                                style: TextStyle(
                                  fontSize: tmidfontsize(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' \Rs ${totalExpense.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: tsmallfontsize(context),
                                  fontWeight: FontWeight.w400,
                                  color: tSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "             Remaining Balance:",
                                style: TextStyle(
                                  fontSize: tmidfontsize(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' \Rs ${remainingBalance.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: tsmallfontsize(context),
                                  fontWeight: FontWeight.w400,
                                  color: tSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: tverysmallspace(context),
                  ),
                  Container(
                    height: 1,
                    width: tfullwidth(context),
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                  SizedBox(
                    height: tverysmallspace(context),
                  ),
                  // Scrollable List
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          final amount = transaction['amount'];
                          final description = transaction['description'];
                          final date = transaction['date'].toDate();

                          final formattedDate =
                              DateFormat('dd MMM yyyy').format(date);
                          final formattedTime =
                              DateFormat('hh:mm a').format(date);

                          return Card(
                            elevation: 2.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
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
                                  color: amount > 0 ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Fixed Bottom Buttons
                  Padding(
                    padding: EdgeInsets.only(top: tverysmallspace(context)),
                    child: Row(
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
