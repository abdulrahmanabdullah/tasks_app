import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WhenScreenEmptyWidget extends StatelessWidget {

  final String message ;

  WhenScreenEmptyWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.2 ,
          width: MediaQuery.of(context).size.width * 0.2 ,
          alignment: Alignment.bottomCenter,
          child: Center(child: SvgPicture.asset("asset/images/blank.svg"),widthFactor: 0,),
        ),
        Text(message),
      ],
    );
  }
}
