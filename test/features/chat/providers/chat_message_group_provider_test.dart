// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'dart:async';

// void main() {
//   group('studentStreamProvider', () {
//     late StreamController<List<Student>> controller;
//     late List<Student> dummyStudents;

//     setUp(() {
//       controller = StreamController<List<Student>>();
//       dummyStudents = [
//         Student(id: '1', name: 'John'),
//         Student(id: '2', name: 'Jane'),
//       ];
//     });

//     tearDown(() {
//       controller.close();
//     });

//     test('emits list of students from repository', () async {
//       // 1. Mock repository
//       final container = ProviderContainer(
//         overrides: [
//           studentRepositoryProvider.overrideWithValue(
//             _MockStudentRepository(controller.stream),
//           ),
//         ],
//       );
//       addTearDown(container.dispose);

//       // 2. Start listening
//       final listener = Listener<AsyncValue<List<Student>>>();
//       container.listen(
//         studentStreamProvider,
//         listener,
//         fireImmediately: true,
//       );

//       // 3. Emit a value
//       controller.add(dummyStudents);

//       // 4. Wait for provider to emit
//       await expectLater(
//         container.read(studentStreamProvider.future),
//         completion(dummyStudents),
//       );
//     });
//   });
// }

// /// Mock Repository
// class _MockStudentRepository implements StudentRepository {
//   final Stream<List<Student>> _stream;
//   _MockStudentRepository(this._stream);

//   @override
//   Stream<List<Student>> getStudentStream() => _stream;

//   // 다른 메서드는 필요에 따라 구현 생략 또는 throw
// }
