class URL {
  final String url;
  final List<String> modules;
  const URL({required this.url, required this.modules});

  Map<String, dynamic> toJson() {
    return {
      'urls': url,
      'modules': modules,
    };
  }
}

class historyURL {
  final String domain;
  final String scanDate;
  const historyURL({required this.domain, required this.scanDate});

  Map<String, dynamic> toJson() {
    return {'domain': domain, 'scanDate': scanDate};
  }
}

class ResourceNormal {
  final String vulnType;
  final String resType;
  final String? value;
  final String? action;

  const ResourceNormal({
    required this.vulnType,
    required this.resType,
    this.value,
    this.action,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'vulnType': vulnType,
      'resType': resType,
    };

    if (value != null) {
      json['value'] = value;
    }

    if (action != null) {
      json['action'] = action;
    }

    return json;
  }
}

class ResourceNormalTableData {
  final String id;
  final String vulnType;
  final String type;
  final String value;
  final String createdDate;
  final String editedDate;

  ResourceNormalTableData({
    required this.id,
    required this.vulnType,
    required this.type,
    required this.value,
    required this.createdDate,
    required this.editedDate,
  });

  factory ResourceNormalTableData.fromJson(Map<String, dynamic> json) {
    return ResourceNormalTableData(
      id: json['_id'],
      vulnType: json['vulnType'],
      type: json['type'],
      value: json['value'],
      createdDate: json['createdDate'],
      editedDate: json['editedDate'],
    );
  }
}
