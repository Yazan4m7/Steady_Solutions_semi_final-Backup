class DoughnutData {
  final String name;
  final num value;
  final String parent;  // For hierarchy (optional)

  DoughnutData({required this.name, required this.value, this.parent = ""});
}