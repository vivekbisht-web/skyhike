import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/url_handler.dart';
import 'compliance_detail_screen.dart';

class AccountScreen extends StatefulWidget {
  final Function(String url) onOpenUrl;

  const AccountScreen({
    super.key,
    required this.onOpenUrl,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _version = '1.0.0';
  String _buildNumber = '1';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = info.version;
          _buildNumber = info.buildNumber;
        });
      }
    } catch (e) {
      debugPrint('Error loading package info: $e');
    }
  }

  void _openCompliance(ComplianceType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplianceDetailScreen(type: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Partner Action Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryNavy, AppTheme.secondaryNavy],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryNavy.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.handshake_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Are You A Service Provider?',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Join Pearl Verified Partner Network',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onOpenUrl('https://marketplace.pearlorganisation.in/register');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryNavy,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        child: const Text('Become a Partner'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          widget.onOpenUrl('https://marketplace.pearlorganisation.in/login');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        child: const Text('Partner Sign In'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionHeader('HELP & DIRECT SUPPORT'),
          _buildCard([
            _menuTile(
              icon: Icons.chat_rounded,
              title: 'WhatsApp Official Helpdesk',
              subtitle: 'Connect instantly with Pearl support',
              iconColor: const Color(0xFF25D366),
              onTap: () => UrlHandler.launchWhatsApp('https://wa.me/918440000000'),
            ),
            _menuTile(
              icon: Icons.headset_mic_rounded,
              title: 'Customer Care Call',
              subtitle: '+91 844-000-0000 (Mon - Sat)',
              iconColor: AppTheme.accentBlue,
              onTap: () => UrlHandler.launchPhone('+918440000000'),
            ),
            _menuTile(
              icon: Icons.mail_outline_rounded,
              title: 'Email Inquiries',
              subtitle: 'support@pearlorganisation.com',
              iconColor: AppTheme.warning,
              onTap: () => UrlHandler.launchEmail('support@pearlorganisation.com'),
            ),
          ]),

          const SizedBox(height: 24),
          _sectionHeader('LEGAL & APP STORE COMPLIANCE'),
          _buildCard([
            _menuTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Data usage, tracking & security',
              iconColor: AppTheme.accentBlue,
              onTap: () => _openCompliance(ComplianceType.privacyPolicy),
            ),
            _menuTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'User agreement & service rules',
              iconColor: AppTheme.accentBlue,
              onTap: () => _openCompliance(ComplianceType.termsOfService),
            ),
            _menuTile(
              icon: Icons.verified_outlined,
              title: 'Partner Verification Standards',
              subtitle: 'Quality assurance protocol',
              iconColor: AppTheme.success,
              onTap: () => _openCompliance(ComplianceType.partnerGuidelines),
            ),
            _menuTile(
              icon: Icons.delete_forever_outlined,
              title: 'Account & Data Deletion',
              subtitle: 'Apple & Play Store compliance mechanism',
              iconColor: AppTheme.error,
              onTap: () => _openCompliance(ComplianceType.accountDeletion),
            ),
          ]),

          const SizedBox(height: 24),
          _sectionHeader('APP PREFERENCES'),
          _buildCard([
            _menuTile(
              icon: Icons.star_rate_rounded,
              title: 'Rate Pearl Marketplace',
              subtitle: 'Share your review on App Store / Play Store',
              iconColor: AppTheme.goldAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for rating Pearl Marketplace!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            _menuTile(
              icon: Icons.share_rounded,
              title: 'Share Application',
              subtitle: 'Recommend Pearl Marketplace to colleagues',
              iconColor: AppTheme.accentBlue,
              onTap: () {
                Share.share(
                  'Explore verified service providers and partners on Pearl Marketplace: https://marketplace.pearlorganisation.in',
                  subject: 'Pearl Marketplace App',
                );
              },
            ),
            _menuTile(
              icon: Icons.cleaning_services_rounded,
              title: 'Clear Cache & Temp Files',
              subtitle: 'Free up local memory and refresh data',
              iconColor: AppTheme.textMuted,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('App cache cleared successfully.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ]),

          const SizedBox(height: 28),
          Center(
            child: Column(
              children: [
                Text(
                  'Pearl Marketplace • Pearl Organisation',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Version $_version (Build $_buildNumber) • Production Ready',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppTheme.textMuted,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: children.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 13,
        color: AppTheme.textMuted,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    );
  }
}
