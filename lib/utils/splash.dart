import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo/main.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyHomePage(title: '')),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // SizedBox(
        //   width: _size.width * .4,
        //   height: 30,
        //   child: SvgPicture.asset(
        //     'assets/images/logo/ic_logo_text.svg',
        //     fit: BoxFit.contain,
        //   ),
        // ),
        SizedBox(
          width: double.infinity,
          height: _size.height * .38,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/png/store_splash.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
