import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../models/invoice.dart';

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
    // final formattedDate = DateFormat('MMM dd. yyyy').format(invoice.issuedDate);

    return Container(
      height: 85,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Button(
        onPressed: () {
          // context.push(
          //   InvoiceDetailsView.routeName,
          //   extra: invoice,
          // );
        },
        child: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: circleColor,
              radius: 28,
              child: Text(
                'invoice.title[0]',
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
                    'invoice.title',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: AppFonts.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'invoice.title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: AppFonts.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '2 mins ago',
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
    );
  }
}
