String plantTableName = 'plant';

class PlantFields {
  static final List<String> values = [
    id,
    name,
    imageLoc,
    size,
    lastWaterDate,
    gap,
    createdTime
  ];

  static String id = '_id';
  static String name = 'Name';
  static String imageLoc = 'ImageLoc';
  static String size = 'Size';
  static String lastWaterDate = 'LastWaterDate';
  static String gap = 'Gap';
  static String createdTime = 'CreatedTime';
}

class Plant {
  const Plant(
      {required this.pName,
      required this.pImageLocation,
      required this.pLastWateredDate,
      required this.pWateringGap,
      required this.pSize,
      this.pId,
      required this.pCreatedTime});

  final int? pId;
  final String pName;
  final String pImageLocation;
  final String pSize;
  final DateTime pLastWateredDate;
  final int pWateringGap;
  final DateTime pCreatedTime;

  Map<String, Object?> toJson() => {
        PlantFields.id: pId,
        PlantFields.name: pName,
        PlantFields.imageLoc: pImageLocation,
        PlantFields.size: pSize,
        PlantFields.lastWaterDate: pLastWateredDate.millisecondsSinceEpoch,
        PlantFields.gap: pWateringGap,
        PlantFields.createdTime: pCreatedTime.millisecondsSinceEpoch,
      };

  static Plant fromJson(Map<String, Object?> data) => Plant(
      pId: data[PlantFields.id] as int?,
      pName: data[PlantFields.name] as String,
      pImageLocation: data[PlantFields.imageLoc] as String,
      pLastWateredDate: DateTime.fromMillisecondsSinceEpoch(
          data[PlantFields.lastWaterDate] as int),
      pWateringGap: data[PlantFields.gap] as int,
      pSize: data[PlantFields.size] as String,
      pCreatedTime: DateTime.fromMillisecondsSinceEpoch(
          data[PlantFields.createdTime] as int));

  Plant copy(
          {int? pId,
          String? pName,
          String? pImageLocation,
          String? pSize,
          DateTime? pLastWateredDate,
          int? pWateringGap,
          DateTime? pCreatedTime}) =>
      Plant(
        pId: pId ?? this.pId,
        pName: pName ?? this.pName,
        pImageLocation: pImageLocation ?? this.pImageLocation,
        pSize: pSize ?? this.pSize,
        pLastWateredDate: pLastWateredDate ?? this.pLastWateredDate,
        pWateringGap: pWateringGap ?? this.pWateringGap,
        pCreatedTime: pCreatedTime ?? this.pCreatedTime,
      );
}
