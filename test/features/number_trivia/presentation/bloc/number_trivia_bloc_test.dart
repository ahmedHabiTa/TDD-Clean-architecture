import 'package:flutter_app/core/failures/failuers.dart';
import 'package:flutter_app/core/use_cases/usecases.dart';
import 'package:flutter_app/core/utils/input_converters.dart';
import 'package:flutter_app/domain/entities/number_trivia.dart';
import 'package:flutter_app/domain/usercases/get_concrete_number_trivia.dart';
import 'package:flutter_app/domain/usercases/get_random_number_trivia.dart';
import 'package:flutter_app/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';


class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  NumberTriviaBloc bloc;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });
  test(
    'initial state should be Empty',
    () async* {
      expect(bloc, Empty());
    },
  );
  group(
    'GetConcreteNumberTrivia',
    () {
      final tNumberString = '1';
      final tNumberParsed = 1;
      final tNumberTrivia = NumberTrivia(text: 'Text Test', number: 1);
      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
            () async {
          // arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(tNumberParsed));
          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
          // assert
          verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );
      test(
        'should emit [Error] when the input is invalid',
        () async {
          // arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
          // assert later
          final expected = [
            // The initial state is always emitted first
            Empty(),
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );
      test(
        'should get data from concrete use case',
        () async {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(tNumberParsed));
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockGetConcreteNumberTrivia(any));
          verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
        },
      );
      test(
        'should emit [Loading,Loaded] state when the gotten data is successful',
        () async {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(tNumberParsed));
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          expectLater(
            bloc,
            emitsInOrder([
              Empty(),
              Loading(),
              Loaded(trivia: tNumberTrivia),
            ]),
          );
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );
      test(
        'should emit [Loading, Error] when getting data fails',
        () async {
          // arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(tNumberParsed));
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );
      test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
          // arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(tNumberParsed));
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );
    },
  );
  group(
    'GetRandomNumberTrivia',
    () {
      final tNumberTrivia = NumberTrivia(text: 'Text Test', number: 1);
      test(
        'should get data from Random use case',
        () async {
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          bloc.add(GetTriviaForRandomNumber());
          await untilCalled(mockGetRandomNumberTrivia(any));
          verify(mockGetRandomNumberTrivia(NoParams()));
        },
      );
      test(
        'should emit [Loading,Loaded] state when the gotten data is successful',
        () async {
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          expectLater(
            bloc,
            emitsInOrder([
              Empty(),
              Loading(),
              Loaded(trivia: tNumberTrivia),
            ]),
          );
          bloc.add(GetTriviaForRandomNumber());
        },
      );
      test(
        'should emit [Loading, Error] when getting data fails',
        () async {
          // arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForRandomNumber());
        },
      );
      test(
        'should emit [Loading,Error] state with a proper message when the gotten data is failed',
        () async {
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          final expected = [
            Empty(),
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(
            bloc,
            emitsInOrder(
              expected,
            ),
          );
          bloc.add(GetTriviaForRandomNumber());
        },
      );
    },
  );
}
