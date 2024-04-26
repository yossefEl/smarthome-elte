import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class DevicesIcons {
  static IconData getIconByType(String? type) {
    final iconsByTypeMap = {
      'BrightnessSensor'.toLowerCase(): FluentIcons.brightness_high_24_regular,
      // OccupancySensor
      'OccupancySensor'.toLowerCase(): FluentIcons.person_24_regular,
      // OxygenSensor
      'OxygenSensor'.toLowerCase(): FluentIcons.airplane_take_off_24_regular,
      // TemperatureSensor
      'TemperatureSensor'.toLowerCase(): FluentIcons.temperature_24_regular,
      // LightBulb
      'LightBulb'.toLowerCase(): FluentIcons.lightbulb_24_regular,
      // Window
      'Window'.toLowerCase(): FluentIcons.app_folder_16_filled,
      // AC
      'AC'.toLowerCase(): FluentIcons.arrow_join_20_regular,
      // Heater
      'Heater'.toLowerCase(): FluentIcons.fire_20_regular,
      // ElectricPlug
      'ElectricPlug'.toLowerCase(): FluentIcons.plug_connected_20_regular,
    };
    if (type == null || iconsByTypeMap.containsKey(type.toLowerCase()) == false) {
      return FluentIcons.error_circle_12_filled;
    }
    return iconsByTypeMap[type.toLowerCase()]!;
  }
}
