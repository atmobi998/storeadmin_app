library globals;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/cc/ar.dart';
import 'package:shopadmin_app/cc/cn.dart';
import 'package:shopadmin_app/cc/en.dart';
import 'package:shopadmin_app/cc/es.dart';
import 'package:shopadmin_app/cc/gr.dart';
import 'package:shopadmin_app/cc/hr.dart';
import 'package:shopadmin_app/cc/nb.dart';
import 'package:shopadmin_app/cc/nn.dart';
import 'package:shopadmin_app/cc/np.dart';
import 'package:shopadmin_app/cc/pl.dart';
import 'package:shopadmin_app/cc/pt.dart';
import 'package:shopadmin_app/cc/ru.dart';
import 'package:shopadmin_app/cc/tw.dart';
import 'package:shopadmin_app/cc/uk.dart';
import 'package:shopadmin_app/cc/tr.dart';
import 'package:shopadmin_app/cc/vi.dart';
import 'package:shopadmin_app/cc/cc_codes.dart';

void showCountryPicker({
  required BuildContext context,
  required ValueChanged<Country> onSelect,
  VoidCallback? onClosed,
  List<String>? exclude,
  List<String>? countryFilter,
  bool showPhoneCode = false,
  CountryListThemeData? countryListTheme,
  bool searchAutofocus = false,
}) {
  assert(exclude == null || countryFilter == null,
      'Cannot provide both exclude and countryFilter');
  showCountryListBottomSheet(
    context: context,
    onSelect: onSelect,
    onClosed: onClosed,
    exclude: exclude,
    countryFilter: countryFilter,
    showPhoneCode: showPhoneCode,
    countryListTheme: countryListTheme,
    searchAutofocus: searchAutofocus,
  );
}

void showCountryListBottomSheet({
  required BuildContext context,
  required ValueChanged<Country> onSelect,
  VoidCallback? onClosed,
  List<String>? exclude,
  List<String>? countryFilter,
  bool showPhoneCode = false,
  CountryListThemeData? countryListTheme,
  bool searchAutofocus = false,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _builder(
      context,
      onSelect,
      exclude,
      countryFilter,
      showPhoneCode,
      countryListTheme,
      searchAutofocus,
    ),
  ).whenComplete(() {
    if (onClosed != null) onClosed();
  });
}

Widget _builder(
  BuildContext context,
  ValueChanged<Country> onSelect,
  List<String>? exclude,
  List<String>? countryFilter,
  bool showPhoneCode,
  CountryListThemeData? countryListTheme,
  bool searchAutofocus,
) {
  final device = MediaQuery.of(context).size.height;
  final statusBarHeight = MediaQuery.of(context).padding.top;
  final height = device - (statusBarHeight + (kToolbarHeight / 1.5));

  Color? _backgroundColor = countryListTheme?.backgroundColor ??
      Theme.of(context).bottomSheetTheme.backgroundColor;
  if (_backgroundColor == null) {
    if (Theme.of(context).brightness == Brightness.light) {
      _backgroundColor = Colors.white;
    } else {
      _backgroundColor = Colors.black;
    }
  }

  final BorderRadius _borderRadius = countryListTheme?.borderRadius ??
      const BorderRadius.only(
        topLeft: Radius.circular(40.0),
        topRight: Radius.circular(40.0),
      );

  return Container(
    height: height,
    decoration: BoxDecoration(
      color: _backgroundColor,
      borderRadius: _borderRadius,
    ),
    child: CountryListView(
      onSelect: onSelect,
      exclude: exclude,
      countryFilter: countryFilter,
      showPhoneCode: showPhoneCode,
      countryListTheme: countryListTheme,
      searchAutofocus: searchAutofocus,
    ),
  );
}

class CountryListThemeData {
  /// The country bottom sheet's background color.
  ///
  /// If null, [backgroundColor] defaults to [BottomSheetThemeData.backgroundColor].
  final Color? backgroundColor;

  ///The style to use for country name text.
  ///
  /// If null, the style will be set to [TextStyle(fontSize: 16)]
  final TextStyle? textStyle;

  ///The flag size.
  ///
  /// If null, set to 25
  final double? flagSize;

  ///The decoration used for the search field
  ///
  /// It defaults to a basic outline-bordered input decoration
  final InputDecoration? inputDecoration;

