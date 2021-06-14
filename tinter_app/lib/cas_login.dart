import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: WebViewExample()));

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  bool showWebView = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff79BFC9),
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Authentification CAS',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          DeleteCookiesIcon(_controller.future),
        ],
      ),
      body: showWebView
          ? WebView(
        initialUrl:
        'https://cas.imtbs-tsp.eu/cas/login?service=http://dfvps.telecom-sudparis.eu:443/cas',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onPageStarted: (String url) async {
          final controller = await _controller.future;
          final cookie = await controller.evaluateJavascript(
              "document.getElementsByTagName('cookie')[0].textContent");

          if (cookie != 'null') {
            // TODO: Store the cookie with shared preferences
            print('onPageStarted COOKIE: $cookie');

            setState(() {
              showWebView = false;
            });
          }
        },
        onPageFinished: (String url) async {
          final controller = await _controller.future;
          controller.evaluateJavascript("document.getElementById(\"footer\").remove();");
          controller.evaluateJavascript("document.body.style.backgroundColor = \"#F4F4F8\";");
          controller.evaluateJavascript("document.getElementById(\"app-name\").style.color = \"#210000\";");
          controller.evaluateJavascript("document.getElementById(\"app-name\").style.fontFamily = \"Open Sans\";");
          controller.evaluateJavascript("document.getElementById(\"app-name\").style.fontSize = \"20px\";");
          controller.evaluateJavascript("document.getElementById(\"app-name\").style.fontWeight = \"500\";");
          controller.evaluateJavascript("document.getElementById(\"app-name\").style.padding = \"30px 20px\";");
          controller.evaluateJavascript("document.getElementById(\"password\").style.borderRadius = \"5px\";");
          controller.evaluateJavascript("document.getElementById(\"password\").style.border = \"thick solid #79BFC9\";");
          controller.evaluateJavascript("document.getElementById(\"password\").style.width = \"60%\";");
          controller.evaluateJavascript("document.getElementById(\"password\").style.margin = \"10px 0px 0px 0px\";");
          controller.evaluateJavascript("document.getElementById(\"username\").style.borderRadius = \"5px\";");
          controller.evaluateJavascript("document.getElementById(\"username\").style.border = \"thick solid #79BFC9\";");
          controller.evaluateJavascript("document.getElementById(\"username\").style.width = \"60%\";");
        },
        gestureNavigationEnabled: true,
      )
          : Center(
        child: Text('Welcome on tINTer'),
      ),
    );
  }
}

class DeleteCookiesIcon extends StatelessWidget {
  DeleteCookiesIcon(this.controller);

  final Future<WebViewController> controller;
  final CookieManager cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return IconButton(
          onPressed: () => _onClearCookies(context, controller.data),
          icon: Icon(Icons.delete),
        );
      },
    );
  }

  void _onClearCookies(BuildContext context, WebViewController controller) async {
    final bool hadCookies = await cookieManager.clearCookies();
    controller.loadUrl(
        "https://cas.imtbs-tsp.eu/cas/login?service=http://dfvps.telecom-sudparis.eu:443/cas");
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
