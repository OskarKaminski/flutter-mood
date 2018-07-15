import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Mood meter',
      home: const MyHomePage(title: 'Mood meter'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  static const statuses = {
    'laugh': '😀',
    'smile': '🙂',
    'sad': '😕',
    'angry': '😤',
    'terrified': '😱'
  };

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  var lastMood = ds['moodHistory'][0]['value'];
                  print(lastMood);
                  return new Card(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new ListTile(
                          leading: new Text(
                              lastMood == null ? statuses['laugh'] : statuses[lastMood],
                              style: new TextStyle(fontSize: 36.0)
                          ),
                          title: new Text(ds['name']),
                        ),
                      ],
                    ),
                  );
                }
            );
          }),
    );
  }
}