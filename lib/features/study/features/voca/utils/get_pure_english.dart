String englishValidation(String wordString) {
  // 1. 공백 제거 (trim)
  final trimmedWord = wordString.trim();

  // 2. 빈 문자열이면 바로 return null
  if (trimmedWord.isEmpty) return REQUIRE_NO_ONLY_SPACE;

  // 3. 영단어(알파벳) 이외 문자 포함 여부 검사 (정규식)
  final isValid = RegExp(r'^[a-zA-Z]+$').hasMatch(trimmedWord);
  if (!isValid) return REQUIRE_ENGLISH_ONLY;

  return trimmedWord;
}

const REQUIRE_NO_ONLY_SPACE = '공백이 아닌 문자를 입력해주세요';
const REQUIRE_ENGLISH_ONLY = '영어 이외의 문자는 입력하지 말아주세요';
