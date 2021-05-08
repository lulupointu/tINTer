import 'package:flutter/material.dart';

class TinterAuthenticationTab2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: login != '' && password != '' ? connect : null,

          ),
        ),
      ),
    );
  }

  void connect() {
    // BLOCSHIT
  }
}
