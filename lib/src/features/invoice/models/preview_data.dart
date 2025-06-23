import '../../business/models/business.dart';
import '../../client/models/client.dart';
import '../../item/models/item.dart';
import 'invoice.dart';
import 'photo.dart';

class PreviewData {
  PreviewData({
    required this.invoice,
    required this.business,
    required this.clients,
    required this.items,
    required this.photos,
    this.customize = true,
  });

  final Invoice invoice;
  final List<Business> business;
  final List<Client> clients;
  final List<Item> items;
  final List<Photo> photos;
  final bool customize;
}
