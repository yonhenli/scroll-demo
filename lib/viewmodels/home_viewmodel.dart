import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class HomeViewModel extends ChangeNotifier {
  static const int ItemRequestThreshold = 10;

  List<String> _items;
  List<String> get items => _items;

  // for pagination
  int _currentPage = 0;
  bool isLoading = false;

  Logger logger = Logger();

  HomeViewModel() {
    refresh();
  }

  Future<void> refresh() async {
    logger.w("calling refresh()");
    _items = List<String>.generate(ItemRequestThreshold, (index) => 'Title $index');
    _currentPage = 0;
    notifyListeners();
  }

  Future<void> loadMore(int index) async {
    var itemPosition = index + 1;
    var requestMoreData =
        itemPosition % ItemRequestThreshold == 0 && itemPosition != 0;
    var pageToRequest = itemPosition ~/ ItemRequestThreshold;

    if (requestMoreData && pageToRequest > _currentPage) {
      print('calling refresh() | pageToRequest: $pageToRequest');
      _currentPage = pageToRequest;
      isLoading = true;

      await Future.delayed(Duration(seconds: 2));
      var newFetchedItems = List<String>.generate(
          ItemRequestThreshold, (index) => 'Title page:$_currentPage item: $index');

      _items.addAll(newFetchedItems);

      isLoading = false;
      notifyListeners();
    }
  }
}
