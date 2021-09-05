import 'package:flutter_app/core/network/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImp networkInfo;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImp(mockDataConnectionChecker);
  });
  group('is Connected', () {
    test(
      'should forward to call to DataConnectionChecker.hasConnection',
      () async {
        final tHasConnectionFuture = Future.value(true);
        when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);
        final result =  networkInfo.isConnected ;
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
