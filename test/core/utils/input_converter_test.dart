import 'package:flutter_app/core/utils/input_converters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });
  group(
    'StringToUnsignedInteger',
    () {
      test(
        'should return an integer when  the string represents an unsigned integer',
          ()async{
          final str = '123';
          final result = inputConverter.stringToUnsignedInteger(str);
          expect(result, Right(123));
          }
      );
      test(
          'should return a failure when the string is not an integer',
              ()async{
            final str = 'abc';
            final result = inputConverter.stringToUnsignedInteger(str);
            expect(result, Left(InvalidInputFailure()));
          }
      );
      test(
          'should return a failure when the string is a negative integer',
              ()async{
            final str = '-123';
            final result = inputConverter.stringToUnsignedInteger(str);
            expect(result, Left(InvalidInputFailure()));
          }
      );
    },
  );
}
