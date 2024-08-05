import 'package:flutter/material.dart';

import 'grocery_item.dart';

class GroceryManager extends ChangeNotifier {
  final _groceryItems = <GroceryItem>[];
  List<GroceryItem> get groceryItems => List.unmodifiable(_groceryItems);

  int _selectedIndex = -1;
  bool _createNewItem = false;

  int get selectedIndex => _selectedIndex;
  bool get isCreatingNewItem => _createNewItem;

  GroceryItem? get selectedGroceryItem =>
      _selectedIndex != -1 ? _groceryItems[_selectedIndex] : null;

  void groceryItemTapped(int index) {
    _selectedIndex = index;
    _createNewItem = false;
    notifyListeners();
  }

  void setSelectedGroceryItem(String id) {
    final index = groceryItems.indexWhere((element) => element.id == id);
    _selectedIndex = index;
    _createNewItem = false;
    notifyListeners();
  }

  void deleteItem(int index) {
    _groceryItems.removeAt(index);
    notifyListeners();
  }

  String getItemId(int index) {
    final groceryItem = _groceryItems[index];
    return groceryItem.id;
  }

  GroceryItem? getGroceryItem(String id) {
    final index = _groceryItems.indexWhere((element) => element.id == id);
    if (index == -1) return null;
    return groceryItems[index];
  }

  void createNewItem() {
    _createNewItem = true;
    notifyListeners();
  }

  void addItem(GroceryItem item) {
    _groceryItems.add(item);
    notifyListeners();
  }

  void updateItem(GroceryItem item) {
    final index = _groceryItems.indexWhere((element) => element.id == item.id);
    _groceryItems[index] = item;
    notifyListeners();
  }

  void completeItem(int index, bool change) {
    final item = _groceryItems[index];
    _groceryItems[index] = item.copyWith(isComplete: change);
    notifyListeners();
  }
}
