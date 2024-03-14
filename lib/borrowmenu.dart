import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medtborrowsys/main.dart';
import 'package:medtborrowsys/sharedprefsprovider.dart';
import 'package:intl/intl.dart';

class BorrowMenu extends StatefulWidget {
  final BorrowedItem borrowedItem;
  const BorrowMenu({super.key, required this.borrowedItem});

  @override
  BorrowMenuState createState() => BorrowMenuState();
}

class BorrowMenuState extends State<BorrowMenu> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _shortController = TextEditingController();
  final TextEditingController _snameController = TextEditingController();
  final TextEditingController _semailController = TextEditingController();
  final TextEditingController _sclassController = TextEditingController();
  DateTime? returnDate;
  Teacher? selectedTeacher;
  Student? selectedStudent;
  bool confirmingdeletion = false;

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
            DropdownMenu(
              width: 200,
              label: const Text("Geliehen von"),
              dropdownMenuEntries: appState.sharedPreferencesProvider
                      .getTeachers()
                      .map((e) => DropdownMenuEntry<dynamic>(
                          value: e,
                          label: e.short,
                          trailingIcon: IconButton(
                              onPressed: () async {
                                if (appState.sharedPreferencesProvider
                                        .getConfirmDelete() ==
                                    true) {
                                  if (confirmingdeletion == false) {
                                    setState(() {
                                      confirmingdeletion = true;
                                    });

                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      if (mounted) {
                                        setState(() {
                                          confirmingdeletion = false;
                                        });
                                      }
                                    });
                                    return;
                                  }
                                }

                                List<Teacher> teachers = appState
                                    .sharedPreferencesProvider
                                    .getTeachers();
                                // get index by id
                                int index = teachers.indexWhere(
                                    (element) => element.id == e.id);
                                teachers.removeAt(index);
                                appState.sharedPreferencesProvider
                                    .setTeachers(teachers);
                                appState.changesMade();
                              },
                              icon: confirmingdeletion
                                  ? const Icon(Icons.delete_forever)
                                  : const Icon(Icons.delete))))
                      .toList() +
                  [const DropdownMenuEntry<dynamic>(value: "+", label: "+")],
              onSelected: (value) async {
                if (value == "+") {
                  // Open create menu
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Neue Lehrkraft"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                                "Bitte geben Sie die Daten der Lehrkraft ein"),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: "Name"),
                              controller: _nameController,
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: "Kürzel"),
                              controller: _shortController,
                              onChanged: (value) => _emailController.text =
                                  "${value.toLowerCase()}@litec.ac.at",
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: "E-Mail"),
                              controller: _emailController,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Abbrechen"),
                          ),
                          TextButton(
                            onPressed: () {
                              List<Teacher> teachers = appState
                                  .sharedPreferencesProvider
                                  .getTeachers();
                              teachers.add(Teacher(
                                  name: _nameController.text,
                                  short: _shortController.text,
                                  email: _emailController.text));
                              appState.sharedPreferencesProvider
                                  .setTeachers(teachers);
                              appState.changesMade();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Speichern"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  selectedTeacher = value;
                }
              },
            ),
            const SizedBox(height: 8),
            DropdownMenu(
              width: 200,
              label: const Text("Geliehen zu"),
              dropdownMenuEntries: appState.sharedPreferencesProvider
                      .getStudents()
                      .map((e) => DropdownMenuEntry<dynamic>(
                          value: e,
                          label: e.name,
                          trailingIcon: IconButton(
                              onPressed: () async {
                                if (appState.sharedPreferencesProvider
                                        .getConfirmDelete() ==
                                    true) {
                                  if (confirmingdeletion == false) {
                                    setState(() {
                                      confirmingdeletion = true;
                                    });

                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      if (mounted) {
                                        setState(() {
                                          confirmingdeletion = false;
                                        });
                                      }
                                    });
                                    return;
                                  }
                                }

                                List<Student> students = appState
                                    .sharedPreferencesProvider
                                    .getStudents();
                                // get index by id
                                int index = students
                                    .indexWhere((element) => element.id == e.id);
                                students.removeAt(index);
                                appState.sharedPreferencesProvider
                                    .setStudents(students);
                                appState.changesMade();
                              },
                              icon: confirmingdeletion
                                  ? const Icon(Icons.delete_forever)
                                  : const Icon(Icons.delete))))
                      .toList() +
                  [const DropdownMenuEntry<dynamic>(value: "+", label: "+")],
              onSelected: (value) async {
                if (value == "+") {
                  // Open create menu
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Neue Person"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                                "Bitte geben Sie die Daten der Person ein"),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: "Name"),
                              controller: _snameController,
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: "Klasse"),
                              controller: _sclassController,
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: "E-Mail"),
                              controller: _semailController,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Abbrechen"),
                          ),
                          TextButton(
                            onPressed: () {
                              List<Student> students = appState
                                  .sharedPreferencesProvider
                                  .getStudents();
                              students.add(Student(
                                  name: _snameController.text,
                                  email: _semailController.text,
                                  classroom: _sclassController.text));
                              appState.sharedPreferencesProvider
                                  .setStudents(students);
                              appState.changesMade();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Speichern"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  selectedStudent = value;
                }
              },
            ),
            const SizedBox(height: 8),
            // Return date
            ElevatedButton(
              onPressed: () async {
                DateTime? pickreturnDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (pickreturnDate != null) {
                  setState(() {
                    returnDate = pickreturnDate;
                  });
                }
              },
              child: returnDate != null
                  ? Text(DateFormat('dd.MM.yyyy').format(returnDate!))
                  : const Text("Rückgabedatum wählen"),
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
            // Check if all fields are filled
            if (selectedTeacher == null ||
                selectedStudent == null ||
                returnDate == null) {
              return;
            }
            List<BorrowedItem> borrowedItems =
                appState.sharedPreferencesProvider.getBorrowedItems();
            // Find item in the list (using id)
            int index = borrowedItems
                .indexWhere((element) => element.id == widget.borrowedItem.id);
            borrowedItems[index].isBorrowed = true;
            borrowedItems[index].borrowDate = DateTime.now();
            borrowedItems[index].returnDate = returnDate;
            borrowedItems[index].borrower = selectedTeacher!.id;
            borrowedItems[index].borrowing = selectedStudent!.id;
            appState.sharedPreferencesProvider.setBorrowedItems(borrowedItems);
            appState.changesMade();
            Navigator.of(context).pop();
          },
          child: const Text("Ausleihen"),
        ),
      ],
    );
  }
}
