import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 250,
          width: 250,
          child: Image.asset(
            'lib/assets/gif/crabGIF.gif',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
