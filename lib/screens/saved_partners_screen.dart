import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../core/services/bookmark_service.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/url_handler.dart';

class SavedPartnersScreen extends StatefulWidget {
  final Function(String url) onOpenPartner;

  const SavedPartnersScreen({
    super.key,
    required this.onOpenPartner,
  });

  @override
  State<SavedPartnersScreen> createState() => _SavedPartnersScreenState();
}

class _SavedPartnersScreenState extends State<SavedPartnersScreen> {
  final BookmarkService _bookmarkService = BookmarkService();

  @override
  void initState() {
    super.initState();
    _bookmarkService.addListener(_onBookmarksChanged);
  }

  void _onBookmarksChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bookmarkService.removeListener(_onBookmarksChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = _bookmarkService.bookmarks;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: bookmarks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.accentBlue.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bookmark_border_rounded,
                        size: 40,
                        color: AppTheme.accentBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Saved Partners Yet',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When you browse verified partners and service providers, tap the bookmark icon to save them for quick offline access.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        widget.onOpenPartner('https://marketplace.pearlorganisation.in/products');
                      },
                      icon: const Icon(Icons.explore_outlined, size: 18),
                      label: const Text('Browse Verified Directory'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final partner = bookmarks[index];
                return Material(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => widget.onOpenPartner(partner.url),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceSecondary,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTheme.borderStrong),
                                ),
                                child: Center(
                                  child: Text(
                                    partner.name.isNotEmpty ? partner.name[0].toUpperCase() : 'P',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.accentBlue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      partner.name,
                                      style: GoogleFonts.ibmPlexSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      partner.category,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.bookmark_remove_rounded, color: AppTheme.error, size: 20),
                                tooltip: 'Remove Bookmark',
                                onPressed: () {
                                  _bookmarkService.removeBookmark(partner.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Removed ${partner.name} from saved'),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (partner.phone != null)
                                TextButton.icon(
                                  icon: const Icon(Icons.phone_rounded, size: 16),
                                  label: const Text('Call'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppTheme.accentBlue,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () => UrlHandler.launchPhone(partner.phone!),
                                )
                              else
                                TextButton.icon(
                                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                                  label: const Text('Inquire'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppTheme.accentBlue,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () => widget.onOpenPartner(partner.url),
                                ),
                              TextButton.icon(
                                icon: const Icon(Icons.share_outlined, size: 16),
                                label: const Text('Share'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.textSecondary,
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  Share.share(
                                    'Check out ${partner.name} on Pearl Marketplace: ${partner.url}',
                                    subject: partner.name,
                                  );
                                },
                              ),
                              ElevatedButton(
                                onPressed: () => widget.onOpenPartner(partner.url),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: const Text('View Profile'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
