import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:scan/app%20service/appconstants.dart';
import 'package:scan/app%20service/connexion.dart';

// ignore: must_be_immutable
class FutureBuilderConnexion extends StatefulWidget {
  Widget Function(BuildContext context, dynamic data) builder;
  Color backGroundColor;
  Future<dynamic> connexionMthod;
  // ignore: use_key_in_widget_constructors
  FutureBuilderConnexion(
      this.connexionMthod, this.builder, this.backGroundColor);
  @override
  State<StatefulWidget> createState() {
    return _FutureBuilderConnexionState();
  }
}

class _FutureBuilderConnexionState extends State<FutureBuilderConnexion> {
  bool stateOnConnexionError = false; // variable très important
  bool stateOnShowingData = false; // variable très important

  String error = 'Vérifiez votre connexion internet et réssayez';

  dynamic data;
  Timer? _timer;
  Widget futureBuilderWaitingWidget = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 80.0,
            height: 80.0,
            child: LoadingIndicator(
                indicatorType: Indicator.cubeTransition,
                colors: [AppConstants.BACKGROUND_APP],
                strokeWidth: 5,
                pathBackgroundColor: Colors.white),
          ),
        ],
      )
    ],
  );

  Widget? content;

  int waitingSeconds = 4;

  _connexionError() {
    if (mounted) {
      setState(() {
        content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Builder(builder: (context) {
                        if (error !=
                            'Vérifiez votre connexion internet et réssayez') {
                          return Column(
                            children: [
                              RichText(
                                textWidthBasis: TextWidthBasis.parent,
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  text: 'Erreur au niveau du serveur',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              RichText(
                                textWidthBasis: TextWidthBasis.parent,
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  text:
                                      'attendez quelques instants et réssayez',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return RichText(
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: error,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          refreshContent();
                        });
                      },
                      child: const Text('Actualiser'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      });
    }
  }

  refreshContent() async {
    content = futureBuilderWaitingWidget;
    Timer timer = Timer(Duration(seconds: waitingSeconds), () {
      if (mounted) {
        stateOnConnexionError = true; // variable très important
        _connexionError();
      }
    });
    dynamic dataTest = await widget.connexionMthod;
    if (dataTest != null) {
      if (!((dataTest is String) &&
          ((dataTest == 'connexion error') || (dataTest == 'server error')))) {
        if (mounted) {
          setState(() {
            timer.cancel();
            stateOnShowingData = true;
            data = dataTest;
          });
        }
      } else {
        if (dataTest == 'connexion error') {
          Connexion connexion = Connexion();
          final bool result = await connexion.testInternetConnexion();
          if (result) {
            error =
                'Erreur au niveau du serveur attendez quelques instants et réssayez';
            stateOnConnexionError = true; // variable très important
          } else {
            error = 'Vérifiez votre connexion internet et réssayez';
            stateOnConnexionError = true; // variable très important
          }
        } else {
          if (dataTest == 'server error') {
            error =
                'Erreur au niveau du serveur attendez quelques instants et réssayez';
            stateOnConnexionError = true; // variable très important
          }
        }
      }
    } else {
      Connexion connexion = Connexion();
      final bool result = await connexion.testInternetConnexion();
      if (result) {
        error =
            'Erreur au niveau du serveur attendez quelques instants et réssayez';
        stateOnConnexionError = true; // variable très important
        _connexionError();
      } else {
        error = 'Vérifiez votre connexion internet et réssayez';
        stateOnConnexionError = true; // variable très important
        _connexionError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    content ??= futureBuilderWaitingWidget;
    if (!stateOnConnexionError && !stateOnShowingData) {
      refreshContent();
    } else {
      stateOnConnexionError = false;
      stateOnShowingData = false;
    }

    if (data != null) {
      content = widget.builder(context, data);
    }
    return Scaffold(
      backgroundColor: widget.backGroundColor,
      body: content,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
