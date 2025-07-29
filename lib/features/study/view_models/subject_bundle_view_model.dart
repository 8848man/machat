import 'package:machat/features/home/enums/subject_enum.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subject_bundle_view_model.g.dart';

@riverpod
class SubjectBundleViewModel extends _$SubjectBundleViewModel {
  @override
  Future<void> build() async {
    return;
  }

  void goSubjectDetail(SubjectEnum subject) {
    // Navigate to the subject detail page
    // This is a placeholder for the actual navigation logic
    print('Navigating to detail page for subject: $subject');
  }

  Future<void> goStudyPageByEnum(SubjectEnum subject) async {
    Future.delayed(const Duration(milliseconds: 150), () async {
      final router = ref.read(goRouterProvider);
      router.goNamed(RouterPath.studySubject.name);
    });
  }
}
