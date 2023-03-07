import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/add_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  final Stream<QuerySnapshot> studentStream =
      FirebaseFirestore.instance.collection('student').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dataList),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButton: StreamBuilder<QuerySnapshot>(
          stream: studentStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              log(AppLocalizations.of(context)!.somethingWrong);
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }

            final storedata = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              a["id"] = document.id;
              storedata.add(a);
            }).toList();
            return storedata.isEmpty
                ? const SizedBox()
                : FloatingActionButton(
                    backgroundColor: Colors.deepPurpleAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddData(),
                        ),
                      );
                    },
                    child: const Icon(Icons.add),
                  );
          }),
      body: StreamBuilder<QuerySnapshot>(
        stream: studentStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            log(AppLocalizations.of(context)!.somethingWrong);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final storedata = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            a["id"] = document.id;
            storedata.add(a);
          }).toList();

          return storedata.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddData(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.addData,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                  itemCount: storedata.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () {
                        showMenu(
                          context: context,
                          position: RelativeRect.fill,
                          items: [
                            PopupMenuItem(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => AddData(
                                        id: storedata[index]["id"],
                                        names: storedata[index]["name"],
                                        studys: storedata[index]["study"],
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.edit,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    Text(AppLocalizations.of(context)!.edit),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('student')
                                    .doc(storedata[index]["id"])
                                    .delete();
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  Text(AppLocalizations.of(context)!.delete),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.blueGrey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                storedata[index]['name'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(
                                height: 20.0,
                                thickness: 1,
                                color: Colors.black,
                              ),
                              Text(
                                storedata[index]['study'],
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
