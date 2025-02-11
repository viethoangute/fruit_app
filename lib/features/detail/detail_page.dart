import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:training_example/constants/fonts.dart';
import 'package:training_example/features/cart/bloc/cart_bloc.dart';
import 'package:training_example/features/cart/bloc/cart_event.dart';
import 'package:training_example/models/product/product.dart';
import 'package:training_example/utils/snackbar_hepler.dart';
import '../../generated/assets.dart';
import '../../translations/locale_keys.g.dart';
import '../cart/bloc/cart_state.dart';

class DetailPage extends StatefulWidget {
  final Product fruitItem;

  const DetailPage({Key? key, required this.fruitItem}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final PageController _pageController = PageController();
  List<Widget> imageWidgets = [];
  int amount = 1;
  late CartBloc cartBloc;

  @override
  void initState() {
    cartBloc = context.read<CartBloc>();
    for (var element in widget.fruitItem.images) {
      imageWidgets.add(
        Image.network(
          width: 300,
          element,
          errorBuilder: (context, error, stackTrace) {
            // Custom widget to display in case of image error
            return Image.asset(
              Assets.assetsImageDefault,
              height: 150,
              width: 150,
            );
          },
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(LocaleKeys.productDetail.tr(),
            style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 35, color: Colors.black),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is AddCartItemErrorState) {
            SnackBarHelper.showMessage(
                context: context,
                message: state.error,
                duration: const Duration(milliseconds: 1500));
          } else if (state is AddedCartItemState) {
            SnackBarHelper.showMessage(
                context: context,
                message: LocaleKeys.addToCartNoti.tr(),
                duration: const Duration(milliseconds: 1500));
            setState(() {
              amount = 1;
            });
          }
        },
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 350,
                    child: PageView(
                      controller: _pageController,
                      children: imageWidgets,
                    ),
                  ),
                  Visibility(
                    visible: widget.fruitItem.images.length > 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: SmoothPageIndicator(
                        effect: const JumpingDotEffect(
                            dotWidth: 10, dotHeight: 10, verticalOffset: 10),
                        controller: _pageController,
                        count: widget.fruitItem.images.length,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.fruitItem.name,
                            style: TextStyle(
                                fontFamily: Fonts.muktaSemiBold,
                                fontSize: 25,
                                height: 1.3,
                                color: Colors.green.shade600),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: '\$${widget.fruitItem.dolar}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 40,
                                      fontFamily: Fonts.muktaBold),
                                ),
                                TextSpan(
                                  text: '\t${LocaleKeys.ea.tr()}',
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontFamily: Fonts.muktaMedium),
                                ),
                              ]),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (amount > 1) {
                                        setState(() {
                                          amount = amount - 1;
                                        });
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    amount.toString(),
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontFamily: Fonts.muktaSemiBold),
                                  ),
                                  const SizedBox(width: 20),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        amount = amount + 1;
                                      });
                                    },
                                    highlightColor: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '\$${widget.fruitItem.unit}',
                            style: const TextStyle(
                                fontFamily: Fonts.muktaSemiBold,
                                fontSize: 18,
                                height: 1.3,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          height: 55,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              cartBloc.add(AddCartItemEvent(
                                  productId: widget.fruitItem.id,
                                  quantity: amount));
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red.shade400)),
                            child: Text(LocaleKeys.addToCart.tr().toUpperCase(),
                                style:
                                    const TextStyle(fontFamily: Fonts.muktaSemiBold)),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.fruitItem.description,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontFamily: Fonts.muktaRegular,
                                  fontSize: 18,
                                  height: 1.3,
                                  color: Colors.black54),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
