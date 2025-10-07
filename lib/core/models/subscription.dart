class Subscription {
  final String? id;
  final String? name;
  final String? description;
  final int? cardTemplateLimit;
  final int? languageLimit;
  final bool? isShowPremiumBadge;
  final bool? isShowProfileClickCount;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? code;
  final double? amount;
  final String? currencyCode;
  bool? isSelected;

  Subscription({
    this.id,
    this.name,
    this.description,
    this.cardTemplateLimit,
    this.languageLimit,
    this.isShowPremiumBadge,
    this.isShowProfileClickCount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.code,
    this.amount,
    this.currencyCode,
    this.isSelected
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      cardTemplateLimit: json['card_template_limit'] ?? 0,
      languageLimit: json['language_limit'] ?? 0,
      isShowPremiumBadge: json['isShowPremiumBadge'] ?? false,
      isShowProfileClickCount: json['isShowProfileClickCount'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime(2000)
          : DateTime(2000),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime(2000)
          : DateTime(2000),
      code: json['code'] ?? '',
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : 0.0,
      currencyCode: json['currency_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'card_template_limit': cardTemplateLimit,
      'language_limit': languageLimit,
      'isShowPremiumBadge': isShowPremiumBadge,
      'isShowProfileClickCount': isShowProfileClickCount,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'code': code,
      'amount': amount,
      'currency_code': currencyCode,
    };
  }
}
