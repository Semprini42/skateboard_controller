import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skateboard_controller/controllers/bluetooth_controller.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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
            // useMaterial3: true,
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            ),
        // home: MyHomePage(),
        home: HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  BluetoothController controller = BluetoothController();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: 180,
              width: double.infinity,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  "Bluetooth App",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SpeedController()),
              ),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(350, 55),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  )),
              child: const Text(
                "Control",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => MyAppState().controller.scanDevices(),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(350, 55),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  )),
              child: const Text(
                "Scan",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<List<ScanResult>>(
              stream: MyAppState().controller.scanResults,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data![index];
                        return ElevatedButton(
                          onPressed: () async {
                            await data.device.connect();
                          },
                          child: ListTile(
                            title: Text(data.device.name),
                            subtitle: Text(data.device.id.id),
                            trailing: Text(data.rssi.toString()),
                          ),
                        );
                      });
                } else {
                  return const Center(child: Text("No devices found"));
                }
              })
        ],
      ),
    );
  }
}

class SpeedController extends StatefulWidget {
  @override
  State<SpeedController> createState() => _SpeedController();
}

class _SpeedController extends State<SpeedController> {
  double _value = 0;

  void changeValue(_value) async {
    List<BluetoothDevice> test =
        await MyAppState().controller.flutterBlue.connectedDevices;
    BluetoothDevice device = test[0];

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          await c.write(utf8.encode(_value.toString()));
        }
      }
    });
  }

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
                    changeValue(_value.toInt());
                  });
                },
                onChangeEnd: (newValue) {
                  setState(() {
                    _value = 0;
                    changeValue(_value.toInt());
                  });
                },
              ),
            ),
          ),
          Row(
            children: [
              Text(
                'Value: ${_value.round().toString()}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
