import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _noteController = TextEditingController();
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection("todo");

  // List<String> noteList = ["test"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Notepad")),
        actions: [
          IconButton(
              onPressed: () {
                addEditItemBottomSheet(callback: (value) async {
                  print(value);
                  await _collection.add({"note": value});
                  //   noteList.add(value);
                  //   setState(() {});
                });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder(
          stream: _collection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey[200],
                        child: Row(children: [
                          Expanded(child: Text(documentSnapshot['note'])),
                          IconButton(
                              onPressed: () {
                                addEditItemBottomSheet(
                                  callback: (value) async {
                                    await _collection
                                        .doc(documentSnapshot.id)
                                        .update({'note': value});
                                    //  noteList[index] = value;
                                    //   setState(() {});
                                    // },
                                  },
                                  initialValue: documentSnapshot['note'],
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              )),
                          IconButton(
                              onPressed: () =>
                                  deleteItem(docummentId: documentSnapshot.id),
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ]),
                      ),
                    );
                  }));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  void addEditItemBottomSheet(
      {String? initialValue, required Function(String) callback}) {
    TextEditingController noteController = TextEditingController();

    if (initialValue != null) {
      noteController.text = initialValue;
    }
    showModalBottomSheet(
        // isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("cancel")),
                Expanded(
                    child: Text(
                  initialValue != null ? "Edit not" : "add new note",
                  textAlign: TextAlign.center,
                )),
                TextButton(
                    onPressed: () {
                      if (noteController.text.isEmpty) {
                      } else {
                        callback(noteController.text);
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text("save")),
              ]),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                        hintText: initialValue != null
                            ? "Edit not "
                            : "Enter new Note",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ))
            ],
          );
        });
  }

  deleteItem({required String docummentId}) async {
    _collection.doc(docummentId).delete();
    // noteList.removeAt(index);
    // setState(() {});
  }

  // void showButtonSheet(
  //     {required BuildContext context, required Function(String) callback}) {
  //   TextEditingController noteController = TextEditingController();
  //   showModalBottomSheet(
  //       // isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Column(
  //           children: [
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             Row(children: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text("cancel")),
  //               const Expanded(
  //                   child: Text(
  //                 "add new note",
  //                 textAlign: TextAlign.center,
  //               )),
  //               TextButton(
  //                   onPressed: () {
  //                     callback(noteController.text);
  //                   },
  //                   child: const Text("save")),
  //             ]),
  //             Padding(
  //                 padding: const EdgeInsets.all(8),
  //                 child: TextField(
  //                   controller: noteController,
  //                   decoration: InputDecoration(
  //                       hintText: "Enter new Note",
  //                       border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(15))),
  //                 ))
  //           ],
  //         );
  //       });
  // }

  // void editItemBottomSheet(
  //     {required String initialValue, required Function(String) callback}) {
  //   TextEditingController noteController =
  //       TextEditingController(text: initialValue);
  //   showModalBottomSheet(
  //       // isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Column(
  //           children: [
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             Row(children: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text("cancel")),
  //               const Expanded(
  //                   child: Text(
  //                 "Edit note",
  //                 textAlign: TextAlign.center,
  //               )),
  //               TextButton(
  //                   onPressed: () {
  //                     callback(noteController.text);
  //                   },
  //                   child: const Text("save")),
  //             ]),
  //             Padding(
  //                 padding: const EdgeInsets.all(16),
  //                 child: TextField(
  //                   controller: noteController,
  //                   decoration: InputDecoration(
  //                       hintText: "Edit Note",
  //                       border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(15))),
  //                 ))
  //           ],
  //         );
  //       });
  // }
}
