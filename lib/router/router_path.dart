part of './lib.dart';

enum RouterPath {
  //최상위
  splash('/', '/'),
  login('/login', 'login'),
  search('/search', 'search'),
  register('/register', 'register'),
  home('/home', 'home'),
  chat('/chat', 'chat'),
  chatProfile('/chat_profile', 'chat_profile'),
  chatCreate('/chat_create', 'chat_create'),
  chatList('/chat_list', 'chat_list'),
  chatImage('/chat_image', 'chat_image'),
  profile('/profile', 'profile'),
  // newHome('/newHome', 'newHome'),
  // example('/example', 'example'),
  // registerTemp('/registerTemp', 'registerTemp'),
  // /home 하위
  // memberPage('member_page/:memberId', 'member_page'),
  // managementPage('management_Page', 'management_page'),

  // example 하위
  // radioButton('radio_button', 'radio_button'),

  // /home 상위
  // app('/app', 'app'),

  // app 하위
  // managementTab('/managementTab','management_tab'),
  // studemtManagement('student','studemtManagement')
  ;

  const RouterPath(this.path, this.name);
  final String path;
  final String name;
}
