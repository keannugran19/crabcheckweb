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

  bool isLoading = true;
  String activeTitle = "Total Crabs";

  @override
  void initState() {
    super.initState();
    fetchAllCounts();
    fetchCrabData();
  }

  Future<void> fetchAllCounts() async {
    Map<String, Future<int>> countFutures = {
      'Cardisoma Carnifex': firestoreService.fetchCount('Cardisoma Carnifex'),
      'Scylla Serrata': firestoreService.fetchCount('Scylla Serrata'),
      'Venitus Latreillei': firestoreService.fetchCount('Venitus Latreillei'),
      'Portunos Pelagicus': firestoreService.fetchCount('Portunos Pelagicus'),
      'Metopograpsus Spp': firestoreService.fetchCount('Metopograpsus Spp'),
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
      totalCount = counts.values.fold(0, (a, b) => a + b);
    });
  }

  Future<void> fetchCrabData() async {
    final documents = await firestoreService.fetchCrabData();
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
    fetchAllCounts();
    fetchCrabData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    late List<double> graphData;
    late String graphTitle;

    // widget style
    var textStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
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
        Align(
          alignment: Alignment.topRight,
          child: ElevatedButton(
              onPressed: restart,
              child: Icon(
                Icons.restart_alt,
                color: colorScheme.primary,
              )),
        ),

        const SizedBox(
          height: 10,
        ),

        // first row displayed
        Row(
          children: [
            InfoCard(
              image: 'lib/assets/images/loginbackground.png',
              title: "Total Crabs",
              value: totalCount.toString(),
              topColor: Colors.grey,
              isActive: activeTitle == "Total Crabs",
              onTap: () {
                setState(() {
                  activeTitle = "Total Crabs";
                });
              },
            ),
          ],
        ),

        const SizedBox(
          height: 20,
        ),

        //* second row displayed
        Row(
          children: [
            InfoCard(
              image: 'lib/assets/images/crabs/cardisomaCarnifex.jpg',
              title: "Cardisoma Carnifex",
              value: cardisomaCarnifexCount.toString(),
              topColor: Colors.orange,
              isActive: activeTitle == "Cardisoma Carnifex",
              onTap: () {
                setState(() {
                  activeTitle = "Cardisoma Carnifex";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              image: 'lib/assets/images/crabs/scyllaSerrata.jpg',
              title: "Scylla Serrata",
              value: scyllaSerrataCount.toString(),
              topColor: Colors.brown,
              isActive: activeTitle == "Scylla Serrata",
              onTap: () {
                setState(() {
                  activeTitle = "Scylla Serrata";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              image: 'lib/assets/images/crabs/portunosPelagicus.jpg',
              title: "Portunos Pelagicus",
              value: portunosPelagicusCount.toString(),
              topColor: Colors.blue,
              isActive: activeTitle == "Portunos Pelagicus",
              onTap: () {
                setState(() {
                  activeTitle = "Portunos Pelagicus";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              image: 'lib/assets/images/crabs/venitusLatreillei.jpeg',
              title: "Venitus Latreillei",
              value: venitusLatreilleiCount.toString(),
              topColor: Colors.yellow,
              isActive: activeTitle == "Venitus Latreillei",
              onTap: () {
                setState(() {
                  activeTitle = "Venitus Latreillei";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              image: 'lib/assets/images/crabs/metopograpsusSp.jpeg',
              title: "Metopograpsus Spp",
              value: metopograpsusSppCount.toString(),
              topColor: Colors.purple,
              isActive: activeTitle == "Metopograpsus Spp",
              onTap: () {
                setState(() {
                  activeTitle = "Metopograpsus Spp";
                });
              },
            ),
          ],
        ),

        const SizedBox(
          height: 20,
        ),

        Column(
          children: [
            // Bar Graph Container
            Text(
              "Total Crab count(per month):",
              style: textStyle,
            ),
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20.0),
              child: BarGraph(
                totalCrabs: graphData, // Pass the dynamically selected data
                activeTitle: graphTitle,
              ),
            ),

            const SizedBox(height: 20),

            // Pie Chart Container
            Text(
              "Total Crab count(per species):",
              style: textStyle,
            ),
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20.0),
              child: PieChartDisplay(
                cardisomaCarnifexCount: cardisomaCarnifexCount,
                scyllaSerrataCount: scyllaSerrataCount,
                venitusLatreilleiCount: venitusLatreilleiCount,
                portunosPelagicusCount: portunosPelagicusCount,
                metopograpsusSppCount: metopograpsusSppCount,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
