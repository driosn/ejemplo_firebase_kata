import 'package:cloud_firestore/cloud_firestore.dart';

class Lenguaje {

  String nombre;
  int votos;
  DocumentReference reference;

  Lenguaje({
    this.nombre,
    this.votos,
    this.reference
  });

  Lenguaje.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    this.nombre = data["nombre"];
    this.votos = data["votos"];
    this.reference = snapshot.reference;
  }

}