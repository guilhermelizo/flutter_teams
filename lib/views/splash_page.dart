import 'package:flutter/material.dart';
import 'home_page.dart';
import '../widgets/brand_widget.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool showBrand = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        showBrand = true;
      });

      Future.delayed(const Duration(milliseconds: 800), _goToHome);
    });
    super.initState();
  }

  void _goToHome() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: Center(
        child: AnimatedOpacity(
          opacity: showBrand ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Hero(
            tag: 'brand_tag',
            child: BrandWidget(
              size: 72,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
