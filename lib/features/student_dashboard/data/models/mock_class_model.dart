import '../../domain/entities/class_entity.dart';

class MockClassModel extends ClassEntity {
  MockClassModel({
    required super.id,
    required super.code,
    required super.name,
    required super.lecturer,
    required super.studentCount,
    required super.group,
    super.status,
  });

  factory MockClassModel.fromEntity(ClassEntity entity) {
    return MockClassModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      lecturer: entity.lecturer,
      studentCount: entity.studentCount,
      group: entity.group,
      status: entity.status,
    );
  }
}
