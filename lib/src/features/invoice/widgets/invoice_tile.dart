import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../business/bloc/business_bloc.dart';
import '../../business/models/business.dart';
import '../../client/bloc/client_bloc.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../../settings/data/settings_repository.dart';
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
    final client = context.watch<ClientBloc>().state.firstWhereOrNull(
      (element) {
        return element.id == invoice.clientID;
      },
    );

    final currency = context.read<SettingsRepository>().getCurrency();

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
            child: Builder(builder: (ctx) {
              return Button(
                onPressed: () {
                  DialogWidget.show(
                    context,
                    title: 'Delete?',
                    delete: true,
                    onPressed: () {
                      Slidable.of(ctx)?.close();
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
              );
            }),
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
                child: BlocBuilder<BusinessBloc, List<Business>>(
                  builder: (context, state) {
                    final business = state.firstWhereOrNull((element) {
                      return element.id == invoice.businessID;
                    });

                    return business == null
                        ? Text(
                            client?.name[0] ?? '?',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: AppFonts.w600,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.file(
                              File(business.imageLogo),
                              height: 28 * 2,
                              width: 28 * 2,
                              fit: BoxFit.cover,
                              errorBuilder: ImageWidget.errorBuilder,
                              frameBuilder: ImageWidget.frameBuilder,
                            ),
                          );
                  },
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
                        return Text(
                          invoice.paymentMethod.isEmpty
                              ? invoice.isEstimate.isEmpty
                                  ? 'Invoice Send'
                                  : 'Estimate Send'
                              : 'Received ${calculateInvoiceMoney(
                                  items: items,
                                  currency: currency,
                                  invoiceID: invoice.id,
                                )}',
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
