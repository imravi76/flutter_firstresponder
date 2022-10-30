import 'dart:async';

import 'package:firstresponder/Fragments/about_page.dart';
import 'package:firstresponder/Fragments/home_page.dart';
import 'package:firstresponder/Fragments/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:reflex/reflex.dart';

import 'databasehelper.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  late PageController _tabsPageController;
  int _selectedTab = 0;

  Reflex reflex = Reflex();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  StreamSubscription<ReflexEvent>? _subscription;
  final List<ReflexEvent> _notificationLogs = [];
  final List<ReflexEvent> _autoReplyLogs = [];
  bool isListening = false;
  String reply = "";
  String? test = "";

  @override
  void initState() {
    _tabsPageController = PageController();
    initPlatformState();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    bool isPermissionGranted = await Reflex.isPermissionGranted;
    //print(isPermissionGranted);

    if(isPermissionGranted == true){
      startListening();
    } else{
      await Reflex.requestPermission();
    }

  }

  void onData(ReflexEvent event) {
    setState(() {
      if (event.type == ReflexEventType.notification) {
        _notificationLogs.add(event);
      } else if (event.type == ReflexEventType.reply) {
        _autoReplyLogs.add(event);
      }
    });
    debugPrint(event.toString());
  }

  void startListening() {

    try {

      Reflex reflex = Reflex(
        debug: false,
        packageNameList: ["com.whatsapp"],
        autoReply: AutoReply(
          packageNameList: ["com.whatsapp"],
          message: sendreply(),
        ),
      );
      //print(_notificationLogs.length);
      _subscription = reflex.notificationStream!.listen(onData);

      setState(() {
        isListening = true;
        reply = "";
      });
    } on ReflexException catch (exception) {
      debugPrint(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabsPageController,
            children: const [
              HomePage(),
              SettingsPage(),
              AboutPage()
            ],

            onPageChanged: (num){
              setState((){
                _selectedTab = num;
              });
            },
          )
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _tabsPageController.animateToPage(index, duration: Duration(microseconds: 300), curve: Curves.easeOutCubic);
            _selectedTab = index;
          });
        },
        selectedIndex: _selectedTab,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          NavigationDestination(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }

  String sendreply() {
    /*final ReflexEvent element = _notificationLogs[_notificationLogs.length-1];
    test = element.title;
    test = test?.substring(0,1);
    print(test);*/
    reply = "Hello Hello!";
    return reply;

    if(test == "+"){
      reply = "Hello Hii";
      return reply;
    } else{
      reply = "No";
      return reply;
    }
  }
}
