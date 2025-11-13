class DiceCategory {
  final String id;
  final String label;
  final String icon;

  DiceCategory({required this.id, required this.label, required this.icon});

  factory DiceCategory.fromJson(Map<String, dynamic> json) {
    return DiceCategory(
      id: json['id'],
      label: json['label'],
      icon: json['icon'],
    );
  }
}
