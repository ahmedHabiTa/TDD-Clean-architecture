import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/core/failures/exceptions.dart';
import 'package:flutter_app/core/failures/failuers.dart';
import 'package:flutter_app/core/network/network_info.dart';

import 'package:flutter_app/data/datasources/number_trivia_local_data_sourse.dart';
import 'package:flutter_app/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_app/domain/entities/number_trivia.dart';
import 'package:flutter_app/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;

  final NumberTriviaLocalDataSource localDataSource;

  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia =
            await remoteDataSource.getConcreteNumberTrivia(number);
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    }else {
      try{
        final localTrivia =
        await localDataSource.getLastNumberTrivia();
        return Right(localTrivia) ;
      }on CacheException{
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async{
    if(await networkInfo.isConnected){
      try{
        final remoteTrivia =
        await remoteDataSource.getRandomNumberTrivia();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      }on ServerException{
        return Left(ServerFailure());
      }
    }else{
      try{
        final localTrivia =
        await localDataSource.getLastNumberTrivia();
        return Right(localTrivia) ;
      }on CacheException{
        return Left(CacheFailure());
      }
    }
  }
}
