import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medtborrowsys/main.dart';
import 'package:medtborrowsys/sharedprefsprovider.dart';

class CreateMenu extends StatefulWidget {
  const CreateMenu({super.key});

  @override
  CreateMenuState createState() => CreateMenuState();
}

class CreateMenuState extends State<CreateMenu> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  IconData? icon;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MedtborrowsysState>();
    return AlertDialog(
      title: const Text("Neues Element erstellen"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Name:"),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte geben Sie einen Namen ein';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Beschreibung:"),
                TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte geben Sie eine Beschreibung ein';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Beschreibung",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Icon:"),
                // Dropdown to choose between all technology items (excluding outlined and rounded)
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
                  items: [Icons.camera, Icons.computer, Icons.phone, Icons.watch, Icons.tablet, Icons.speaker, Icons.headset, Icons.keyboard, Icons.mouse, Icons.print, Icons.scanner, Icons.tv, Icons.router, Icons.storage, Icons.usb, Icons.sd_card, Icons.sim_card, Icons.battery_full, Icons.power, Icons.smart_toy, Icons.cable, Icons.devices_other]
                      .map<DropdownMenuItem<IconData>>((IconData value) {
                    return DropdownMenuItem<IconData>(
                      value: value,
                      child: Icon(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
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
            if (_formKey.currentState!.validate()) {
              List<BorrowedItem> items = appState.sharedPreferencesProvider.getBorrowedItems();
              items.add(BorrowedItem(
                name: nameController.text,
                description: descriptionController.text,
                icon: icon ?? Icons.devices_other,
              ));
              appState.sharedPreferencesProvider.setBorrowedItems(items);
              appState.changesMade();
              Navigator.of(context).pop();
            }
          },
          child: const Text("Erstellen"),
        ),
      ],
    );
  }
}
