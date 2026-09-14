import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../core/services/bookmark_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import 'account_screen.dart';
import 'categories_screen.dart';
import 'saved_partners_screen.dart';
import 'webview_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;
  final GlobalKey<WebViewScreenState> _homeWebViewKey = GlobalKey<WebViewScreenState>();
  final GlobalKey<WebViewScreenState> _partnersWebViewKey = GlobalKey<WebViewScreenState>();
  
  final BookmarkService _bookmarkService = BookmarkService();

  @override
  void initState() {
    super.initState();
    _bookmarkService.addListener(_onBookmarksUpdated);
  }

  void _onBookmarksUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bookmarkService.removeListener(_onBookmarksUpdated);
    super.dispose();
  }

  void _navigateToTab(int index, [String? targetUrl]) {
    setState(() {
      _currentIndex = index;
    });

    if (targetUrl != null) {
      if (index == 0) {
        _homeWebViewKey.currentState?.loadUrl(targetUrl);
      } else if (index == 2) {
        _partnersWebViewKey.currentState?.loadUrl(targetUrl);
      }
    }
  }

  void _openUrlInMarketplace(String url) {
    setState(() {
      _currentIndex = 0;
    });
    _homeWebViewKey.currentState?.loadUrl(url);
  }

  void _showSearchBottomSheet() {
    final searchCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final recentSearches = _bookmarkService.recentSearches;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Pearl Marketplace',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: searchCtrl,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    _bookmarkService.addRecentSearch(query.trim());
                    Navigator.pop(context);
                    final encoded = Uri.encodeComponent(query.trim());
                    _openUrlInMarketplace('https://marketplace.pearlorganisation.in/products?search=$encoded');
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search partners, services, IT, legal...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.accentBlue),
                  filled: true,
                  fillColor: AppTheme.surfaceSecondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (recentSearches.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _bookmarkService.clearRecentSearches(),
                      child: Text('Clear', style: GoogleFonts.inter(fontSize: 11.5, color: AppTheme.error)),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recentSearches.map((term) {
                    return ActionChip(
                      label: Text(term, style: GoogleFonts.inter(fontSize: 12)),
                      avatar: const Icon(Icons.history_rounded, size: 14),
                      onPressed: () {
                        Navigator.pop(context);
                        final encoded = Uri.encodeComponent(term);
                        _openUrlInMarketplace('https://marketplace.pearlorganisation.in/products?search=$encoded');
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String get _appBarTitle {
    switch (_currentIndex) {
      case 0:
        return 'Pearl Marketplace';
      case 1:
        return 'Explore Categories';
      case 2:
        return 'Verified Partners';
      case 3:
        return 'Saved Partners';
      case 4:
        return 'Account & Support';
      default:
        return 'Pearl Marketplace';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarksCount = _bookmarkService.bookmarks.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return;
        }

        final canGoBack = await _homeWebViewKey.currentState?.canGoBack() ?? false;
        if (canGoBack) {
          await _homeWebViewKey.currentState?.goBack();
          return;
        }

        if (context.mounted) {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Exit App?', style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w700)),
              content: const Text('Are you sure you want to exit Pearl Marketplace?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryNavy),
                  child: const Text('Exit'),
                ),
              ],
            ),
          );

          if (shouldExit == true && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _appBarTitle,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded, size: 22),
              tooltip: 'Search Marketplace',
              onPressed: _showSearchBottomSheet,
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined, size: 20),
              tooltip: 'Share App',
              onPressed: () {
                Share.share(
                  'Explore verified service providers and partners on Pearl Marketplace: https://marketplace.pearlorganisation.in',
                  subject: 'Pearl Marketplace App',
                );
              },
            ),
          ],
        ),
        drawer: AppDrawer(
          onNavigate: (tabIndex, targetUrl) => _navigateToTab(tabIndex, targetUrl),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // Tab 0: Home WebView
            WebViewScreen(
              key: _homeWebViewKey,
              initialUrl: 'https://marketplace.pearlorganisation.in/',
              onOpenSaved: () => setState(() => _currentIndex = 3),
            ),
            // Tab 1: Categories Explorer
            CategoriesScreen(
              onSelectCategory: _openUrlInMarketplace,
            ),
            // Tab 2: Verified Partners Directory WebView
            WebViewScreen(
              key: _partnersWebViewKey,
              initialUrl: 'https://marketplace.pearlorganisation.in/products',
              onOpenSaved: () => setState(() => _currentIndex = 3),
            ),
            // Tab 3: Saved Bookmarks
            SavedPartnersScreen(
              onOpenPartner: _openUrlInMarketplace,
            ),
            // Tab 4: Account & Support
            AccountScreen(
              onOpenUrl: _openUrlInMarketplace,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              activeIcon: Icon(Icons.grid_view_sharp),
              label: 'Categories',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.verified_outlined),
              activeIcon: Icon(Icons.verified_rounded),
              label: 'Partners',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: bookmarksCount > 0,
                label: Text('$bookmarksCount'),
                child: const Icon(Icons.bookmark_outline_rounded),
              ),
              activeIcon: Badge(
                isLabelVisible: bookmarksCount > 0,
                label: Text('$bookmarksCount'),
                child: const Icon(Icons.bookmark_rounded),
              ),
              label: 'Saved',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
