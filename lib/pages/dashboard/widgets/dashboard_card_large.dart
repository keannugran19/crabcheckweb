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
  List<double> charybdisFeriatus = List<double>.filled(12, 0);
  List<double> scyllaOlivacea = List<double>.filled(12, 0);
  List<double> scyllaParamamosain = List<double>.filled(12, 0);
  List<double> portunosPelagicus = List<double>.filled(12, 0);
  List<double> zosimusAeneus = List<double>.filled(12, 0);

// Total counts for each species
  int charybdisFeriatusCount = 0;
  int scyllaOlivaceaCount = 0;
  int scyllaParamamosainCount = 0;
  int portunosPelagicusCount = 0;
  int zosimusAeneusCount = 0;
  int totalCount = 0;

  bool isLoading = true;
  String activeTitle = '';

  @override
  void initState() {
    super.initState();
    fetchAllCounts();
    fetchCrabData();
  }

  Future<void> fetchAllCounts() async {
    Map<String, Future<int>> countFutures = {
      'Charybdis Feriatus': firestoreService.fetchCount('Charybdis Feriatus'),
      'Scylla Olivacea': firestoreService.fetchCount('Scylla Olivacea'),
      'Scylla Paramamosain': firestoreService.fetchCount('Scylla Paramamosain'),
      'Portunos Pelagicus': firestoreService.fetchCount('Portunos Pelagicus'),
      'Zosimus Aeneus': firestoreService.fetchCount('Zosimus Aeneus'),
    };

    Map<String, int> counts = {
      for (var entry in countFutures.entries) entry.key: await entry.value,
    };

    setState(() {
      charybdisFeriatusCount = counts['Charybdis Feriatus'] ?? 0;
      scyllaOlivaceaCount = counts['Scylla Olivacea'] ?? 0;
      scyllaParamamosainCount = counts['Scylla Paramamosain'] ?? 0;
      portunosPelagicusCount = counts['Portunos Pelagicus'] ?? 0;
      zosimusAeneusCount = counts['Zosimus Aeneus'] ?? 0;
      totalCount = counts.values.fold(0, (a, b) => a + b);
    });
  }

  Future<void> fetchCrabData() async {
    final documents = await firestoreService.fetchCrabData();
    processCrabData(documents);
  }

  void processCrabData(List<QueryDocumentSnapshot> documents) {
    resetMonthlyCounts();

    for (var doc in documents) {
      DateTime dateTime = (doc['timestamp'] as Timestamp).toDate();
      int monthIndex = dateTime.month - 1; // Convert month to 0-based index

      String species = doc['species'];
      incrementSpeciesCount(species, monthIndex);
      totalCrabs[monthIndex]++;
    }

    setState(() {});
  }

  void resetMonthlyCounts() {
    totalCrabs.fillRange(0, 12, 0);
    charybdisFeriatus.fillRange(0, 12, 0);
    scyllaOlivacea.fillRange(0, 12, 0);
    scyllaParamamosain.fillRange(0, 12, 0);
    portunosPelagicus.fillRange(0, 12, 0);
    zosimusAeneus.fillRange(0, 12, 0);
  }

  void incrementSpeciesCount(String species, int monthIndex) {
    switch (species) {
      case 'Charybdis Feriatus':
        charybdisFeriatus[monthIndex]++;
        break;
      case 'Scylla Olivacea':
        scyllaOlivacea[monthIndex]++;
        break;
      case 'Scylla Paramamosain':
        scyllaParamamosain[monthIndex]++;
        break;
      case 'Portunos Pelagicus':
        portunosPelagicus[monthIndex]++;
        break;
      case 'Zosimus Aeneus':
        zosimusAeneus[monthIndex]++;
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

    void updateGraphData() {
      // Determine which data to display based on the selected title
      if (activeTitle.contains('Charybdis Feriatus')) {
        graphTitle = 'Charybdis Feriatus';
        graphData = charybdisFeriatus;
      } else if (activeTitle.contains('Scylla Olivacea')) {
        graphTitle = 'Scylla Olivacea';
        graphData = scyllaOlivacea;
      } else if (activeTitle.contains('Scylla Paramamosain')) {
        graphTitle = 'Scylla Paramamosain';
        graphData = scyllaParamamosain;
      } else if (activeTitle.contains('Portunos Pelagicus')) {
        graphTitle = 'Portunos Pelagicus';
        graphData = portunosPelagicus;
      } else if (activeTitle.contains('Zosimus Aeneus')) {
        graphTitle = 'Zosimus Aeneus';
        graphData = zosimusAeneus;
      } else {
        // Default to Total Crabs
        graphTitle = 'Total Crabs';
        graphData = totalCrabs;
      }

      setState(() {});
    }

    updateGraphData();

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
              title: "Charybdis Feriatus",
              value: charybdisFeriatusCount.toString(),
              topColor: Colors.brown,
              isActive: activeTitle == "Charybdis Feriatus",
              onTap: () {
                setState(() {
                  activeTitle = "Charybdis Feriatus";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              title: "Scylla Olivacea",
              value: scyllaOlivaceaCount.toString(),
              topColor: Colors.orange,
              isActive: activeTitle == "Scylla Olivacea",
              onTap: () {
                setState(() {
                  activeTitle = "Scylla Olivacea";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              title: "Scylla Paramamosain",
              value: scyllaParamamosainCount.toString(),
              topColor: Colors.green,
              isActive: activeTitle == "Scylla Paramamosain",
              onTap: () {
                setState(() {
                  activeTitle = "Scylla Paramamosain";
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
              title: "Zosimus Aeneus",
              value: zosimusAeneusCount.toString(),
              topColor: Colors.purple,
              isActive: activeTitle == "Zosimus Aeneus",
              onTap: () {
                setState(() {
                  activeTitle = "Zosimus Aeneus";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              title: "Total Crabs",
              value: totalCount.toString(),
              topColor: Colors.white,
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

        Column(
          children: [
            // * BAR GRAPH CONTAINER
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: BarGraph(
                  totalCrabs: graphData, // Pass the dynamically selected data
                  activeTitle: graphTitle,
                ),
              ),
            ),

            const SizedBox(height: 20),

            //* PIE CHART CONTAINER
            SizedBox(
              height: 400,
              width: width,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PieChartDisplay(
                    scyllaOlivaceaCount: scyllaOlivaceaCount,
                    scyllaSerrataCount: charybdisFeriatusCount,
                    scyllaParamamosainCount: scyllaParamamosainCount,
                    portunosPelagicusCount: portunosPelagicusCount,
                    zosimusAeneusCount: zosimusAeneusCount,
                  ),
                ),
              ),
            )
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
