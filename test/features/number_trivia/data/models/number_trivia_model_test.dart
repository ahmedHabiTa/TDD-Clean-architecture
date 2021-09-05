import 'dart:convert';

import 'package:flutter_app/data/models/number_trivia_model.dart';
import 'package:flutter_app/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Text Test');
  test('should be a sbuclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test(
      'Should return a valid model when JSON number is an integer',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        final result = NumberTriviaModel.fromJson(jsonMap);
        expect(result, tNumberTriviaModel);
      },
    );
    test(
      'Should return a valid model when JSON number is an regarded as double',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        final result = NumberTriviaModel.fromJson(jsonMap);
        expect(result, tNumberTriviaModel);
      },
    );
  });
  group('toJson', () {
    test(
      'should return a json map containing the data',
      () async {
        final result = tNumberTriviaModel.toJson();
        final expectedMap = {
          "text": "Text Test",
          "number": 1,
        } ;
        expect(result, expectedMap);
      },
    );
  });
}
