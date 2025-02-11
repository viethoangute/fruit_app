import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:training_example/features/home/bloc/user_info_bloc/user_info_bloc.dart';
import '../../../di/injection.dart';
import '../../../generated/assets.dart';
import '../../../translations/locale_keys.g.dart';
import '../../authentication/blocs/auth_bloc.dart';
import '../../home/bloc/user_info_bloc/user_info_state.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var authBloc = getIt.get<AuthBloc>();
  var userInfoBloc = getIt.get<UserInfoBloc>();
  bool isImageError = false;

  final CircleAvatar defaultAvatar = const CircleAvatar(
    radius: 25.0,
    backgroundImage: AssetImage(Assets.assetsImageDefault),
    backgroundColor: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(LocaleKeys.settings.tr()),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: BlocBuilder<UserInfoBloc, UserInfoState>(
                    bloc: userInfoBloc,
                    builder: (context, state) {
                      if (state is UserInfoFetchedState) {
                        return isImageError
                            ? defaultAvatar
                            : CircleAvatar(
                                radius: 45.0,
                                backgroundImage: NetworkImage(
                                  state.userInfo.imageURL!,
                                ),
                                onBackgroundImageError: (e, t) {
                                  setState(() {
                                    isImageError = true;
                                  });
                                },
                                backgroundColor: Colors.transparent,
                              );
                      } else {
                        return defaultAvatar;
                      }
                    },
                  )),
              const SizedBox(height: 25),
              BlocBuilder<UserInfoBloc, UserInfoState>(
                bloc: userInfoBloc,
                builder: (context, state) {
                  if (state is UserInfoFetchedState) {
                    return Text(
                      state.userInfo.name,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          overflow: TextOverflow.ellipsis),
                    );
                  } else {
                    return const Text(
                      '',
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          overflow: TextOverflow.ellipsis),
                    );
                  }
                },
              ),
              const SizedBox(height: 15),
              BlocBuilder(
                  bloc: userInfoBloc,
                  builder: (context, state) {
                    if (state is UserInfoFetchedState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.email, color: Colors.black54),
                          const SizedBox(width: 10),
                          Text(
                            state.userInfo.username,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      );
                    } else {
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: Colors.black54),
                          SizedBox(width: 10),
                          Text(
                            '',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      );
                    }
                  }),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                color: const Color.fromRGBO(246, 246, 246, 1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    LocaleKeys.settings.tr().toUpperCase(),
                    style: const TextStyle(
                        fontFamily: 'Mukta-Bold',
                        letterSpacing: 2,
                        fontSize: 18,
                        color: Color.fromRGBO(159, 159, 159, 1)),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.waiting.tr(),
                          style: const TextStyle(color: Colors.green)),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 160,
                            child: const Text('0',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis)),
                          ),
                          const Icon(Icons.remove_red_eye_outlined, size: 20)
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.confirmed.tr(),
                          style: const TextStyle(color: Colors.blue)),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 160,
                            child: const Text('2',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis)),
                          ),
                          const Icon(Icons.remove_red_eye_outlined, size: 20)
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.canceled.tr(),
                          style: const TextStyle(color: Colors.red)),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 160,
                            child: const Text('0',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis)),
                          ),
                          const Icon(Icons.remove_red_eye_outlined, size: 20)
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: const Color.fromRGBO(246, 246, 246, 1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    LocaleKeys.profile.tr().toUpperCase(),
                    style: const TextStyle(
                        fontFamily: 'Mukta-Bold',
                        letterSpacing: 2,
                        fontSize: 18,
                        color: Color.fromRGBO(159, 159, 159, 1)),
                  ),
                ),
              ),
              BlocBuilder<UserInfoBloc, UserInfoState>(
                bloc: userInfoBloc,
                builder: (context, state) {
                  if (state is UserInfoFetchedState) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            GoRouter.of(context).pushNamed('changeName',
                                extra: state.userInfo.name);
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(LocaleKeys.name.tr()),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 160,
                                        child: Text(state.userInfo.name,
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ),
                                      const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            GoRouter.of(context)
                                .pushNamed('changeAddress', extra: {
                              'province': state.userInfo.province,
                              'district': state.userInfo.district,
                              'commune': state.userInfo.commune,
                              'detailAddress': state.userInfo.detailAddress
                            });
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(LocaleKeys.address.tr()),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 160,
                                        child: Text(
                                          state.userInfo.province!.isNotEmpty?
                                            '${state.userInfo.detailAddress}, ${state.userInfo.commune}, ${state.userInfo.district}, ${state.userInfo.province}' : '',
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ),
                                      const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LocaleKeys.phone.tr()),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      child: Text(state.userInfo.phone!,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    const Icon(Icons.arrow_forward_ios_rounded,
                                        size: 20)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LocaleKeys.password.tr()),
                                const Row(
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      child: Text('**********',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 20)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LocaleKeys.name.tr()),
                                const Row(
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      child: Text('',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 20)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LocaleKeys.address.tr()),
                                const Row(
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      child: Text('',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 20)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LocaleKeys.phone.tr()),
                                const Row(
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      child: Text('',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 20)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              Container(
                width: double.infinity,
                color: const Color.fromRGBO(246, 246, 246, 1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    LocaleKeys.preferences.tr().toUpperCase(),
                    style: const TextStyle(
                        fontFamily: 'Mukta-Bold',
                        letterSpacing: 2,
                        fontSize: 18,
                        color: Color.fromRGBO(159, 159, 159, 1)),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).push('/language');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.public_rounded),
                            const SizedBox(width: 10),
                            Text(LocaleKeys.language.tr()),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 160,
                              child: Text(
                                  EasyLocalization.of(context)
                                              ?.locale
                                              .toString() ==
                                          'en'
                                      ? 'English'
                                      : 'Tiếng Việt',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis)),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded,
                                size: 20)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.nights_stay_rounded),
                          const SizedBox(width: 10),
                          Text(LocaleKeys.darkMode.tr()),
                        ],
                      ),
                      Switch.adaptive(
                        value: false,
                        onChanged: (bool value) {},
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  authBloc.add(LogoutRequest());
                },
                child: Container(
                  color: Colors.red,
                  height: 45,
                  width: double.infinity,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(LocaleKeys.logout.tr(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18))),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
