import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final databaseAuth = FirebaseDatabase.instance.ref("Todo List");
  bool loading = false;
  var currentTime = DateTime.now().millisecond;
  void clearInput() {
    titleController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(" Add Item "),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return " Required ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Title",
                        hintText: "Study Time",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        prefixIcon: const Icon(Icons.account_circle_outlined),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLength: 500,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Write Description Here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (titleController.text.toString().isNotEmpty) {
                          setState(() {
                            loading = true;
                          });
                        }
                        if (formKey.currentState!.validate()) {
                          databaseAuth.child(currentTime.toString()).set({
                            "day": DateTime.now().day.toString(),
                            "month": DateTime.now().month.toString(),
                            "year": DateTime.now().year.toString(),
                            "id": currentTime.toString(),
                            "title": titleController.text.toString(),
                            "description":
                                descriptionController.text.toString(),
                          }).then((value) {
                            setState(() {
                              loading = false;
                            });
                            Error().errorMsg("Item Added Successfully");
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ));
                          }).onError((error, stackTrace) {
                            setState(() {
                              loading = false;
                            });
                            Error().errorMsg(error.toString());
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        alignment: Alignment.center,
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                " Add Item ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        clearInput();
                        Error().errorMsg(" Cancel Item");
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(),
                            ));
                      },
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        alignment: Alignment.center,
                        child: const Text(
                          " Cancel ",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        )));
  }
}
