import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Highschool{
  late int id;
  late String name;

  Highschool(this.id, this.name);

  static List<Highschool> getHighschools(){
    return <Highschool>[
      Highschool(0, "Select a School District"),
      Highschool(1, "Montgomery")
    ];
  }


}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenesus',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      darkTheme:ThemeData.dark(),
      home: const MyHomePage(title: 'Zenesus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}




class _MyHomePageState extends State<MyHomePage> {
  String email = "";
  String password = "";
  String final_response = "";

  late bool _passwordVisible = false;

  final List<Highschool> _highschools = Highschool.getHighschools();
  late List<DropdownMenuItem<Highschool>> _dropdownMenuItems;
  late Highschool _selectedHighschool;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_highschools);
    _selectedHighschool = _dropdownMenuItems[0].value!;
    super.initState();
  }

  List<DropdownMenuItem<Highschool>> buildDropdownMenuItems(List<Highschool> highschools) {
    List<DropdownMenuItem<Highschool>> items = [];
    for (Highschool highschool in highschools){
      items.add(
        DropdownMenuItem(
          value: highschool,
          child: Text(highschool.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Highschool? selectedHighschool){
    setState((){
      _selectedHighschool = selectedHighschool!;
    });
  }

  
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    super.dispose();
  }


  //function to add border and rounded edges to our form
  OutlineInputBorder _inputformdeco(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide:
      BorderSide(width: 1.5, color: Colors.blue, style: BorderStyle.solid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zenesus",style:  TextStyle(
            fontSize: 25,
            letterSpacing: 7,
            fontWeight: FontWeight.bold,
            fontFamily: "Merriweather"
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(passwordController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
      body: Center(

        child: Column(

          children: <Widget>[
            SizedBox(width: 350,height:450 ,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  const Spacer(flex: 3),
                  Image.asset('assets/open-book.png',
                    height: 225,
                    width: 225,
                  ),

                  const Spacer(flex: 1),

                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.school),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          )
                      ),
                      value: _selectedHighschool,
                      items: _dropdownMenuItems,
                      onChanged: onChangeDropdownItem
                  ),

                  const Spacer(flex: 1),
                  TextFormField(
                      keyboardType: TextInputType.text,
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: "Enter your email",
                        enabledBorder: _inputformdeco(),
                        focusedBorder: _inputformdeco(),
                      )
                    ),
                  const Spacer(flex: 1),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      enabledBorder: _inputformdeco(),
                      focusedBorder: _inputformdeco(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),

                ],

              )
              ),
            ElevatedButton(
              onPressed: () async {


                //url to send the get request to
                const url = 'http://10.0.2.2:5000/api/login';


                //sending a post request to the url
                final post = await http.post(Uri.parse(url), body: json.encode(
                    {'email' : "asdfasdfhjk",
                      "password":"asdfadsf", 'highschool':"Montgomery Highschool",
                      "mp":"MP2"}));

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
            ),

          ],
        ),

      ),
    );
  }


}
