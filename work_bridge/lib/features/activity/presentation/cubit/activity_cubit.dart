import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/dummy_data.dart';
import 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(const ActivityInitial());

  Future<void> loadActivity() async {
    emit(const ActivityLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const ActivityLoaded(appliedJobs: DummyData.appliedJobs));
  }
}
