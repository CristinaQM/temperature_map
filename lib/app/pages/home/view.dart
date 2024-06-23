import 'package:flutter/material.dart';
import 'package:temperature_map/app/widgets/my_menubar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 1000,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/img3.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    padding: const EdgeInsets.all(50),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre de Página Web',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 80,
                          ),
                        ),
                        SizedBox(height: 50),
                        SizedBox(
                          width: 900,
                          child: Text(
                            'Slogan Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const MyMenuBar(),
                ],
              ),
              Container(
                width: double.infinity,
                height: 835,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 60),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Row(
                              children: [
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15.0, top: 65.0),
                                    child: SizedBox(
                                    height: 50,
                                    
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          "Problemática",
                                          style: TextStyle(fontSize: 40),
                                        )),
                                  ),
                                )),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                                    child: Container(
                                    height: 700,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'images/img1_pro.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ))
                              ],
                          ),
                          
                          Positioned(
                            top: 450,
                            child: Container(
                              height: 190,
                              width: 1200,
                              color: Colors.blue,
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    top: 35.0, left: 370.0, right: 40),
                                child: Text(
                                  "Las grandes ciudades tienen poca vegetación ocasionando un aumento de las temperaturas según el clima y el entorno que los rodea. Conocer las diferencias de temperaturas de una ciudad ayuda a conocer en qué lugar se debería forestar para ayudar a tener un ambiente saludable.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 835,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 60),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                                    child: Container(
                                    height: 700,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'images/img1_pro.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )),
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 40.0, top: 65.0),
                                    child: SizedBox(
                                    height: 50,
                                    
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          "Propuesta",
                                          style: TextStyle(fontSize: 40),
                                        )),
                                  ),
                                )),
                                
                              ],
                          ),
                          
                          Positioned(
                            top: 450,
                            left: 700,
                            
                            child: Container(
                              height: 190,
                              width: 1220,
                              color: Colors.blue,
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    top: 22.0, left: 40.0, right: 370.0),
                                child: Text(
                                  "El proyecto se centrará en la creación de un sistema de monitoreo ambiental que utilice dispositivos IoTpara recopilar datos en tiempo real sobre la temperatura y la humedad en una ubicación específica dentro de Guayaquil. El sistema constará de tres componentes principales: Dispositivo de Monitoreo IoT, Plataforma en la Nube, Portal Web de Visualización de Datos",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
