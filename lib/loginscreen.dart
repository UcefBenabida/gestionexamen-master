import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scan/app%20service/appconstants.dart';
import 'package:scan/app%20service/connexion.dart';
import 'package:scan/app%20service/futurebuilderconnexion.dart';
import 'package:scan/app%20service/loginservice.dart';
import 'package:scan/examenscanner.dart';
import 'package:http/http.dart' as http;
import 'package:scan/homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color bgColor = Colors.white;

  Future<dynamic> _connexionTest() async {
    LoginService loginService = LoginService();
    String? token = await loginService.getToken();
    if (token is String) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
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
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.APP_NAME),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "réalisée grâce à Allah et:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.normal),
            ),
            Expanded(
              child: ListView(children: [
                Center(
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          AppConstants.APP_LOGO,
                          height: 200,
                          // color: Color.fromARGB(255, 15, 147, 59),
                          opacity: const AlwaysStoppedAnimation<double>(4),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "X",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(children: const [
                          Text(
                            "Benabida Youssef",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "&",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Nouhaila Hanbali",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          width: 170,
                          height: 100,
                          padding: const EdgeInsets.only(top: 20),
                          child: OutlinedButton(
                            style: flatButtonStyle,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScannerWidget()),
                              );
                            },
                            child: Text(
                              'S\'authentifier',
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ]),
            ),
          ],
        ),
      );
    }, bgColor);
  }
}
