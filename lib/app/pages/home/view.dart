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
                    height: 730,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/home_banner.jpg'),
                        fit: BoxFit.cover,
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
                height: 700,
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
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: SizedBox(
                                    height: 80,
                                    
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
                                    height: 500,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'images/home_banner.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ))
                              ],
                          ),
                          
                          Positioned(
                            top: 280,
                            child: Container(
                              height: 180,
                              width: 600,
                              color: Colors.blue,
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    top: 35.0, left: 140.0, right: 40),
                                child: Text(
                                  "Las grandes ciudades tienen poca vegetación ocasionando un aumento de las temperaturas según el clima y el entorno que los rodea. Conocer las diferencias de temperaturas de una ciudad ayuda a conocer en qué lugar se debería forestar para ayudar a tener un ambiente saludable.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 117, 27, 27),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.amber,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: const Color.fromARGB(255, 104, 94, 63),
                          height: 100,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: const Color.fromARGB(255, 31, 14, 36),
                          height: 100,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
