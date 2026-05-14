import 'package:flutter/material.dart';

import '../../Framework/Constant/imageAsset.dart';
class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset(
          AppImageAsset.logo,
          width: 200,
          fit: BoxFit.cover,),
            SizedBox(height: 5),
          ],
        ),
      );
  }
}