  ///The border radius of the bottom sheet
  ///
  /// It defaults to 40 for the top-left and top-right values.
  final BorderRadius? borderRadius;

  const CountryListThemeData({
    this.backgroundColor,
    this.textStyle,
    this.flagSize,
    this.inputDecoration,
    this.borderRadius,
  });
}

List<Country> _countryList = countryCodes.map((country) => Country.from(json: country)).toList();

class CountryPickUtils {
  static Country getCountryByIsoCode(String countryCode) {
    try {
      return _countryList.firstWhere(
        (country) => country.countryCode.toLowerCase() == countryCode.toLowerCase(),
      );
    } catch (error) {
      throw Exception("The initialValue provided is not a supported iso code!");
    }
  }
}

class CountryListView extends StatefulWidget {
  /// Called when a country is select.
  ///
  /// The country picker passes the new value to the callback.
  final ValueChanged<Country> onSelect;

  /// An optional [showPhoneCode] argument can be used to show phone code.
  final bool showPhoneCode;

  /// An optional [exclude] argument can be used to exclude(remove) one ore more
  /// country from the countries list. It takes a list of country code(iso2).
  /// Note: Can't provide both [exclude] and [countryFilter]
  final List<String>? exclude;

  /// An optional [countryFilter] argument can be used to filter the
  /// list of countries. It takes a list of country code(iso2).
  /// Note: Can't provide both [countryFilter] and [exclude]
  final List<String>? countryFilter;

  /// An optional argument for customizing the
  /// country list bottom sheet.
  final CountryListThemeData? countryListTheme;

  /// An optional argument for initially expanding virtual keyboard
  final bool searchAutofocus;

  const CountryListView({
    Key? key,
    required this.onSelect,
    this.exclude,
    this.countryFilter,
    this.showPhoneCode = false,
    this.countryListTheme,
    this.searchAutofocus = false,
  })  : assert(exclude == null || countryFilter == null,
            'Cannot provide both exclude and countryFilter'),
        super(key: key);

  @override
  _CountryListViewState createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  late List<Country> _countryList;
  late List<Country> _filteredList;
  late TextEditingController _searchController;
  late bool _searchAutofocus;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _countryList =
        countryCodes.map((country) => Country.from(json: country)).toList();

    //Remove duplicates country if not use phone code
    if (!widget.showPhoneCode) {
      final ids = _countryList.map((e) => e.countryCode).toSet();
      _countryList.retainWhere((country) => ids.remove(country.countryCode));
    }

    if (widget.exclude != null) {
      _countryList.removeWhere(
          (element) => widget.exclude!.contains(element.countryCode));
    }
    if (widget.countryFilter != null) {
      _countryList.removeWhere(
          (element) => !widget.countryFilter!.contains(element.countryCode));
    }

    _filteredList = <Country>[];
    _filteredList.addAll(_countryList);

