import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/add_item_screen.dart';
import 'package:todo/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _databaseAuth = FirebaseDatabase.instance.ref("Todo List");
  var editController = TextEditingController();
  var descriptionController = TextEditingController();
  final searchFormKey = GlobalKey<FormState>();
  var searchController = TextEditingController();
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 40,
            ),
            child: const Text(
              " To-do's",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: searchFormKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                ),
              )),
          Expanded(
            child: FirebaseAnimatedList(
              query: _databaseAuth,
              itemBuilder: (context, snapshot, animation, index) {
                final title =
                    snapshot.child("title").value.toString().toUpperCase();
                if (searchController.text.toString().isEmpty) {
                  return Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text(
                                  snapshot
                                      .child("title")
                                      .value
                                      .toString()
                                      .toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              leading: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.account_circle_outlined,
                                    color: Colors.purple,
                                  )),
                              trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              title: const Text(" Edit "),
                                              trailing: const Icon(
                                                  Icons.edit_rounded),
                                              onTap: () {
                                                Navigator.pop(context);
                                                editButton(
                                                  snapshot
                                                      .child("title")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("id")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("description")
                                                      .value
                                                      .toString(),
                                                );
                                              },
                                            )),
                                        PopupMenuItem(
                                            value: 1,
                                            onTap: () {
                                              delete(
                                                snapshot
                                                    .child("id")
                                                    .value
                                                    .toString(),
                                              );
                                            },
                                            child: const ListTile(
                                              title: Text(" Completed "),
                                              trailing:
                                                  Icon(Icons.delete_forever),
                                            )),
                                        PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              title: const Text(" Detail "),
                                              trailing: const Icon(
                                                  Icons.more_rounded),
                                              onTap: () {
                                                Navigator.pop(context);
                                                detailButton(
                                                  snapshot
                                                      .child("title")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("description")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("day")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("month")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("year")
                                                      .value
                                                      .toString(),
                                                );
                                              },
                                            )),
                                      ],
                                  child: const Icon(Icons.more_vert)),
                              subtitle: Text(
                                snapshot.child("description").value.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 70, bottom: 10, top: 0),
                              child: Text(
                                  "${snapshot.child("day").value} / ${snapshot.child("month").value} / ${snapshot.child("year").value}"))
                        ],
                      ));
                } else if (title
                    .toUpperCase()
                    .contains(searchController.text.toString().toUpperCase())) {
                  return Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text(
                                  snapshot
                                      .child("title")
                                      .value
                                      .toString()
                                      .toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              leading:
                                  const Icon(Icons.account_circle_outlined),
                              trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              title: const Text(" Edit "),
                                              trailing: const Icon(
                                                  Icons.edit_rounded),
                                              onTap: () {
                                                Navigator.pop(context);
                                                editButton(
                                                  snapshot
                                                      .child("title")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("id")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("description")
                                                      .value
                                                      .toString(),
                                                );
                                              },
                                            )),
                                        PopupMenuItem(
                                            value: 1,
                                            onTap: () {
                                              delete(
                                                snapshot
                                                    .child("id")
                                                    .value
                                                    .toString(),
                                              );
                                            },
                                            child: const ListTile(
                                              title: Text(" Delete "),
                                              trailing:
                                                  Icon(Icons.delete_forever),
                                            )),
                                        PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.pop(context);
                                                detailButton(
                                                  snapshot
                                                      .child("title")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("description")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("day")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("month")
                                                      .value
                                                      .toString(),
                                                  snapshot
                                                      .child("year")
                                                      .value
                                                      .toString(),
                                                );
                                              },
                                            )),
                                      ],
                                  child: const Icon(Icons.more_vert)),
                              subtitle: Text(
                                snapshot.child("description").value.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 70, bottom: 10, top: 0),
                              child: Text(
                                  "${snapshot.child("day").value} / ${snapshot.child("month").value} / ${snapshot.child("year").value}"))
                        ],
                      ));
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddItemScreen(),
              ));
        },
        tooltip: 'Add One',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> delete(String id) {
    return _databaseAuth.child(id).remove().then((value) {
      Error().errorMsg(
          "Congratulation ! \n You Did Your Job That Why We Remove It Successfully");
    }).onError((error, stackTrace) {
      Error().errorMsg(error.toString());
    });
  }

  Future<void> editButton(String title, String id, String description) {
    editController.text = title;
    descriptionController.text = description;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(" Edit To-Do "),
          content: Container(
            padding: const EdgeInsets.all(5),
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.47,
            child: ListView(
              children: [
                TextFormField(
                  controller: editController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Title"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLength: 500,
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Description"),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _databaseAuth.child(id).update({
                      "title": editController.text.toString().toUpperCase(),
                      "description": descriptionController.text.toString(),
                      "day": DateTime.now().day.toString(),
                      "month": DateTime.now().month.toString(),
                      "year": DateTime.now().year.toString()
                    }).then((value) {
                      Error().errorMsg(" Update Successfully ");
                    }).onError((error, stackTrace) {
                      Error().errorMsg(error.toString());
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(6)),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      " Update ",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Error().errorMsg("Cancel Successfully ");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(6)),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      " Cancel ",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> detailButton(
      String title, String description, String day, String month, String year) {
    editController.text = title;
    descriptionController.text = description;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(" Detail of To-Do "),
          content: Container(
            padding: const EdgeInsets.all(5),
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                TextFormField(
                  enabled: false,
                  controller: editController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Title"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLength: 500,
                  enabled: false,
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Description"),
                ),
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.date_range),
                      hintText:
                          "${day.toString()} / ${month.toString()} / ${year.toString()}"),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_balance_outlined),
                      hintText: "Status : Pending "),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class Error {
  void errorMsg(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.purple,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
