import 'dart:convert';

import 'package:matcher/matcher.dart';
import 'package:flutter_app/data/datasources/number_trivia_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/core/failures/exceptions.dart';
import 'package:flutter_app/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;
  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group(
    'getConcreteNumberTrivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
      test(
        '''should perform a http GET request on a URL with number
        being the endpoint and with application/json''',
        () async {
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(
                    fixture('trivia.json'),
                    200,
                  ));
          dataSource.getConcreteNumberTrivia(tNumber);
          verify(mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
        },
      );
      test(
        'should return a numberTrivia when the statusCode is 200',
        () async {
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(
                    fixture('trivia.json'),
                    200,
                  ));
          final result = await dataSource.getConcreteNumberTrivia(tNumber);
          expect(result, equals(tNumberTriviaModel));
        },
      );
      test(
        'should return a serverException when the statusCode is 404 or other',
        () async {
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(
                    'Something went wrong',
                    404,
                  ));
          final call = dataSource.getConcreteNumberTrivia;
          expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
        },
      );
    },
  );
  group(
    'getRandomNumberTrivia',
        () {
      final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
      test(
        '''should perform a http GET request on a URL with random number
        being the endpoint and with application/json''',
            () async {
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(
            fixture('trivia.json'),
            200,
          ));
          dataSource.getRandomNumberTrivia();
          verify(mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
        },
      );
      test(
        'should return a numberTrivia when the statusCode is 200',
            () async {
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(
            fixture('trivia.json'),
            200,
          ));
          final result = await dataSource.getRandomNumberTrivia();
          expect(result, equals(tNumberTriviaModel));
        },
      );
      test(
        'should return a serverException when the statusCode is 404 or other',
            () async {
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(
            'Something went wrong',
            404,
          ));
          final call = dataSource.getRandomNumberTrivia();
          expect(() => call, throwsA(TypeMatcher<ServerException>()));
        },
      );
    },
  );
}
