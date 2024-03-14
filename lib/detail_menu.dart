import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medtborrowsys/main.dart';
import 'package:medtborrowsys/sharedprefsprovider.dart';
import 'package:medtborrowsys/borrowmenu.dart';
import 'package:medtborrowsys/returnmenu.dart';
import 'package:medtborrowsys/editmenu.dart';
import 'package:intl/intl.dart';

class DetailMenu extends StatefulWidget {
  final BorrowedItem borrowedItem;
  const DetailMenu({super.key, required this.borrowedItem});

  @override
  DetailMenuState createState() => DetailMenuState();
}

class DetailMenuState extends State<DetailMenu> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MedtborrowsysState>();
    return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Details über ${widget.borrowedItem.name}"),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return EditMenu(borrowedItem: widget.borrowedItem);
                    });
              },
            ),
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
                      child: Text(widget.borrowedItem.description,
                          maxLines: 5, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.info),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(widget.borrowedItem.id,
                          maxLines: 5, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.note),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                          widget.borrowedItem.notes.isEmpty
                              ? "Keine Notizen"
                              : widget.borrowedItem.notes,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    IconButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Notizen löschen"),
                                  content: const Text(
                                      "Möchten Sie die Notizen wirklich löschen?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Abbrechen")),
                                    TextButton(
                                        onPressed: () {
                                          List<BorrowedItem> items =
                                              appState.sharedPreferencesProvider
                                                  .getBorrowedItems();
                                          int index = items.indexWhere(
                                              (element) =>
                                                  element.id == widget.borrowedItem.id);
                                          items[index].notes = "";
                                          appState.sharedPreferencesProvider
                                              .setBorrowedItems(items);
                                          setState(() {
                                            widget.borrowedItem.notes = "";
                                          });
                                          appState.changesMade();
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Löschen"))
                                  ],
                                );
                              });
                        }, icon: const Icon(Icons.check))
                  ],
                ),
                const SizedBox(height: 8),
                if (widget.borrowedItem.isBorrowed)
                  Row(
                    children: [
                      const Icon(Icons.person_outline),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                            "${appState.sharedPreferencesProvider.getTeachers().firstWhere((element) => element.id == widget.borrowedItem.borrower, orElse: () => Teacher(name: "Nicht gefunden")).name} (${appState.sharedPreferencesProvider.getTeachers().firstWhere((element) => element.id == widget.borrowedItem.borrower, orElse: () => Teacher(name: "Nicht gefunden")).short})",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                if (widget.borrowedItem.isBorrowed)
                  const SizedBox(
                    height: 8,
                  ),
                if (widget.borrowedItem.isBorrowed)
                  Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                            "${appState.sharedPreferencesProvider.getStudents().firstWhere((element) => element.id == widget.borrowedItem.borrowing, orElse: () => Student(name: "Nicht gefunden", classroom: "Nicht gefunden")).name} (${appState.sharedPreferencesProvider.getStudents().firstWhere((element) => element.id == widget.borrowedItem.borrowing, orElse: () => Student(name: "Nicht gefunden", classroom: "")).classroom})",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                if (widget.borrowedItem.isBorrowed)
                  const SizedBox(
                    height: 8,
                  ),
                if (widget.borrowedItem.isBorrowed)
                  Row(
                    children: [
                      const Icon(Icons.timer),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                            DateFormat('dd.MM.yyyy')
                                .format(widget.borrowedItem.borrowDate ?? DateTime.now()),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                if (widget.borrowedItem.isBorrowed)
                  const SizedBox(
                    height: 8,
                  ),
                if (widget.borrowedItem.isBorrowed)
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                            "${DateFormat('dd.MM.yyyy').format(widget.borrowedItem.returnDate ?? DateTime.now())} (in ${(widget.borrowedItem.returnDate ?? DateTime.now()).difference(DateTime.now()).inDays} Tagen)",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                if (widget.borrowedItem.isBorrowed)
                  const SizedBox(
                    height: 8,
                  ),
                if (widget.borrowedItem.isDefect)
                  const Row(
                    children: [
                      Icon(Icons.broken_image),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text("Defekt",
                            maxLines: 5, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                if (widget.borrowedItem.isBorrowed)
                  const SizedBox(
                    height: 8,
                  ),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.borrowedItem.isBorrowed) {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return ReturnMenu(
                              borrowedItem: widget.borrowedItem,
                            );
                          });
                      appState.selectedIndex = 0;
                    } else {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return BorrowMenu(
                              borrowedItem: widget.borrowedItem,
                            );
                          });
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: widget.borrowedItem.isBorrowed
                      ? const Text("Zurückgeben")
                      : const Text("Ausleihen"),
                )
              ],
            ),
          ),
        ));
  }
}
