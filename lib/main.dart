import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skateboard_controller/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'skateboard controller',
        theme: ThemeData(
          useMaterial3: true,
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // home: MyHomePage(),
        home: HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                min: 0.0,
                max: 1023.0,
                value: _value,
                label: '${_value.round()}',
                onChanged: (newValue) {
                  setState(() {
                    _value = newValue;
                  });
                },
                onChangeEnd: (newValue) {
                  setState(() {
                    _value = 0;
                  });
                },
              ),
            ),
          ),
          Row(
            children: [
              Text('Value: ${_value.round().toString()}',),
            ],
          ),
        ],
      ),
    );
  }
}
