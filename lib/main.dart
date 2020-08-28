import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wikiappgedik/bookmodel.dart';
import 'package:wikiappgedik/detya.dart';
import 'package:wikiappgedik/qrscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: QRViewExample(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.qrtext,{Key key, this.title}) : super(key: key);
  final String qrtext;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Books bilgi;
  bool geldi =false;


  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  @override
  void initState() {
   var arda =widget.qrtext;
    postAt(arda);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var qrText=widget.qrtext;


    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Wiki Gedik"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: geldi ? ListView.builder(
          itemCount: bilgi.data.length,
          itemBuilder: (context,int){
            return ListTile(
              title:Text( bilgi.data[int].name.toString()),

              subtitle: Text( bilgi.data[int].description.toString()),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Detay(bilgi.data[int].id.toInt())),
                );

              },


            );
          },


        ):Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          var arda =widget.qrtext;
          postAt(arda);
        },
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Future<void> postAt(String arda) async {

    const baseUrl = "http://wiki.gedik.com.tr/api/books";
    final http.Client httpClient = http.Client();
    var token ="bMGv48Tt2gTI2gfnGwft3QflmXoMxvnc:qqZucz2u5Q5ggGewPd5KLZ23W0eVuOoA";





    final radyoUrl = baseUrl;
    http.Response radyoCevap = await httpClient.get(radyoUrl,
      headers: {"Authorization":"Token ${arda == null ? token :arda }"},

    );
    if (radyoCevap.statusCode != 200) {
      debugPrint(radyoCevap.body.toString());
      throw Exception("Radyo  Apisi Geteirilemedi");
    }
    final radyoCevapJSON = jsonDecode(radyoCevap.body);

    bilgi= Books.fromJson(radyoCevapJSON);
    setState(() {
      geldi=true;
    });



  }
}
