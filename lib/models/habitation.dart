import 'package:tds/models/typehabitat.dart';

class Habitation {
  int id;
  TypeHabitat typeHabitat;
  String image;
  String libelle;
  String adresse;
  int nbpersonnes;
  int chambres;
  int superficie;
  double prixmois;

  Habitation(this.id, this.typeHabitat, this.image, this.libelle, this.adresse, this.nbpersonnes, this.chambres, this.superficie, this.prixmois);
}