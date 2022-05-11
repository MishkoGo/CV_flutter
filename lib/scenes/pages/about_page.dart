import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50,),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/image.jpg'),
                ),
                SizedBox(height: 20,),
                Text('Junior Flutter Developer', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            ),
          )
         )
      );
  }
}


