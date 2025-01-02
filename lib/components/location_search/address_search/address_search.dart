import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/location_search/address_search/_address_search_result.dart';
import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/components/scroller.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:flutter/material.dart' hide Autocomplete;

class SearchAddress extends StatefulWidget {
  final Function(Address) onFinish;

  const SearchAddress({
    required this.onFinish,
    super.key,
  });

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
          onTap: () {
            widget.onFinish(addresses[i]);
            Navigator.pop(context);
          }));
      if (i != addresses.length - 1) {
        result.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.3,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
      title: "Addresse",
      body: Stack(children: [
        Container(
            margin: const EdgeInsets.only(top: 80, bottom: 10),
            child: StreamBuilder<List<Address>>(
                stream: _autocomplete.stream,
                builder: (context, snapshot) {
                  return ScrollList(
                      children: snapshot.hasData
                          ? _addressSearchResults(snapshot.data!)
                          : []);
                })),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          margin: const EdgeInsets.only(top: 10),
          child: SearchInput(
            label: "Chercher une addresse...",
            controller: _autocomplete.controller,
          ),
        ),
      ]),
    );
  }
}
