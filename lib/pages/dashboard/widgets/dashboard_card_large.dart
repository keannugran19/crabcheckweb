import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_graph.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/info_card.dart';
import 'package:crabcheckweb1/pages/dashboard/pieChart/pie_chart.dart';
import 'package:crabcheckweb1/services/firestore.dart';
import 'package:flutter/material.dart';

class DashboardPageLargeScreen extends StatefulWidget {
  const DashboardPageLargeScreen({super.key});

  @override
  State<DashboardPageLargeScreen> createState() =>
      _DashboardPageLargeScreenState();
}

class _DashboardPageLargeScreenState extends State<DashboardPageLargeScreen> {
  // initiate firestore
  final FirestoreService firestoreService = FirestoreService();

  // selected year
  String selectedYear = '2024';

// Monthly counts for each species
  List<double> totalCrabs = List<double>.filled(12, 0);
  List<double> cardisomaCarnifex = List<double>.filled(12, 0);
  List<double> scyllaSerrata = List<double>.filled(12, 0);
  List<double> venitusLatreillei = List<double>.filled(12, 0);
  List<double> portunosPelagicus = List<double>.filled(12, 0);
  List<double> metopograpsusSpp = List<double>.filled(12, 0);

// Total counts for each species
  int cardisomaCarnifexCount = 0;
  int scyllaSerrataCount = 0;
  int venitusLatreilleiCount = 0;
  int portunosPelagicusCount = 0;
  int metopograpsusSppCount = 0;
  int totalCount = 0;
  int unclassifiedCount = 0;

  bool isLoading = true;
  String activeTitle = "Total Crabs";

  @override
  void initState() {
    super.initState();
    selectedYear = '2024';
    fetchAllCounts(selectedYear);
    fetchCrabData(selectedYear);
  }

  Future<void> fetchAllCounts(String selectedYear) async {
    Map<String, Future<int>> countFutures = {
      'Cardisoma Carnifex':
          firestoreService.fetchCount('Cardisoma Carnifex', selectedYear),
      'Scylla Serrata':
          firestoreService.fetchCount('Scylla Serrata', selectedYear),
      'Venitus Latreillei':
          firestoreService.fetchCount('Venitus Latreillei', selectedYear),
      'Portunos Pelagicus':
          firestoreService.fetchCount('Portunos Pelagicus', selectedYear),
      'Metopograpsus Spp':
          firestoreService.fetchCount('Metopograpsus Spp', selectedYear),
      'Unclassified': firestoreService.fetchReportCount(),
    };

    Map<String, int> counts = {
      for (var entry in countFutures.entries) entry.key: await entry.value,
    };

    setState(() {
      cardisomaCarnifexCount = counts['Cardisoma Carnifex'] ?? 0;
      scyllaSerrataCount = counts['Scylla Serrata'] ?? 0;
      venitusLatreilleiCount = counts['Venitus Latreillei'] ?? 0;
      portunosPelagicusCount = counts['Portunos Pelagicus'] ?? 0;
      metopograpsusSppCount = counts['Metopograpsus Spp'] ?? 0;
      totalCount = cardisomaCarnifexCount +
          scyllaSerrataCount +
          venitusLatreilleiCount +
          portunosPelagicusCount +
          metopograpsusSppCount;
      unclassifiedCount = counts['Unclassified'] ?? 0;
    });
  }

  Future<void> fetchCrabData(String selectedYear) async {
    final documents = await firestoreService.fetchCrabDataForYear(selectedYear);
    processCrabData(documents);
  }

  void processCrabData(List<QueryDocumentSnapshot> documents) {
    resetMonthlyCounts(totalCrabs, cardisomaCarnifex, scyllaSerrata,
        venitusLatreillei, portunosPelagicus, metopograpsusSpp);

    for (var doc in documents) {
      DateTime dateTime = (doc['timestamp'] as Timestamp).toDate();
      int monthIndex = dateTime.month - 1; // Convert month to 0-based index

      String species = doc['species'];
      incrementSpeciesCount(species, monthIndex);
      totalCrabs[monthIndex]++;
    }

    setState(() {});
  }

  void resetMonthlyCounts(
      List<double> totalCrabs,
      List<double> cardisomaCarnifex,
      List<double> scyllaSerrata,
      List<double> venitusLatreillei,
      List<double> portunosPelagicus,
      List<double> metopograpsusSpp) {
    totalCrabs.fillRange(0, 12, 0);
    cardisomaCarnifex.fillRange(0, 12, 0);
    scyllaSerrata.fillRange(0, 12, 0);
    venitusLatreillei.fillRange(0, 12, 0);
    portunosPelagicus.fillRange(0, 12, 0);
    metopograpsusSpp.fillRange(0, 12, 0);
  }

