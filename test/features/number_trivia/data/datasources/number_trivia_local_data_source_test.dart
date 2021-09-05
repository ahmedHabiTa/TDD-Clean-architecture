import 'dart:convert';

import 'package:flutter_app/core/failures/exceptions.dart';
import 'package:flutter_app/data/datasources/number_trivia_local_data_sourse.dart';
import 'package:flutter_app/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from sharedPreferences when there is data in cache',
      () async {
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        final result = await dataSource.getLastNumberTrivia();
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should throw cache Exception when there is no data cached ',
      () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        final call = dataSource.getLastNumberTrivia;
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });
  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel(number: 1,text: 'test');
    test(
      'should call SharedPreferences to cache the data',
          () async {
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        final expectedJsonString = json.encode(tNumberTriviaModel);
        verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
      },
    );

  });
}
