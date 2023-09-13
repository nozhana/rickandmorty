import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioError? error;
  final String? errorMessage;

  const DataState({this.data, this.error, this.errorMessage});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess([T? data]) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(DioError error) : super(error: error);
  const DataFailed.withMessage(String message) : super(errorMessage: message);
}
