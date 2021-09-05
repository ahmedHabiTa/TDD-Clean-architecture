import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/core/failures/failuers.dart';
import 'package:flutter_app/core/use_cases/usecases.dart';
import 'package:flutter_app/core/utils/input_converters.dart';
import 'package:flutter_app/domain/entities/number_trivia.dart';
import 'package:flutter_app/domain/usercases/get_concrete_number_trivia.dart';
import 'package:flutter_app/domain/usercases/get_random_number_trivia.dart';
import 'package:meta/meta.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure';
const String CACHE_FAILURE_MESSAGE = 'Cache failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'please input a positive integer number';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;

  final GetRandomNumberTrivia getRandomNumberTrivia;

  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required this.getConcreteNumberTrivia,
    @required this.getRandomNumberTrivia,
    @required this.inputConverter,
  }) : super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(

    NumberTriviaEvent event,
  ) async* {
    yield Empty();
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield Loading();
          final failureOrTrivia = await getConcreteNumberTrivia(
            Params(number: integer),
          );
          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(
        NoParams(),
      );
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }
  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> either,
      ) async* {
    yield either.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (trivia) => Loaded(trivia: trivia),
    );
  }
  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
        break ;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
        break ;
      default:
        return 'UnExpected Error';
        break ;
    }
  }
}
