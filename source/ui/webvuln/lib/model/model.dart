class URL {
  final List<String> url;
  final List<String> modules;
  const URL({required this.url, required this.modules});

  Map<String, dynamic> toJson() {
    return {
      'urls': url,
      'modules': modules,
    };
  }
}

class History {
  final String? domain;
  final String? scanDate;
  const History({
    this.domain,
    this.scanDate,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'domain': domain,
      'scanDate': scanDate,
    };

    if (domain != null) {
      json['domain'] = domain;
    }

    if (scanDate != null) {
      json['scanDate'] = scanDate;
    }

    return json;
  }
}

class Vulnerability {
  final String type;
  final String logs;
  final List<String> payload;
  final String severity;

  Vulnerability({
    required this.type,
    required this.logs,
    required this.payload,
    required this.severity,
  });
}

class HistoryTableData {
  final String id;
  final String domain;
  final int numVuln;
  final List<Vulnerability> vuln;
  final String resultSeverity;
  final double resultPoint;
  final String scanDate;

  HistoryTableData({
    required this.id,
    required this.domain,
    required this.numVuln,
    required this.vuln,
    required this.resultSeverity,
    required this.resultPoint,
    required this.scanDate,
  });

  factory HistoryTableData.fromJsonHistory(dynamic json) {
    List<Map<String, dynamic>> vulnListJson =
        List<Map<String, dynamic>>.from(json['vulnerabilities']);
    List<Vulnerability> vulnList = vulnListJson.map((vulnJson) {
      List<String> payloadList = List<String>.from(vulnJson['payload']);
      return Vulnerability(
        type: vulnJson['type'],
        logs: vulnJson['logs'],
        payload: payloadList,
        severity: vulnJson['severity'],
      );
    }).toList();

    return HistoryTableData(
      id: json['_id'],
      domain: json['domain'],
      numVuln: json['numVuln'],
      vuln: vulnList,
      resultSeverity: json['resultSeverity'],
      resultPoint: json['resultPoint'].toDouble(),
      scanDate: json['scanDate'],
    );
  }

  factory HistoryTableData.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> resultListJson = [];
    try {
      resultListJson = List<Map<String, dynamic>>.from(json['result']);
    } catch (e) {
      throw Exception('No result found or invalid result in database');
    }
    Map<String, dynamic> resultData =
        resultListJson.first; // TODO: fix this (why first?)

    List<Map<String, dynamic>> vulnListJson =
        List<Map<String, dynamic>>.from(resultData['vulnerabilities']);
    List<Vulnerability> vulnList = vulnListJson.map((vulnJson) {
      List<String> payloadList = List<String>.from(vulnJson['payload']);
      return Vulnerability(
        type: vulnJson['type'],
        logs: vulnJson['logs'],
        payload: payloadList,
        severity: vulnJson['severity'],
      );
    }).toList();

    return HistoryTableData(
      id: resultData['_id'],
      domain: resultData['domain'],
      numVuln: resultData['numVuln'],
      vuln: vulnList,
      resultSeverity: resultData['resultSeverity'],
      resultPoint: resultData['resultPoint'],
      scanDate: resultData['scanDate'],
    );
  }
}

class ResourceNormal {
  final String vulnType;
  final String resType;
  final dynamic value;
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

class ResourceFile {
  final String? fileName;
  final String description;
  final dynamic base64value;
  final String? action;

  const ResourceFile({
    this.fileName,
    required this.description,
    this.base64value,
    this.action,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'description': description,
    };

    if (fileName != null) {
      json['fileName'] = fileName;
    }

    if (base64value != null) {
      json['base64value'] = base64value;
    }

    if (action != null) {
      json['action'] = action;
    }

    return json;
  }
}

class ResourceFileTableData {
  final String id;
  final String fileName;
  final String description;
  final String base64value;
  final String createdDate;
  final String editedDate;

  ResourceFileTableData({
    required this.id,
    required this.fileName,
    required this.description,
    required this.base64value,
    required this.createdDate,
    required this.editedDate,
  });

  factory ResourceFileTableData.fromJson(Map<String, dynamic> json) {
    return ResourceFileTableData(
      id: json['_id'],
      fileName: json['fileName'],
      description: json['description'],
      base64value: json['base64value'],
      createdDate: json['createdDate'],
      editedDate: json['editedDate'],
    );
  }
}

class ChartData {
  final String x;
  final num y;
  final num y1;

  ChartData(this.x, this.y, this.y1);
}
