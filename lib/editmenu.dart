import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medtborrowsys/main.dart';
import 'package:medtborrowsys/sharedprefsprovider.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class EditMenu extends StatefulWidget {
  final BorrowedItem borrowedItem;
  const EditMenu({super.key, required this.borrowedItem});

  @override
  EditMenuState createState() => EditMenuState();
}

class EditMenuState extends State<EditMenu> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  IconData? icon;
  DateTime? returnDate;
  DateTime? borrowDate;
  Teacher? selectedTeacher;
  Student? selectedStudent;
  bool defect = false;
  bool borrowed = false;

  final TextEditingController _tnameController = TextEditingController();
  final TextEditingController _temailController = TextEditingController();
  final TextEditingController _tshortController = TextEditingController();
  final TextEditingController _snameController = TextEditingController();
  final TextEditingController _semailController = TextEditingController();
  final TextEditingController _sclassController = TextEditingController();
  bool confirmingdeletion = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.borrowedItem.name;
    _descriptionController.text = widget.borrowedItem.description;
    _notesController.text = widget.borrowedItem.notes;
    icon = widget.borrowedItem.icon;
    defect = widget.borrowedItem.isDefect;
    borrowed = widget.borrowedItem.isBorrowed;
    returnDate = widget.borrowedItem.returnDate;
    borrowDate = widget.borrowedItem.borrowDate;
    selectedTeacher = context
        .read<MedtborrowsysState>()
        .sharedPreferencesProvider
        .getTeachers()
        .firstWhereOrNull(
            (element) => element.id == widget.borrowedItem.borrower);

    selectedStudent = context
        .read<MedtborrowsysState>()
        .sharedPreferencesProvider
        .getStudents()
        .firstWhereOrNull(
            (element) => element.id == widget.borrowedItem.borrowing);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MedtborrowsysState>();
    return AlertDialog(
      title: Text("${widget.borrowedItem.name} bearbeiten"),
      content: SingleChildScrollView(
          child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte geben Sie einen Namen ein';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte geben Sie eine Beschreibung ein';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Icon:"),
                const SizedBox(
                  width: 10,
                ),
                DropdownButton<IconData>(
                  value: icon,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (IconData? newValue) {
                    setState(() {
                      icon = newValue;
                    });
                  },
                  items: [
                    Icons.camera,
                    Icons.computer,
                    Icons.phone,
                    Icons.watch,
                    Icons.tablet,
                    Icons.speaker,
                    Icons.headset,
                    Icons.keyboard,
                    Icons.mouse,
                    Icons.print,
                    Icons.scanner,
                    Icons.tv,
                    Icons.router,
                    Icons.storage,
                    Icons.usb,
                    Icons.sd_card,
                    Icons.sim_card,
                    Icons.battery_full,
                    Icons.power,
                    Icons.smart_toy,
                    Icons.cable,
                    Icons.devices_other
                  ].map<DropdownMenuItem<IconData>>((IconData value) {
                    return DropdownMenuItem<IconData>(
                      value: value,
                      child: Icon(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Defekt:"),
                const SizedBox(
                  width: 10,
                ),
                Switch(
                    value: defect,
                    onChanged: (value) => setState(() => defect = value)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ausgeliehen:"),
                const SizedBox(
                  width: 10,
                ),
                Switch(
                    value: borrowed,
                    onChanged: (value) => setState(() => borrowed = value)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.notes),
                      labelText: 'Notizen',
                    ),
                    maxLines: 5,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      _notesController.text = "";
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
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
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DropdownMenu(
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
                                              const Duration(milliseconds: 500),
                                              () {
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
                        [
                          const DropdownMenuEntry<dynamic>(
                              value: "+", label: "+")
                        ],
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
                                    decoration: const InputDecoration(
                                        labelText: "Name"),
                                    controller: _tnameController,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                        labelText: "Kürzel"),
                                    controller: _tshortController,
                                    onChanged: (value) => _temailController
                                            .text =
                                        "${value.toLowerCase()}@litec.ac.at",
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                        labelText: "E-Mail"),
                                    controller: _temailController,
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
                                        short: _tshortController.text,
                                        email: _temailController.text));
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
                ),
                IconButton(
                    onPressed: () async {
                      setState(() {
                        selectedTeacher = null;
                      });
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
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
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DropdownMenu(
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
                                              const Duration(milliseconds: 500),
                                              () {
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
                                      int index = students.indexWhere(
                                          (element) => element.id == e.id);
                                      students.removeAt(index);
                                      appState.sharedPreferencesProvider
                                          .setStudents(students);
                                      appState.changesMade();
                                    },
                                    icon: confirmingdeletion
                                        ? const Icon(Icons.delete_forever)
                                        : const Icon(Icons.delete))))
                            .toList() +
                        [
                          const DropdownMenuEntry<dynamic>(
                              value: "+", label: "+")
                        ],
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
                                    decoration: const InputDecoration(
                                        labelText: "Name"),
                                    controller: _snameController,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                        labelText: "Klasse"),
                                    controller: _sclassController,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                        labelText: "E-Mail"),
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
                ),
                IconButton(
                    onPressed: () async {
                      setState(() {
                        selectedStudent = null;
                      });
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? pickborrowDate = await showDatePicker(
                        context: context,
                        initialDate: borrowDate ?? DateTime.now(),
                        firstDate: borrowDate
                                ?.subtract(const Duration(days: 365)) ??
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate:
                            DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (pickborrowDate != null) {
                        setState(() {
                          borrowDate = pickborrowDate;
                        });
                      }
                    },
                    child: borrowDate != null
                        ? Text(DateFormat('dd.MM.yyyy').format(borrowDate!))
                        : const Text("Ausborgdatum wählen"),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      setState(() {
                        borrowDate = null;
                      });
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? pickreturnDate = await showDatePicker(
                        context: context,
                        initialDate: returnDate ?? DateTime.now(),
                        firstDate: returnDate
                                ?.subtract(const Duration(days: 365)) ??
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate:
                            DateTime.now().add(const Duration(days: 3650)),
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
                ),
                IconButton(
                    onPressed: () async {
                      setState(() {
                        returnDate = null;
                      });
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
          ],
        )),
      )),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Abbrechen"),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              List<BorrowedItem> items =
                  appState.sharedPreferencesProvider.getBorrowedItems();
              int index = items.indexWhere(
                  (element) => element.id == widget.borrowedItem.id);
              items[index] = BorrowedItem(
                name: _nameController.text,
                description: _descriptionController.text,
                icon: icon ?? Icons.help_outline,
                isDefect: defect,
                isBorrowed: borrowed,
                returnDate: returnDate,
                borrowDate: borrowDate,
                borrower: selectedTeacher?.id ?? items[index].borrower,
                borrowing: selectedStudent?.id ?? items[index].borrowing,
                notes: _notesController.text,
              );
              appState.sharedPreferencesProvider.setBorrowedItems(items);
              appState.changesMade();
              Navigator.of(context).pop();
            }
          },
          child: const Text("Speichern"),
        ),
      ],
    );
  }
}
