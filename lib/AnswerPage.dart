import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:kuzzle/kuzzle.dart';

import 'ResultPage.dart';
import 'QuestionPage.dart';
import 'UserState.dart';

class AnswerPage extends StatefulWidget {
  AnswerPage(this.gameid);
  final String gameid;
  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
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
        title: const Text('解答'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('games')
            .doc(widget.gameid)
            .get(),
        builder: (context, gamess) {
          if (gamess.connectionState == ConnectionState.done) {
            if (gamess.hasError) {
              return const Center(
                child: Text('エラー'),
              );
            }
            if (!gamess.hasData) {
              return const Center(
                child: Text('指定した問題が見つかりません'),
              );
            }
            Map<String, dynamic> gamedata =
                gamess.data!.data() as Map<String, dynamic>;
            // final answer = gamedata[
            // "members/${userState.player!.uid}/a${gamedata['current']}"];
            print("gamedata:$gamedata");
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('tests')
                          .doc(gamedata['test'])
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('エラー'),
                          );
                        }
                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return const Center(
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
                          var _qNoteController = []..length = 11;
                          for (var i = 1; i <= 10; i++) {
                            var ii = "q" + i.toString().padLeft(2, "0");
                            _qTitleController[i] = data[ii + 'Title'] ?? "";
                            _qItem1Controller[i] = data[ii + 'Item1'] ?? "";
                            _qItem2Controller[i] = data[ii + 'Item2'] ?? "";
                            _qItem3Controller[i] = data[ii + 'Item3'] ?? "";
                            _qItem4Controller[i] = data[ii + 'Item4'] ?? "";
                            _qAnswerController[i] = data[ii + 'Answer'] ?? "";
                            _qNoteController[i] = data[ii + 'Note'] ?? "";
                          }
                          RadioListTile makeRadioListTile(
                              String text, String value) {
                            return RadioListTile(
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
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      _qTitleController[idx],
                                      style: const TextStyle(fontSize: 20),
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
                                  const SizedBox(height: 8),
                                  Text("正解：" + _qAnswerController[idx]),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      _qNoteController[idx],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Column(
                            children: <Widget>[
                              const Text("正解 / 不正解"),
                              const SizedBox(height: 8),
                              makeCard(gamedata['current']),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: const Text("OK"),
                                  onPressed: () async {
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
                                      Map<String, dynamic> data = event.data()!;
                                      if (data['status'] == 1) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return QuestionPage(widget.gameid);
                                        }));
                                      }
                                      if (data['status'] == 3) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ResultPage(widget.gameid);
                                        }));
                                      }
                                      setState(() {
                                        infoText =
                                            "お待ちください\nstatus：${data['status']}";
                                      });
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(infoText),
                            ],
                          );
                        }
                        // データが読込中の場合
                        return const Center(
                          child: Text('読込中...'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('読込中...'),
            );
          }
        },
      ),
    );
  }
}
