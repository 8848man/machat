part of '../lib.dart';

class DrawerProfile extends ConsumerWidget {
  const DrawerProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MCDrawerViewModel notifier =
        ref.read(mCDrawerViewModelProvider.notifier);
    final AsyncValue<DrawerModel> state = ref.watch(mCDrawerViewModelProvider);

    return GestureDetector(
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: state.when(
          data: (data) => boxRow(data),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      onTap: () => notifier.goProfile(),
    );
  }

  Widget boxRow(DrawerModel data) {
    return Row(
      children: [
        gradientAvatar(size: 120, user: data.user),
        MCSpace().horizontalHalfSpace(),
        profileTextColumn(data.user).expand(),
      ],
    );
  }

  // 내 정보
  Widget profileTextColumn(UserData user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('이름 : ${user.name}'),
        if (user.nationId != null) const Text('한국'),
      ],
    );
  }
}
