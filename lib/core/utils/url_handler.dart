import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHandler {
  static const String baseHost = 'marketplace.pearlorganisation.in';

  static bool isInternalUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.isEmpty || uri.host.contains(baseHost) || uri.host.contains('pearlorganisation');
    } catch (_) {
      return false;
    }
  }

  static bool isSpecialScheme(String url) {
    final lower = url.toLowerCase();
    return lower.startsWith('tel:') ||
        lower.startsWith('mailto:') ||
        lower.startsWith('sms:') ||
        lower.startsWith('whatsapp:') ||
        lower.startsWith('intent:') ||
        lower.startsWith('geo:') ||
        lower.contains('wa.me/') ||
        lower.contains('api.whatsapp.com/');
  }

  static Future<bool> launchExternal(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch external URL: $url');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching external URL $url: $e');
      return false;
    }
  }

  static Future<bool> launchPhone(String phoneNumber) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: clean);
    return await launchUrl(uri);
  }

  static Future<bool> launchEmail(String email, {String? subject, String? body}) async {
    final params = <String, String>{};
    if (subject != null) params['subject'] = subject;
    if (body != null) params['body'] = body;

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: params.isNotEmpty ? params : null,
    );
    return await launchUrl(uri);
  }

  static Future<bool> launchWhatsApp(String phoneOrUrl) async {
    Uri uri;
    if (phoneOrUrl.startsWith('http') || phoneOrUrl.startsWith('whatsapp')) {
      uri = Uri.parse(phoneOrUrl);
    } else {
      final clean = phoneOrUrl.replaceAll(RegExp(r'[^0-9]'), '');
      uri = Uri.parse('https://wa.me/$clean');
    }
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
