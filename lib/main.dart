import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/src/bloc/lenguaje_bloc.dart';
import 'package:firebase_example/src/models/lenguaje.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {

  LenguajeBLoC lenguajeBLoC = LenguajeBLoC();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalLenguaje(context)
        ),
        appBar: AppBar(
          title: Text("Lenguaje")
        ),
        body: Center(
          child: StreamBuilder(
            stream: lenguajeBLoC.lenguajesStream,
            builder: (context, snapshot) {
              
              if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    
                    Lenguaje lenguaje = Lenguaje.fromSnapshot(documents[index]);
                    
                    return ListTile(
                      onTap: () async {
                        await lenguajeBLoC.agregarUnVoto(lenguaje);
                      },
                      title: Text(
                        lenguaje.nombre,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        lenguaje.votos.toString()
                      ),
                    );
                  },
                );

              }

              return Center(
                child: CircularProgressIndicator(),
              );

            },
          )
        ),
      );
  }

  showModalLenguaje(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Agregar Lenguaje",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  decoration: InputDecoration(
                    hintText: "Nombre de Lenguaje"
                  ),
                  onChanged: (nuevoValor) {
                    lenguajeBLoC.nombre = nuevoValor;
                  },
                ),

                const SizedBox(height: 16),

                RaisedButton(
                  child: Text("Agregar"),
                  onPressed: () async {
                    await lenguajeBLoC.agregarLenguaje();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      }
    );
  }
}