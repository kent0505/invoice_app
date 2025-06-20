import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../client/bloc/client_bloc.dart';
import '../../client/models/client.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../screens/invoice_details_screen.dart';

class InvoiceTile extends StatelessWidget {
  const InvoiceTile({
    super.key,
    required this.invoice,
    required this.circleColor,
  });

  final Invoice invoice;
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    Client? client;
    try {
      client = context
          .read<ClientBloc>()
          .state
          .firstWhere((element) => element.id == invoice.clientID);
    } catch (e) {
      logger(e);
    }

    return Slidable(
      closeOnScroll: true,
      endActionPane: ActionPane(
        extentRatio: 107 / MediaQuery.of(context).size.width,
        motion: ScrollMotion(),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 6,
              bottom: 6,
              right: 16,
            ),
            child: Button(
              onPressed: () {
                DialogWidget.show(
                  context,
                  title: 'Delete?',
                  delete: true,
                  onPressed: () {
                    context
                        .read<InvoiceBloc>()
                        .add(DeleteInvoice(invoice: invoice));
                    context.pop();
                  },
                );
              },
              child: Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: const SvgWidget(Assets.delete),
                ),
              ),
            ),
          ),
        ],
      ),
      child: Container(
        height: 85,
        margin: const EdgeInsets.only(
          bottom: 6,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Button(
          onPressed: () {
            context.push(
              InvoiceDetailsScreen.routePath,
              extra: invoice,
            );
          },
          child: Row(
            children: [
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: circleColor,
                radius: 28,
                child: Text(
                  client?.name[0] ?? '?',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: AppFonts.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client?.name ?? '?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: AppFonts.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    BlocBuilder<ItemBloc, List<Item>>(
                      builder: (context, items) {
                        double amount = 0;
                        for (Item item in items) {
                          if (item.invoiceID == invoice.id) {
                            amount += double.tryParse(item.discountPrice) ?? 0;
                          }
                        }

                        return Text(
                          invoice.paymentMethod.isEmpty
                              ? 'Invoice Send'
                              : 'Received \$${amount.toStringAsFixed(2)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: AppFonts.w400,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                formatSmartDate(invoice.date),
                style: const TextStyle(
                  color: Color(0xff748098),
                  fontSize: 12,
                  fontFamily: AppFonts.w400,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
