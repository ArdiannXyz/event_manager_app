class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final double price;
  final String? imageUrl;
  final int maxParticipants;
  final int currentParticipants;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.price,
    this.imageUrl,
    required this.maxParticipants,
    required this.currentParticipants,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      location: json['location'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
      maxParticipants: json['max_participants'] ?? 0,
      currentParticipants: json['current_participants'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'price': price,
      'image_url': imageUrl,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
    };
  }

  bool get isAvailable => currentParticipants < maxParticipants;
}