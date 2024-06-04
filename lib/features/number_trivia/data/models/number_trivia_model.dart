import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({required super.text, required super.number});

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NumberTriviaModel &&
        other.number == number &&
        other.text == text;
  }

  @override
  int get hashCode => number.hashCode ^ text.hashCode;

  @override
  String toString() => 'NumberTriviaModel(number: $number, text: $text)';
}
