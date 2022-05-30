import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'UserState.dart';
import 'NewTestPage.dart';
import 'DetailTestPage.dart';
import 'LoginCheck.dart';

class MyPage extends StatefulWidget {
  static const routeName = '/mypage';
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    if (userState.user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("マイページ"),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text("${userState.user!.email}"),
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return NewTestPage(userState.user!);
                        }),
                      ),
                    },
                    child: Text("新規問題作成"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('tests')
                    // .where('author', isEqualTo: widget.user.email)
                    .orderBy('date')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    return ListView(
                      children: documents.map((document) {
                        return Card(
                          child: ListTile(
                            title: Text(document['title']),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_right),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return DetailTestPage(document.id);
                                  }),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return Center(
                    child: Text("読込中..."),
                  );
                },
              ),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlinedButton(
                    onPressed: () => {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return LoginCheck(nextPage: MyPage.routeName);
                          }))
                        },
                    child: Text("ログイン", style: TextStyle(fontSize: 40)))
              ]),
        ),
      );
    }
  }
}
