/// Custom business object class which contains properties to hold the detailed
/// information about the order which will be rendered in datagrid.
class OrderInfo {
  /// Creates the order class with required details.
  OrderInfo(
      this.category, this.all, this.performance, double d, String city, double x);

  /// Id of an order.
  final int category;

  /// Customer Id of an order.
  final int all;

  /// Name of an order.
  final String performance;

  
}