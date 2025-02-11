import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:training_example/constants/constants.dart';
import 'package:training_example/di/injection.dart';
import 'package:training_example/features/cart/bloc/cart_event.dart';
import 'package:training_example/features/home/widgets/fruit_item.dart';
import 'package:training_example/features/home/widgets/horizontal_category.dart';
import 'package:training_example/generated/assets.dart';
import 'package:training_example/features/home/bloc/user_info_bloc/user_info_bloc.dart';
import 'package:training_example/models/user_info/user.dart' as user_model;
import 'package:training_example/repositories/vn_address_repository.dart';
import '../../../constants/fonts.dart';
import '../../../translations/locale_keys.g.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../bloc/product_bloc/product_bloc.dart';
import '../bloc/product_bloc/product_event.dart';
import '../bloc/product_bloc/product_state.dart';
import '../bloc/user_info_bloc/user_info_event.dart';
import '../bloc/user_info_bloc/user_info_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late UserInfoBloc userInfoBloc;
  late user_model.UserInfo userInfo;
  late CartBloc cartBloc;
  bool isImageError = false;
  late ProductBloc productBloc;
  VNAddressRepository addressRepository = getIt.get<VNAddressRepository>();

  int currentPickedCategory = 0;

  final CircleAvatar defaultAvatar = const CircleAvatar(
    radius: 25.0,
    backgroundImage: AssetImage(Assets.assetsImageDefault),
    backgroundColor: Colors.transparent,
  );

  @override
  void initState() {
    userInfoBloc = context.read<UserInfoBloc>();
    userInfoBloc.add(FetchCurrentUserInfoEvent());

    productBloc = context.read<ProductBloc>();
    productBloc.add(FetchProductsEvent(category: Constants.generalCategories[0]));
    
    cartBloc = context.read<CartBloc>();
    cartBloc.add(FetchCartItemEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          'Fruity',
          style: TextStyle(
              fontSize: 40,
              color: Colors.green.shade800,
              fontWeight: FontWeight.w900,
              fontFamily: Fonts.dancingBold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.person,
            color: Colors.green.shade800,
            size: 35,
          ),
          onPressed: () {
            GoRouter.of(context).push('/usersRemotePage');
          },
        ),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 15),
              child: BlocBuilder<UserInfoBloc, UserInfoState>(
                bloc: userInfoBloc,
                builder: (context, state) {
                  if (state is UserInfoFetchedState) {
                    return isImageError
                        ? defaultAvatar
                        : CircleAvatar(
                            radius: 25.0,
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
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 4,
                left: 10.0,
                top: 35.0),
            child: Text(
              LocaleKeys.mainTitle.tr(),
              style: const TextStyle(
                fontSize: 30,
                fontFamily: Fonts.muktaMedium,
                height: 1.4,
              ),
            ),
          ),
          HorizontalCategory(
              initialIndex: currentPickedCategory,
              onCategoryChange: (index) {
                setState(() {
                  currentPickedCategory = index!;
                  productBloc.add(FetchProductsEvent(
                      category: Constants.generalCategories[index]));
                });
              }),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductsLoadingState) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              } else if (state is ProductsErrorState) {
                return Expanded(
                    child: Center(
                        child:
                            Text('An Error has occurred! \n${state.error}')));
              } else if (state is ProductsFetchedState) {
                return Expanded(
                  child: Scrollbar(
                    thickness: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(const Duration(milliseconds: 1500));
                          productBloc.add(FetchProductsEvent(category: Constants.generalCategories[currentPickedCategory]));
                        },
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 5),
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              return FruitItem(
                                  item: state.products[index],
                                  onTap: () {
                                    GoRouter.of(context).pushNamed('detail',
                                        extra: state.products[index]);
                                  });
                            }),
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
