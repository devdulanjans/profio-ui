class Template {
  final String? id;
  final String? name;
  final String? description;
  final String? previewImage;
  final Map<String, String>? placeholders;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? htmlContent;
  final String? templateCode;
  bool? isAlreadySelected;

  Template({
    this.id,
     this.name,
     this.description,
     this.previewImage,
     this.placeholders,
     this.isActive,
     this.createdAt,
     this.updatedAt,
     this.htmlContent,
     this.templateCode,
    this.isAlreadySelected
  });

  // Factory constructor to create Template from JSON
  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['_id'] ?? "",  // Provide a default empty string if null
      name: json['name'] ?? "Untitled Template",  // Default name if null
      description: json['description'] ?? "No description provided",  // Default description if null
      previewImage: json['preview_image'] ?? "",  // Default empty string if null
      placeholders: Map<String, String>.from(json['placeholders'] ?? {}),
      isActive: json['is_active'] ?? false,  // Default false if null
      createdAt: json['created_at'] ?? "1970-01-01T00:00:00.000Z",  // Default timestamp if null
      updatedAt: json['updated_at'] ?? "1970-01-01T00:00:00.000Z",  // Default timestamp if null
      htmlContent: json['html_content'] ?? "",  // Default empty string if null
      templateCode: json['template_code'] ?? "UNKNOWN",  // Default "UNKNOWN" if null
    );
  }

  // Method to convert Template to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? "",
      "name": name,
      "description": description,
      "preview_image": previewImage,
      "placeholders": placeholders,
      "is_active": isActive,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "html_content": htmlContent,
      "template_code": templateCode,
    };
  }
}
