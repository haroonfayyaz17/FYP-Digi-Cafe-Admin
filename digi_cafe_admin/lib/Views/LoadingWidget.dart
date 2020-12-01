import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ConstrainedBox(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              padding: EdgeInsets.only(left: 40, top: 25),
              child: Image.asset('images/logo.png'),
            ),
          ],
        ),
      ),
    );
  }
}
