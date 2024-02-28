import 'dart:convert';
import 'package:medtborrowsys/colors.dart' as colors;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BorrowedItem {
  String id;
  String name;
  String description;
  String borrower;
  String borrowing;
  DateTime? returnDate;
  DateTime? borrowDate;
  IconData icon;
  bool isBorrowed;
  bool isDefect;
  String notes;

  BorrowedItem({String? id, this.name = "", this.description = "", this.borrower = "", this.borrowing = "", this.returnDate, this.borrowDate, this.icon = Icons.help_outline, this.isBorrowed = false, this.isDefect = false, this.notes = ""})
      : id = id ?? const Uuid().v4();

  String toJson() {
    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'description': description,
      'borrower': borrower,
      'borrowing': borrowing,
      'returnDate': returnDate?.toIso8601String(),
      'borrowDate': borrowDate?.toIso8601String(),
      'icon': icon.codePoint,
      'isBorrowed': isBorrowed,
      'isDefect': isDefect,
      'notes': notes,
    };

    return jsonEncode(data);
  }

  factory BorrowedItem.fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return BorrowedItem(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      borrower: data['borrower'],
      borrowing: data['borrowing'],
      returnDate: data['returnDate'] != null ? DateTime.parse(data['returnDate']) : null,
      borrowDate: data['borrowDate'] != null ? DateTime.parse(data['borrowDate']) : null,
      icon: IconData(data['icon'], fontFamily: 'MaterialIcons'),
      isBorrowed: data['isBorrowed'],
      isDefect: data['isDefect'],
      notes: data['notes'],
    );
  }
}

class SharedPreferencesProvider extends ChangeNotifier {
  SharedPreferencesProvider._privateConstructor();

  static final SharedPreferencesProvider _instance =
      SharedPreferencesProvider._privateConstructor();

  factory SharedPreferencesProvider() {
    return _instance;
  }

  late SharedPreferences _sharedPreferences;

  Future<void> load() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  ThemeMode getTheme() {
    final themeValue = _sharedPreferences.getInt('app_theme') ?? 0;
    return ThemeMode.values[themeValue];
  }

  void setTheme(ThemeMode theme) {
    _sharedPreferences.setInt('app_theme', theme.index);
  }

  bool getSideBarAutoExpansion() {
    return _sharedPreferences.getBool('sidebar_auto_expanded') ?? true;
  }

  bool getSideBarExpanded() {
    return _sharedPreferences.getBool('sidebar_expanded') ?? false;
  }

  int getSideBarExpandedIndex() {
    return _sharedPreferences.getInt('sidebar_expanded_index') ?? 1;
  }

  void setSideBarAutoExpansion(bool autoExpanded) {
    _sharedPreferences.setBool('sidebar_auto_expanded', autoExpanded);
  }

  void setSideBarExpanded(bool expanded) {
    _sharedPreferences.setBool('sidebar_expanded', expanded);
  }

  void setSideBarExpandedIndex(int index) {
    _sharedPreferences.setInt('sidebar_expanded_index', index);
  }

  int getThemeColorIndex() {
    return _sharedPreferences.getInt('app_theme_color') ?? 0;
  }

  MaterialColor getThemeColor() {
    return colors.getThemeColor(getThemeColorIndex());
  }

  Color getThemeComplementaryColor() {
    final themeMode = _sharedPreferences.getInt('app_theme') ?? 2;
    return colors.getThemeComplementary(themeMode, getThemeColorIndex());
  }

  void setThemeColor(int color) {
    _sharedPreferences.setInt('app_theme_color', color);
  }

  List<BorrowedItem> getBorrowedItems() {
    List<BorrowedItem> output = [];
    final data = _sharedPreferences.getStringList('borroweditems') ?? [];
    for (var classroom in data) {
      output.add(BorrowedItem.fromJson(classroom));
    }
    return output;
  }

  void setBorrowedItems(List<BorrowedItem> borrowedItems) {
    List<String> output = [];
    for (var borrowedItem in borrowedItems) {
      if (borrowedItem.id != "") {
        output.add(borrowedItem.toJson());
      }
    }
    _sharedPreferences.setStringList('borroweditems', output);
  }

  bool getConfirmDelete() {
    return _sharedPreferences.getBool('confirm_delete') ?? true;
  }

  void setConfirmDelete(bool value) {
    _sharedPreferences.setBool('confirm_delete', value);
  }
}
