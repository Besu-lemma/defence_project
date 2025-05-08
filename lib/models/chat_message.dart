class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});

  // Convert message to Map for storage
  Map<String, dynamic> toJson() => {'text': text, 'isUser': isUser};

  // Create a message from stored data
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(text: json['text'], isUser: json['isUser']);
  }
}