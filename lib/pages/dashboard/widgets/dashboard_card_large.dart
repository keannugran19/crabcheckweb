import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_graph.dart';
import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_graph_lists.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/info_card.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/pie_chart.dart';
import 'package:flutter/material.dart';

class DashboardPageLargeScreen extends StatefulWidget {
  const DashboardPageLargeScreen({super.key});

  @override
  State<DashboardPageLargeScreen> createState() =>
      _DashboardPageLargeScreenState();
}

class _DashboardPageLargeScreenState extends State<DashboardPageLargeScreen> {
  // call the database
  final db = FirebaseFirestore.instance;
  // count
  int scyllaSerrataCount = 0;
  int scyllaOlivaceaCount = 0;
  int scyllaParamamosainCount = 0;
  int portunosPelagicusCount = 0;
  int zosimusAeneusCount = 0;
  // total count
  int totalCount = 0;

  // loading
  bool isLoading = true;

  String activeTitle = '';

// run state
  @override
  void initState() {
    super.initState();
    fetchAllCounts();
  }

  // restart the state of the dashboard
  void restart() {
    setState(() {
      isLoading = true;
    });
    fetchAllCounts();
  }

// get all counts
  Future<void> fetchAllCounts() async {
    final scyllaSerrataCount = await fetchCount('Scylla Serrata');
    final scyllaOlivaceaCount = await fetchCount('Scylla Olivacea');
    final scyllaParamamosainCount = await fetchCount('Scylla Paramamosain');
    final portunosPelagicusCount = await fetchCount('Portunos Pelagicus');
    final zosimusAeneusCount = await fetchCount('Zosimus Aeneus');

    setState(() {
      this.scyllaSerrataCount = scyllaSerrataCount;
      this.scyllaOlivaceaCount = scyllaOlivaceaCount;
      this.scyllaParamamosainCount = scyllaParamamosainCount;
      this.portunosPelagicusCount = portunosPelagicusCount;
      this.zosimusAeneusCount = zosimusAeneusCount;
      totalCount = scyllaSerrataCount +
          scyllaOlivaceaCount +
          scyllaParamamosainCount +
          portunosPelagicusCount +
          zosimusAeneusCount;
    });
  }

// query of getting count data from the database
  Future<int> fetchCount(String species) async {
    final crabRef = db.collection('crab');
    final query = crabRef.where('species', isEqualTo: species);
    final snapshot = await query.count().get();
    return snapshot.count!;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    late List<double> graphData;
    late String graphTitle;

    // Determine what graphTitle to put on the variable graphTitle
    if (activeTitle.contains('Scylla Serrata')) {
      graphTitle = 'Scylla Serrata';
    } else if (activeTitle.contains('Scylla Olivacea')) {
      graphTitle = 'Scylla Olivacea';
    } else if (activeTitle.contains('Scylla Paramamosain')) {
      graphTitle = 'Scylla Paramamosain';
    } else if (activeTitle.contains('Portunos Pelagicus')) {
      graphTitle = 'Portunos Pelagicus';
    } else if (activeTitle.contains('Zosimus Aeneus')) {
      graphTitle = 'Zosimus Aeneus';
    } else if (activeTitle.contains('Total Crabs')) {
      graphTitle = 'Total Crabs';
    } else {
      graphTitle = 'Total Crabs';
    }

    // Assign graph data based on the graphTitle
    switch (graphTitle) {
      case 'Scylla Serrata':
        graphData = scyllaSerrata;
        break;
      case 'Scylla Olivacea':
        graphData = scyllaOlivacea;
        break;
      case 'Scylla Paramamosain':
        graphData = scyllaParamamosain;
        break;
      case 'Portunos Pelagicus':
        graphData = portunosPelagicus;
        break;
      case 'Zosimus Aeneus':
        graphData = zosimusAeneus;
        break;
      case 'Total Crabs':
        graphData = totalCrabs;
        break;
      default:
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
              topColor: Colors.grey,
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
            Column(
              children: [
                Column(
                  children: [
                    //* BAR GRAPH CONTAINER
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: BarGraph(
                          totalCrabs: graphData,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //* PIE CHART CONTAINER
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: PieChartDisplay(
                          scyllaOlivaceaCount: scyllaOlivaceaCount,
                          scyllaSerrataCount: scyllaSerrataCount,
                          scyllaParamamosainCount: scyllaParamamosainCount,
                          portunosPelagicusCount: portunosPelagicusCount,
                          zosimusAeneusCount: zosimusAeneusCount,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
