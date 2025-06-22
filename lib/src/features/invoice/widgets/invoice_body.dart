import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/switch_button.dart';
import '../../../core/widgets/title_text.dart';
import '../../business/models/business.dart';
import '../../client/models/client.dart';
import '../../item/models/item.dart';
import '../bloc/invoice_bloc.dart';
import 'photos_list.dart';
import '../models/photo.dart';
import 'invoice_dates.dart';
import 'invoice_select_data.dart';
import 'invoice_selected_data.dart';

class InvoiceBody extends StatelessWidget {
  const InvoiceBody({
    super.key,
    required this.date,
    required this.dueDate,
    required this.number,
    required this.business,
    required this.clients,
    required this.items,
    required this.photos,
    required this.isEstimate,
    required this.signature,
    required this.hasSignature,
    required this.active,
    required this.onSelectBusiness,
    required this.onSelectClient,
    required this.onSelectItems,
    required this.onSignature,
    required this.onAddSignature,
    required this.onDate,
    required this.onDueDate,
    required this.onCreate,
    required this.onAddPhotos,
    required this.onRemoveItem,
  });

  final int date;
  final int dueDate;
  final int number;
  final List<Business> business;
  final List<Client> clients;
  final List<Item> items;
  final List<Photo> photos;
  final String isEstimate;
  final String signature;
  final bool hasSignature;
  final bool active;
  final VoidCallback onSelectBusiness;
  final VoidCallback onSelectClient;
  final VoidCallback onSelectItems;
  final VoidCallback onSignature;
  final VoidCallback onAddSignature;
  final VoidCallback onDate;
  final VoidCallback onDueDate;
  final VoidCallback onCreate;
  final VoidCallback onAddPhotos;
  final void Function(int) onRemoveItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: TitleText(title: 'Issued'),
                  ),
                  SizedBox(
                    width: 120,
                    child: TitleText(title: 'Due'),
                  ),
                  Spacer(),
                  TitleText(title: '#'),
                ],
              ),
              const SizedBox(height: 6),
              InvoiceDates(
                date: date,
                dueDate: dueDate,
                number: number,
                onDate: onDate,
                onDueDate: onDueDate,
              ),
              const SizedBox(height: 16),
              const TitleText(title: 'Business account'),
              const SizedBox(height: 6),
              business.isEmpty
                  ? InvoiceSelectData(
                      title: 'Choose Account',
                      onPressed: onSelectBusiness,
                    )
                  : InvoiceSelectedData(
                      title: business.first.name,
                      onPressed: onSelectBusiness,
                    ),
              const SizedBox(height: 16),
              const TitleText(title: 'Client'),
              const SizedBox(height: 6),
              clients.isEmpty
                  ? InvoiceSelectData(
                      title: 'Add Client',
                      onPressed: onSelectClient,
                    )
                  : InvoiceSelectedData(
                      title: clients.first.name,
                      onPressed: onSelectClient,
                    ),
              const SizedBox(height: 16),
              const TitleText(title: 'Items'),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: List.generate(
                    items.length,
                    (index) {
                      return InvoiceSelectedData(
                        title: items[index].title,
                        onPressed: () {
                          onRemoveItem(index);
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
              InvoiceSelectData(
                title: items.isEmpty ? 'Add Item' : 'Add another Item',
                onPressed: onSelectItems,
              ),
              const SizedBox(height: 16),
              const TitleText(title: 'Summary'),
              const SizedBox(height: 6),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: AppFonts.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      calculateInvoiceMoney(items: items),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: AppFonts.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: TitleText(title: 'Signature'),
                  ),
                  SwitchButton(
                    isActive: hasSignature,
                    onPressed: onSignature,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (hasSignature) ...[
                SvgPicture.string(signature),
                const SizedBox(height: 16),
                MainButton(
                  title: signature.isEmpty
                      ? 'Create a signature'
                      : 'Change signature',
                  outlined: true,
                  onPressed: onAddSignature,
                ),
              ],
              if (isEstimate.isNotEmpty) ...[
                const SizedBox(height: 16),
                TitleText(title: 'Photos'),
                const SizedBox(height: 6),
                InvoiceSelectData(
                  title: 'Add Photo',
                  onPressed: onAddPhotos,
                ),
                const SizedBox(height: 16),
                BlocBuilder<InvoiceBloc, InvoiceState>(
                  builder: (context, state) {
                    return PhotosList(photos: photos);
                  },
                ),
              ],
            ],
          ),
        ),
        MainButtonWrapper(
          children: [
            MainButton(
              title: 'Save',
              active: active,
              onPressed: onCreate,
            ),
          ],
        ),
      ],
    );
  }
}
