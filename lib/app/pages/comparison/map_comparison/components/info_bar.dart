import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/pages/comparison/map_comparison/controller.dart';
import 'package:temperature_map/app/widgets/info_bar_global_widgets.dart';
import 'package:temperature_map/core/app_constants.dart';
import 'package:temperature_map/routes/pages.dart';

class MapComparisonBar extends StatelessWidget {
  const MapComparisonBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapComparisonController>();
    final rutasList = controller.rutas;

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
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.offAllNamed(Routes.home);
                },
                icon: Icon(MdiIcons.arrowLeft),
              ),
              const Expanded(
                child: Text(
                  'Comparar Rutas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: controller.rutas.length,
              itemBuilder: (context, idx) {
                final ruta = controller.rutas[idx];

                return RutaExpansionTile(
                  ruta: ruta,
                  index: idx,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final myLength = rutasList.length;
              String newParam = '';
              for (var i = 0; i < myLength; i++) {
                final ruta = rutasList[i];
                newParam += '${ruta['dataKey']}${ruta['id']}';
                if (i < myLength - 1) {
                  newParam += '_';
                }
              }

              Get.offAndToNamed(
                '/dashboard_comparison/$newParam',
              );
            },
            child: const Text('Dashboard'),
          ),
        ],
      ),
    );
  }
}

class RutaExpansionTile extends StatefulWidget {
  const RutaExpansionTile({
    super.key,
    required this.ruta,
    required this.index,
  });

  final Map<String, dynamic> ruta;
  final int index;

  @override
  State<RutaExpansionTile> createState() => _RutaExpansionTileState();
}

class _RutaExpansionTileState extends State<RutaExpansionTile> {
  final controller = Get.find<MapComparisonController>();
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    if (controller.rutaActual['id'] == widget.ruta['id']) {
      isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              isExpanded = !isExpanded;
              setState(() {});
            },
            child: Obx(
              () => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: (controller.rutaActual['id'] == widget.ruta['id']) ? const Color(0xff766ED1) : const Color(0xFFD6EFEF),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ruta ${widget.ruta['id']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: (controller.rutaActual['id'] == widget.ruta['id']) ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: getStrongColorbyIndex(
                              widget.index,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: (controller.rutaActual['id'] == widget.ruta['id'])
                                ? Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                    Icon((isExpanded) ? MdiIcons.chevronUp : MdiIcons.chevronDown),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          height: (isExpanded) ? 325 : 0,
          width: 200,
          duration: const Duration(milliseconds: 500),
          child: (isExpanded)
              ? ListView.builder(
                  itemCount: widget.ruta['dataList'].length,
                  itemBuilder: (ctx, idx) {
                    final point = widget.ruta['dataList'][idx];
                    final temp = point['temperatura'];

                    final color = (temp >= altaTemperatura)
                        ? altoColor
                        : (temp > maxTempAmbiente)
                            ? medioColor
                            : bajoColor;

                    return _PointDataTile(
                      point: point,
                      color: color,
                      ruta: widget.ruta,
                    );
                  },
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _PointDataTile extends StatelessWidget {
  final dynamic ruta;
  final dynamic point;
  final Color color;
  const _PointDataTile({
    required this.point,
    required this.color,
    required this.ruta,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapComparisonController>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (controller.selectedPoint['id'] == point['id'] && controller.rutaActual['id'] == ruta['id']) {
            controller.selectedPoint.clear();
          } else {
            final Map<String, dynamic> pointMap = {...point};
            pointMap['rutaID'] = ruta['id'];
            controller.selectedPoint.value = pointMap;
            controller.newCenter(miRuta: ruta, miPoint: pointMap, move: true);
          }
        },
        child: Obx(
          () => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (controller.selectedPoint['id'] == point['id'] && controller.rutaActual['id'] == ruta['id'])
                  ? const Color(
                      0xFFBAB6E8,
                    )
                  : const Color(
                      0xffD8E7F8,
                    ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color,
                      radius: 13,
                      child: Text(
                        '${point['id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (point['id'].toString().length < 3) ? 14 : 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    PointParamTag(
                      label: '${point['temperatura']}°C',
                      icon: MdiIcons.thermometer,
                      color: const Color(0xFFFF9F31),
                    ),
                    const SizedBox(width: 20),
                    PointParamTag(
                      label: '${point['humedad']}%',
                      icon: MdiIcons.waterPercent,
                      color: const Color(0xFF3180FF),
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: (controller.selectedPoint['id'] == point['id']) ? 165 : 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  child: (controller.selectedPoint['id'] == point['id'])
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
