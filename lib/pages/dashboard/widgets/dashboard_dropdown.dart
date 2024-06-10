import 'package:flutter/material.dart';

const List<String> list = <String>[
  'All',
  'Scylla serrata',
  'Scylla olivacea',
  'Scylla Paramamosain',
  'Portunos Pelagicus',
  'Zosimus Aeneus '
];

class DropdownMenuDashboard extends StatefulWidget {
  const DropdownMenuDashboard({super.key});

  @override
  State<DropdownMenuDashboard> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuDashboard> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
