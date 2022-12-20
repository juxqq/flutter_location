import 'package:flutter/material.dart';
import 'package:tds/models/habitation.dart';
import 'package:tds/models/typehabitat.dart';
import 'package:tds/services/habitation_service.dart';
import 'package:tds/share/location_style.dart';
import 'package:tds/share/location_text_style.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tds/views/habitation_list.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final HabitationService service = HabitationService();
  final String title;
  late List<TypeHabitat> _typehabitats;
  late List<Habitation> _habitations;

  MyHomePage({required this.title, Key? key}) : super(key: key) {
    _habitations = service.getHabitationsTop10();
    _typehabitats = service.getTypeHabitats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            _buildTypeHabitat(context),
            SizedBox(height: 20),
            _buildDerniereLocation(context),
          ],
        ),
      ),
    );
  }

  _buildTypeHabitat(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.0),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          _typehabitats.length,
          (index) => _buildHabitat(context, _typehabitats[index]),
        ),
      ),
    );
  }

  _buildHabitat(BuildContext context, TypeHabitat typeHabitat) {
    var icon = Icons.house;
    switch (typeHabitat.id) {
      case 2:
        icon = Icons.apartment;
        break;
      default:
        icon = Icons.home;
    }
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: LocationStyle.backgroundColorPurple,
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HabitationList(typeHabitat.id == 1),
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white70,
              ),
              SizedBox(width: 5),
              Text(
                typeHabitat.libelle,
                style: LocationTextStyle.regularWhiteTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildDerniereLocation(BuildContext context) {
    return Container(
      height: 240,
      child: ListView.builder(
        itemCount: _habitations.length,
        itemExtent: 220,
        itemBuilder: (context, index) =>
            _buildRow(_habitations[index], context),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  _buildRow(Habitation habitation, BuildContext context) {
    var format = intl.NumberFormat('### €');

    return Container(
      width: 240,
      margin: EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/images/locations/${habitation.image}',
              fit: BoxFit.fitWidth,
            ),
          ),
          Text(
            habitation.libelle,
            style: LocationTextStyle.regularTextStyle,
          ),
          Row(
            children: [
              Icon(Icons.location_on_outlined),
              Text(
                habitation.adresse,
                style: LocationTextStyle.regularTextStyle,
              ),
            ],
          ),
          Text(
            format.format(habitation.prixmois),
            style: LocationTextStyle.boldTextStyle,
          ),
        ],
      ),
    );
  }
}
