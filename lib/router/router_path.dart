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
  addFriend('/add_friend', 'add_friend'),
  token('/token', 'token'),
  study('/study', 'study'),
  earnPoint('/earn_point', 'earn_point'),
  englishVoca('/study/english_voca', 'english_voca'),
  subjectManage('/study/subject_manage', 'subject_manage'),
  addVocabulary('/study/add_vocabulary', 'add_vocabulary'),
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
