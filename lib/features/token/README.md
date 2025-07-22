# Token Feature

이 모듈은 사용자의 토큰을 관리하는 기능을 제공합니다. Firebase Firestore를 사용하여 토큰 정보와 사용 내역을 저장하고 관리합니다.

## 주요 기능

### 1. 토큰 관리
- 사용자별 토큰 잔액 관리
- 토큰 획득 및 사용 내역 추적
- 일일 보상 시스템

### 2. 토큰 충전 방법
1. **일일 보상**: 매일 한 번 버튼을 눌러 토큰을 받을 수 있습니다.
2. **현금 결제**: 다양한 토큰 패키지를 구매하여 토큰을 충전할 수 있습니다.

### 3. 토큰 사용 내역
- 모든 토큰 사용/획득 내역을 로그로 기록
- 사용자별 상세한 토큰 통계 제공

## 파일 구조

```
lib/features/token/
├── models/
│   ├── token_model.dart          # 토큰 정보 모델
│   ├── token_log_model.dart      # 토큰 로그 모델
│   └── token_package_model.dart  # 토큰 패키지 모델
├── repositories/
│   ├── token_repository.dart     # 토큰 데이터 관리
│   └── token_package_repository.dart # 토큰 패키지 데이터 관리
├── view_models/
│   ├── token_view_model.dart     # 토큰 비즈니스 로직
│   └── token_package_view_model.dart # 토큰 패키지 비즈니스 로직
├── example_usage.dart            # 사용 예시
├── lib.dart                      # 라이브러리 export
└── README.md                     # 이 파일
```

## Firebase 컬렉션 구조

### token/{userId}
사용자의 토큰 정보를 저장합니다.

```json
{
  "currentTokens": 100,
  "totalEarnedTokens": 500,
  "totalSpentTokens": 400,
  "lastDailyReward": "2024-01-01T00:00:00Z",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### token_log/{logId}
토큰 사용 내역을 저장합니다.

```json
{
  "userId": "user123",
  "type": "dailyReward",
  "amount": 10,
  "balanceBefore": 90,
  "balanceAfter": 100,
  "description": "일일 보상",
  "metadata": {},
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### token_packages/{packageId}
구매 가능한 토큰 패키지 정보를 저장합니다.

```json
{
  "name": "기본 패키지",
  "description": "1000 토큰",
  "tokenAmount": 1000,
  "price": 10000,
  "currency": "KRW",
  "isActive": true,
  "isPopular": false,
  "bonusTokens": 100,
  "imageUrl": "https://example.com/image.png",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

## 사용법

### 1. 기본 설정

```dart
import 'package:provider/provider.dart';
import 'features/token/lib.dart';

// Provider 설정
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => TokenViewModel()),
    ChangeNotifierProvider(create: (_) => TokenPackageViewModel()),
  ],
  child: YourApp(),
)
```

### 2. 토큰 정보 로드

```dart
final tokenVM = context.read<TokenViewModel>();
await tokenVM.loadUserToken(userId);
await tokenVM.loadUserTokenLogs(userId);
```

### 3. 일일 보상 받기

```dart
final success = await tokenVM.claimDailyReward(userId);
if (success) {
  print('일일 보상을 받았습니다!');
}
```

### 4. 토큰 사용

```dart
final success = await tokenVM.spendTokens(
  userId,
  10,
  description: '고급 기능 사용',
);
if (success) {
  print('토큰을 사용했습니다!');
}
```

### 5. 토큰 패키지 구매

```dart
final packageVM = context.read<TokenPackageViewModel>();
await packageVM.loadActivePackages();

// 패키지 선택
final selectedPackage = packageVM.activePackages.first;
await tokenVM.purchaseTokens(
  userId,
  selectedPackage.totalTokens,
  selectedPackage.price,
);
```

### 6. 토큰 로그 확인

```dart
// 모든 로그
final logs = tokenVM.tokenLogs;

// 특정 타입의 로그만
final dailyRewards = tokenVM.getLogsByType(TokenLogType.dailyReward);

// 최근 7일간의 로그
final recentLogs = tokenVM.getLogsByDays(7);
```

## 확장성 고려사항

### 1. 패키지 분리 가능
이 모듈은 독립적으로 작동하도록 설계되어 있어, 필요시 별도의 패키지로 분리할 수 있습니다.

### 2. 다양한 결제 시스템 지원
현재는 기본적인 토큰 구매만 지원하지만, 다양한 결제 시스템(카드, 모바일 결제 등)을 쉽게 추가할 수 있습니다.

### 3. 토큰 사용 케이스 확장
새로운 토큰 사용 케이스가 추가될 때 `TokenLogType`에 새로운 타입을 추가하면 됩니다.

### 4. 보상 시스템 확장
일일 보상 외에도 다양한 보상 시스템(출석 체크, 미션 완료 등)을 쉽게 추가할 수 있습니다.

## 설정

### 기본 토큰 패키지 생성

Firebase Firestore에 기본 토큰 패키지를 생성하려면:

```dart
final packageRepo = TokenPackageRepository();

// 기본 패키지들 생성
await packageRepo.createPackage(TokenPackageModel(
  id: 'basic_1000',
  name: '기본 패키지',
  description: '1000 토큰',
  tokenAmount: 1000,
  price: 10000,
  currency: 'KRW',
  isActive: true,
  isPopular: false,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
));

await packageRepo.createPackage(TokenPackageModel(
  id: 'popular_5000',
  name: '인기 패키지',
  description: '5000 토큰 + 500 보너스',
  tokenAmount: 5000,
  price: 45000,
  currency: 'KRW',
  isActive: true,
  isPopular: true,
  bonusTokens: 500,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
));
```

## 주의사항

1. **Firebase 설정**: Firebase 프로젝트가 올바르게 설정되어 있어야 합니다.
2. **사용자 인증**: 사용자 ID는 인증된 사용자의 고유 ID여야 합니다.
3. **트랜잭션 안전성**: 토큰 사용 시 Firestore 트랜잭션을 사용하여 데이터 일관성을 보장합니다.
4. **에러 처리**: 네트워크 오류나 Firebase 오류에 대한 적절한 에러 처리가 필요합니다.

## 라이센스

이 모듈은 프로젝트의 라이센스를 따릅니다. 