import 'package:plant_watering_app/utils/plant.dart';
import 'package:plant_watering_app/utils/water_activity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PlantDatabase {
  PlantDatabase._init();

  static final PlantDatabase instance = PlantDatabase._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('gardening.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //Create database with all the required tables
  Future _createDB(Database db, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String textType = 'TEXT NOT NULL';
    const String integerType = 'INTEGER NOT NULL';

    //Create Plant table
    await db.execute('''CREATE TABLE $plantTableName (
      ${PlantFields.id} $idType,
      ${PlantFields.name} $textType,
      ${PlantFields.imageLoc} $textType,
      ${PlantFields.size} $textType,
      ${PlantFields.lastWaterDate} $integerType,
      ${PlantFields.gap} $integerType,
      ${PlantFields.createdTime} $integerType
    ) ''');

    //Create WaterActivity table
    await db.execute('''CREATE TABLE $waterActivityTableName (
      ${WaterActivityFields.id} $idType,
      ${WaterActivityFields.plantId} $integerType,
      ${WaterActivityFields.waterActivityDate} $integerType
    )''');
  }

  //------------- WATER ACTIVITY DB OPERATIONS ----------
  //Create a waterActivity
  Future<WaterActivity> createWaterActivity(WaterActivity waterActivity) async {
    final db = await instance.database;
    final generatedId =
        await db.insert(waterActivityTableName, waterActivity.toJson());
    return waterActivity.copy(
      wId: generatedId,
    );
  }

  //Read all waterActivities by plantId
  Future<List<WaterActivity>> readAllWaterActivitiesByPlantId(
      int? plantId) async {
    final db = await instance.database;
    final waterActivityData = await db.query(waterActivityTableName,
        where: '${WaterActivityFields.plantId} = ?',
        whereArgs: [plantId],
        orderBy: '${WaterActivityFields.waterActivityDate} ASC');

    if (waterActivityData.isNotEmpty) {
      return waterActivityData
          .map((waterActivityData) => WaterActivity.fromJson(waterActivityData))
          .toList();
    } else {
      throw Exception(
          'readAllWaterActivitiesByPlantId: No water activities found for the plant $plantId');
    }
  }

  //Read all waterActivities by waterDate
  Future<List<WaterActivity>> readAllWaterActivitiesByDate(
      int waterDate) async {
    final db = await instance.database;
    final waterActivityData = await db.query(waterActivityTableName,
        where: '${WaterActivityFields.waterActivityDate} = ?',
        whereArgs: [waterDate],
        orderBy: '${WaterActivityFields.plantId} ASC');

    if (waterActivityData.isNotEmpty) {
      return waterActivityData
          .map((waterActivityData) => WaterActivity.fromJson(waterActivityData))
          .toList();
    } else {
      throw Exception(
          'readAllWaterActivitiesByDate: No water activities found for the date $waterDate');
    }
  }

  //Delete a waterActivity by id
  Future<int> deleteWaterActivity(int id) async {
    final db = await instance.database;
    return await db.delete(waterActivityTableName,
        where: '${WaterActivityFields.id} = ?', whereArgs: [id]);
  }

  //------------- PLANT DB OPERATIONS ----------
  //Create a plant
  Future<int> createPlantReturnId(Plant plant) async {
    final db = await instance.database;
    int id = await db.insert(plantTableName, plant.toJson());
    return id;
  }

  //Read a plant by Id
  Future<Plant> readPlant(int id) async {
    final db = await instance.database;
    final plantData = await db.query(plantTableName,
        columns: PlantFields.values,
        where: '${PlantFields.id} = ?',
        whereArgs: [id]);
    if (plantData.isNotEmpty) {
      return Plant.fromJson(plantData.first);
    } else {
      throw Exception('readPlant: ID $id not found');
    }
  }

  //Read all plants
  Future<List<Plant>> readAllPlants() async {
    final db = await instance.database;
    final plantData = await db.query(plantTableName,
        orderBy: '${PlantFields.lastWaterDate} ASC');

    if (plantData.isNotEmpty) {
      return plantData.map((plantData) => Plant.fromJson(plantData)).toList();
    } else {
      throw Exception('readAllPlants: No plant found');
    }
  }

  //  //Read plants to be watered today
  // Future<List<Plant>> readPlantsWaterToday() async {
  //   final db = await instance.database;
  //   final plantData = await db.query(plantTableName,
  //       where: '$',
  //       orderBy: '${PlantFields.lastWaterDate} ASC');

  //   if (plantData.isNotEmpty) {
  //     return plantData.map((plantData) => Plant.fromJson(plantData)).toList();
  //   } else {
  //     throw Exception('readPlantsWaterToday: No plant found');
  //   }
  // }

  //Update a plant
  Future<int> updatePlant(Plant plant) async {
    final db = await instance.database;
    return await db.update(plantTableName, plant.toJson(),
        where: '${PlantFields.id} = ?', whereArgs: [plant.pId]);
  }

  //Update waterDate for a plant
  Future<int> updatePlantWateredDate(int? id, DateTime date) async {
    final db = await instance.database;
    Map<String, Object?> waterDate = {
      PlantFields.lastWaterDate: date.millisecondsSinceEpoch
    };
    return await db.update(plantTableName, waterDate,
        where: '${PlantFields.id} = ?', whereArgs: [id]);
  }

  //Delete a plant by id
  Future<int> deletePlant(int id) async {
    final db = await instance.database;
    return await db.delete(plantTableName,
        where: '${PlantFields.id} = ?', whereArgs: [id]);
  }

  //Close DB
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
