import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:temperature_map/app/pages/map/controller.dart';
import 'package:temperature_map/app/pages/rutas_dialog/view.dart';
import 'package:temperature_map/app/widgets/info_bar_global_widgets.dart';
import 'package:temperature_map/core/app_constants.dart';
import 'package:temperature_map/routes/pages.dart';

class MapViewBar extends StatefulWidget {
  const MapViewBar({
    super.key,
  });

  @override
  State<MapViewBar> createState() => _MapViewBarState();
}

class _MapViewBarState extends State<MapViewBar> {
  bool hide = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapPageController>();
    final route = controller.route;

    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1.0, 0.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.offAllNamed(Routes.home);
                },
                icon: Icon(MdiIcons.arrowLeft),
              ),
              Expanded(
                child: Text(
                  'Ruta ${route['id']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  hide = !hide;
                  setState(() {});
                },
                icon: Icon((hide) ? MdiIcons.menuDown : MdiIcons.menuUp),
              ),
            ],
          ),
          if (hide)
            const SizedBox.shrink()
          else
            Expanded(
              child: Column(
                children: [
                  const Divider(),
                  MyPercentWidget(
                      medidaPromedio:
                          controller.calculateAverage('temperatura')),
                  const Divider(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.pointList.length,
                      itemBuilder: (context, idx) {
                        final point = controller.pointList[idx];
                        final temp = point['temperatura'];

                        final color = (temp >= altaTemperatura)
                            ? altoColor
                            : (temp > maxTempAmbiente)
                                ? medioColor
                                : bajoColor;

                        return DataPointTile(point: point, color: color);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.dialog(const RutasDialog());
                    },
                    child: const Text('Comparar Rutas'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        '/dashboard/${route['dataKey']}${route['id']}',
                      );
                    },
                    child: const Text('Dashboard'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class MyPercentWidget extends StatefulWidget {
  const MyPercentWidget({
    super.key,
    required this.medidaPromedio,
  });

  final double medidaPromedio;

  @override
  State<MyPercentWidget> createState() => _MyPercentWidgetState();
}

class _MyPercentWidgetState extends State<MyPercentWidget> {
  Map<String, bool> expandedStates = {
    'temperatura': true,
    'MQ135': false,
    'PM2_5': false,
    'PM10': false,
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapPageController>();
    final co2Promedio = controller.calculateAverage('MQ135');
    final pm25Promedio = controller.calculateAverage('PM2_5');
    final pm10Promedio = controller.calculateAverage('PM10');

    return Column(
      children: [
        // Temperatura Widget
        _buildIndicatorSection(
          'Temperatura Promedio',
          widget.medidaPromedio,
          '°C',
          'temperatura',
          (widget.medidaPromedio >= altaTemperatura)
              ? altoColor
              : (widget.medidaPromedio > maxTempAmbiente)
                  ? medioColor
                  : bajoColor,
        ),

        // CO2 Widget
        if (co2Promedio > 0)
          _buildIndicatorSection(
            'CO₂ Promedio',
            co2Promedio,
            'CO₂',
            'MQ135',
            Colors.green,
          ),

        // PM2.5 Widget
        if (pm25Promedio > 0)
          _buildIndicatorSection(
            'PM₂.₅ Promedio',
            pm25Promedio,
            'PM₂.₅',
            'PM2_5',
            Colors.orange,
          ),

        // PM10 Widget
        if (pm10Promedio > 0)
          _buildIndicatorSection(
            'PM₁₀ Promedio',
            pm10Promedio,
            'PM₁₀',
            'PM10',
            Colors.red,
          ),
      ],
    );
  }

  Widget _buildIndicatorSection(
    String title,
    double value,
    String unit,
    String key,
    Color color,
  ) {
    final controller = Get.find<MapPageController>();
    final normalizedValue = controller.normalizeValue(value, key);

    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                expandedStates[key] = !expandedStates[key]!;
              });
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Icon(expandedStates[key]!
                        ? MdiIcons.chevronUp
                        : MdiIcons.chevronDown),
                  ],
                ),
                AnimatedContainer(
                  height: expandedStates[key]! ? 140 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: expandedStates[key]!
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: CircularPercentIndicator(
                                  radius: 60,
                                  animation: true,
                                  lineWidth: 10,
                                  percent: normalizedValue / 100,
                                  center: Text(
                                    '${value.toStringAsFixed(2)} $unit',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  progressColor: color,
                                  circularStrokeCap: CircularStrokeCap.round,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class DataPointTile extends StatelessWidget {
  final dynamic point;
  const DataPointTile({
    super.key,
    required this.point,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapPageController>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (controller.selectedPointID == point['id']) {
            controller.selectedPointID = 0;
          } else {
            controller.selectedPointID = point['id'];
            controller.newCenter(point['id']);
          }
        },
        child: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Color(
                (controller.selectedPointID == point['id'])
                    ? 0xff766ED1
                    : 0xFFD6EFEF,
              ).withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color,
                      radius: 15,
                      child: Text(
                        '${point['id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              (point['id'].toString().length < 3) ? 15 : 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              PointParamTag(
                                label: '${point['temperatura']}°C',
                                icon: MdiIcons.thermometer,
                                color: const Color(0xFFFF9F31),
                              ),
                              const SizedBox(width: 22),
                              PointParamTag(
                                label: '${point['humedad']}%',
                                icon: MdiIcons.waterPercent,
                                color: const Color(0xFF3180FF),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              if (point['MQ135'] != null)
                                PointParamTag(
                                  label: '${point['MQ135']}CO₂',
                                  icon: MdiIcons.molecule,
                                  color: Colors.green,
                                ),
                              const SizedBox(width: 20),
                              if (point['PM2_5'] != null)
                                PointParamTag(
                                  label: '${point['PM2_5']}PM₂.₅',
                                  icon: MdiIcons.airPurifier,
                                  color: Colors.orange,
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (point['PM10'] != null)
                            PointParamTag(
                              label: '${point['PM10']}PM₁₀',
                              icon: Icons.air_outlined,
                              color: Colors.red,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: (controller.selectedPointID == point['id']) ? 165 : 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  child: (controller.selectedPointID == point['id'])
                      ? MyPointInfo(
                          point: point,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyPointInfo extends StatefulWidget {
  final dynamic point;
  const MyPointInfo({
    super.key,
    required this.point,
  });

  @override
  State<MyPointInfo> createState() => _MyPointInfoState();
}

class _MyPointInfoState extends State<MyPointInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Colors.black.withOpacity(0.5),
            ),
            PointParamTag(
              label: '${widget.point['timestamp']}',
              icon: MdiIcons.calendarClock,
              color: const Color(0xffF02B53),
              width: 10,
            ),
            const SizedBox(height: 8),
            PointParamTag(
              boldLabel: 'Alt: ',
              label: '${widget.point['altitude']}',
              icon: MdiIcons.imageFilterHdr,
              color: const Color(0xff7179DB),
              width: 10,
            ),
            const SizedBox(height: 8),
            PointParamTag(
              boldLabel: 'Lat: ',
              label: '${widget.point['latitude']}',
              icon: MdiIcons.latitude,
              color: const Color(0xffF9DB81),
              width: 10,
            ),
            const SizedBox(height: 8),
            PointParamTag(
              boldLabel: 'Long: ',
              label: '${widget.point['longitude']}',
              icon: MdiIcons.longitude,
              color: const Color(0xffF9DB81),
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
