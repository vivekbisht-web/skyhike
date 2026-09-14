import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../core/services/network_service.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/url_handler.dart';
import '../widgets/offline_view.dart';

class WebViewScreen extends StatefulWidget {
  final String initialUrl;
  final Function(WebViewController controller)? onControllerCreated;
  final VoidCallback? onOpenSaved;

  const WebViewScreen({
    super.key,
    this.initialUrl = 'https://marketplace.pearlorganisation.in/',
    this.onControllerCreated,
    this.onOpenSaved,
  });

  @override
  State<WebViewScreen> createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  double _progress = 0;
  bool _isLoading = true;
  bool _hasError = false;
  String _currentUrl = '';

  String get currentUrl => _currentUrl;
  WebViewController get controller => _controller;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl;
    _initWebViewController();
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _progress = progress / 100.0;
                _isLoading = progress < 100;
              });
            }
          },
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                _currentUrl = url;
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (url) {
            if (mounted) {
              setState(() {
                _currentUrl = url;
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (error) {
            debugPrint('WebView resource error: ${error.description} (code: ${error.errorCode})');
            // Only flag critical errors (e.g. host lookup failure, connection refused)
            if (error.isForMainFrame ?? true) {
              if (error.errorCode == -2 || error.errorCode == -6 || error.errorCode == -8) {
                if (mounted) {
                  setState(() {
                    _hasError = true;
                  });
                }
              }
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;

            // Handle special schemes (tel, mailto, whatsapp, sms, maps)
            if (UrlHandler.isSpecialScheme(url)) {
              await UrlHandler.launchExternal(url);
              return NavigationDecision.prevent;
            }

            // Handle external domains outside pearl marketplace
            if (!UrlHandler.isInternalUrl(url)) {
              await UrlHandler.launchExternal(url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    widget.onControllerCreated?.call(_controller);
  }

  Future<void> loadUrl(String url) async {
    _hasError = false;
    await _controller.loadRequest(Uri.parse(url));
  }

  Future<void> reload() async {
    _hasError = false;
    await _controller.reload();
  }

  Future<bool> canGoBack() async {
    return await _controller.canGoBack();
  }

  Future<void> goBack() async {
    if (await canGoBack()) {
      await _controller.goBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final networkService = NetworkService();

    if (!networkService.isConnected || _hasError) {
      return OfflineView(
        onRetry: () async {
          final isOnline = await networkService.checkConnection();
          if (isOnline) {
            setState(() {
              _hasError = false;
            });
            reload();
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Still offline. Please check your internet connection.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        onOpenSaved: widget.onOpenSaved,
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          color: AppTheme.accentBlue,
          backgroundColor: AppTheme.surface,
          onRefresh: reload,
          child: WebViewWidget(
            controller: _controller,
          ),
        ),

        // Progress Bar
        if (_isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 3,
              child: LinearProgressIndicator(
                value: _progress > 0 ? _progress : null,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentBlue),
              ),
            ),
          ),
      ],
    );
  }
}