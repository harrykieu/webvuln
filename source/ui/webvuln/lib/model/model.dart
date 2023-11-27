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

class resource {
  final String vulnType;
  final String resType;
  final String value;
  final String action;
  const resource(
      {required this.vulnType,
      required this.action,
      required this.resType,
      required this.value});
  Map<String, dynamic> toJson() {
    return {
      'vulnType': vulnType,
      'action': action,
      'resType': resType,
      'value': value
    };
  }
}

class ChartData {
  final String x;
  final num y;
  final num y1;

  ChartData(this.x, this.y, this.y1);
}

