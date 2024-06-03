import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/models/errors/failures.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia({
    required int? number,
  });
  
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
