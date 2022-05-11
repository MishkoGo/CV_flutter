import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/about_page.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text('Currency Converter', style: TextStyle(fontSize: 20),),
                  accountEmail: Text(''),
              ),
              buildMenuItem(
                text: 'About',
                icon: Icons.account_box_outlined,
                onClicked: () => selectedItem(context, 1),
              )
            ],
          ),
        )
    );
  }

 Widget buildMenuItem({
   required String text, required IconData icon, VoidCallback? onClicked
 }) {
    final color = Colors.black;
    final hoverColor = Colors.white;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked
    );
 }

 void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AboutPage(),
        ));
        break;
    }
 }
}
