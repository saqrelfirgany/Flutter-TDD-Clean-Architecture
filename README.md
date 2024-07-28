# Flutter TDD Clean Architecture

<pre>
lib/
|- core/
|  |- models/
|  |- usecases/
|  |- utils/
|- features/
|  |- number_trivia/
|     |- data/
|     |- domain/
|     |- presentation/
|- main.dart

</pre>


### Core

The `core` directory contains the essential building blocks and reusable components of the application.

- **models**: Defines the data models used across different layers of the application.
- **usecases**: Contains business logic that can be reused across multiple features.
- **utils**: Utility classes and helper functions.

### Features

Each feature of the application has its own directory under `features`. This ensures that the code related to a specific feature is encapsulated and independent of other features.

#### Feature Structure

Each feature directory is further divided into three layers:

1. **data**
2. **domain**
3. **presentation**

#### Data Layer

The data layer is responsible for managing the data required by the application. It interacts with external data sources such as APIs, local databases, or web services.

- **repositories**: Interfaces that define the operations related to data fetching and persistence.
- **datasources**: Classes that implement the repository interfaces and handle data operations.
- **models**: Data transfer objects (DTOs) that represent the data retrieved from external sources.

#### Domain Layer

The domain layer contains the business logic of the application. It defines use cases and the core entities of the application.

- **entities**: Core business objects that represent the application's domain.
- **repositories**: Abstract definitions of data operations required by the domain layer.
- **usecases**: Classes that encapsulate the business logic and coordinate between the domain and data layers.

#### Presentation Layer

The presentation layer is responsible for the UI and user interaction. It consists of widgets, state management, and presentation logic.

- **widgets**: Flutter widgets that build the UI.
- **bloc/cubit**: State management classes that handle the business logic and UI state.

## Example

Here's an example to illustrate how the different layers interact with each other.

### 1. core/models

```dart
// lib/core/models/failure_model.dart
class FailureModel {
  final String error;
  final String message;

  Book({required this.error, required this.message});
}
```

### 2. core/usecases

```dart
// lib/core/usecases/usecase.dart
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// lib/core/usecases/no_params.dart
class NoParams {}
```

### 3. core/utils

```dart
// lib/core/utils/exception.dart
class ServerException implements Exception {}

// lib/core/utils/failure.dart
class Failure {
  final String message;

  Failure(this.message);
}

// lib/core/utils/constants.dart
const String baseUrl = "https://api.example.com";
```

### 4. features/feature_one/data/datasources

```dart
// lib/features/feature_one/data/datasources/book_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:rawafid_employee/core/models/book.dart';
import 'package:rawafid_employee/core/utils/exception.dart';
import 'package:rawafid_employee/core/utils/constants.dart';

abstract class BookRemoteDataSource {
  Future<List<Book>> getBooks();
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final Dio dio;

  BookRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Book>> getBooks() async {
    try {
      final response = await dio.get('$baseUrl/books');
      return (response.data as List).map((book) => Book.fromJson(book)).toList();
    } catch (e) {
      throw ServerException();
    }
  }
}
```

### 5. features/feature_one/data/repositories

```dart
// lib/features/feature_one/data/repositories/book_repository_impl.dart
import 'package:rawafid_employee/core/utils/exception.dart';
import 'package:rawafid_employee/core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:rawafid_employee/features/feature_one/domain/entities/book.dart';
import 'package:rawafid_employee/features/feature_one/domain/repositories/book_repository.dart';
import 'package:rawafid_employee/features/feature_one/data/datasources/book_remote_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Book>>> getBooks() async {
    try {
      final books = await remoteDataSource.getBooks();
      return Right(books);
    } on ServerException {
      return Left(Failure("Failed to fetch books"));
    }
  }
}
```

### 6. features/feature_one/data/models

```dart
// lib/features/feature_one/data/models/book_model.dart
import 'package:rawafid_employee/features/feature_one/domain/entities/book.dart';

class BookModel extends BookEntity {
  BookModel({required String id, required String title, required String author})
      : super(id: id, title: title, author: author);

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
    );
  }
}

```
### 7. features/feature_one/domain/entities

```dart
// lib/features/feature_one/domain/entities/book_entity.dart
class BookEntity {
  final String id;
  final String title;
  final String author;

  Book({required this.id, required this.title, required this.author});
}

```

### 8. features/feature_one/domain/repositories

```dart
// lib/features/feature_one/domain/repositories/book_repository.dart
import 'package:dartz/dartz.dart';
import 'package:rawafid_employee/core/utils/failure.dart';
import 'package:rawafid_employee/features/feature_one/domain/entities/book.dart';

abstract class BookRepository {
  Future<Either<Failure, List<Book>>> getBooks();
}
```

### 9. features/feature_one/domain/usecases

```dart
// lib/features/feature_one/domain/usecases/get_books.dart
import 'package:dartz/dartz.dart';
import 'package:rawafid_employee/core/usecases/usecase.dart';
import 'package:rawafid_employee/core/utils/failure.dart';
import 'package:rawafid_employee/features/feature_one/domain/entities/book.dart';
import 'package:rawafid_employee/features/feature_one/domain/repositories/book_repository.dart';

class GetBooks implements UseCase<List<Book>, NoParams> {
  final BookRepository repository;

  GetBooks(this.repository);

  @override
  Future<Either<Failure, List<Book>>> call(NoParams params) async {
    return await repository.getBooks();
  }
}

```
### 10. features/feature_one/presentation/screen

```dart
// lib/features/feature_one/presentation/screens/book_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rawafid_employee/features/feature_one/presentation/cubit/book_cubit.dart';

class BookListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books')),
      body: BlocProvider(
        create: (_) => BookCubit()..getBooks(),
        child: BlocBuilder<BookCubit, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BookLoaded) {
              return ListView.builder(
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.books[index].title),
                    subtitle: Text(state.books[index].author),
                  );
                },
              );
            } else if (state is BookError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
```

### 11. features/feature_one/presentation/cubit

```dart
// lib/features/feature_one/presentation/cubit/book_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:rawafid_employee/core/usecases/no_params.dart';
import 'package:rawafid_employee/core/utils/failure.dart';
import 'package:rawafid_employee/features/feature_one/domain/entities/book.dart';
import 'package:rawafid_employee/features/feature_one/domain/usecases/get_books.dart';
import 'package:equatable/equatable.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final GetBooks getBooksUseCase;

  BookCubit({required this.getBooksUseCase}) : super(BookInitial());

  void getBooks() async {
    emit(BookLoading());
    final Either<Failure, List<Book>> failureOrBooks = await getBooksUseCase(NoParams());
    failureOrBooks.fold(
      (failure) => emit(BookError(failure.message)),
      (books) => emit(BookLoaded(books)),
    );
  }
}

```

### 12. features/feature_one/presentation/state

```dart
// lib/features/feature_one/presentation/cubit/book_state.dart
part of 'book_cubit.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Book> books;

  BookLoaded(this.books);

  @override
  List<Object> get props => [books];
}

class BookError extends BookState {
  final String message;

  BookError(this.message);

  @override
  List<Object> get props => [message];
}
```
