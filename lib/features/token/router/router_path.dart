part of './lib.dart';

enum TokenRouterPath {
  //최상위
  root('/', '/'),
  login('/login', 'login'),
  token('/token', 'token'),
  packageRegister('/packageRegister', 'packageRegister');

  const TokenRouterPath(this.path, this.name);
  final String path;
  final String name;
}
