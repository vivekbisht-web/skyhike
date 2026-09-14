import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/url_handler.dart';

enum ComplianceType { privacyPolicy, termsOfService, accountDeletion, partnerGuidelines }

class ComplianceDetailScreen extends StatelessWidget {
  final ComplianceType type;

  const ComplianceDetailScreen({
    super.key,
    required this.type,
  });

  String get _title {
    switch (type) {
      case ComplianceType.privacyPolicy:
        return 'Privacy Policy';
      case ComplianceType.termsOfService:
        return 'Terms of Service';
      case ComplianceType.accountDeletion:
        return 'Account & Data Deletion';
      case ComplianceType.partnerGuidelines:
        return 'Partner Verification Standards';
    }
  }

  Widget _buildContent(BuildContext context) {
    switch (type) {
      case ComplianceType.privacyPolicy:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pearl Marketplace Privacy Policy',
              style: GoogleFonts.ibmPlexSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text('Last updated: September 2026', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppTheme.textMuted)),
            const SizedBox(height: 16),
            _paragraph(
              'Pearl Organisation operates Pearl Marketplace ("marketplace.pearlorganisation.in") to connect businesses and consumers with verified service partners. We respect your privacy and are committed to protecting personal data collected through our mobile applications and services.',
            ),
            _heading('1. Information We Collect'),
            _paragraph(
              '• Profile & Contact Data: Name, business name, phone number, email address, and service categories when you register as a partner or submit inquiries.\n• Usage & Diagnostics: Anonymous app interaction metrics, device platform information, and crash reports to improve stability.\n• Location Data: Optional approximate location when you search for nearby verified partners.',
            ),
            _heading('2. How We Use Information'),
            _paragraph(
              'We use your data solely to facilitate partner introductions, verify credentials, prevent fraudulent listings, deliver customer support, and comply with applicable laws.',
            ),
            _heading('3. Data Security & Storage'),
            _paragraph(
              'All data transmitted between the mobile application and our servers is secured using industry-standard TLS/SSL encryption. We do not sell user personal information to third parties.',
            ),
            _heading('4. Contacting Our Data Privacy Team'),
            _paragraph(
              'If you have questions regarding this policy or wish to exercise data rights, contact privacy@pearlorganisation.com or visit www.pearlorganisation.com.',
            ),
          ],
        );

      case ComplianceType.termsOfService:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: GoogleFonts.ibmPlexSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text('Effective Date: September 2026', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppTheme.textMuted)),
            const SizedBox(height: 16),
            _paragraph(
              'By accessing or using the Pearl Marketplace mobile app, you agree to be bound by these Terms of Service. If you do not agree, please do not use the application.',
            ),
            _heading('1. Marketplace Services'),
            _paragraph(
              'Pearl Marketplace provides a platform for discovering and connecting with verified service providers. Pearl Organisation validates credentials during our verification process but recommends users exercise due diligence when entering into service contracts.',
            ),
            _heading('2. Partner Conduct'),
            _paragraph(
              'All listed partners must maintain accurate business details, adhere to fair business practices, and fulfill client commitments promptly. Inaccurate representation or fraudulent conduct results in immediate account suspension.',
            ),
            _heading('3. Intellectual Property'),
            _paragraph(
              'All logos, trademarks, and brand assets displayed belong to Pearl Organisation or their respective verified partners and are protected by applicable intellectual property laws.',
            ),
          ],
        );

      case ComplianceType.accountDeletion:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account & Data Deletion Request',
              style: GoogleFonts.ibmPlexSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text('App Store & Play Store Compliance', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppTheme.textMuted)),
            const SizedBox(height: 16),
            _paragraph(
              'In compliance with Apple App Store Guideline 5.1.1(v) and Google Play Store User Data Policies, registered users and verified partners can request the complete deletion of their account, profile listings, and associated data at any time.',
            ),
            _heading('What Happens When Your Account Is Deleted:'),
            _paragraph(
              '• Your business profile and public partner listings will be permanently removed from Pearl Marketplace within 48 hours.\n• All active inquiries, messages, and saved preferences associated with your profile will be purged.\n• Financial and invoice transaction records will be retained only for the legally mandated period required by tax authorities.',
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Initiate Immediate Deletion Request',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap below to send an official account removal request directly to our Data Privacy Officer via email or WhatsApp.',
                    style: GoogleFonts.inter(fontSize: 12.5, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            UrlHandler.launchEmail(
                              'support@pearlorganisation.com',
                              subject: 'Account Deletion Request - Pearl Marketplace',
                              body: 'Hello Support Team,\n\nI would like to request the permanent deletion of my Pearl Marketplace account and all associated data.\n\nAccount Email/Phone: \nReason (optional): \n\nThank you.',
                            );
                          },
                          icon: const Icon(Icons.email_outlined, size: 16),
                          label: const Text('Email Request'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.error,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            UrlHandler.launchWhatsApp('https://wa.me/918440000000?text=Hello%20Pearl%20Support,%20I%20wish%20to%20request%20account%20deletion%20for%20Pearl%20Marketplace.');
                          },
                          icon: const Icon(Icons.chat_rounded, size: 16),
                          label: const Text('WhatsApp Support'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

      case ComplianceType.partnerGuidelines:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Partner Verification Standards',
              style: GoogleFonts.ibmPlexSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text('Quality & Trust Framework', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppTheme.textMuted)),
            const SizedBox(height: 16),
            _paragraph(
              'Every partner featured on Pearl Marketplace undergoes our rigorous 4-step verification protocol:\n\n1. Legal Registration & Business Identity Verification.\n2. Service Capability & Portfolio Assessment.\n3. Background Check & Client Reference Validation.\n4. Ongoing Quality Review & SLA Compliance.',
            ),
          ],
        );
    }
  }

  Widget _heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13.5,
        color: AppTheme.textSecondary,
        height: 1.6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: AppTheme.primaryNavy,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildContent(context),
      ),
    );
  }
}