    _searchAutofocus = widget.searchAutofocus;
  }

  @override
  Widget build(BuildContext context) {
    final String searchLabel =
        CountryLocalizations.of(context)?.countryName(countryCode: 'search') ??
            'Search';

    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            autofocus: _searchAutofocus,
            controller: _searchController,
            decoration: widget.countryListTheme?.inputDecoration ??
                InputDecoration(
                  labelText: searchLabel,
                  hintText: searchLabel,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xFF8C98A8).withOpacity(0.2),
                    ),
                  ),
                ),
            onChanged: _filterSearchResults,
          ),
        ),
        Expanded(
          child: ListView(
            children: _filteredList
                .map<Widget>((country) => _listRow(country))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _listRow(Country country) {
    final TextStyle _textStyle =
        widget.countryListTheme?.textStyle ?? _defaultTextStyle;

    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      // Add Material Widget with transparent color
      // so the ripple effect of InkWell will show on tap
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          country.nameLocalized = CountryLocalizations.of(context)
              ?.countryName(countryCode: country.countryCode)
              ?.replaceAll(RegExp(r"\s+"), " ");
          widget.onSelect(country);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 20),
              SizedBox(
                // the conditional 50 prevents irregularities caused by the flags in RTL mode
                width: isRtl ? 50 : null,
                child: Text(
                  Utils.countryCodeToEmoji(country.countryCode),
                  style: TextStyle(
                    fontSize: widget.countryListTheme?.flagSize ?? 25,
                  ),
                ),
              ),
              if (widget.showPhoneCode) ...[
                const SizedBox(width: 15),
                SizedBox(
                  width: 45,
                  child: Text(
                    '${isRtl ? '' : '+'}${country.phoneCode}${isRtl ? '+' : ''}',
                    style: _textStyle,
                  ),
                ),
                const SizedBox(width: 5),
              ] else
                const SizedBox(width: 15),
              Expanded(
                child: Text(
                  CountryLocalizations.of(context)
                          ?.countryName(countryCode: country.countryCode)
                          ?.replaceAll(RegExp(r"\s+"), " ") ??
                      country.name,
                  style: _textStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _filterSearchResults(String query) {
    List<Country> _searchResult = <Country>[];
    final CountryLocalizations? localizations =
        CountryLocalizations.of(context);

    if (query.isEmpty) {
      _searchResult.addAll(_countryList);
    } else {
      _searchResult = _countryList
          .where((c) => c.startsWith(query, localizations))
          .toList();
    }

    setState(() => _filteredList = _searchResult);
  }

  get _defaultTextStyle => const TextStyle(fontSize: 16);
}

class Utils {
  static String countryCodeToEmoji(String countryCode) {
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}

class Country {
  ///The country phone code
  final String phoneCode;

  ///The country code, ISO (alpha-2)
  final String countryCode;
  final int e164Sc;
  final bool geographic;
  final int level;

  ///The country name in English
  final String name;

  ///The country name localized
  late String? nameLocalized;

  ///An example of a telephone number without the phone code
  final String example;

  ///Country name (country code) [phone code]
  final String displayName;

  ///An example of a telephone number with the phone code and plus sign
  final String? fullExampleWithPlusSign;

  ///Country name (country code)

  final String displayNameNoCountryCode;
  final String e164Key;

  @Deprecated('The modern term is displayNameNoCountryCode. '
      'This feature was deprecated after v1.0.6.')
  String get displayNameNoE164Cc => displayNameNoCountryCode;

  String? getTranslatedName(BuildContext context) {
    return CountryLocalizations.of(context)
        ?.countryName(countryCode: countryCode);
  }

  Country({
    required this.phoneCode,
    required this.countryCode,
    required this.e164Sc,
    required this.geographic,
    required this.level,
    required this.name,
    this.nameLocalized = '',
    required this.example,
    required this.displayName,
    required this.displayNameNoCountryCode,
    required this.e164Key,
    this.fullExampleWithPlusSign,
  });

  Country.from({required Map<String, dynamic> json})
      : phoneCode = json['e164_cc'],
        countryCode = json['iso2_cc'],
        e164Sc = json['e164_sc'],
        geographic = json['geographic'],
        level = json['level'],
        name = json['name'],
        example = json['example'],
        displayName = json['display_name'],
        fullExampleWithPlusSign = json['full_example_with_plus_sign'],
        displayNameNoCountryCode = json['display_name_no_e164_cc'],
        e164Key = json['e164_key'];

  static Country parse(String country) {
    return CountryParser.parse(country);
  }

  static Country? tryParse(String country) {
    return CountryParser.tryParse(country);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['e164_cc'] = phoneCode;
    data['iso2_cc'] = countryCode;
    data['e164_sc'] = e164Sc;
    data['geographic'] = geographic;
    data['level'] = level;
    data['name'] = name;
    data['example'] = example;
    data['display_name'] = displayName;
    data['full_example_with_plus_sign'] = fullExampleWithPlusSign;
    data['display_name_no_e164_cc'] = displayNameNoCountryCode;
    data['e164_key'] = e164Key;
    return data;
  }

  bool startsWith(String query, CountryLocalizations? localizations) =>
      name.toLowerCase().startsWith(query.toLowerCase()) ||
      countryCode.toLowerCase().startsWith(query.toLowerCase()) ||
      (localizations
              ?.countryName(countryCode: countryCode)
              ?.toLowerCase()
              .startsWith(query.toLowerCase()) ??
          false);

  @override
  String toString() => 'Country(countryCode: $countryCode, name: $name)';

  @override
  bool operator ==(Object other) {
    if (other is Country) {
      return other.countryCode == countryCode;
    }

    return super == other;
  }
  
  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
  

}

class CountryLocalizations {
  final Locale locale;

  CountryLocalizations(this.locale);

  /// The `CountryLocalizations` from the closest [Localizations] instance
  /// that encloses the given context.
  ///
  /// This method is just a convenient shorthand for:
  /// `Localizations.of<CountryLocalizations>(context, CountryLocalizations)`.
  ///
  /// References to the localized resources defined by this class are typically
  /// written in terms of this method. For example:
  ///
  /// ```dart
  /// CountryLocalizations.of(context).countryName(countryCode: country.countryCode),
  /// ```
  static CountryLocalizations? of(BuildContext context) {
    return Localizations.of<CountryLocalizations>(
      context,
      CountryLocalizations,
    );
  }

  /// A [LocalizationsDelegate] that uses [_CountryLocalizationsDelegate.load]
  /// to create an instance of this class.
  static const LocalizationsDelegate<CountryLocalizations> delegate =
      _CountryLocalizationsDelegate();

  /// The localized country name for the given country code.
  String? countryName({required String countryCode}) {
    switch (locale.languageCode) {
      case 'zh':
        switch (locale.scriptCode) {
          case 'Hant':
            return tw[countryCode];
          case 'Hans':
          default:
            return cn[countryCode];
        }
      case 'el':
        return gr[countryCode];
      case 'es':
        return es[countryCode];
      case 'pt':
        return pt[countryCode];
      case 'nb':
        return nb[countryCode];
      case 'nn':
        return nn[countryCode];
      case 'uk':
        return uk[countryCode];
      case 'pl':
        return pl[countryCode];
      case 'tr':
        return tr[countryCode];
      case 'ru':
        return ru[countryCode];
      case 'hi':
      case 'ne':
        return np[countryCode];
      case 'ar':
        return ar[countryCode];
      case 'hr':
        return hr[countryCode];
      case 'vi':
        return vi[countryCode];
      case 'en':
      default:
        return en[countryCode];
    }
  }
}

class _CountryLocalizationsDelegate
    extends LocalizationsDelegate<CountryLocalizations> {
  const _CountryLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'ar',
      'zh',
      'el',
      'es',
      'pl',
      'pt',
      'nb',
      'nn',
      'ru',
      'uk',
      'hi',
      'ne',
      'tr',
      'hr',
      'vi',
    ].contains(locale.languageCode);
  }

  @override
  Future<CountryLocalizations> load(Locale locale) {
    final CountryLocalizations localizations = CountryLocalizations(locale);
    return Future.value(localizations);
  }

  @override
  bool shouldReload(_CountryLocalizationsDelegate old) => false;
}

class CountryParser {
  /// Returns a single country if [country] matches a country code or name.
  ///
  /// Throws an [ArgumentError] if no matching element is found.
  static Country parse(String country) {
    return tryParseCountryCode(country) ?? parseCountryName(country);
  }

  /// Returns a single country if [country] matches a country code or name.
  ///
  /// returns null if no matching element is found.
  static Country? tryParse(String country) {
    return tryParseCountryCode(country) ?? tryParseCountryName(country);
  }

  /// Returns a single country if it matches the given [countryCode] (iso2_cc).
  ///
  /// Throws a [StateError] if no matching element is found.
  static Country parseCountryCode(String countryCode) {
    return _getFromCode(countryCode.toUpperCase());
  }

  /// Returns a single country that matches the given [countryCode] (iso2_cc).
  ///
  /// Returns null if no matching element is found.
  static Country? tryParseCountryCode(String countryCode) {
    try {
      return parseCountryCode(countryCode);
    } catch (_) {
      return null;
    }
  }

  /// Returns a single country if it matches the given [countryName].
  ///
  /// Uses the application [context] to determine what language is used in the
  /// app, if provided, and checks the country names for this locale if any.
  /// If no match is found and no [locales] are given, the default language is
  /// checked (english), followed by the rest of the available translations. If
  /// any [locales] are given, only those supported languages are used, in
  /// addition to the [context] language.
  ///
  /// Throws an [ArgumentError] if no matching element is found.
  static Country parseCountryName(
    String countryName, {
    BuildContext? context,
    List<Locale>? locales,
  }) {
    final String countryNameLower = countryName.toLowerCase();

    final CountryLocalizations? localizations =
        context != null ? CountryLocalizations.of(context) : null;

    final String languageCode = _anyLocalizedNameToCode(
      countryNameLower,
      localizations?.locale,
      locales,
    );

    return _getFromCode(languageCode);
  }

  /// Returns a single country if it matches the given [countryName].
  ///
  /// Returns null if no matching element is found.
  static Country? tryParseCountryName(
    String countryName, {
    BuildContext? context,
    List<Locale>? locales,
  }) {
    try {
      return parseCountryName(countryName, context: context, locales: locales);
    } catch (_) {
      return null;
    }
  }

  /// Returns a country that matches the [countryCode] (iso2_cc).
  static Country _getFromCode(String countryCode) {
    return Country.from(
      json: countryCodes.singleWhere(
        (Map<String, dynamic> c) => c['iso2_cc'] == countryCode,
      ),
    );
  }

  /// Returns a country code that matches a country with the given [name] for
  /// any language, or the ones given by [locales]. If no locale list is given,
  /// the language for the [locale] is prioritized, followed by the default
  /// language, english.
  static String _anyLocalizedNameToCode(
    String name,
    Locale? locale,
    List<Locale>? locales,
  ) {
    String? code;

    if (locale != null) code = _localizedNameToCode(name, locale);
    if (code == null && locales == null) {
      code = _localizedNameToCode(name, const Locale('en'));
    }
    if (code != null) return code;

    final List<Locale> localeList = locales ?? <Locale>[];

    if (locales == null) {
      final List<Locale> exclude = <Locale>[const Locale('en')];
      if (locale != null) exclude.add(locale);
      localeList.addAll(_supportedLanguages(exclude: exclude));
    }

    return _nameToCodeFromGivenLocales(name, localeList);
  }

  /// Returns the country code that matches the given [name] for any of the
  /// [locales].
  ///
  /// Throws an [ArgumentError] if no matching element is found.
  static String _nameToCodeFromGivenLocales(String name, List<Locale> locales) {
    String? code;

    for (int i = 0; i < locales.length && code == null; i++) {
      code = _localizedNameToCode(name, locales[i]);
    }

    if (code == null) {
      throw ArgumentError.value('No country found');
    }

    return code;
  }

  /// Returns the code for the country that matches the given [name] in the
  /// language given by the [locale]. Defaults to english.
  ///
  /// Returns null if no match is found.
  static String? _localizedNameToCode(String name, Locale locale) {
    final Map<String, String> translation = _getTranslation(locale);

    String? code;

    translation.forEach((key, value) {
      if (value.toLowerCase() == name) code = key;
    });

    return code;
  }

  // ToDo: solution to prevent manual update on adding new localizations?
  /// Returns a translation for the given [locale]. Defaults to english.
  static Map<String, String> _getTranslation(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        switch (locale.scriptCode) {
          case 'Hant':
            return tw;
          case 'Hans':
          default:
            return cn;
        }
      case 'el':
        return gr;
      case 'ar':
        return ar;
      case 'es':
        return es;
      case 'pt':
        return pt;
      case 'nb':
        return nb;
      case 'nn':
        return nn;
      case 'uk':
        return uk;
      case 'pl':
        return pl;
      case 'tr':
        return tr;
      case 'hr':
        return hr;
      case 'ru':
        return ru;
      case 'vi':
        return vi;
      case 'hi':
      case 'ne':
        return np;
      case 'en':
      default:
        return en;
    }
  }

  // ToDo: solution to prevent manual update on adding new localizations?
  /// A list of the supported locales, except those included in the [exclude]
  /// list.
  static List<Locale> _supportedLanguages({
    List<Locale> exclude = const <Locale>[],
  }) {
    return <Locale>[
      const Locale('en'),
      const Locale('ar'),
      const Locale('es'),
      const Locale('el'),
      const Locale('nb'),
      const Locale('nn'),
      const Locale('pl'),
      const Locale('pt'),
      const Locale('ru'),
      const Locale('hi'),
      const Locale('ne'),
      const Locale('uk'),
      const Locale('tr'),
      const Locale('hr'),
      const Locale('vi'),
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    ]..removeWhere((Locale l) => exclude.contains(l));
  }
}
