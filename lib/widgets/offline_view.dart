import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class OfflineView extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback? onOpenSaved;

  const OfflineView({
    super.key,
    required this.onRetry,
    this.onOpenSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryNavy.withValues(alpha: 0.06),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.accentBlue.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: AppTheme.accentBlue,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Internet Connection',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Please check your network settings and try again. You can still access your saved partners offline.',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry Connection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (onOpenSaved != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpenSaved,
                icon: const Icon(Icons.bookmark_outline_rounded, size: 18),
                label: const Text('View Saved Partners'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryNavy,
                  side: const BorderSide(color: AppTheme.borderStrong),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
