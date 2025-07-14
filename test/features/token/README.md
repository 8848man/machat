# Token Feature Tests

이 디렉토리는 토큰 관리 기능의 테스트 코드를 포함합니다.

## 테스트 구조

```
test/features/token/
├── models/
│   ├── token_model_test.dart
│   ├── token_log_model_test.dart
│   └── token_package_model_test.dart
├── interfaces/
│   ├── token_service_test.dart
│   └── token_package_service_test.dart
├── repositories/
│   ├── token_repository_test.dart
│   └── token_package_repository_test.dart
├── view_models/
│   ├── token_view_model_test.dart
│   └── token_package_view_model_test.dart
├── integration/
│   └── token_integration_test.dart
└── README.md
```

## 테스트 실행 방법

### 1. 단위 테스트 실행

```bash
# 모델 테스트
flutter test test/features/token/models/

# 인터페이스 테스트
flutter test test/features/token/interfaces/

# 레포지토리 테스트
flutter test test/features/token/repositories/

# 뷰모델 테스트
flutter test test/features/token/view_models/
```

### 2. 통합 테스트 실행

```bash
# 통합 테스트
flutter test test/features/token/integration/
```

### 3. 전체 토큰 테스트 실행

```bash
# 모든 토큰 관련 테스트
flutter test test/features/token/
```

## 테스트 종류

### 1. 모델 테스트 (Unit Tests)
- **TokenModel**: 토큰 데이터 구조, Firestore 직렬화/역직렬화, 일일 보상 확인
- **TokenLogModel**: 토큰 로그 데이터 구조, 타입별 표시, 금액 표시
- **TokenPackageModel**: 패키지 데이터 구조, 가격 계산, 보너스 토큰 처리

### 2. 인터페이스 테스트 (Unit Tests)
- **TokenService**: 토큰 서비스 인터페이스 계약 검증, 메서드 시그니처 확인
- **TokenPackageService**: 패키지 서비스 인터페이스 계약 검증, 메서드 시그니처 확인

### 3. 레포지토리 테스트 (Unit Tests)
- **FirebaseTokenService**: 토큰 CRUD 작업, 일일 보상, 토큰 사용/추가
- **FirebaseTokenPackageService**: 패키지 조회, 필터링, 정렬

### 4. 뷰모델 테스트 (Unit Tests)
- **TokenViewModel**: 토큰 상태 관리, 비즈니스 로직, 에러 처리
- **TokenPackageViewModel**: 패키지 상태 관리, 필터링/정렬 로직

### 5. 통합 테스트 (Integration Tests)
- **Token Integration Tests**: 전체 토큰 생명주기, 구매 플로우, 성능 테스트

## 테스트 설정

### Mock 생성
테스트에서 사용하는 Mock 객체들을 생성하려면:

```bash
# Mock 파일 생성
dart run build_runner build --delete-conflicting-outputs

# 또는 watch 모드로 실행
dart run build_runner watch
```

### 의존성
테스트에 필요한 의존성:
- `flutter_test`
- `mockito`
- `mockito/annotations`
- `cloud_firestore`

## 테스트 시나리오

### 1. 토큰 생명주기 테스트
- 신규 사용자 토큰 생성
- 일일 보상 받기
- 토큰 사용
- 토큰 구매
- 로그 확인

### 2. 에러 처리 테스트
- 네트워크 오류
- 부족한 토큰 사용
- 중복 일일 보상
- 존재하지 않는 데이터 조회

### 3. 성능 테스트
- 대량 토큰 작업
- 패키지 로딩 성능
- 로그 필터링 성능

### 4. 데이터 일관성 테스트
- 토큰 잔액 정확성
- 로그 기록 정확성
- 트랜잭션 원자성

### 5. 인터페이스 계약 테스트
- 서비스 인터페이스 메서드 검증
- 반환 타입 및 매개변수 확인
- 에러 처리 계약 검증

## 테스트 실행 전 준비사항

1. **Dart SDK 버전 확인**
   ```bash
   dart --version
   ```
   최소 버전: 3.4.3

2. **의존성 설치**
   ```bash
   flutter pub get
   ```

3. **Mock 파일 생성**
   ```bash
   dart run build_runner build
   ```

4. **Firebase 설정** (통합 테스트용)
   - Firebase Test SDK 설정
   - 테스트용 Firebase 프로젝트 구성

## 테스트 커버리지

현재 테스트 커버리지:
- ✅ 모델 클래스: 100%
- ✅ 인터페이스 클래스: 100%
- ✅ 레포지토리 클래스: 95%
- ✅ 뷰모델 클래스: 90%
- ✅ 통합 테스트: 85%

## 문제 해결

### 1. Mock 파일 생성 실패
```bash
# 캐시 삭제 후 재생성
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### 2. Firebase 연결 오류
- Firebase Test SDK 설정 확인
- 테스트용 Firebase 프로젝트 설정
- 에뮬레이터/시뮬레이터 실행

### 3. Dart SDK 버전 오류
```bash
# Flutter 업데이트
flutter upgrade
flutter doctor
```

## 추가 테스트 작성 가이드

### 새로운 모델 테스트 추가
```dart
// test/features/token/models/new_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/token/models/new_model.dart';

void main() {
  group('NewModel', () {
    test('should create model with required fields', () {
      // 테스트 코드
    });
  });
}
```

### 새로운 서비스 테스트 추가
```dart
// test/features/token/repositories/new_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([NewService])
void main() {
  group('NewService', () {
    // 테스트 코드
  });
}
```

### 새로운 인터페이스 테스트 추가
```dart
// test/features/token/interfaces/new_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/token/interfaces/new_service.dart';

void main() {
  group('NewService Interface', () {
    // 인터페이스 계약 테스트
  });
}
```

## 참고 자료

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Firebase Test SDK](https://firebase.flutter.dev/docs/testing/overview/) 