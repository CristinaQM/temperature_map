import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class RutasController extends GetxController {
  final _loading = true.obs;
  final _rutas = <dynamic>[].obs;

  bool get loading => _loading.value;
  List<Map<String, dynamic>> get rutas => [..._rutas];

  final database = FirebaseDatabase.instance;

  void fetchRecords() async {
    _loading.value = true;

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.get();

    if (snapshot.exists) {
      _rutas.clear();
      final data = snapshot.value;
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

    print(_rutas);
  }

  @override
  void onReady() {
    super.onReady();
    fetchRecords();
  }
}
