import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failuers.dart';
import 'package:flutter_app/core/use_cases/usecases.dart';
import 'package:flutter_app/domain/entities/number_trivia.dart';
import 'package:flutter_app/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia,NoParams>{
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async{
   return await repository.getRandomNumberTrivia() ;
  }
  
}
