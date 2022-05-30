import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'AnswerPage.dart';
import 'ResultPage.dart';
import 'UserState.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage(this.gameid);
  final String gameid;
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String infoText = "";
  String _type = '';
  void _handleRadio(value) => setState(() {
        _type = value;
      });

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('問題'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('games')
            .doc(widget.gameid)
            .get(),
        builder: (context, gamess) {
          if (gamess.connectionState == ConnectionState.done) {
            if (gamess.hasError) {
              return Center(
                child: Text('エラー'),
              );
            }
            if (!gamess.hasData) {
              return Center(
                child: Text('指定した問題が見つかりません'),
              );
            }
            Map<String, dynamic> gamedata =
                gamess.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(32),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('tests')
                          .doc(gamedata['test'])
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('エラー'),
                          );
                        }
                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return Center(
                            child: Text('指定した問題が見つかりません'),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          var _qTitleController = []..length = 11;
                          var _qItem1Controller = []..length = 11;
                          var _qItem2Controller = []..length = 11;
                          var _qItem3Controller = []..length = 11;
                          var _qItem4Controller = []..length = 11;
                          var _qAnswerController = []..length = 11;
                          for (var i = 1; i <= 10; i++) {
                            var ii = "q" + i.toString().padLeft(2, "0");
                            _qTitleController[i] = data[ii + 'Title'] ?? "";
                            _qItem1Controller[i] = data[ii + 'Item1'] ?? "";
                            _qItem2Controller[i] = data[ii + 'Item2'] ?? "";
                            _qItem3Controller[i] = data[ii + 'Item3'] ?? "";
                            _qItem4Controller[i] = data[ii + 'Item4'] ?? "";
                            _qAnswerController[i] = data[ii + 'Answer'] ?? "";
                          }
                          RadioListTile makeRadioListTile(
                              String text, String value) {
                            return new RadioListTile(
                              title: Text(text),
                              value: value,
                              groupValue: _type,
                              onChanged: (value) => _handleRadio(value),
                            );
                          }

                          Card makeCard(int idx) {
                            return Card(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    color: Theme.of(context).primaryColor,
                                    width: double.infinity,
                                    child: Text(
                                      "第 ${idx.toString()} 問",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText1,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      _qTitleController[idx],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  makeRadioListTile(
                                      _qItem1Controller[idx], "1"),
                                  const SizedBox(height: 8),
                                  makeRadioListTile(
                                      _qItem2Controller[idx], "2"),
                                  const SizedBox(height: 8),
                                  makeRadioListTile(
                                      _qItem3Controller[idx], "3"),
                                  const SizedBox(height: 8),
                                  makeRadioListTile(
                                      _qItem4Controller[idx], "4"),
                                ],
                              ),
                            );
                          }

                          return Column(
                            children: <Widget>[
                              makeCard(gamedata['current']),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.check),
                                  label: Text("決定"),
                                  onPressed: () async {
                                    try {
                                      final FirebaseAuth auth =
                                          FirebaseAuth.instance;
                                      final UserCredential result =
                                          await auth.signInAnonymously();
                                      final User user = userState.player!;
                                      await FirebaseFirestore.instance
                                          .collection(
                                              'games/${widget.gameid}/members')
                                          .doc(user.uid)
                                          .update({
                                        'a${gamedata['current']}': _type,
                                      });
                                      // 開始ステータス待ち
                                      setState(() {
                                        infoText = "お待ちください";
                                      });
                                      final FirebaseFirestore store =
                                          FirebaseFirestore.instance;
                                      store
                                          .collection('games')
                                          .doc(widget.gameid)
                                          .snapshots()
                                          .listen((event) {
                                        print(event.data().toString());
                                        Map<String, dynamic> data =
                                            event.data()!;
                                        if (data['status'] == 2) {
                                          try {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return AnswerPage(
                                                      widget.gameid);
                                                },
                                              ),
                                            );
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                        }
                                        if (data['status'] == 3) {
                                          try {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return ResultPage(
                                                      widget.gameid);
                                                },
                                              ),
                                            );
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                        }
                                        setState(() {
                                          infoText =
                                              "お待ちください\nstatus：${data['status']}";
                                        });
                                      });
                                    } catch (e) {
                                      setState(() {
                                        infoText = e.toString();
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(infoText),
                            ],
                          );
                        }
                        // データが読込中の場合
                        return Center(
                          child: Text('読込中...'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('読込中...'),
            );
          }
        },
      ),
    );
  }
}
