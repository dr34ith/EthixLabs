import 'payload_item.dart';

/// A named technique (e.g. "IDOR") within an OWASP category, with a short
/// usage description and the exact payload(s) it uses.
class PayloadTechnique {
  final String name;
  final List<PayloadItem> payloads;
  final String description;

  const PayloadTechnique({
    required this.name,
    required this.payloads,
    required this.description,
  });
}
