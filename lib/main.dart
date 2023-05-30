import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            sliderTheme: SliderThemeData(
              showValueIndicator: ShowValueIndicator.always,
            )),
        home: MyHomePage(),
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
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A random idea:'),
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          ),
          RotatedBox(
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
          Text(_value.round().toString()),
        ],
      ),
    );
  }
}
