import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/job.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<Job> results;
  final String query;

  const SearchLoaded({required this.results, required this.query});

  @override
  List<Object?> get props => [results, query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
