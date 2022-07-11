import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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


//function to add border and rounded edges to our form
OutlineInputBorder _inputformdeco(){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide:
    BorderSide(width: 1.5, color: Colors.blue, style: BorderStyle.solid),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  String email = "";
  String password = "";
  String final_response = "";

  final _formkey = GlobalKey<FormState>(); //key created to interact with the form

  //function to validate and save user form
  Future<void> _savingData() async{
    final validation = _formkey.currentState?.validate();
    if (!validation!){
      return;
    }
    _formkey.currentState?.save();
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
            const SizedBox(height: 100),
            SizedBox(width: 350,
              child: Form(key: _formkey,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your email: ',
                    enabledBorder: _inputformdeco(),
                    focusedBorder: _inputformdeco(),
                  ),onSaved: (value){
                  setState(() {
                    email = value!;
                  });
                },
                ),

              ),
            ),
            /*
            Text(
              name,
              style: Theme.of(context).textTheme.headline4,
            ),

            */
            FlatButton(
              onPressed: () async {

                _savingData();

                //url to send the get request to
                const url = 'http://10.0.2.2:5000/api/getgrade';


                //sending a post request to the url
                final post = await http.post(Uri.parse(url), body: json.encode({'email' : "asdfasdfhjk", "password":"asdfadsf"}));

                //getting data from the python server script and assigning it to response
                final response = await http.get(Uri.parse(url));

                //converting the fetched data from json to key value pair that can be displayed on the screen
                final decoded = json.decode(response.body) as Map<String, dynamic>;

                //changing the UI be reassigning the fetched data to final response
                setState(() {
                  final_response = decoded['name'];
                });

              },
              child: Text('GET'),
              color: Colors.lightBlue,
            ),
            //Text(final_response, style: TextStyle(fontSize: 24)),

          ],
        ),
      ),
    );
  }
}
