# machat

실시간 채팅 앱 마챗입니다.

## 폴더 구조  

│  extensions.dart  
│  main.dart  
│  
├─animated_widget  
│      animation_slide_up.dart  
│      lib.dart  
├─assets  
│  ├─icons  
│  │      chat-plus copy.svg  
│  │      chat-plus.svg  
│  │      crown.png  
│  │      enter.svg  
│  │      login.png  
│  │      logout.png  
│  │      person_plus.svg  
│  ├─images  
│  │      ma_chat.png  
│  └─lotties  
├─config  
│      firebase_config.dart  
├─design_system  
│  │  lib.dart  
│  │  
│  ├─animations  
│  ├─buttons  
│  │      buttons.dart  
│  ├─check_box  
│  │      mc_check_box.dart  
│  ├─colors  
│  │      color.dart  
│  ├─inputs  
│  │      text_input.dart  
│  │  
│  ├─sized_boxes.dart  
│  │      padding.dart  
│  │      space.dart  
│  └─utils  
├─features  
│  ├─chat  
│  │  │  lib.dart  
│  │  ├─expand  
│  │  │  ├─enums
│  │  │  │      chat_contents_type.dart  
│  │  │  │      expand_state.dart  
│  │  │  ├─models  
│  │  │  │      chat_expand_model.dart  
│  │  │  │      chat_expand_model.freezed.dart  
│  │  │  │      chat_image_button_config.dart  
│  │  │  │      chat_image_list.dart  
│  │  │  │      chat_image_list.freezed.dart  
│  │  │  ├─providers  
│  │  │  │      expand_image_state_provider.dart  
│  │  │  │      expand_widget_state_provider.dart  
│  │  │  ├─repositories  
│  │  │  │      chat_image_repository.dart  
│  │  │  ├─view_models  
│  │  │  │      chat_image_view_model.dart  
│  │  │  │      chat_image_view_model.g.dart  
│  │  │  └─widgets  
│  │  │          chat_expand.dart  
│  │  │          chat_expand_brancher.dart  
│  │  │          chat_picture.dart  
│  │  │          chat_upload.dart  
│  │  ├─interface  
│  │  │      chat_view_model_interface.dart  
│  │  ├─models  
│  │  │      chat.dart  
│  │  │      chat.freezed.dart  
│  │  │      chat.g.dart  
│  │  │      image.dart  
│  │  │      image.freezed.dart  
│  │  │      image.g.dart  
│  │  ├─providers  
│  │  │      chat_focus_node_provider.dart  
│  │  │      chat_image_provider.dart  
│  │  │      chat_message_group_provider.dart  
│  │  │      chat_message_provider.dart  
│  │  │      chat_room_name_provider.dart  
│  │  │      chat_sending_widget_proivder.dart  
│  │  ├─repository  
│  │  │      chat_repository.dart  
│  │  ├─screens  
│  │  │      chat.dart  
│  │  ├─utils  
│  │  │      chat_utils.dart  
│  │  ├─view_models  
│  │  │      chat_view_model.dart  
│  │  │      chat_view_model.g.dart  
│  │  └─widgets  
│  │          chat_bubble.dart  
│  │          chat_contents.dart  
│  │          chat_image.dart  
│  │          chat_input.dart  
│  │          chat_profile.dart  
│  │          chat_sending_contents.dart  
│  ├─chat_create  
│  │  │  lib.dart  
│  │  ├─models 
│  │  │      chat_create_model.dart  
│  │  │      chat_create_model.freezed.dart  
│  │  ├─screens  
│  │  │      chat_create.dart  
│  │  ├─view_models  
│  │  │      chat_create_view_model.dart  
│  │  │      chat_create_view_model.g.dart  
│  │  └─widgets  
│  │          body.dart  
│  │          footer.dart  
│  │          header.dart  
│  ├─chat_expand_image  
│  │  ├─providers  
│  │  │      selected_image_url_provider.dart  
│  │  ├─screens  
│  │  │      expand_image.dart  
│  │  ├─view_models  
│  │  └─widgets  
│  ├─chat_list  
│  │  │  lib.dart  
│  │  ├─screens  
│  │  │      chat_list.dart  
│  │  ├─view_models  
│  │  │      chat_list_view_model.dart  
│  │  │      chat_list_view_model.g.dart  
│  │  └─widgets  
│  │          mobile.dart  
│  │          web.dart  
│  ├─common  
│  │  ├─caches  
│  │  │      shared_prefrences.dart  
│  │  ├─dialogs  
│  │  ├─interfaces  
│  │  │      cache_provider.dart  
│  │  │      cache_service.dart  
│  │  │      repository_service.dart  
│  │  ├─layouts  
│  │  │      default_layout.dart  
│  │  │      get_actions.dart  
│  │  │      lib.dart  
│  │  │      mobile_scaffold.dart  
│  │  │      web_scaffold.dart  
│  │  ├─login_module  
│  │  ├─models  
│  │  │      chat_list_model.dart  
│  │  │      chat_list_model.freezed.dart  
│  │  │      chat_room_data.dart  
│  │  │      chat_room_data.freezed.dart  
│  │  │      chat_room_data.g.dart  
│  │  │      friends_model.dart  
│  │  │      friends_model.freezed.dart  
│  │  │      members.dart  
│  │  │      members.freezed.dart  
│  │  │      members.g.dart  
│  │  │      user_data.dart  
│  │  │      user_data.freezed.dart  
│  │  │      user_data.g.dart  
│  │  ├─providers  
│  │  │      chat_room_id.dart  
│  │  │      friend_list.dart  
│  │  │      user_cache_providers.dart  
│  │  ├─repositories  
│  │  │      chat_room_crud_repository.dart  
│  │  │      friend_crud_repository.dart  
│  │  │      user_repository.dart  
│  │  ├─utils  
│  │  │      chat_key_generator.dart  
│  │  │      completer.dart  
│  │  │      date_parser.dart  
│  │  │      error_widget.dart  
│  │  │      extractor.dart  
│  │  │      get_color.dart  
│  │  │      loading_overtime.dart  
│  │  │      logout_util.dart  
│  │  │      router_utils.dart  
│  │  │      throttle.dart  
│  │  │      timestamp_converter.dart  
│  │  │      user_checker.dart  
│  │  ├─view_models  
│  │  │      chat_room_crud_view_model.dart  
│  │  │      chat_room_crud_view_model.g.dart  
│  │  │      friend_list_view_model.dart  
│  │  │      friend_list_view_model.g.dart  
│  │  │      user_view_model.dart  
│  │  │      user_view_model.g.dart  
│  │  └─widgets  
│  │          mc_check_box_view.dart  
│  ├─drawer  
│  │  │  lib.dart  
│  │  ├─models  
│  │  │      drawer_model.dart  
│  │  │      drawer_model.freezed.dart  
│  │  ├─repository  
│  │  │      drawer_repository.dart  
│  │  ├─screens  
│  │  │      mc_drawer.dart  
│  │  ├─view_models  
│  │  │      mc_drawer_view_model.dart  
│  │  │      mc_drawer_view_model.g.dart  
│  │  └─widgets  
│  │          drawer_chat_list.dart  
│  │          drawer_profile.dart  
│  │          drawer_router.dart  
│  ├─floating_button  
│  │  │  lib.dart  
│  │  ├─model  
│  │  ├─repository  
│  │  │      floating_button_repository.dart  
│  │  ├─screens  
│  │  │      mc_floationg_button.dart  
│  │  ├─view_model  
│  │  │      floating_button_view_model.dart  
│  │  │      floating_button_view_model.g.dart  
│  │  └─widgets  
│  ├─home  
│  │  │  lib.dart  
│  │  ├─repositories  
│  │  │      chat_room_repository.dart  
│  │  ├─screens  
│  │  │      home_page.dart  
│  │  ├─view_models  
│  │  │      chat_list_view_model.dart  
│  │  │      chat_list_view_model.g.dart  
│  │  │      friends_view_model.dart  
│  │  │      friends_view_model.g.dart  
│  │  └─widgets  
│  │          chat_list.dart  
│  │          delete_chat_room_dialog.dart  
│  │          firends.dart  
│  │          friends_page_widgets.dart  
│  │          friend_list.dart  
│  │          home_bundle.dart  
│  │          my_info.dart  
│  ├─loading  
│  │  │  lib.dart  
│  │  ├─screens  
│  │  │      loading_widget.dart  
│  │  └─view_models  
│  │          loading_view_model.dart  
│  ├─login  
│  │  │  lib.dart  
│  │  ├─models  
│  │  │      login_model.dart  
│  │  │      login_model.freezed.dart  
│  │  ├─repository  
│  │  │      login_repository.dart  
│  │  ├─screens  
│  │  │      login_page.dart  
│  │  │      web.dart  
│  │  ├─view_models  
│  │  │      login_view_model.dart  
│  │  │      login_view_model.g.dart  
│  │  └─widgets  
│  │          bundle_body.dart  
│  │          bundle_footer.dart  
│  │          bundle_header.dart  
│  │          login_bundle.dart  
│  ├─profile  
│  │  ├─models  
│  │  │      profile_model.dart  
│  │  │      profile_model.freezed.dart  
│  │  ├─providers  
│  │  │      profile_user_provider.dart  
│  │  ├─repository  
│  │  │      profile_repository.dart  
│  │  ├─screens  
│  │  │      my_profile.dart  
│  │  │      other_profile.dart  
│  │  ├─utils  
│  │  │      call_profile.dart  
│  │  │      define_is_friend.dart  
│  │  ├─view_models  
│  │  │      profile_view_model.dart  
│  │  │      profile_view_model.g.dart  
│  │  └─widgets  
│  │      │  profile_background.dart  
│  │      ├─my_profile  
│  │      │      profile_auth_button.dart  
│  │      │      profile_body.dart  
│  │      │      profile_bundle.dart  
│  │      │      profile_footer.dart  
│  │      │      profile_header.dart  
│  │      └─other_profile.dart  
│  │              profile_auth_button.dart  
│  │              profile_body.dart  
│  │              profile_bundle.dart  
│  │              profile_footer.dart  
│  │              profile_header.dart  
│  ├─profile_detail  
│  │  ├─models  
│  │  ├─screens  
│  │  ├─view_models  
│  │  └─widgets  
│  ├─register  
│  │  │  lib.dart  
│  │  ├─models  
│  │  │      register_model.dart  
│  │  │      register_model.freezed.dart  
│  │  ├─repository  
│  │  │      register_repository.dart  
│  │  ├─screens  
│  │  │      register_page.dart  
│  │  ├─utils  
│  │  │      validation.dart  
│  │  ├─view_models  
│  │  │      register_view_model.dart  
│  │  │      register_view_model.g.dart  
│  │  └─widgets  
│  │          bundle_body.dart  
│  │          bundle_footer.dart  
│  │          bundle_header.dart  
│  │          register_bundle.dart  
│  ├─snack_bar_manager  
│  │  │  lib.dart  
│  │  ├─models  
│  │  │      snack_bar_manager_data.dart  
│  │  │      snack_bar_manager_data.freezed.dart  
│  │  ├─provider  
│  │  │      snack_bar_manager.dart  
│  │  ├─screen  
│  │  │      snack_bar_manager.dart  
│  │  └─utils  
│  │          snack_bar_caller.dart  
│  └─splash  
│      │  lib.dart  
│      ├─models  
│      ├─repository  
│      ├─screens  
│      │      splash_page.dart  
│      └─view_models  
└─router  
        lib.dart  
        router.dart  
        router_path.dart  
