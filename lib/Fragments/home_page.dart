import 'package:firstresponder/Screens/add_rule.dart';
import 'package:firstresponder/databasehelper.dart';
import 'package:flutter/material.dart';

import '../Models/rule.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool isSwitched = false;
  String isRule = "";
  String isColor = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home"),),
        body: Container(
          width: double.infinity,
          //padding: const EdgeInsets.only(top: 24.0),
          //color: Color(0xFFF6F6F6),
          child: Stack(
            children: [

              FutureBuilder(
                initialData: const [],
                future: _dbHelper.getRules(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        //print(snapshot.data?.length);
                        Rule item = snapshot.data![index];
                        String title = item.received_msg.replaceAll(RegExp('[^0-9a-zA-Z,./;:''""(){}]'), '');
                        String subtitle = item.reply_message.replaceAll('','');

                        if(item.status == "true"){
                          isSwitched = true;
                          isRule = "On";
                        } else {
                          isSwitched = false;
                          isRule = "Off";
                        }

                        return Dismissible(
                          key: UniqueKey(),
                          secondaryBackground: Container(color: Colors.red,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const <Widget>[
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    " Delete",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),),
                          background: Container(color: Colors.blue,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    " Edit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          confirmDismiss: (direction) async{
                            if (direction == DismissDirection.endToStart) {
                              final bool res = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                          "Are you sure you want to delete this Rule?"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            _dbHelper.deleteRule(item.id);
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              return res;
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddRule(edit: true, rule: item)),
                              ).then((value) {
                                setState(() {});
                              });
                            }
                          },
                          child: SizedBox(
                            height: 100.0,
                            child: Center(
                              child: ListTile(
                                title: Text("Received: $title", style: const TextStyle(fontSize: 16.0),),
                                subtitle: Text("Send: $subtitle", style: const TextStyle(fontSize: 12.0)),
                                leading: CircleAvatar(maxRadius: 32.0, backgroundColor: isRule == 'On' ? Colors.green : Colors.red,child: Text(isRule, style: const TextStyle(color: Colors.white),),),
                                trailing: Switch(value: isSwitched, onChanged: (bool value) {
                                  setState(() {
                                    _dbHelper.updateRule(Rule(id: item.id, status: value.toString(), received_msg: item.received_msg, reply_message: item.reply_message, reply_count: item.reply_count, contacts: item.contacts, ignored_contacts: item.ignored_contacts));
                                    //isSwitched = value;
                                  });
                                },),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddRule(edit: true, rule: item)),
                                  ).then((value) {
                                    setState(() {});
                                  });

                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),

              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: FloatingActionButton.extended(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRule())
                  ).then((value) {
                    setState(() {});
                  });
                },
                  label: const Text("Add Rule"),
                  icon: const Icon(Icons.app_registration),
          ),
              )
      ],
    ),
        ));
  }
}
