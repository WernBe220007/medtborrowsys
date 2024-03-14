import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medtborrowsys/main.dart';
import 'package:medtborrowsys/sharedprefsprovider.dart';

class ReturnMenu extends StatefulWidget {
  final BorrowedItem borrowedItem;
  const ReturnMenu({super.key, required this.borrowedItem});

  @override
  ReturnMenuState createState() => ReturnMenuState();
}

class ReturnMenuState extends State<ReturnMenu> {
  final TextEditingController _notesController = TextEditingController();
  bool defect = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MedtborrowsysState>();
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${widget.borrowedItem.name} ausleihen"),
        ],
      ),
      content: SingleChildScrollView(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            Row(
              children: [
                const Icon(Icons.title),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    widget.borrowedItem.name,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.description),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    widget.borrowedItem.description,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: "Anmerkungen",
                hintText: "Anmerkungen",
                icon: Icon(Icons.notes),
              ),
              controller: _notesController,
              maxLines: 5,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.broken_image),
                const SizedBox(
                  width: 8,
                ),
                const Text("Defekt?"),
                const SizedBox(
                  width: 8,
                ),
                Switch(
                  value: defect,
                  onChanged: (value) {
                    setState(() {
                      defect = value;
                    });
                  },
                ),
              ],
            ),
          ]))),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Abbrechen"),
        ),
        ElevatedButton(
          onPressed: () {
            List<BorrowedItem> borrowedItems =
                appState.sharedPreferencesProvider.getBorrowedItems();
            // Find item in the list (using id)
            int index = borrowedItems
                .indexWhere((element) => element.id == widget.borrowedItem.id);
            borrowedItems[index].isBorrowed = false;
            borrowedItems[index].borrowDate = null;
            borrowedItems[index].returnDate = null;
            borrowedItems[index].borrower = "";
            borrowedItems[index].borrowing = "";
            borrowedItems[index].notes = _notesController.text;
            borrowedItems[index].isDefect = defect;
            appState.sharedPreferencesProvider.setBorrowedItems(borrowedItems);
            appState.changesMade();
            Navigator.of(context).pop();
          },
          child: const Text("Rückgabe"),
        ),
      ],
    );
  }
}
