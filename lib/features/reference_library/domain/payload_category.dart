import 'payload_technique.dart';

/// An OWASP category grouping (e.g. "A01:2025 Broken Access Control") and
/// the lab techniques filed under it.
class PayloadCategory {
  final String code;
  final String name;
  final String icon;
  final List<PayloadTechnique> techniques;

  const PayloadCategory({
    required this.code,
    required this.name,
    required this.icon,
    required this.techniques,
  });
}
