import 'package:ble_comms/controllers/debug_controller.dart';
import 'package:ble_comms/widgets/actionbtn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BLE Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BLE Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DebugController debug = DebugController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ValueListenableBuilder<String>(
        builder: (BuildContext context, String value, Widget? child) {
          // This builder will only get called when the _counter
          // is updated.
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Debug messages will appear below:',
                ),
                Text(
                  debug.message.value,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
        valueListenable: debug.message,
        // The child parameter is most helpful if the child is
        // expensive to build and does not depend on the value from
        // the notifier.
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: SizedBox(
            width: 40,
            height: 40,
            child: FlutterLogo(size: 40),
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  child: Icon(Icons.clear_all),
                  onPressed: () {
                    debug.clear();
                  },
                ),
              )),
          BluetoothActionButton(
              debugController: debug)
        ],
      ),
    );
  }
}
