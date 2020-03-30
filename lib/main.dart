import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

typedef SHGetKnownFolderPathC = ffi.Int32 Function(
    ffi.Pointer rfid,
    ffi.Uint32 dwFlags,
    ffi.Pointer hToken,
    ffi.Pointer<ffi.Pointer> ppszPath);
typedef SHGetKnownFolderPathDart = int Function(
    ffi.Pointer referenceID,
    int flags,
    ffi.Pointer handle,
    ffi.Pointer<ffi.Pointer> path);

class LocalAppDataFolder extends ffi.Struct {
    ffi.Pointer<ffi.Uint64>  data1;
    ffi.Pointer<ffi.Uint16> data2;
    ffi.Pointer<ffi.Uint16> data3;
    ffi.Pointer<Utf8>  data4;
}

typedef GetAppContainerFolderPathWindows = ffi.Int32 Function(
  ffi.Pointer<Utf16> appContainerSid,
  ffi.Pointer<ffi.Pointer<Utf16>> path,
);

typedef GetAppContainerFolderPathDart = int Function(
  ffi.Pointer<Utf16> appContainerSid,
  ffi.Pointer<ffi.Pointer<Utf16>> path,
);

typedef FreeMemWindows = ffi.Void Function(
  ffi.Pointer<ffi.Void> pointer
);
typedef FreeMemDart = void Function(
  ffi.Pointer<ffi.Void> pointer
);

typedef SHGetFolderPathC = ffi.Int32 Function(
    ffi.Int64 hwnd,
    ffi.Int64 csidl,
    ffi.Int64 hToken,
    ffi.Int64 dwFlags,
    ffi.Pointer<Utf16> pszpath);

typedef SHGetFolderPathDart = int Function(
    int hwnd,
    int cSisl,
    int hToken,
    int dwFlags,
    ffi.Pointer<Utf16> pszpath);

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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
  final dylib1 = ffi.DynamicLibrary.open('shell32.dll');
  // final dylib2 = ffi.DynamicLibrary.open('ole32.dll');
  final getPath  =
  dylib1.lookupFunction<SHGetFolderPathC, SHGetFolderPathDart>('SHGetFolderPathA');
  print(getPath);
 final cis = 0x001c ;
 final flags = 0x8000;
  ffi.Pointer<Utf16> r = allocate();
  final getPathResult = getPath(0, cis, 0,flags, r);
  print(getPathResult);
  print(r.ref);
//   File file = File(r.ref.toString());
//   print(file.readAsStringSync());
//   file.writeAsStringSync(r.ref.toString());
//  print(file.path);
  // final freeMem = dylib2.lookupFunction<FreeMemWindows, FreeMemDart>('CoTaskMemFree');
  // freeMem(r.cast());


    // setState(() {
    //   // This call to setState tells the Flutter framework that something has
    //   // changed in this State, which causes it to rerun the build method below
    //   // so that the display can reflect the updated values. If we changed
    //   // _counter without calling setState(), then the build method would not be
    //   // called again, and so nothing would appear to happen.
    //   _counter++;
    // });
  }

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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
