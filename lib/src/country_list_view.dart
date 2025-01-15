import 'package:country_picker/src/res/country_codes.dart';
import 'package:country_picker/src/utils.dart';
import 'package:flutter/material.dart';

import '../country_picker.dart';

typedef CustomFlagBuilder = Widget Function(Country country);

class CountryListView extends StatefulWidget {
  const CountryListView({Key? key,
    required this.onSelect,
    required this.scrollController,
    this.exclude,
    this.favorite,
    this.chosen,
    this.countryFilter,
    this.showPhoneCode = false,
    this.showFlag = false,
    this.countryListTheme,
    this.searchAutofocus = false,
    this.showWorldWide = false,
    this.showSearch = true,
    this.customFlagBuilder,
  }) : assert(
  exclude == null || countryFilter == null,
  'Cannot provide both exclude and countryFilter',
  ), super(key: key);

  /// Called when a country is select.
  ///
  /// The country picker passes the new value to the callback.
  final ValueChanged<Country> onSelect;

  /// An optional [showPhoneCode] argument can be used to show phone code.
  final bool showPhoneCode;

  /// An optional [showFlag] argument can be used to show flag.
  final bool showFlag;

  /// An optional [exclude] argument can be used to exclude(remove) one ore more
  /// country from the countries list. It takes a list of country code(iso2).
  /// Note: Can't provide both [exclude] and [countryFilter]
  final List<String>? exclude;

  /// An optional [countryFilter] argument can be used to filter the
  /// list of countries. It takes a list of country code(iso2).
  /// Note: Can't provide both [countryFilter] and [exclude]
  final List<String>? countryFilter;

  /// An optional [favorite] argument can be used to show countries
  /// at the top of the list. It takes a list of country code(iso2).
  final List<String>? favorite;

  /// An optional [chosen] argument can be used to highlight countries
  /// in the list. It takes a list of country code(iso2).
  final List<String>? chosen;

  /// An optional argument for customizing the
  /// country list bottom sheet.
  final CountryListThemeData? countryListTheme;

  /// An optional argument for initially expanding virtual keyboard
  final bool searchAutofocus;

  /// An optional argument for showing "World Wide" option at the beginning of the list
  final bool showWorldWide;

  /// An optional argument for hiding the search bar
  final bool showSearch;

  /// Custom builder function for flag widget
  final CustomFlagBuilder? customFlagBuilder;

  /// Draggable scrollController
  final ScrollController scrollController;

  @override
  State<CountryListView> createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  final CountryService _countryService = CountryService();

  late List<Country> _countryList;
  late List<Country> _filteredList;
  List<Country>? _favoriteList;
  late TextEditingController _searchController;
  late bool _searchAutofocus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _countryList = _countryService.getAll();

    _countryList =
        countryCodes.map((country) => Country.from(json: country)).toList();

    //Remove duplicates country if not use phone code
    if (!widget.showPhoneCode) {
      final ids = _countryList.map((e) => e.countryCode).toSet();
      _countryList.retainWhere((country) => ids.remove(country.countryCode));
    }

    if (widget.favorite != null) {
      _favoriteList = _countryService.findCountriesByCode(widget.favorite!);
    }

    if (widget.exclude != null) {
      _countryList.removeWhere(
            (element) => widget.exclude!.contains(element.countryCode),
      );
    }

    if (widget.countryFilter != null) {
      _countryList.removeWhere(
            (element) => !widget.countryFilter!.contains(element.countryCode),
      );
    }

    _filteredList = <Country>[];
    if (widget.showWorldWide) {
      _filteredList.add(Country.worldWide);
    }
    _filteredList.addAll(_countryList);

