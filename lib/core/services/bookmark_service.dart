import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPartner {
  final String id;
  final String name;
  final String category;
  final String url;
  final String? logoUrl;
  final String? phone;
  final String? email;
  final String? location;
  final double? rating;
  final String tier; // Elite, Premium, Standard
  final DateTime savedAt;

  SavedPartner({
    required this.id,
    required this.name,
    required this.category,
    required this.url,
    this.logoUrl,
    this.phone,
    this.email,
    this.location,
    this.rating,
    this.tier = 'Standard',
    DateTime? savedAt,
  }) : savedAt = savedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'url': url,
      'logoUrl': logoUrl,
      'phone': phone,
      'email': email,
      'location': location,
      'rating': rating,
      'tier': tier,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory SavedPartner.fromMap(Map<String, dynamic> map) {
    return SavedPartner(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      url: map['url'] ?? '',
      logoUrl: map['logoUrl'],
      phone: map['phone'],
      email: map['email'],
      location: map['location'],
      rating: (map['rating'] as num?)?.toDouble(),
      tier: map['tier'] ?? 'Standard',
      savedAt: map['savedAt'] != null
          ? DateTime.tryParse(map['savedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class BookmarkService extends ChangeNotifier {
  static final BookmarkService _instance = BookmarkService._internal();
  factory BookmarkService() => _instance;
  BookmarkService._internal();

  static const String _storageKey = 'pp_saved_partners';
  static const String _searchHistoryKey = 'pp_search_history';

  final List<SavedPartner> _bookmarks = [];
  List<SavedPartner> get bookmarks => List.unmodifiable(_bookmarks);

  final List<String> _recentSearches = [];
  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getStringList(_storageKey);
      if (savedData != null) {
        _bookmarks.clear();
        for (final item in savedData) {
          try {
            final map = jsonDecode(item) as Map<String, dynamic>;
            _bookmarks.add(SavedPartner.fromMap(map));
          } catch (e) {
            debugPrint('Error parsing saved partner: $e');
          }
        }
      }

      final searches = prefs.getStringList(_searchHistoryKey);
      if (searches != null) {
        _recentSearches.clear();
        _recentSearches.addAll(searches);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('BookmarkService init error: $e');
    }
  }

  bool isBookmarked(String idOrUrl) {
    return _bookmarks.any((b) => b.id == idOrUrl || b.url == idOrUrl);
  }

  Future<void> toggleBookmark(SavedPartner partner) async {
    final index = _bookmarks.indexWhere((b) => b.id == partner.id || b.url == partner.url);
    if (index >= 0) {
      _bookmarks.removeAt(index);
    } else {
      _bookmarks.insert(0, partner);
    }
    await _persist();
    notifyListeners();
  }

  Future<void> removeBookmark(String id) async {
    _bookmarks.removeWhere((b) => b.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> clearAllBookmarks() async {
    _bookmarks.clear();
    await _persist();
    notifyListeners();
  }

  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    _recentSearches.remove(trimmed);
    _recentSearches.insert(0, trimmed);
    if (_recentSearches.length > 10) {
      _recentSearches.removeLast();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_searchHistoryKey, _recentSearches);
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    _recentSearches.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
    notifyListeners();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataList = _bookmarks.map((b) => jsonEncode(b.toMap())).toList();
      await prefs.setStringList(_storageKey, dataList);
    } catch (e) {
      debugPrint('Error saving bookmarks: $e');
    }
  }
}
