// room_model.dart

class Room {
  final String type;
  final double rate;
  final bool isAvailable;
  final double amount;  // Added the amount field

  Room({
    required this.type,
    required this.rate,
    required this.isAvailable,
    required this.amount,  // Added the amount to the constructor
  });

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'rate': rate,
      'isAvailable': isAvailable,
      'amount': amount,  // Include the amount in serialization
    };
  }

  // Deserialize from JSON
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      type: json['type'],
      rate: json['rate'],
      isAvailable: json['isAvailable'],
      amount: json['amount'],  // Include the amount in deserialization
    );
  }
}
