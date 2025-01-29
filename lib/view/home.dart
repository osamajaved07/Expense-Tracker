import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:expense_tracker/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller to manage dynamic entries
class EntryController extends GetxController {
  // var entries = <String>[].obs;
  var entries = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addEntry(String entry) async {
    try {
      var docRef = await firestore.collection('entries').add({
        'entry': entry,
        'timestamp': FieldValue.serverTimestamp(),
      });

      entries.insert(0, {
        'id': docRef.id.toString(),
        'entry': entry.toString()
      }); // Add to top
    } catch (e) {
      print("error while adding entry: $e");
      Get.snackbar('Error', 'Failed to save entry: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchEntries() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('entries')
          .orderBy('timestamp', descending: true)
          .get();

      entries.value = snapshot.docs
          .map((doc) => {
                'id': doc.id.toString(),
                'entry': doc['entry']?.toString() ?? '', // Ensure it's a string
              })
          .toList();
    } catch (e) {
      print("error while fetching entries: $e");
    }
  }

  Future<void> deleteEntry(String docId) async {
    try {
      await firestore.collection('entries').doc(docId).delete();
      entries.removeWhere((entry) => entry['id'] == docId);
      Get.snackbar('Success', 'Entry deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.lightGreen);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete entry: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[200]);
    }
  }
  // void addEntry(String entry) {
  //   entries.add(entry); // Add new entry to the list
  // }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final EntryController controller = Get.put(EntryController());

  void showDeleteConfirmation(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this entry?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteEntry(docId);
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

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
                    // final entry = controller.entries[index];
                    final entryData = controller.entries[index];
                    final entry = entryData['entry'];
                    final docId = entryData['id'];

                    return GestureDetector(
                      onTap: () {
                        Get.to(
                            () => TransactionsScreen(entry: entry.toString()));
                      },
                      child: Card(
                          elevation: 4.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            title:
                                Text(entry, style: TextStyle(fontSize: 16.0)),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  showDeleteConfirmation(context, docId),
                            ),
                          )),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
