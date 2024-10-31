
class Pharmacy {
  final String name;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;

  Pharmacy({
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
}
