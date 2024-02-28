import 'package:flutter/material.dart';
import 'package:medtborrowsys/sharedprefsprovider.dart';
import 'package:provider/provider.dart';
import 'package:medtborrowsys/main.dart';

class HomePage extends StatefulWidget {
  final List<BorrowedItem> borrowedItems;
  const HomePage({super.key, required this.borrowedItems});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MedtborrowsysState>();
    var borrowedItemsNotBorrowed = widget.borrowedItems.where((item) => !item.isBorrowed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDT borrow SYS'),
      ),
      body: widget.borrowedItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("MEDT borrow SYS", style: TextStyle(fontSize: 40)),
                  Text("by Benedikt Werner aka GameTec_live"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Erstellen sie ein Element um zu starten",
                      style: TextStyle(fontSize: 30))
                ],
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200, // max width of each card
                childAspectRatio: 3 / 2, // ratio of width to height
                crossAxisSpacing: 8, // horizontal spacing
                mainAxisSpacing: 8, // vertical spacing
              ),
              itemCount: borrowedItemsNotBorrowed.length,
              itemBuilder: (context, index) {
                final borrowedItem = borrowedItemsNotBorrowed[index];
                return Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        borrowedItem.returnDate?.isBefore(DateTime.now()) ?? false
                            ? Badge(
                                label: const Text("!"),
                                child: Icon(borrowedItem.icon))
                            : Icon(borrowedItem.icon),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(borrowedItem.name, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description),
                            Text(borrowedItem.description, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.person),
                            Text(borrowedItem.borrower, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.person_outline),
                            Text(borrowedItem.borrowing, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      appState.changesMade();
                    },
                  ),
                );
              },
            ),
    );
  }
}