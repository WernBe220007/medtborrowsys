import 'package:flutter/material.dart';
import 'package:medtborrowsys/sharedprefsprovider.dart';
import 'package:provider/provider.dart';
import 'package:medtborrowsys/main.dart';
import 'package:medtborrowsys/detail_menu.dart';

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
    var borrowedItemsNotBorrowed =
        widget.borrowedItems.where((item) => !item.isBorrowed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDT borrow SYS'),
        actions: [
          widget.borrowedItems.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: ItemSearch(widget.borrowedItems),
                    );
                  },
                )
              : const SizedBox(),
        ],
      ),
      body: widget.borrowedItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("MEDT borrow SYS", style: TextStyle(fontSize: 40)),
                  Text("by Benedikt Werner aka GameTec_live"),
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
                        borrowedItem.isDefect || borrowedItem.notes.isNotEmpty
                            ? Badge(
                                label: const Text("!"),
                                child: Icon(borrowedItem.icon))
                            : Icon(borrowedItem.icon),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(borrowedItem.name,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(borrowedItem.description,
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            borrowedItem.isDefect
                                ? const Icon(Icons.broken_image)
                                : const SizedBox(),
                            borrowedItem.isDefect
                                ? const Expanded(
                                    child: Text(
                                    "Defekt",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ))
                                : const SizedBox()
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.info),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                borrowedItem.id,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w200),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DetailMenu(borrowedItem: borrowedItem);
                        },
                      );
                      appState.changesMade();
                    },
                  ),
                );
              },
            ),
    );
  }
}

class ItemSearch extends SearchDelegate<BorrowedItem?> {
  final List<BorrowedItem> borrowedItems;

  ItemSearch(this.borrowedItems);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = borrowedItems.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          title: Row(
            children: [
              Icon(item.icon),
              const SizedBox(
                width: 8,
              ),
              Text(item.name),
            ],
          ),
          subtitle: Text(item.description,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w200)),
          onTap: () async {
            close(context, item);
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return DetailMenu(borrowedItem: item);
              },
            );
          },
        );
      },
    );
  }
}
