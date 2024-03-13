import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medtborrowsys/detail_menu.dart';
import 'package:provider/provider.dart';
import 'package:medtborrowsys/helpers.dart';
import 'package:medtborrowsys/settings.dart';
import 'package:medtborrowsys/homepage.dart';
import 'package:medtborrowsys/infopage.dart';

// Shared Preferences Provider
import 'package:medtborrowsys/sharedprefsprovider.dart';

// Logger
import 'package:logger/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferencesProvider = SharedPreferencesProvider();
  await sharedPreferencesProvider.load();
  runApp(Medtborrowsys(sharedPreferencesProvider));
}

class Medtborrowsys extends StatelessWidget {
  // Root Widget
  final SharedPreferencesProvider _sharedPreferencesProvider;
  const Medtborrowsys(this._sharedPreferencesProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _sharedPreferencesProvider),
        ChangeNotifierProvider(
          create: (context) => MedtborrowsysState(_sharedPreferencesProvider),
        ),
      ],
      child: MainPage(sharedPreferencesProvider: _sharedPreferencesProvider),
    );
  }
}

class MedtborrowsysState extends ChangeNotifier {
  final SharedPreferencesProvider sharedPreferencesProvider;
  MedtborrowsysState(this.sharedPreferencesProvider);

  SharedPreferencesProvider? _sharedPreferencesProvider;
  Logger? log;
  int selectedIndex = 0;

  GlobalKey navigationRailKey = GlobalKey();
  Size? navigationRailSize;

  void changesMade() {
    notifyListeners();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.sharedPreferencesProvider});

  final SharedPreferencesProvider sharedPreferencesProvider;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //var selectedIndex = 0;
  bool confirmingdeletion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateNavigationRailWidth(context));
  }

  @override
  void reassemble() async {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MedtborrowsysState>();
    appState._sharedPreferencesProvider = widget.sharedPreferencesProvider;
    appState.log ??= Logger();

    if (appState.sharedPreferencesProvider.getSideBarAutoExpansion()) {
      double width = MediaQuery.of(context).size.width;
      if (width >= 600) {
        appState.sharedPreferencesProvider.setSideBarExpanded(true);
      } else {
        appState.sharedPreferencesProvider.setSideBarExpanded(false);
      }
    }

    Widget page; // Set Page

    switch (appState.selectedIndex) {
      // Sidebar Navigation
      case 0:
        page = HomePage(borrowedItems: appState.sharedPreferencesProvider.getBorrowedItems().where((element) => !element.isBorrowed).toList());
        break;
      case 1:
        page = const Infopage(); // Info
        break;
      default:
        try {
          //page = ClassRoomPage(
          //    classroom: appState.sharedPreferencesProvider
          //        .getClassRooms()[appState.selectedIndex - 2]);
          page = Scaffold(body: DetailMenu(borrowedItem: appState.sharedPreferencesProvider.getBorrowedItems().where((element) => element.isBorrowed).toList()[appState.selectedIndex - 2]));
        } catch (e) {
          throw Exception("Item not found");
        }
    }

    List<BorrowedItem> borrowedItems =
        appState.sharedPreferencesProvider.getBorrowedItems();
    List<NavigationRailDestination> borrowedItemsDest = [];

    for (var i = 0; i < borrowedItems.length; i++) {
      if (!borrowedItems[i].isBorrowed) {
        continue;
      }
      borrowedItemsDest.add(NavigationRailDestination(
        icon: (borrowedItems[i].returnDate?.isBefore(DateTime.now()) ?? false) || borrowedItems[i].isDefect ? Badge(
              label: const Text("!"),
              child: Icon(borrowedItems[i].icon)) : Icon(borrowedItems[i].icon),
        label: Row(
          children: [
            Text(borrowedItems[i].name),
          ],
        ),
      ));
    }

    return MaterialApp(
      title: 'MEDT Borrow Sys', // App Name
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: widget.sharedPreferencesProvider.getThemeColor()),
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: ColorScheme.fromSeed(
                        seedColor:
                            widget.sharedPreferencesProvider.getThemeColor(),
                        brightness: Brightness.light)
                    .surface,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: widget.sharedPreferencesProvider.getThemeColor(),
            brightness: Brightness.dark),
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: ColorScheme.fromSeed(
                        seedColor:
                            widget.sharedPreferencesProvider.getThemeColor(),
                        brightness: Brightness.dark)
                    .surface,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.light)),
      ),
      themeMode: widget.sharedPreferencesProvider.getTheme(), // Dark Theme
      home: LayoutBuilder(// Build Page
          builder: (context, constraints) {
        bool isexp = appState.sharedPreferencesProvider.getSideBarExpanded();
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        key: appState.navigationRailKey,
                        trailing: Expanded(
                            child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                              elevation: 0,
                              onPressed: () async {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const AlertDialog(
                                            title: Text("Settings"),
                                            content: SettingsMainPage()));
                              },
                              child: const Icon(Icons.settings),
                            ),
                          ),
                        )),
                        // Sidebar
                        extended: isexp,
                        labelType: isexp ? null : NavigationRailLabelType.all,
                        destinations: [
                          // Sidebar Items
                          const NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            selectedIcon: Icon(Icons.home),
                            label: Text("Home"),
                          ),
                          const NavigationRailDestination(
                            icon: Icon(Icons.info),
                            label: Text("Info"),
                          ),
                          ...borrowedItemsDest,
                        ],
                        selectedIndex: appState.selectedIndex,
                        onDestinationSelected: (value) {
                          setState(() {
                            appState.selectedIndex = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
