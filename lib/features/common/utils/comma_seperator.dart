List<String> getCommaSeperatedList(String text) {
  return text
      .split(',')
      .map((e) => e.replaceAll(' ', '')) // 각 단어 내부 공백 제거
      .where((e) => e.isNotEmpty) // 빈 문자열 제거 (선택사항)
      .toList();
}
