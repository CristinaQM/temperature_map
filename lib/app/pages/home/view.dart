import 'package:flutter/material.dart';
import 'package:temperature_map/app/widgets/my_menubar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:temperature_map/core/app_constants.dart';

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
                        image: AssetImage('images/geotemp_grass.jpeg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    padding: const EdgeInsets.all(50),
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 200),
                          Text(
                            'GeoTemp',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 80,
                            ),
                          ),
                          SizedBox(height: 50),
                          SizedBox(
                            width: 700,
                            child: Text(
                              'Tu Compañero Tecnológico que Monitorea la Temperatura y Rastrea la Ubicación GPS con Precisión, para que Siempre Estés Informado y Seguro en Cualquier Lugar del Mundo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const MyMenuBar(),
                ],
              ),
              ResponsiveContainer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class ResponsiveContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Container(
              width: double.infinity,
              height: 1400,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 60),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        LayoutBuilder(builder: (context, constraints) {
                          if (constraints.maxWidth < 600) {
                            return Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                                    child: Container(
                                      height: 700,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('images/img5.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 65.0),
                                  child: SizedBox(
                                    height: 400.0,
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Column(
                                                children: [
                                                  const Text(
                                                    "Problemática",
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight: FontWeight.w900,
                                                      color: myPurple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 25.0),
                                                child: DefaultTextStyle(
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 25.0,
                                                    ),
                                                    child: AnimatedTextKit(
                                                      animatedTexts: [
                                                        TyperAnimatedText(
                                                            "Las grandes ciudades tienen poca vegetación ocasionando un aumento de las temperaturas según el clima y el entorno que los rodea. Conocer las diferencias de temperaturas de una ciudad ayuda a conocer en qué lugar se debería forestar para ayudar a tener un ambiente saludable.",
                                                            textAlign: TextAlign.justify)
                                                      ],
                                                      totalRepeatCount: 1,
                                                    )),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 65.0),
                                  child: SizedBox(
                                    height: 400.0,
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Problemática",
                                                style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.w900,
                                                  color: myPurple,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 25.0),
                                                child: DefaultTextStyle(
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 25.0,
                                                    ),
                                                    child: AnimatedTextKit(
                                                      animatedTexts: [
                                                        TyperAnimatedText(
                                                            "Las grandes ciudades tienen poca vegetación ocasionando un aumento de las temperaturas según el clima y el entorno que los rodea. Conocer las diferencias de temperaturas de una ciudad ayuda a conocer en qué lugar se debería forestar para ayudar a tener un ambiente saludable.",
                                                            textAlign: TextAlign.justify)
                                                      ],
                                                      totalRepeatCount: 1,
                                                    )),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                                    child: Container(
                                      height: 700,
                                      width: 100,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('images/img5.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                              ],
                            );
                          }
                        }),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              height: 1000,
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
                              padding: const EdgeInsets.only(top: 65.0),
                              child: SizedBox(
                                height: 400.0,
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Problemática",
                                            style: TextStyle(
                                              fontSize: 60,
                                              fontWeight: FontWeight.w900,
                                              color: myPurple,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 25.0),
                                            child: DefaultTextStyle(
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25.0,
                                                ),
                                                child: AnimatedTextKit(
                                                  animatedTexts: [
                                                    TyperAnimatedText(
                                                        "Las grandes ciudades tienen poca vegetación ocasionando un aumento de las temperaturas según el clima y el entorno que los rodea. Conocer las diferencias de temperaturas de una ciudad ayuda a conocer en qué lugar se debería forestar para ayudar a tener un ambiente saludable.",
                                                        textAlign: TextAlign.justify)
                                                  ],
                                                  totalRepeatCount: 1,
                                                )),
                                          )
                                        ],
                                      ),
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
                                    image: AssetImage('images/img5.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Container(
              width: double.infinity,
              height: 1500,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 60),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        LayoutBuilder(builder: (context, constraints) {
                          if (constraints.maxWidth < 600) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 35.0, right: 15.0),
                                  child: Container(
                                    height: 700,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('images/geotemp.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 65.0),
                                    child: SizedBox(
                                      height: 600.0,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Propuesta",
                                                style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.w900,
                                                  color: myPurple,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 25.0),
                                                child: DefaultTextStyle(
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 25.0,
                                                    ),
                                                    child: AnimatedTextKit(
                                                      animatedTexts: [
                                                        TyperAnimatedText(
                                                            "El proyecto se centrará en la creación de un sistema de monitoreo ambiental que utilice dispositivos IoTpara recopilar datos en tiempo real sobre la temperatura y la humedad en una ubicación específica dentro de Guayaquil. El sistema constará de tres componentes principales: Dispositivo de Monitoreo IoT, Plataforma en la Nube, Portal Web de Visualización de Datos.",
                                                            textAlign: TextAlign.justify)
                                                      ],
                                                      totalRepeatCount: 1,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 35.0, right: 15.0),
                                  child: Container(
                                    height: 700,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('images/geotemp.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 65.0),
                                  child: SizedBox(
                                    height: 400.0,
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Propuesta",
                                                style: TextStyle(
                                                  fontSize: 60,
                                                  fontWeight: FontWeight.w900,
                                                  color: myPurple,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 25.0),
                                                child: DefaultTextStyle(
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 25.0,
                                                    ),
                                                    child: AnimatedTextKit(
                                                      animatedTexts: [
                                                        TyperAnimatedText(
                                                            "El proyecto se centrará en la creación de un sistema de monitoreo ambiental que utilice dispositivos IoTpara recopilar datos en tiempo real sobre la temperatura y la humedad en una ubicación específica dentro de Guayaquil. El sistema constará de tres componentes principales: Dispositivo de Monitoreo IoT, Plataforma en la Nube, Portal Web de Visualización de Datos.",
                                                            textAlign: TextAlign.justify)
                                                      ],
                                                      totalRepeatCount: 1,
                                                    )),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                )),
                              ],
                            );
                          }
                        }),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              height: 1000,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 60),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        LayoutBuilder(builder: (context, constraints) {
                          if (constraints.maxWidth < 600) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 35.0, right: 15.0),
                                  child: Container(
                                    height: 700,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('images/geotemp.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 65.0),
                                    child: SizedBox(
                                      height: 400.0,
                                      child: Align(
                                          alignment: Alignment.topCenter,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const Text(
                                                  "Propuesta",
                                                  style: TextStyle(
                                                    fontSize: 60,
                                                    fontWeight: FontWeight.w900,
                                                    color: myPurple,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 25.0),
                                                  child: DefaultTextStyle(
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 25.0,
                                                      ),
                                                      child: AnimatedTextKit(
                                                        animatedTexts: [
                                                          TyperAnimatedText(
                                                              "El proyecto se centrará en la creación de un sistema de monitoreo ambiental que utilice dispositivos IoTpara recopilar datos en tiempo real sobre la temperatura y la humedad en una ubicación específica dentro de Guayaquil. El sistema constará de tres componentes principales: Dispositivo de Monitoreo IoT, Plataforma en la Nube, Portal Web de Visualización de Datos.",
                                                              textAlign: TextAlign.justify)
                                                        ],
                                                        totalRepeatCount: 1,
                                                      )),
                                                )
                                              ],
                                            ),
                                          )),
                                    )),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 35.0, right: 15.0),
                                  child: Container(
                                    height: 700,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('images/geotemp.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 65.0),
                                  child: SizedBox(
                                    height: 400.0,
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Propuesta",
                                                style: TextStyle(
                                                  fontSize: 60,
                                                  fontWeight: FontWeight.w900,
                                                  color: myPurple,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 25.0),
                                                child: DefaultTextStyle(
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 25.0,
                                                    ),
                                                    child: AnimatedTextKit(
                                                      animatedTexts: [
                                                        TyperAnimatedText(
                                                            "El proyecto se centrará en la creación de un sistema de monitoreo ambiental que utilice dispositivos IoTpara recopilar datos en tiempo real sobre la temperatura y la humedad en una ubicación específica dentro de Guayaquil. El sistema constará de tres componentes principales: Dispositivo de Monitoreo IoT, Plataforma en la Nube, Portal Web de Visualización de Datos.",
                                                            textAlign: TextAlign.justify)
                                                      ],
                                                      totalRepeatCount: 1,
                                                    )),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                )),
                              ],
                            );
                          }
                        }),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        })
      ],
    );
  }
}
