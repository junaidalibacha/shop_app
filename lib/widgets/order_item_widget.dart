import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/order_provider.dart';

class OrderItemWidget extends StatefulWidget {
  const OrderItemWidget({
    Key? key,
    required this.order,
  }) : super(key: key);
  final OrderItemModel order;

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

bool _isExpanded = false;

class _OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: const Icon(Icons.expand_more),
            ),
          ),
          _isExpanded
              ? SizedBox(
                  height: min(widget.order.orderItems.length * 20.0 + 10, 100),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: ListView(
                      children: widget.order.orderItems
                          .map((prod) => Row(
                                children: [
                                  Text(
                                    prod.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${prod.quantity}x \$${prod.price}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
