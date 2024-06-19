import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class RutasDialog extends GetView<RutasController> {
  const RutasDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RutasController());
    return AlertDialog(
      content: Obx(
        () => (controller.loading)
            ? const Center(
                child: SizedBox.square(
                  dimension: 48,
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: controller.rutas
                      .map(
                        (r) => const ListTile(
                          leading: const Icon(Icons.account_box_outlined),
                          title: Text('AA'),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // children: [
                            //   Text('ID: ${r['user']['id']}'),
                            //   Text('Date: ${r['datetime'].split(' ').first}'),
                            //   Text('Time: ${r['datetime'].split(' ').last}'),
                            // ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
      ),
    );
  }
}
