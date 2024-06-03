import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });
  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test(
    'should get trivia from the repository',
    () async {
      mockNumberTriviaRepository = MockNumberTriviaRepository();
      usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);

      // arrange
      when(
        mockNumberTriviaRepository.getRandomNumberTrivia(),
      ).thenAnswer((realInvocation) async => Right(tNumberTrivia));
      // act
      final result = await usecase(params: NoParams());

      // assert
      expect(result, Right(tNumberTrivia));
      verify(
        mockNumberTriviaRepository.getRandomNumberTrivia(),
      );
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
