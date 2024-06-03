import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });
  const tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test(
    'should get trivia for the number from the repository',
    () async {
      mockNumberTriviaRepository = MockNumberTriviaRepository();
      usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);

      // arrange
      when(
        mockNumberTriviaRepository.getConcreteNumberTrivia(
          number: anyNamed('number'),
        ),
      ).thenAnswer((realInvocation) async => Right(tNumberTrivia));
      // act
      final result = await usecase(params: const Params(number: tNumber));

      // assert
      expect(result, Right(tNumberTrivia));
      verify(
        mockNumberTriviaRepository.getConcreteNumberTrivia(number: tNumber),
      );
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
