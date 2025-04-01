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
        gradientAvatar(data.user),
        MCSpace().horizontalHalfSpace(),
        profileTextColumn(data.user).expand(),
      ],
    );
  }

  // 프로필 사진
  Widget gradientAvatar(UserData user) {
    return Container(
      height: 120,
      width: 120,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xff4dabf7),
            Color(0xffda77f2),
            Color(0xfff783ac),
          ],
        ),
        borderRadius: BorderRadius.circular(500),
      ),
      child: const CircleAvatar(
        radius: 30,
        child: Icon(
          Icons.person,
          color: Color(0xffCCCCCC),
          size: 70,
        ),
      ),
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
