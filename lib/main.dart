import 'dart:ffi' as ffi;
// import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';


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
  final dylib2 = ffi.DynamicLibrary.open('ole32.dll');
  // This is a deprecated call, but should still work. Using this for now because it's easier to call.
  // The new one needs a GUI struct, that I haven't figured out how to get from ffi.
  final getPath  =
  dylib1.lookupFunction<SHGetFolderPathC, SHGetFolderPathDart>('SHGetFolderPathA');
  print(getPath);
 final cis = 0x001c; // THE ID for LOCAL_DATA
 final flags = 0x8000; // CREATE FLAG
  ffi.Pointer<Utf16> r = allocate();
  final getPathResult = getPath(0, cis, 0,flags, r);
  print(getPathResult);
  print(r.ref.toString()); // This prints "Instance of 'Utf16'"
//   File file = File(r.ref.toString());
//   print(file.readAsStringSync());
//   file.writeAsStringSync(r.ref.toString());
//  print(file.path);
  final freeMem = dylib2.lookupFunction<FreeMemWindows, FreeMemDart>('CoTaskMemFree');
  freeMem(r.cast());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
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
