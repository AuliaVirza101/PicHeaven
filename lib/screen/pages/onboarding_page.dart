import 'package:d_session/d_session.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:photoidea_app/common/app_constants.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void gotoDashboard() {
    DSession.setCustom('see_onboarding', true).then((value) {
      if(mounted) Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              AppConstants.onboardingBackground,
              fit: BoxFit.cover,
              height: size.height,
            )
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppConstants.onboardingImage,
                // width: size.width * 0.8,
                // height: size.height * 0.6,
              ),
              const Gap(30),
              Text(
                'Welcome to PicHeaven\nClick To begin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                  
                ),
              ),
              const Gap(50),
              ElevatedButton(
                onPressed: gotoDashboard,
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: Colors.black87,
                    ))),
                child:  Text('Begin',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ],
          )
        ],
      ),
    );
  }
}
