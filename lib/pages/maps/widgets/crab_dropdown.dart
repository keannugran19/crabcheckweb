import 'package:flutter/material.dart';

class CrabSpeciesDropdown extends StatelessWidget {
  final String selectedSpecies;
  final ValueChanged<String> onSelectedSpeciesChanged;

  const CrabSpeciesDropdown({
    required this.selectedSpecies,
    required this.onSelectedSpeciesChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> crabSpecies = [
      'All',
      'Cardisoma Carnifex',
      'Scylla Serrata',
      'Venitus Latreillei',
      'Portunos Pelagicus',
      'Metopograpsus Spp',
    ];

    return DropdownButton<String>(
      value: selectedSpecies,
      onChanged: (String? newValue) {
        if (newValue != null) {
          onSelectedSpeciesChanged(newValue);
        }
      },
      items: crabSpecies.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
