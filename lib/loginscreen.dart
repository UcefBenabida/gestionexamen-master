import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scan/app%20service/connexion.dart';
import 'package:scan/app%20service/futurebuilderconnexion.dart';
import 'package:scan/examenscanner.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color bgColor = Colors.white;

  Future<dynamic> _connexionTest() async {
    Connexion connexion = Connexion();
    http.Response response = await connexion.getData("system/connexiontest");
    if (kDebugMode) {
      print("****************   ${response.body}   ****************");
    }
    if (response.body == "connected.") {
      return "connected.";
    } else {
      return response;
    }
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.black,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilderConnexion(_connexionTest(), (context, data) {
      return SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 200,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(100, 0, 50, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/fp.png",
                          height: 200,
                          // color: Color.fromARGB(255, 15, 147, 59),
                          opacity: const AlwaysStoppedAnimation<double>(4)),
                      // CircleAvatar(
                      //   backgroundImage: AssetImage("images/fp.png"),
                      //   radius: 50.0,
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: 170,
                        height: 100,
                        padding: const EdgeInsets.only(top: 20),
                        child: TextButton(
                          style: flatButtonStyle,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScannerWidget()),
                            );
                          },
                          child: const Text(
                            'S\'authentifier',
                            style: TextStyle(
                              color: Color.fromARGB(255, 93, 221, 114),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    }, bgColor);
  }
}
