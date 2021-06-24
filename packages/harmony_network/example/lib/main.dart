import 'package:example/ext.dart';
import 'package:flutter/material.dart';

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
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: Text('send request'),
              onPressed: () async {
                //send request
                // var api = Openapi();
                // var response = await api.getMyProgramControllerApi().getmyProgramsUsingGET().sealed();
                // print(response.data);
                // print(response.exception);
              },
            ),
          ],
        ),
      ),
    );
  }
}
