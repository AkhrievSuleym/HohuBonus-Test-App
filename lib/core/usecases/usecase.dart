import 'package:fpdart/fpdart.dart';
import 'package:hb_test_app/core/error/failures.dart';

abstract interface class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class EmptyParams {}
