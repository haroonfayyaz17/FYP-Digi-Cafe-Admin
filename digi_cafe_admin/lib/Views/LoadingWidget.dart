import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MyWidgets.dart';

class LoadingWidget extends StatelessWidget {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // if (count == 0)
    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     await MyWidgets.internetStatus(context).then((value) {});
    //     count++;
    //   });
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
