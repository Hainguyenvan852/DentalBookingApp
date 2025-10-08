class ServiceModel {
  final String name;
  final String description;

  ServiceModel({required this.name, required this.description});


  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description
  };


  factory ServiceModel.fromMap(Map<String, dynamic> m) => ServiceModel(
    name: m['name'] as String,
    description: m['description'] as String,
  );
}