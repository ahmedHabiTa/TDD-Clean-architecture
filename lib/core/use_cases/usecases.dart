import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/core/failures/failuers.dart';
import 'package:flutter_app/domain/entities/number_trivia.dart';

abstract class UseCase<Type,Params>{
  Future<Either<Failure, NumberTrivia>> call(Params params);
  }
class NoParams extends Equatable{}