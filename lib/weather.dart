class Weather {
  final String name;
  final String desc;
  final String icon;
  final double temp;

  Weather({this.name = '', this.desc = '', this.icon = '', this.temp = 0});  


  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      name: json['name']?? '',
      desc: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      temp: json['main']['temp'] ?? 0);
  }
}