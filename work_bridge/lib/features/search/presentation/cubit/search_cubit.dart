import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/repositories/job_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final JobRepository _jobRepository;

  SearchCubit(this._jobRepository) : super(const SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }
    emit(const SearchLoading());
    try {
      final results = await _jobRepository.searchJobs(query.trim());
      emit(SearchLoaded(results: results, query: query));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  void clear() {
    emit(const SearchInitial());
  }
}
