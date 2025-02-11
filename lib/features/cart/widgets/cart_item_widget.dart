import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_example/di/injection.dart';
import 'package:training_example/features/cart/bloc/cart_bloc.dart';
import 'package:training_example/features/cart/bloc/cart_event.dart';

import '../../../constants/fonts.dart';
import '../../../generated/assets.dart';
import '../../../models/cart_item/cart_item.dart';

class CartItemWidget extends StatefulWidget {
  final CartItem item;
  final ValueChanged<bool> onChose;
  final VoidCallback onDelete;
  final VoidCallback onQuantityChange;
  late CartBloc cartBloc;

  CartItemWidget({Key? key, required this.item, required this.onChose, required this.onDelete, required this.onQuantityChange})
      : super(key: key) {
    cartBloc = getIt.get<CartBloc>();
  }

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete_outline_outlined, color: Colors.white),
      ),
      key: Key(widget.item.id),
      onDismissed: (_) => widget.onDelete(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: Image.network(
              widget.item.itemInfo!.images[0],
              height: 90,
              width: 90,
              errorBuilder: (context, error, stackTrace) {
                // Custom widget to display in case of image error
                return Image.asset(
                  Assets.assetsImageDefault,
                  height: 90,
                  width: 90,
                );
              },
            ),
            trailing: Checkbox(
              value: widget.item.isChose,
              onChanged: (bool? value) {
                setState(() {
                  widget.item.isChose = !widget.item.isChose;
                  widget.onChose(value!);
                });
              },
            ),
            title: Text(
              widget.item.itemInfo!.name,
              maxLines: 1,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${widget.item.itemInfo!.dolar}',
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                      fontFamily: Fonts.muktaSemiBold),
                ),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (widget.item.quantity > 1) {
                            widget.cartBloc.add(UpdateQuantityEvent(
                                productId: widget.item.id,
                                isIncrease: false,
                                quantity: 1));
                            setState(() {
                              widget.item.quantity -= 1;
                            });
                            widget.onQuantityChange();
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
                        widget.item.quantity.toString(),
                        style: const TextStyle(
                            fontSize: 20, fontFamily: Fonts.muktaSemiBold),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          widget.cartBloc.add(UpdateQuantityEvent(
                              productId: widget.item.id,
                              isIncrease: true,
                              quantity: 1));
                          setState(() {
                            widget.item.quantity += 1;
                          });
                          widget.onQuantityChange();
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
            isThreeLine: true,
          ),
        ),
      ),
    );
  }
}
