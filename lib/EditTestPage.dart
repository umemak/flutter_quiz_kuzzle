import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'UserState.dart';
import 'MyPage.dart';

class EditTestPage extends StatefulWidget {
  EditTestPage(this.id);
  final String id;

  @override
  _EditTestPageState createState() => _EditTestPageState();
}

class _EditTestPageState extends State<EditTestPage> {
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("問題編集"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(32),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('tests')
                    .doc(widget.id)
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
                    final _titleController = TextEditingController.fromValue(
                        TextEditingValue(text: data['title'] ?? ""));
                    var _qTitleController = []..length = 11;
                    var _qItem1Controller = []..length = 11;
                    var _qItem2Controller = []..length = 11;
                    var _qItem3Controller = []..length = 11;
                    var _qItem4Controller = []..length = 11;
                    var _qAnswerController = []..length = 11;
                    var _qNoteController = []..length = 11;
                    for (var i = 1; i <= 10; i++) {
                      var ii = "q" + i.toString().padLeft(2, "0");
                      _qTitleController[i] = TextEditingController.fromValue(
                          TextEditingValue(text: data[ii + 'Title'] ?? ""));
                      _qItem1Controller[i] = TextEditingController.fromValue(
                          TextEditingValue(text: data[ii + 'Item1'] ?? ""));
                      _qItem2Controller[i] = TextEditingController.fromValue(
                          TextEditingValue(text: data[ii + 'Item2'] ?? ""));
                      _qItem3Controller[i] = TextEditingController.fromValue(
                          TextEditingValue(text: data[ii + 'Item3'] ?? ""));
                      _qItem4Controller[i] = TextEditingController.fromValue(
                          TextEditingValue(text: data[ii + 'Item4'] ?? ""));
                      _qAnswerController[i] = TextEditingController.fromValue(
                          TextEditingValue(text: data[ii + 'Answer'] ?? ""));
                      _qNoteController[i] = TextEditingController.fromValue(
                          TextEditingValue(text: data[ii + 'Note'] ?? ""));
                    }
                    TextFormField makeTextFormField(
                        String l, TextEditingController c) {
                      return TextFormField(
                        decoration: InputDecoration(labelText: l),
                        controller: c,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        readOnly: false,
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
                              child: Text("${idx.toString()}問目",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1),
                            ),
                            makeTextFormField("問題文", _qTitleController[idx]),
                            makeTextFormField("選択肢1", _qItem1Controller[idx]),
                            makeTextFormField("選択肢2", _qItem2Controller[idx]),
                            makeTextFormField("選択肢3", _qItem3Controller[idx]),
                            makeTextFormField("選択肢4", _qItem4Controller[idx]),
                            makeTextFormField("正解", _qAnswerController[idx]),
                            makeTextFormField("解説", _qNoteController[idx]),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: <Widget>[
                        Text("${userState.user!.email}"),
                        TextFormField(
                          decoration: InputDecoration(labelText: "タイトル"),
                          controller: _titleController,
                        ),
                        const SizedBox(height: 8),
                        makeCard(1),
                        makeCard(2),
                        makeCard(3),
                        makeCard(4),
                        makeCard(5),
                        makeCard(6),
                        makeCard(7),
                        makeCard(8),
                        makeCard(9),
                        makeCard(10),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.save),
                            label: Text('保存'),
                            onPressed: () async {
                              final date = DateTime.now()
                                  .toLocal()
                                  .toIso8601String(); // 現在の日時
                              await FirebaseFirestore.instance
                                  .collection('tests')
                                  .doc(widget.id)
                                  .update({
                                'author': userState.user!.email,
                                'title': _titleController.text,
                                'q01Title': _qTitleController[1].text,
                                'q01Item1': _qItem1Controller[1].text,
                                'q01Item2': _qItem2Controller[1].text,
                                'q01Item3': _qItem3Controller[1].text,
                                'q01Item4': _qItem4Controller[1].text,
                                'q01Answer': _qAnswerController[1].text,
                                'q01Note': _qNoteController[1].text,
                                'q02Title': _qTitleController[2].text,
                                'q02Item1': _qItem1Controller[2].text,
                                'q02Item2': _qItem2Controller[2].text,
                                'q02Item3': _qItem3Controller[2].text,
                                'q02Item4': _qItem4Controller[2].text,
                                'q02Answer': _qAnswerController[2].text,
                                'q02Note': _qNoteController[2].text,
                                'q03Title': _qTitleController[3].text,
                                'q03Item1': _qItem1Controller[3].text,
                                'q03Item2': _qItem2Controller[3].text,
                                'q03Item3': _qItem3Controller[3].text,
                                'q03Item4': _qItem4Controller[3].text,
                                'q03Answer': _qAnswerController[3].text,
                                'q03Note': _qNoteController[3].text,
                                'q04Title': _qTitleController[4].text,
                                'q04Item1': _qItem1Controller[4].text,
                                'q04Item2': _qItem2Controller[4].text,
                                'q04Item3': _qItem3Controller[4].text,
                                'q04Item4': _qItem4Controller[4].text,
                                'q04Answer': _qAnswerController[4].text,
                                'q04Note': _qNoteController[4].text,
                                'q05Title': _qTitleController[5].text,
                                'q05Item1': _qItem1Controller[5].text,
                                'q05Item2': _qItem2Controller[5].text,
                                'q05Item3': _qItem3Controller[5].text,
                                'q05Item4': _qItem4Controller[5].text,
                                'q05Answer': _qAnswerController[5].text,
                                'q05Note': _qNoteController[5].text,
                                'q06Title': _qTitleController[6].text,
                                'q06Item1': _qItem1Controller[6].text,
                                'q06Item2': _qItem2Controller[6].text,
                                'q06Item3': _qItem3Controller[6].text,
                                'q06Item4': _qItem4Controller[6].text,
                                'q06Answer': _qAnswerController[6].text,
                                'q06Note': _qNoteController[6].text,
                                'q07Title': _qTitleController[7].text,
                                'q07Item1': _qItem1Controller[7].text,
                                'q07Item2': _qItem2Controller[7].text,
                                'q07Item3': _qItem3Controller[7].text,
                                'q07Item4': _qItem4Controller[7].text,
                                'q07Answer': _qAnswerController[7].text,
                                'q07Note': _qNoteController[7].text,
                                'q08Title': _qTitleController[8].text,
                                'q08Item1': _qItem1Controller[8].text,
                                'q08Item2': _qItem2Controller[8].text,
                                'q08Item3': _qItem3Controller[8].text,
                                'q08Item4': _qItem4Controller[8].text,
                                'q08Answer': _qAnswerController[8].text,
                                'q08Note': _qNoteController[8].text,
                                'q09Title': _qTitleController[9].text,
                                'q09Item1': _qItem1Controller[9].text,
                                'q09Item2': _qItem2Controller[9].text,
                                'q09Item3': _qItem3Controller[9].text,
                                'q09Item4': _qItem4Controller[9].text,
                                'q09Answer': _qAnswerController[9].text,
                                'q09Note': _qNoteController[9].text,
                                'q10Title': _qTitleController[10].text,
                                'q10Item1': _qItem1Controller[10].text,
                                'q10Item2': _qItem2Controller[10].text,
                                'q10Item3': _qItem3Controller[10].text,
                                'q10Item4': _qItem4Controller[10].text,
                                'q10Answer': _qAnswerController[10].text,
                                'q10Note': _qNoteController[10].text,
                                'date': date
                              });
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return MyPage();
                                }),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.delete),
                            label: Text("削除"),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('tests')
                                  .doc(widget.id)
                                  .delete();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return MyPage();
                              }));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, //ボタンの背景色
                            ),
                          ),
                        ),
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
      ),
    );
  }
}
