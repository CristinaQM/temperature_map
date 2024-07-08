import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class DashboardPageController extends GetxController {
  //Data de la ruta seleccionada
  Map<String, dynamic> route = {};

  //Lista de los puntos de ubicación
  final pointList = <dynamic>[].obs;

  //Creación de la instancia de Firebase,
  //por medio de esta accederemos a la data
  final database = FirebaseDatabase.instance;

  //Url de la base de datos, guardada en variable
  //por si se cambia en un futuro se cambia solo la variable
  final urlSrc = 'sensorDataNuevoMariaIsabel';

  //Observables
  //Son variables que, por medio del widget OBx, cambiarán la vista
  //si es que la variable es modificada

  final _loading = true.obs; //variable de carga
  bool get loading => _loading.value; //getter

  final _hasError = false.obs; //variable de error
  bool get hasError => _hasError.value; //getter

  //Función para llamar los datos de firebase y guardarlos
  Future<void> fetchRoute() async {
    _loading.value = true;

    try {
      //El parameter se envía al seleccionar la ruta
      //Consta de la dataKey de la ruta seguida del id
      final parameter = Get.parameters['dataKey']!;

      //Parameters
      String dataKey = parameter.substring(1);
      int id = int.parse(parameter.substring(0, 1));

      //Guardamos la data en el Map de ruta
      route['id'] = id;
      route['dataKey'] = dataKey;

      //Firebase Data
      //Creamos una referencia con el path de la base de datos
      //más la key del objeto deseado, para llamar la información de solo
      //ese objeto
      final reference = FirebaseDatabase.instance.ref('$urlSrc/$dataKey');

      //Le agregamos un Listener, en caso de que haya una modificación
      //en la base de datos se realizará el evento descrito aquí
      //(aún no terminado de probar)
      reference.onValue.listen(
        (DatabaseEvent event) async {
          final snapshot = event.snapshot.value; //obtenemos la data del firebase y la guardamos
          pointList.clear(); //limpiamos la lista para evitar colocar elementos repetidos

          pointList.addAll(snapshot as List<dynamic>); //agregamos toda la data (todos los json de los location points)
          pointList.removeWhere((item) => item == null); //borramos los datos nulos

          //Este for está hecho para agregarle un id a cada location point
          //para tener un identificador en caso de necesitarlo
          for (var i = 0; i < pointList.length; i++) {
            pointList[i].putIfAbsent('id', () => i);
          }

          _loading.value = false;
        },
      );
    } catch (e) {
      _loading.value = false;
      _hasError.value = true;
    }
  }

  @override
  void onInit() async {
    await fetchRoute();
    super.onInit();
  }
}
