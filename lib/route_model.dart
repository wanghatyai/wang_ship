class RouteShip{
  final String routeId;
  final String routeCode;
  final String routeName;

  RouteShip({
    this.routeId,
    this.routeCode,
    this.routeName
  });

  factory RouteShip.fromJson(Map<String, dynamic> json){
    return new RouteShip(
      routeId: json['r_id'],
      routeCode: json['r_code'],
      routeName: json['r_name'],
    );
  }

}