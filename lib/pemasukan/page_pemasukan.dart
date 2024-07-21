// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tugasuprak/database/database_helper.dart';
import 'package:tugasuprak/decoration/format_rupiah.dart';
import 'package:tugasuprak/model/model_database.dart';
import 'package:tugasuprak/pemasukan/page_input_pemasukan.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PagePemasukan extends StatefulWidget {
  const PagePemasukan({Key? key}) : super(key: key);

  @override
  State<PagePemasukan> createState() => _PagePemasukanState();
}

class _PagePemasukanState extends State<PagePemasukan> {
  List<ModelDatabase> listPemasukan = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  int strJmlUang = 0;
  int strCheckDatabase = 0;

  @override
  void initState() {
    super.initState();
    getDatabase();
    getJmlUang();
    getAllData();
  }

  // Cek database ada data atau tidak
  Future<void> getDatabase() async {
    var checkDB = await databaseHelper.cekDataPemasukan();
    setState(() {
      if (checkDB == 0) {
        strCheckDatabase = 0;
        strJmlUang = 0;
      } else {
        strCheckDatabase = checkDB!;
      }
    });
  }

  // Cek jumlah total uang
  Future<void> getJmlUang() async {
    var checkJmlUang = await databaseHelper.getJmlPemasukan();
    setState(() {
      if (checkJmlUang == 0) {
        strJmlUang = 0;
      } else {
        strJmlUang = checkJmlUang;
      }
    });
  }

  // Get data untuk menampilkan ke listview
  Future<void> getAllData() async {
    var ListData = await databaseHelper.getDataPemasukan();
    setState(() {
      listPemasukan.clear();
      ListData!.forEach((kontak) {
        listPemasukan.add(ModelDatabase.fromMap(kontak));
      });
    });
  }

  // Untuk hapus data berdasarkan id
  Future<void> deleteData(ModelDatabase modelDatabase, int position) async {
    await databaseHelper.deletePemasukan(modelDatabase.id!);
    setState(() {
      getJmlUang();
      getDatabase();
      listPemasukan.removeAt(position);
    });
  }

  // Untuk insert data baru
  Future<void> openFormCreate() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageInputPemasukan(),
      ),
    );

    if (result == 'save') {
      await getAllData();
      await getJmlUang();
      await getDatabase();
    }
  }

  // Untuk edit data
  Future<void> openFormEdit(ModelDatabase modelDatabase) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PageInputPemasukan(modelDatabase: modelDatabase)));

    if (result == 'update') {
      await getAllData();
      await getJmlUang();
      await getDatabase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: 150,
              margin: EdgeInsets.only(top: 14, bottom: 14, left: 10, right: 10),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/bgcard.png'),
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Pemasukan',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(strJmlUang),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
            ),
            strCheckDatabase == 0
                ? Container(
                    padding: EdgeInsets.only(top: 200),
                    child: Text(
                      'Ups, belum ada pemasukan.\nYuk catat pemasukan kamu!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listPemasukan.length,
                    itemBuilder: (context, index) {
                      ModelDatabase modeldatabase = listPemasukan[index];
                      return Card(
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                        clipBehavior: Clip.antiAlias,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Slidable(
                          endActionPane:
                              ActionPane(motion: ScrollMotion(), children: [
                            SlidableAction(
                              onPressed: (slidableContext) {
                                openFormEdit(modeldatabase);
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.green,
                            ),
                            SlidableAction(
                              backgroundColor: Colors.red,
                              onPressed: (slidableContext) {
                                AlertDialog hapus = AlertDialog(
                                  title: Text(
                                    'Hapus Data',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  content: Container(
                                    child: Text(
                                      'Yakin ingin menghapus data ini?',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        deleteData(modeldatabase, index);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Ya',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Tidak',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                                showDialog(
                                    context: context,
                                    builder: (context) => hapus);
                              },
                              icon: Icons.delete,
                            ),
                          ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: ListTile(
                              title: Text(
                                '${modeldatabase.keterangan}',
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    CurrencyFormat.convertToIdr(int.parse(
                                        modeldatabase.jml_uang.toString())),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: Colors.green),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4, bottom: 8),
                                    child: Text(
                                      '${modeldatabase.tanggal}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openFormCreate();
        },
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xff5142E6),
      ),
    );
  }
}
