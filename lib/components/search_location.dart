import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/components/scroller.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:flutter/material.dart' hide Autocomplete;
import '../data/locations_data.dart';
import '../utils/colors.dart';

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
            "${infos.city} (${infos.cityCode})",
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
                      shadowColor: widget.color.darker,
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