    _searchAutofocus = widget.searchAutofocus;
  }

  @override
  Widget build(BuildContext context) {
    final containsCountry = _filteredList
        .any((country) => country.name == _favoriteList?.first.name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 36),
        if (widget.showSearch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: _searchAutofocus,
              controller: _searchController,
              cursorColor: const Color(0xff313135),
              textAlignVertical: TextAlignVertical.center,
              style:
              widget.countryListTheme?.searchTextStyle ?? _defaultTextStyle,
              decoration: widget.countryListTheme?.inputDecoration?.copyWith(
                suffixIcon:  _searchController.selection.baseOffset > 0 ||
                    _searchController.selection.extentOffset > 0 ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _filterSearchResults('');
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.cancel,
                      size: 24,
                      color: Color(0xff545B73),
                    ),
                  ),
                ) : const SizedBox(),
              ),
              onChanged: _filterSearchResults,
            ),
          ),
        const SizedBox(height: 16),
        const Divider(
          thickness: 1,
          height: 1,
          color: Color(0xffE8E9ED),
        ),
        if (_filteredList.isNotEmpty)
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16.0),
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              children: [
                if (_favoriteList != null && containsCountry) ...[
                  ..._favoriteList!.map<Widget>(buildItem),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(
                      thickness: 1,
                      height: 32,
                      color: Color(0xffE8E9ED),
                    ),
                  ),
                ],
                ..._filteredList.map<Widget>(
                  buildItem,
                ),
              ],
            ),
          ),
        if (_filteredList.isEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 56, left: 56, top: 120),
            child: Text(
              'No results found.\nPlease check your request to '
                  'make sure it\'s correct.',
              style: widget.countryListTheme?.textStyle
                  ?.copyWith(fontSize: 14, color: const Color(0xff757680)),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget buildItem(Country country) {
    return country.countryCode == widget.chosen?.first ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xff3170D3).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(child: _listRow(country, isFavorite: true)),
            const Row(
              children: [
                Icon(
                  Icons.check_rounded,
                  color: Color(0xff1C4483),
                ),
                SizedBox(
                  width: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    ) : _listRow(country);
  }

  Widget _listRow(Country country, {bool isFavorite = false}) {
    final textStyle = widget.countryListTheme?.textStyle ?? _defaultTextStyle;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final showFlag = widget.showFlag;

    return Material(
      // Add Material Widget with transparent color
      // so the ripple effect of InkWell will show on tap
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          country.nameLocalized = CountryLocalizations.of(context)
              ?.countryName(countryCode: country.countryCode)
              ?.replaceAll(RegExp(r'\s+'), ' ');
          widget.onSelect(country);
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: isFavorite ? 12 : 28,
          ),
          child: Row(
            children: <Widget>[
              if (showFlag) Row(
                children: [
                  if (widget.customFlagBuilder == null)
                    _flagWidget(country)
                  else
                    widget.customFlagBuilder!(country),
                ],
              ) else const SizedBox(height: 48,),
              SizedBox(width: showFlag ? 8 : 0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CountryLocalizations.of(context)
                          ?.countryName(countryCode: country.countryCode)
                          ?.replaceAll(RegExp(r'\s+'), ' ') ??
                          country.name,
                      style: isFavorite
                          ? textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff1C4483),
                      )
                          : textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (widget.showPhoneCode && !country.iswWorldWide) ...[
                      const SizedBox(width: 15),
                      SizedBox(
                        width: 45,
                        child: Text(
                          '${isRtl ? '' : '+'}${country.phoneCode}${isRtl ? '+' : ''}',
                          style: textStyle.copyWith(
                            color: const Color(0xff757680),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ] else
                      const SizedBox(width: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flagWidget(Country country) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      // the conditional 50 prevents irregularities caused by the flags in RTL mode
      width: isRtl ? 50 : null,
      child: _emojiText(country),
    );
  }

  Widget _emojiText(Country country) => Text(
    country.iswWorldWide
        ? '\uD83C\uDF0D'
        : Utils.countryCodeToEmoji(country.countryCode),
    style: TextStyle(
      fontSize: widget.countryListTheme?.flagSize ?? 25,
      fontFamilyFallback: widget.countryListTheme?.emojiFontFamilyFallback,
    ),
  );

  void _filterSearchResults(String query) {
    var searchResult = <Country>[];
    final localizations = CountryLocalizations.of(context);

    if (query.isEmpty) {
      searchResult.addAll(_countryList);
    } else {
      searchResult = _countryList
          .where((c) => c.startsWith(query, localizations))
          .toList();
    }

    setState(() => _filteredList = searchResult);
  }

  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 16);
}
