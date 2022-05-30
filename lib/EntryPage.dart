import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'QuestionPage.dart';
import 'UserState.dart';

class EntryPage extends StatefulWidget {
  static const routeName = '/entry';
  EntryPage(this.codeID);
  final String codeID;

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  String infoText = "";
  String name = "";
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final _codeController = TextEditingController(text: widget.codeID);
    final _nameController = TextEditingController(text: name);
    return Scaffold(
      appBar: AppBar(
        title: Text("参加"),
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "参加コード"),
              controller: _codeController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "表示名"),
              controller: _nameController,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                try {
                  // 匿名ログイン
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final UserCredential result = await auth.signInAnonymously();
                  final User user = result.user!;
                  userState.setPlayer(user);
                  // 参加コード確認
                  final FirebaseFirestore store = FirebaseFirestore.instance;
                  final DocumentSnapshot ss = await store
                      .collection('games')
                      .doc(_codeController.text)
                      .get();
                  if (!ss.exists) {
                    setState(() {
                      infoText = "参加コードが無効です";
                    });
                  } else {
                    // 参加登録
                    await store
                        .collection('games')
                        .doc(ss.id)
                        .collection('members')
                        .doc(user.uid)
                        .set({
                      'uid': user.uid,
                      'name': _nameController.text,
                      'joined': false,
                      'point': 0,
                    });
                    name = _nameController.text;
                    // 開始ステータス待ち
                    setState(() {
                      infoText = "開始までお待ちください";
                    });
                    store
                        .collection('games')
                        .doc(ss.id)
                        .snapshots()
                        .listen((event) {
                      print(event.data().toString());
                      Map<String, dynamic> data = event.data()!;
                      if (data['status'] == 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return QuestionPage(ss.id);
                            },
                          ),
                        );
                      }
                      setState(() {
                        infoText = "開始までお待ちください\nstatus：${data['status']}";
                      });
                    });
                  }
                } catch (e) {
                  setState(() {
                    infoText = "参加コードが無効です";
                  });
                }
              },
              child: Text("参加する"),
            ),
            const SizedBox(height: 8),
            Text(infoText),
          ],
        ),
      ),
    );
  }
}
