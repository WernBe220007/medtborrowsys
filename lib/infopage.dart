import 'package:flutter/material.dart';

class Infopage extends StatelessWidget {
  const Infopage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDT borrow SYS'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("MEDT borrow SYS", style: TextStyle(fontSize: 40)),
            Text("by Benedikt Werner aka GameTec_live"),
            SizedBox(height: 20),
            Text("Ein simples system um übersicht zu behalten, wer was ausgeliehen hat."),
            SizedBox(height: 10),
            Text("Um ein Element auszuleihen, einfach auf der Homepage das Element auswählen und auf 'ausleihen' klicken. Die nötigen Informationen eintragen und nach einem erneuten Klick auf 'ausleihen' ist das Element als ausgeliehen markiert und nur noch in der Seitenleiste zu sehen."),
            SizedBox(height: 5),
            Text("Um ein Element zurückzugeben, dieses in der Seitenleiste auswählen und auf 'zurückgeben' klicken. Es gibt die option eine Notiz zu schreiben und das Element als Defekt zu makieren (sollte dies der fall sein). Das Element ist dann wieder in der Hauptansicht zu sehen."),
            SizedBox(height: 5),
            Text("Ein rotes ! zeigt an, dass das Element als Defekt markiert ist, eine Notiz hinterlegt ist oder die Person überzogen hat."),
          ],
        ),
      ),
    );
  }
}