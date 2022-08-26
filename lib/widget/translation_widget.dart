import 'package:flutter/material.dart';
import 'package:google_translate/api/translation_api.dart';
import 'package:google_translate/utils/translations.dart';

class TranslationWidget extends StatefulWidget {
  final String? message;
  final String? fromLanguage;
  final String? toLanguage;
  final Widget Function(String translation) builder;

  const TranslationWidget({
     this.message,
     this.fromLanguage,
     this.toLanguage,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _TranslationWidgetState createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  late String translation;

  @override
  Widget build(BuildContext context) {
     final fromLanguageCode = Translations.getLanguageCode(widget.fromLanguage!);
    final toLanguageCode = Translations.getLanguageCode(widget.toLanguage!);

    return FutureBuilder(
      //future: TranslationApi.translate(widget.message, toLanguageCode),

      future: TranslationApi.translate2(
          widget.message!, fromLanguageCode, toLanguageCode),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return buildWaiting();
          default:
            if (snapshot.hasError) {
              translation = 'Could not translate due to Network problems';
            } else {
              translation = snapshot.data;
            }
            return widget.builder(translation);
        }
      },
    );
  }

  Widget buildWaiting() =>
      translation == null ? Container() : widget.builder(translation);
}
