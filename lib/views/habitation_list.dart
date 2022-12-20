import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tds/models/habitation.dart';
import 'package:intl/intl.dart/' as intl;
import 'package:tds/services/habitation_service.dart';
import 'package:tds/views/share/habitation_option.dart';

class HabitationList extends StatelessWidget {
  final HabitationService service = HabitationService();
  late List<Habitation> _habitations;
  final bool isHouseList;

  HabitationList(this.isHouseList, {Key? key}) : super(key: key) {
    _habitations = isHouseList ? service.getMaisons() : service.getAppartements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Liste des ${this.isHouseList ? 'maisons' : 'appartements'}"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _habitations.length,
          itemBuilder: (context, index) =>
              _buildRow(_habitations[index], context),
          itemExtent: 285,
        ),
      ),
    );
  }

  _buildRow(Habitation habitation, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: Column(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'assets/images/locations/${habitation.image}',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          _buildDetails(habitation),
        ],
      ),
    );
  }

  _buildDetails(Habitation habitation) {
    var format = intl.NumberFormat("### €");
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(habitation.libelle),
                  subtitle: Text(habitation.adresse),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  format.format(habitation.prixmois),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HabitationOption(Icons.group, "${habitation.chambres} personnes"),
              HabitationOption(
                  Icons.fit_screen, "${habitation.superficie} m^2"),
            ],
          ),
        ],
      ),
    );
  }
}
