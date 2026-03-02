import 'package:flutter_bloc/flutter_bloc.dart';
import 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(const ActivityInitial());

  Future<void> loadActivity() async {
    emit(const ActivityLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const ActivityLoaded(
      appliedJobs: [
        AppliedJob(
          id: 'a1',
          jobTitle: 'Flutter Developer',
          company: 'TechCorp',
          location: 'Bengaluru',
          appliedDate: '20 Feb 2025',
          currentStatus: 'interview',
          timeline: ['applied', 'shortlisted', 'interview'],
        ),
        AppliedJob(
          id: 'a2',
          jobTitle: 'Product Designer',
          company: 'DesignHub',
          location: 'Remote',
          appliedDate: '15 Feb 2025',
          currentStatus: 'shortlisted',
          timeline: ['applied', 'shortlisted'],
        ),
        AppliedJob(
          id: 'a3',
          jobTitle: 'DevOps Engineer',
          company: 'ScaleUp',
          location: 'Pune',
          appliedDate: '10 Feb 2025',
          currentStatus: 'offered',
          timeline: ['applied', 'shortlisted', 'interview', 'offered'],
        ),
        AppliedJob(
          id: 'a4',
          jobTitle: 'Backend Engineer',
          company: 'CloudBase',
          location: 'Hyderabad',
          appliedDate: '5 Feb 2025',
          currentStatus: 'rejected',
          timeline: ['applied', 'rejected'],
        ),
      ],
    ));
  }
}
