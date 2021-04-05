import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/src/models/lenguaje.dart';
import 'package:rxdart/rxdart.dart';

class LenguajeBLoC {

  final _nombreController = BehaviorSubject<String>();

  Stream<QuerySnapshot> get lenguajesStream => FirebaseFirestore.instance.collection("lenguaje").snapshots();
  Stream<String> get nombreStream => _nombreController.stream;

  set nombre(valor) => _nombreController.sink.add(valor);

  String get nombre => _nombreController.value;

  Future<void> agregarLenguaje() async {
    DocumentReference reference = await FirebaseFirestore.instance.collection("lenguaje").add({
      "nombre": nombre,
      "votos": 0
    });

    print("Id NUEVA REFERENCIA: ${reference.id}");
  }

  Future<void> agregarUnVoto(Lenguaje mLenguaje) async {
    FirebaseFirestore.instance.runTransaction((txn) async {
      final snapshot = await txn.get(mLenguaje.reference);
      final lenguaje = Lenguaje.fromSnapshot(snapshot);

      txn.update(mLenguaje.reference, {'votos': lenguaje.votos + 1});
    });
    
    await mLenguaje.reference.update({
      "votos": mLenguaje.votos + 1
    });
  }

  void dispose() {
    _nombreController?.close();
  }
}