  void incrementSpeciesCount(String species, int monthIndex) {
    switch (species) {
      case 'Cardisoma Carnifex':
        cardisomaCarnifex[monthIndex]++;
        break;
      case 'Scylla Serrata':
        scyllaSerrata[monthIndex]++;
        break;
      case 'Venitus Latreillei':
        venitusLatreillei[monthIndex]++;
        break;
      case 'Portunos Pelagicus':
        portunosPelagicus[monthIndex]++;
        break;
      case 'Metopograpsus Spp':
        metopograpsusSpp[monthIndex]++;
        break;
    }
  }

// Restart the dashboard state
  void restart() {
    setState(() => isLoading = true);
    selectedYear = selectedYear;
    fetchAllCounts(selectedYear);
    fetchCrabData(selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    late List<double> graphData;
    late String graphTitle;

    // reusable widgets
    var containerBoxDecoration = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    );

    // Determine which data to display based on the selected title
    if (activeTitle.contains('Cardisoma Carnifex')) {
      graphTitle = 'Cardisoma Carnifex';
      graphData = cardisomaCarnifex;
    } else if (activeTitle.contains('Scylla Serrata')) {
      graphTitle = 'Scylla Serrata';
      graphData = scyllaSerrata;
    } else if (activeTitle.contains('Venitus Latreillei')) {
      graphTitle = 'Venitus Latreillei';
      graphData = venitusLatreillei;
    } else if (activeTitle.contains('Portunos Pelagicus')) {
      graphTitle = 'Portunos Pelagicus';
      graphData = portunosPelagicus;
    } else if (activeTitle.contains('Metopograpsus Spp')) {
      graphTitle = 'Metopograpsus Spp';
      graphData = metopograpsusSpp;
    } else {
      // Default to Total Crabs
      graphTitle = 'Total Crabs';
      graphData = totalCrabs;
    }

//* DASHBOARD
    return Column(
      children: [
        // Page restart button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: selectedYear,
              items: ['2024', '2025', '2026'].map((String year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedYear = newValue!;
                  fetchCrabData(selectedYear);
                  fetchAllCounts(selectedYear);
                });
              },
            ),
            ElevatedButton(
                onPressed: restart,
                child: Icon(
                  Icons.restart_alt,
                  color: colorScheme.primary,
                )),
          ],
        ),

        const SizedBox(
          height: 10,
        ),

// first row displayed
        Row(
          children: [
            Expanded(
              flex: 4,
              child: InfoCard(
                image: 'lib/assets/images/loginbackground.png',
                title: "Total Crabs",
                value: totalCount,
                topColor: Colors.grey,
                isActive: activeTitle == "Total Crabs",
                onTap: () {
                  setState(() {
                    activeTitle = "Total Crabs";
                  });
                },
              ),
            ),
            SizedBox(
              width: width / 64,
            ),
            Expanded(
              flex: 2,
              child: InfoCard(
                image: 'lib/assets/images/unclassified.jpg',
                title: "Unclassified",
                value: unclassifiedCount,
                topColor: Colors.red,
                isActive: false,
                onTap: () {
                  // Handle tap
                },
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 20,
        ),

        //* second row displayed
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InfoCard(
                image: 'lib/assets/images/crabs/cardisomaCarnifex.jpg',
                title: "Cardisoma Carnifex",
                value: cardisomaCarnifexCount,
                topColor: Colors.orange,
                isActive: activeTitle == "Cardisoma Carnifex",
                onTap: () {
                  setState(() {
                    activeTitle = "Cardisoma Carnifex";
                  });
                },
              ),
            ),
            SizedBox(
              width: width / 64,
            ),
            Expanded(
              flex: 1,
              child: InfoCard(
                image: 'lib/assets/images/crabs/scyllaSerrata.jpg',
                title: "Scylla Serrata",
                value: scyllaSerrataCount,
                topColor: Colors.brown,
                isActive: activeTitle == "Scylla Serrata",
                onTap: () {
                  setState(() {
                    activeTitle = "Scylla Serrata";
                  });
                },
              ),
            ),
            SizedBox(
              width: width / 64,
            ),
            Expanded(
              flex: 1,
              child: InfoCard(
                image: 'lib/assets/images/crabs/portunosPelagicus.jpg',
                title: "Portunos Pelagicus",
                value: portunosPelagicusCount,
                topColor: Colors.blue,
                isActive: activeTitle == "Portunos Pelagicus",
                onTap: () {
                  setState(() {
                    activeTitle = "Portunos Pelagicus";
                  });
                },
              ),
            ),
            SizedBox(
              width: width / 64,
            ),
            Expanded(
              flex: 1,
              child: InfoCard(
                image: 'lib/assets/images/crabs/venitusLatreillei.jpeg',
                title: "Venitus Latreillei",
                value: venitusLatreilleiCount,
                topColor: Colors.yellow,
                isActive: activeTitle == "Venitus Latreillei",
                onTap: () {
                  setState(() {
                    activeTitle = "Venitus Latreillei";
                  });
                },
              ),
            ),
            SizedBox(
              width: width / 64,
            ),
            Expanded(
              flex: 1,
              child: InfoCard(
                image: 'lib/assets/images/crabs/metopograpsusSp.jpeg',
                title: "Metopograpsus Spp",
                value: metopograpsusSppCount,
                topColor: Colors.purple,
                isActive: activeTitle == "Metopograpsus Spp",
                onTap: () {
                  setState(() {
                    activeTitle = "Metopograpsus Spp";
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 20,
        ),

        Row(
          children: [
            // Bar Graph Container
            Expanded(
              flex: 3,
              child: Container(
                height: 400,
                decoration: containerBoxDecoration,
                padding: const EdgeInsets.all(20.0),
                child: BarGraph(
                  totalCrabs: graphData,
                  activeTitle: graphTitle,
                ),
              ),
            ),

            const SizedBox(width: 20),

            // Pie Chart Container
            Expanded(
              flex: 2,
              child: Container(
                height: 400,
                decoration: containerBoxDecoration,
                padding: const EdgeInsets.all(20.0),
                child: PieChartDisplay(
                  metopograpsusSppCount: metopograpsusSppCount,
                  portunosPelagicusCount: portunosPelagicusCount,
                  cardisomaCarnifexCount: cardisomaCarnifexCount,
                  scyllaSerrataCount: scyllaSerrataCount,
                  venitusLatreilleiCount: venitusLatreilleiCount,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
