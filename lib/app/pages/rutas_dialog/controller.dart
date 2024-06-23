import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class RutasController extends GetxController {
  final _loading = true.obs;
  final _rutas = <String, dynamic>{}.obs;

  final urlSrc = 'sensorDataNuevoMariaIsabel';

  bool get loading => _loading.value;
  Map<String, dynamic> get rutas => {..._rutas};

  final database = FirebaseDatabase.instance;

  void fetchRecords() async {
    _loading.value = true;

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.get();

    if (snapshot.exists) {
      _rutas.clear();
      final data = snapshot.value as Map;
      final map = data[urlSrc];

      int counter = 1;

      for (var ruta in map.entries) {
        final List<dynamic> list = ruta.value;
        list.removeWhere((item) => item == null);
        for (var i = 0; i < list.length; i++) {
          list[i].putIfAbsent('id', () => i);
        }
        _rutas['Ruta $counter'] = list;

        counter++;
      }
    }

    //TODO: Para agregarlo en el mapa en tiempo real
    // final reference = database.ref('sensorDataNuevoMariaIsabel');
    // reference.onValue.listen(
    //   (DatabaseEvent event) {
    //     _rutas.clear();
    //     final snapshot = event.snapshot.value;
    //     print(snapshot);
    //   },
    // );

    // reference.onValue.listen(onData)

    _loading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
    fetchRecords();
  }
}
