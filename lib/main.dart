import 'package:flutter/material.dart';
import 'package:tugasuprak/pemasukan/page_pemasukan.dart';
import 'package:tugasuprak/pengeluaran/page_pengeluaran.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

bool _iconBool = false;
IconData _iconLight = Icons.wb_sunny;
IconData _iconDark = Icons.nights_stay;

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _iconBool
          ? ThemeData(brightness: Brightness.light)
          : ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          // title: Text(
          //   'Catatan Keuangan',
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 24,
          //       color: Color(0xff5142E6)),
          // ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _iconBool = !_iconBool;
                  });
                },
                icon: Icon(_iconBool ? _iconDark : _iconLight))
          ],
          bottom: setTabBar(),
        ),
        body: TabBarView(controller: tabController, children: [
          PagePemasukan(),
          PagePengeluaran(),
        ]),
      ),
    );
  }

  TabBar setTabBar() {
    return TabBar(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 3, color: Color(0xff5142E6)),
        ),
        controller: tabController,
        labelColor: Color(0xff5142E6),
        tabs: [
          Tab(
            text: 'Pemasukan',
          ),
          Tab(
            text: 'Pengeluaran',
          )
        ]);
  }
}

