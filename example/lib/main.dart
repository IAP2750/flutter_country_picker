import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo for country picker package',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: [
        const Locale('en'),
        const Locale('ar'),
        const Locale('es'),
        const Locale('de'),
        const Locale('fr'),
        const Locale('el'),
        const Locale('et'),
        const Locale('nb'),
        const Locale('nn'),
        const Locale('pl'),
        const Locale('pt'),
        const Locale('ru'),
        const Locale('hi'),
        const Locale('ne'),
        const Locale('uk'),
        const Locale('hr'),
        const Locale('tr'),
        const Locale('lv'),
        const Locale('lt'),
        const Locale('ku'),
        const Locale('nl'),
        const Locale('it'),
        const Locale('ko'),
        const Locale('ja'),
        const Locale('id'),
        const Locale('cs'),
        const Locale('ht'),
        const Locale('sk'),
        const Locale('ro'),
        const Locale('bg'),
        const Locale('ca'),
        const Locale('he'),
        const Locale('fa'),
        const Locale('da'),
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'), // Generic Simplified Chinese 'zh_Hans'
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'), // Generic traditional Chinese 'zh_Hant'
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo for country picker')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showCountryPicker(
              context: context,
              favorite: <String>['US'],
              //Optional. Shows phone code before the country name.
              showPhoneCode: false,
              onSelect: (Country country) {},
              // Optional. Sheet moves when keyboard opens.
              moveAlongWithKeyboard: true,
              // Optional. Sets the theme for the country list picker.
              countryListTheme: CountryListThemeData(
                // Optional. Sets the border radius for the bottomsheet.
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                // Optional. Styles the search field.
                inputDecoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Start typing to search',
                  prefixIcon: const Icon(Icons.search),

                ),
                // Optional. Styles the text in the search field
                searchTextStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
            );
          },
          child: const Text('Show country picker'),
        ),
      ),
    );
  }
}
