import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medtborrowsys/main.dart';
import 'package:medtborrowsys/sharedprefsprovider.dart';

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
        title: Text("Details über ${widget.borrowedItem.name}"),
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
                      child: Text(widget.borrowedItem.name,
                          maxLines: 5, overflow: TextOverflow.ellipsis,),
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
                      child: Text(widget.borrowedItem.notes.isEmpty ? "Keine Notizen" : widget.borrowedItem.notes,
                          maxLines: 5, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
