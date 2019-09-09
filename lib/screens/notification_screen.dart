import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.0),
      itemBuilder: (context, index) => Card(
            child: ListTile(
              onTap: () {},
              leading: CircleAvatar(
                radius: 24.0,
                backgroundImage: AssetImage('images/person.jpg'),
              ),
              title: RichText(
                text: TextSpan(
                    text: 'Joko menambahkan anda di grup sad asa... ',
                    style: TextStyle(
                        fontSize: 14.0, color: Colors.black, fontFamily: "pop"),
                    children: [
                      TextSpan(
                        text: 'Trip to Gn. Bromo',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      )
                    ]),
              ),
              trailing: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "11:11 pm",
                      style: TextStyle(
                        color: Colors.red,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      itemCount: 10,
    );
  }
}
