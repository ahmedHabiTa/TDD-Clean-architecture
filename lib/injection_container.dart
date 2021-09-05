import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_app/core/network/network_info.dart';
import 'package:flutter_app/core/utils/input_converters.dart';
import 'package:flutter_app/data/datasources/number_trivia_local_data_sourse.dart';
import 'package:flutter_app/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_app/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_app/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_app/domain/usercases/get_concrete_number_trivia.dart';
import 'package:flutter_app/domain/usercases/get_random_number_trivia.dart';
import 'package:flutter_app/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
final serviceLocator = GetIt.instance;

Future<void> init() async {
  //this factory to get instance of the bloc Class after we run the app to activate the bloc
  //that's why we cannot user singleton or lazySingleton
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator(),
      getRandomNumberTrivia: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );
  //LazySingleton to get only one instance of the getConcreteNumberTrivia to
  //increase the performance ....we don't need to make it factory because
  //we don't have to get an instance of it after we run the app
  serviceLocator.registerLazySingleton(
    () => GetConcreteNumberTrivia(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetRandomNumberTrivia(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => InputConverter(),
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(
    () => sharedPreferences,
  );
  serviceLocator.registerLazySingleton(
        () => http.Client(),
  );
  serviceLocator.registerLazySingleton(
        () => DataConnectionChecker(),
  );
}
