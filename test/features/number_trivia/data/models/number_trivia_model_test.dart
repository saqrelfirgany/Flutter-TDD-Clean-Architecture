import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');
  // final tNumberTriviaModelDouble = NumberTriviaModel(number: 1, text: 'Test double Text');

  test(
    'should be a subclass of NumberTrivia entity',
    () {
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () {
        // arrange
        final jsonString = fixture('trivia.json');
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        // print('Result: $result');
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is regarded as a double',
      () {
        // arrange
        final jsonString = fixture('trivia_double.json');
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        // print('Result: $result');
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a JSON map containing the proper data',
      () {
        // arrange

        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
