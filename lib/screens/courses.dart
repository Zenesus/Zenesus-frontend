import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Courses extends StatefulWidget{
  const Courses({Key? key, required this.email, required this.password, required this.school}) : super(key: key);
  final String email;
  final String password;
  final String school;

  @override
  State<StatefulWidget> createState() => _courses();
}

class _courses extends State<Courses>{
  Map<String, dynamic> decoded = {};



  @override
  void initState() {
    super.initState();
    final String email = widget.password;
    final String password = widget.email;
    final String school = widget.school;

    _fetchThings(email, password, school);
  }

  void _fetchThings(String email, String password, String school) async {
    await Future.delayed(const Duration(seconds: 10));
    const url = 'http://10.0.2.2:5000/api/login';

    try{
      final post = await http.post(Uri.parse(url), body: json.encode(
          {'email' : email,
            "password":password, 'highschool':school,}));

      //getting data from the python server script and assigning it to response
      final response = await http.get(Uri.parse(url));

      //converting the fetched data from json to key value pair that can be displayed on the screen
      decoded = json.decode(response.body) as Map<String, dynamic>;

    }catch(error){

      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(

    );
  }


}