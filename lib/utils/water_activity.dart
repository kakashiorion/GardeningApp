String waterActivityTableName = 'WaterActivity';

class WaterActivityFields {
  static final List<String> values = [
    id,
    plantId,
    waterActivityDate,
  ];

  static String id = '_id';
  static String plantId = 'PlantId';
  static String waterActivityDate = 'WaterActivityDate';
}

class WaterActivity {
  const WaterActivity(
      {this.wId, required this.wPlantId, required this.wWaterActivityDate});
  final int? wId;
  final int wPlantId;
  final DateTime wWaterActivityDate;

  Map<String, Object?> toJson() => {
        WaterActivityFields.id: wId,
        WaterActivityFields.plantId: wPlantId,
        WaterActivityFields.waterActivityDate:
            wWaterActivityDate.millisecondsSinceEpoch,
      };

  static WaterActivity fromJson(Map<String, Object?> data) => WaterActivity(
        wId: data[WaterActivityFields.id] as int?,
        wPlantId: data[WaterActivityFields.plantId] as int,
        wWaterActivityDate: DateTime.fromMillisecondsSinceEpoch(
            data[WaterActivityFields.waterActivityDate] as int),
      );

  WaterActivity copy({int? wId, int? wPlantId, DateTime? wWaterActivityDate}) =>
      WaterActivity(
        wId: wId ?? this.wId,
        wPlantId: wPlantId ?? this.wPlantId,
        wWaterActivityDate: wWaterActivityDate ?? this.wWaterActivityDate,
      );
}
