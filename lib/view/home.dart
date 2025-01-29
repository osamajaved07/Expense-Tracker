import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:expense_tracker/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller to manage dynamic entries
class EntryController extends GetxController {
  var entries = <String>[].obs; // Reactive list for dynamic updates
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addEntry(String entry) async {
    try {
      // Add entry to Firestore
      await firestore
          .collection('entries')
          .add({'entry': entry, 'timestamp': FieldValue.serverTimestamp()});

      // Add entry to local list
      entries.add(entry);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save entry: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchEntries() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('entries')
          // .orderBy('timestamp', )
          .get();
      entries.value =
          snapshot.docs.map((doc) => doc['entry'] as String).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch entries: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  // void addEntry(String entry) {
  //   entries.add(entry); // Add new entry to the list
  // }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final EntryController controller = Get.put(EntryController());

  void showInputDialog(BuildContext context, Function(String) onSave) {
    TextEditingController _textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Details"),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: "Type something...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String inputText = _textController.text.trim();
                if (inputText.isNotEmpty) {
                  onSave(inputText); // Pass the text back
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchEntries();
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
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // Pencil icon
            onPressed: () {
              showInputDialog(context, (enteredText) {
                controller
                    .addEntry(enteredText); // Save the input to the controller
              });
            },
          ),
        ],
      ),
      body: Container(
        height: tfullheight(context),
        width: tfullwidth(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(
          () => controller.entries.isEmpty
              ? Center(
                  child: Text(
                    'No entries yet. Tap the edit icon to add one.',
                    style: TextStyle(color: ttextcolor),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(
                      top: tlargespace(context),
                      left: tsmallspace(context),
                      right: tsmallspace(context),
                      bottom: tmidspace(context)),
                  itemCount: controller.entries.length,
                  itemBuilder: (context, index) {
                    final entry = controller.entries[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => TransactionsScreen(entry: entry));
                      },
                      child: Card(
                        elevation: 4.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            entry,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
