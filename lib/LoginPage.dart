import 'package:kuzzle/kuzzle.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'SignupPage.dart';
import 'MyPage.dart';
import 'UserState.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginUserEmail = "";
  String loginUserPassword = "";
  String infoText = "";

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("ログイン"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    loginUserEmail = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    loginUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final kuzzle = Kuzzle(
                      WebSocketProtocol(Uri(
                        scheme: 'ws',
                        host: 'kuzzle',
                        port: 7512,
                      )),
                      offlineMode: OfflineMode.auto,
                    );
                    final result = await kuzzle.auth.login('local', {
                      'username': loginUserEmail,
                      'password': loginUserPassword,
                    });
                    // ログインに成功した場合
                    KuzzleUser user = await kuzzle.auth.getCurrentUser();
                    userState.setUser(user);
                    setState(() {
                      infoText = "ログインOK：${user.uid}";
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return MyPage();
                        },
                      ),
                    );
                  } catch (e) {
                    // ログインに失敗した場合
                    setState(() {
                      infoText = "ログインNG：${e.toString()}";
                    });
                  }
                },
                child: const Text("ログイン"),
              ),
              const SizedBox(height: 8),
              Text(infoText),
              OutlinedButton(
                  onPressed: () => {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SignupPage();
                        }))
                      },
                  child: const Text("利用登録"))
            ],
          ),
        ),
      ),
    );
  }
}
