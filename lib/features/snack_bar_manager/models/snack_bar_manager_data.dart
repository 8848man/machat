import 'package:freezed_annotation/freezed_annotation.dart';

part 'snack_bar_manager_data.freezed.dart';

@freezed
class SnackBarManagerData with _$SnackBarManagerData {
  factory SnackBarManagerData({
    @Default('init value') String text,
    @Default(false) bool dialogCall,
  }) = _SnackBarManagerData;
}
