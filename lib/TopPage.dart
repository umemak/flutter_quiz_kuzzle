import 'package:flutter/material.dart';

import 'EntryPage.dart';
import 'LoginCheck.dart';
import 'MyPage.dart';

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOP"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              OutlinedButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return EntryPage("");
                            },
                          ),
                        ),
                      },
                  child: Text("参加する", style: TextStyle(fontSize: 40))),
              OutlinedButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginCheck(nextPage: MyPage.routeName);
                            },
                          ),
                        ),
                      },
                  child: Text("問題作成・編集", style: TextStyle(fontSize: 40)))
            ]),
      ),
    );
  }
}
