part of '../lib.dart';

String? emailChangeValidation(String val) {
  // 아이디가 빈 값일 때 검증하지 않음
  if (val.isEmpty) return null;

  // @와 . 문자는 1개만 허용하고, 그 외에는 영문 대소문자와 숫자만 허용
  final RegExp validId = RegExp(r'^[a-zA-Z0-9@.]+$');

  // 유효한 문자인지 확인
  if (!validId.hasMatch(val)) return '이메일 형식을 제외한 특수문자는 사용할 수 없습니다.';

  // @와 . 문자가 각각 1개만 있는지 확인
  int atCount = val.split('@').length - 1;
  int dotCount = val.split('.').length - 1;

  if (atCount > 1 || dotCount > 1) return '이메일 형식을 제외한 특수문자는 사용할 수 없습니다.';

  return null; // 검증 통과
}

String? emailValidation(String val) {
  // 입력 값이 비어 있는지 검증
  if (val.isEmpty) return '이메일을 다시 확인해주십시오.';

  // 이메일 형식 검증
  final RegExp emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegExp.hasMatch(val)) {
    return '올바른 이메일 형식을 입력해주세요.';
  }

  // 추가 검증 로직 (예: 다른 조건 검사)
  if (emailChangeValidation(val) != null) {
    return '이메일을 다시 확인해주십시오.';
  }

  return null; // 검증 통과
}

// 이름 형식 검증
String? nameChangeValidation(String val) {
  // 이름이 너무 긴 경우
  if (val.length >= 30) return '이름이 너무 깁니다! 30자 이내로 설정해주세요';

  // 특수문자 및 공백 포함 여부 검증
  final RegExp specialCharOrSpace = RegExp(r'[^\w가-힣ㄱ-ㅎㅏ-ㅣ]');
  if (specialCharOrSpace.hasMatch(val)) {
    return '이름에 특수문자나 공백, 단자음, 단모음을 포함할 수 없습니다!';
  }

  return null; // 검증 통과
}

// 이름 자모음 추가 검증
String? nameConsVowValidation(String val) {
  // 특수문자 및 공백 포함 여부 검증
  final RegExp specialCharOrSpace = RegExp(r'[^\w가-힣]'); // 특수문자 및 공백 탐지
  if (specialCharOrSpace.hasMatch(val)) {
    return '이름에 특수문자나 공백, 단자음, 단모음을 포함할 수 없습니다!';
  }

  return null; // 검증 통과
}

String? nameValidation(String val) {
  if (val.isEmpty) return '이름을 다시 확인해주십시오.';
  if (nameChangeValidation(val) != null) return nameChangeValidation(val);
  if (nameConsVowValidation(val) != null) return nameConsVowValidation(val);

  return null; // 검증 통과
}

String? passwordValidation(String val) {
  // 비밀번호 길이 제한 (8~20자)
  if (val.length < 8 || val.length > 20) {
    return '비밀번호는 8자 이상 20자 이하로 설정해주세요.';
  }

  // 영어 대문자 포함 여부 검증
  final RegExp hasUpperCase = RegExp(r'[A-Z]');
  if (!hasUpperCase.hasMatch(val)) {
    return '비밀번호에 영어 대문자를 포함해야 합니다.';
  }

  // 영어 소문자 포함 여부 검증
  final RegExp hasLowerCase = RegExp(r'[a-z]');
  if (!hasLowerCase.hasMatch(val)) {
    return '비밀번호에 영어 소문자를 포함해야 합니다.';
  }

  // 숫자 포함 여부 검증
  final RegExp hasDigit = RegExp(r'[0-9]');
  if (!hasDigit.hasMatch(val)) {
    return '비밀번호에 숫자를 포함해야 합니다.';
  }

  // 특수문자 포함 여부 검증
  final RegExp hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  if (!hasSpecialChar.hasMatch(val)) {
    return '비밀번호에 특수문자를 포함해야 합니다.';
  }

  // 모든 조건을 만족하면 null 반환 (검증 통과)
  return null;
}
