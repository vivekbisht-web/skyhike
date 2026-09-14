import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/url_handler.dart';

class AppDrawer extends StatelessWidget {
  final Function(int tabIndex, String? targetUrl) onNavigate;

  const AppDrawer({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.surface,
      child: Column(
        children: [
          // Branded Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryNavy, AppTheme.secondaryNavy],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'P',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.accentBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pearl Marketplace',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF38BDF8),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Verified Partner Network",
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10.5,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Drawer Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildDrawerItem(
                  icon: Icons.storefront_rounded,
                  title: 'Marketplace Home',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0, 'https://marketplace.pearlorganisation.in/');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.category_outlined,
                  title: 'Explore Categories',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(1, null);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.verified_user_outlined,
                  title: 'Verified Partners',
                  badge: 'Verified',
                  badgeColor: AppTheme.success,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(2, 'https://marketplace.pearlorganisation.in/products');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.stars_rounded,
                  title: 'Elite & Premium Tiers',
                  badge: 'Elite',
                  badgeColor: AppTheme.goldAccent,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0, 'https://marketplace.pearlorganisation.in/?tier=elite');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.bookmark_outline_rounded,
                  title: 'Saved Partners',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(3, null);
                  },
                ),
                const Divider(height: 20),
                _buildDrawerItem(
                  icon: Icons.app_registration_rounded,
                  title: 'Partner Registration',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0, 'https://marketplace.pearlorganisation.in/register');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.login_rounded,
                  title: 'Partner Login',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0, 'https://marketplace.pearlorganisation.in/login');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.support_agent_rounded,
                  title: 'WhatsApp Helpdesk',
                  onTap: () {
                    Navigator.pop(context);
                    UrlHandler.launchWhatsApp('https://api.whatsapp.com/send?phone=+918440000000');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.share_rounded,
                  title: 'Share App',
                  onTap: () {
                    Navigator.pop(context);
                    Share.share(
                      'Explore verified service providers and partners on Pearl Marketplace: https://marketplace.pearlorganisation.in',
                      subject: 'Pearl Marketplace App',
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.policy_outlined,
                  title: 'Privacy & Store Compliance',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(4, null);
                  },
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.surfaceSecondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pearl Organisation',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMuted,
                  ),
                ),
                Text(
                  'v1.0.0 Production',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    Color? badgeColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryNavy, size: 22),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (badgeColor ?? AppTheme.accentBlue).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: (badgeColor ?? AppTheme.accentBlue).withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                badge,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: badgeColor ?? AppTheme.accentBlue,
                ),
              ),
            )
          : null,
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
