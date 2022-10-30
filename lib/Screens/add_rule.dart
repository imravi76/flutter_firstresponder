import 'package:flutter/material.dart';

import '../Models/rule.dart';
import '../databasehelper.dart';

class AddRule extends StatefulWidget {
  final Rule? rule;
  final bool? edit;

  const AddRule({Key? key, this.edit, this.rule}) : super(key: key);

  @override
  State<AddRule> createState() => _AddRuleState();
}

class _AddRuleState extends State<AddRule> {

  final _dbHelper = DatabaseHelper();
  //int _ruleId = 0;
  String? recvMsg;
  String contactField = "";
  String ignoredField = "";
  bool recvEdit = false;
  bool cardVisible = false;
  var id;
  var selected = false;

  //bool _choiceIndex = false;

  int _value = 0;
  final List<String> _options = ['1', 'All', 'Random'];

  static List<String> replyList = [""];
  TextEditingController matchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final SnackBar _emptyField = const SnackBar(content: Text("Reply Message is Compulsory"));
  final SnackBar _emptyField2 = const SnackBar(content: Text("Received Message field is Compulsory"));
  final SnackBar _emptyField3 = const SnackBar(content: Text("Delete Empty Reply Fields"));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.rule != null) {
      //print(widget.rule?.id);
      cardVisible = true;
      contactField = widget.rule!.contacts;
      ignoredField = widget.rule!.ignored_contacts;
      recvMsg = widget.rule!.received_msg;
      id = widget.rule!.id;

      if(widget.rule?.reply_count == '1'){
        _value = 0;
      } else if(widget.rule?.reply_count == 'All'){
        _value = 1;
      } else if(widget.rule?.reply_count == 'Random'){
        _value = 2;
      }

      if(widget.rule!.received_msg == '*welcome*'){
        recvMsg = widget.rule!.received_msg;
      } else if(widget.rule!.received_msg == '*all*'){
        recvMsg = widget.rule!.received_msg;
      } else{
        recvMsg = "";
        matchController.text = widget.rule!.received_msg;
        selected = true;
        recvEdit = true;
      }

      //print(widget.rule!.reply_message);
      //String result = widget.rule!.reply_message.replaceAll(RegExp('[, ]'), '');
      //String result1 = result.replaceAll(RegExp('[[]'), '');
      //String result2 = result1.replaceAll(RegExp(']'), '');
      //List<String> result3 = result2.split('}');
      //print(result);
      //print(result1);
      //print(result2);
      //print(result3);

      String result = widget.rule!.reply_message.toString();

      String result1 = result.substring(1, result.length-1);
      List<String> result2 = result1.split('}, ');
      
      //print(result1);
      //print(result2);

      replyList = result2;
      //replyList.removeAt(replyList.length-1);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Rule"),
      ),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              //padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
              //color: Colors.white,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Received Message",
                      style:
                          TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  RadioListTile(
                      title: const Text("Welcome Message"),
                      value: "*welcome*",
                      groupValue: recvMsg,
                      onChanged: (value) {
                        setState(() {
                          recvMsg = value.toString();
                          recvEdit = false;
                          cardVisible = true;
                        });
                      }),
                  RadioListTile(
                    //toggleable: selected,
                      title: const Text("Exact Match"),
                      value: "",
                      groupValue: recvMsg,
                      onChanged: (value) {
                        setState(() {
                          recvMsg = value.toString();
                          recvEdit = true;
                          cardVisible = true;
                        });
                      }),
                  RadioListTile(
                      title: const Text("All"),
                      value: "*all*",
                      groupValue: recvMsg,
                      onChanged: (value) {
                        setState(() {
                          recvMsg = value.toString();
                          recvEdit = false;
                          cardVisible = true;
                        });
                      }),
                  Visibility(
                    visible: recvEdit,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                      child: TextField(
                        controller: matchController,
                        onChanged: (value){
                          recvMsg = value.toString();
                        },
                          decoration:
                              const InputDecoration(hintText: "Should be answered"),
                          maxLines: null,
                          minLines: null),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: cardVisible,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 0.0),
                //color: Colors.white,
                child: Column(
                  children: [
                    const Text(
                      "Reply Message",
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text("No.of Replies:")),
                    Row(
                      children: [
                        Wrap(
                          spacing: 8.0,
                          children: List<Widget>.generate(
                            3,
                            (int index) {
                              return ChoiceChip(
                                label: Text(_options[index]),
                                selected: _value == index,
                                //backgroundColor: Theme.of(context).colorScheme.primary,
                                onSelected: (bool selected) {
                                  setState(() {
                                    _value = index;
                                    //print(_options[_value]);
                                  });
                                },
                              );
                            },
                          ).toList(),
                        ),

                      ],
                    ),

                    //ReplyMessage(),

                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ..._getReply(),
                          ],
                        )),
                    //ReplyMessage(),
                    //ReplyMessage(),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: cardVisible,
              child: const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text("optional"),
              ),
            ),
            Visibility(
              visible: cardVisible,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 0.0),
                child: Column(
                  children: [
                    const Text(
                      "Specific Contacts",
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      onChanged: (value){
                        contactField = value.toString();
                      },
                        decoration: const InputDecoration(hintText: "Separated with ;"),
                        maxLines: null,
                        minLines: null)
                  ],
                ),
              ),
            ),
            Visibility(
              visible: cardVisible,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                child: Column(
                  children: [
                    const Text(
                      "Ignored Contacts",
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      onChanged: (value){
                        ignoredField = value.toString();
                      },
                        decoration: const InputDecoration(hintText: "Separated with ;"),
                        maxLines: null,
                        minLines: null)
                  ],
                ),
              ),
            ),

            Visibility(
              visible: cardVisible,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  //bottom: 24.0,
                  //right: 24.0,
                  //top: 24.0,
                  padding: const EdgeInsets.only(right: 24.0, top: 24.0, bottom: 24.0),
                  child: FloatingActionButton.extended(onPressed: () async {
                    //print(recvMsg);
                    //print(replyList);
                    if(replyList[0] == ""){
                      ScaffoldMessenger.of(context).showSnackBar(_emptyField);
                      //print("Empty List");

                    }else{
                      //print("Not Empty");
                      if(recvMsg == ""){
                        ScaffoldMessenger.of(context).showSnackBar(_emptyField2);
                      }
                      else if(replyList[replyList.length-1] == ""){
                        ScaffoldMessenger.of(context).showSnackBar(_emptyField3);
                      } else{
                        //print(replyList.length);
                        //print(replyList[0]);
                        if(widget.edit == false) {

                        List list = replyList;
                        for(int i=0;i<replyList.length;i++){
                          String temp = list[i];
                          list[i] = "$temp}";
                        }
                          id = new DateTime.now().millisecondsSinceEpoch;
                          Rule _newRule = Rule(status: 'true',
                              received_msg: recvMsg.toString(),
                              reply_message: list.toString(),
                              reply_count: _options[_value],
                              contacts: contactField.toString(),
                              ignored_contacts: ignoredField.toString(),
                              id: id);
                          await _dbHelper.insertRule(_newRule);
                          replyList = [""];
                          _value = 0;
                          Navigator.pop(context);
                        } else if(widget.edit == true){
                          List list = replyList;
                          for(int i=0;i<replyList.length;i++){
                            String temp = list[i];
                            list[i] = "$temp}";
                          }
                          id = new DateTime.now().millisecondsSinceEpoch;
                          Rule _newRule = Rule(status: widget.rule!.status,
                              received_msg: recvMsg.toString(),
                              reply_message: list.toString(),
                              reply_count: _options[_value],
                              contacts: contactField.toString(),
                              ignored_contacts: ignoredField.toString(),
                              id: widget.rule!.id);
                          await _dbHelper.updateRule(_newRule);
                          //print("Success!");
                          replyList = [""];
                          _value = 0;
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                    label: const Text("Done"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getReply() {
    List<Widget> replyTextFields = [];
    for (int i = 0; i < replyList.length; i++) {
      replyTextFields.add(Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Row(
          children: [
            Expanded(child: ReplyTextFields(i)),
            const SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == replyList.length - 1, i),
          ],
        ),
      ));
    }
    return replyTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          replyList.insert(replyList.length, "");
          //print("added at: ${replyList.length}");
          if(replyList.length > 1){
            setState(() {
              _value = 2;
            });
          }
        } else {
          replyList.removeAt(index);
          //print("removed at: ${replyList.length}");
          if(replyList.length == 1){
            setState(() {
              _value = 0;
            });
          }

        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ReplyTextFields extends StatefulWidget {
  final int index;

  const ReplyTextFields(this.index, {super.key});

  @override
  _ReplyTextFieldsState createState() => _ReplyTextFieldsState();
}

class _ReplyTextFieldsState extends State<ReplyTextFields> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = _AddRuleState.replyList[widget.index];
    });
    return TextFormField(
      controller: _nameController,
      maxLines: null,
      minLines: null,
      // save text field data in friends list at index
      // whenever text field value changes
      onChanged: (v) => _AddRuleState.replyList[widget.index] = v,
      decoration: const InputDecoration(hintText: 'Should be sent'),
    );
  }
}
