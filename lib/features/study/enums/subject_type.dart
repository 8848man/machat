enum SubjectType {
  none('none', '없음'),
  english('english', '영어');

  const SubjectType(this.type, this.name);

  final String type;
  final String name;
}
