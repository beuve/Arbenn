import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/components/scroller.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:arbenn/utils/colors.dart';
import 'package:flutter/material.dart' hide Autocomplete;

class CitySearchResult extends StatelessWidget {
  final City infos;
  final Function()? onTap;
  final Nuance color;

  const CitySearchResult({
    Key? key,
    required this.infos,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(15),
          child: Text(
            infos.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color.darker,
              fontSize: 15,
            ),
          ),
        ));
  }
}

class SearchCity extends StatefulWidget {
  final Nuance color;
  final Function(City) onFinish;

  const SearchCity({
    required this.color,
    required this.onFinish,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  late Autocomplete<City> _autocomplete;

  @override
  void dispose() {
    _autocomplete.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _autocomplete = City.autocomplete;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
      title: "Ville",
      color: widget.color,
      body: Stack(children: [
        Container(
            margin: const EdgeInsets.only(top: 70, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder<List<City>>(
                stream: _autocomplete.stream,
                builder: (context, snapshot) {
                  return ScrollList(
                      color: widget.color,
                      children: snapshot.hasData
                          ? snapshot.data!
                              .map((c) => CitySearchResult(
                                    infos: c,
                                    color: widget.color,
                                    onTap: () {
                                      widget.onFinish(c);
                                      Navigator.pop(context);
                                    },
                                  ))
                              .toList()
                          : []);
                })),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          margin: const EdgeInsets.only(top: 10),
          child: SearchInput(
            label: "Chercher une ville...",
            color: widget.color,
            controller: _autocomplete.controller,
          ),
        ),
      ]),
    );
  }
}

class AddressSearchResult extends StatelessWidget {
  final Address infos;
  final Function()? onTap;
  final Nuance color;

  const AddressSearchResult({
    Key? key,
    required this.infos,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.bottom,
                child:
                    Icon(ArbennIcons.location, size: 18, color: color.darker),
              ),
              TextSpan(
                text: " ${infos.toString()}",
                style: TextStyle(
                  color: color.darker,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchAddress extends StatefulWidget {
  final Nuance color;
  final Function(Address) onFinish;

  const SearchAddress({
    required this.color,
    required this.onFinish,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchAddress> createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  late Autocomplete<Address> _autocomplete;

  @override
  void dispose() {
    _autocomplete.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _autocomplete = Address.autocomplete;
    super.initState();
  }

  List<Widget> _addressSearchResults(List<Address> addresses) {
    List<Widget> result = [];
    for (var i = 0; i < addresses.length; i++) {
      result.add(AddressSearchResult(
          infos: addresses[i],
          color: widget.color,
          onTap: () {
            widget.onFinish(addresses[i]);
            Navigator.pop(context);
          }));
      if (i != addresses.length - 1) {
        result.add(Divider(
          thickness: 1,
          indent: 10,
          endIndent: 250,
          color: widget.color.light,
        ));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
      title: "Ville",
      color: widget.color,
      body: Stack(children: [
        Container(
            margin: const EdgeInsets.only(top: 70, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder<List<Address>>(
                stream: _autocomplete.stream,
                builder: (context, snapshot) {
                  return ScrollList(
                      color: widget.color,
                      children: snapshot.hasData
                          ? _addressSearchResults(snapshot.data!)
                          : []);
                })),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          margin: const EdgeInsets.only(top: 10),
          child: SearchInput(
            label: "Chercher une addresse...",
            color: widget.color,
            controller: _autocomplete.controller,
          ),
        ),
      ]),
    );
  }
}
