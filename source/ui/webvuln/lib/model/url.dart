class urlScanned {
  final String no;
  final String description;
  final String scanTime;
  final String vulnerabilities;
  const urlScanned(
      {required this.no,
      required this.description,
      required this.scanTime,
      required this.vulnerabilities});

  urlScanned copy(
          {String? no,
          String? description,
          String? scanTime,
          String? vulnerabilities}) =>
      urlScanned(
          no: no ?? this.no,
          description: description ?? this.description,
          scanTime: scanTime ?? this.scanTime,
          vulnerabilities: vulnerabilities ?? this.vulnerabilities);


  @override
  bool operator == (Object other) => identical(this, other) || other is urlScanned && runtimeType == other.runtimeType && no == other.no &&
          description == other.description &&
          scanTime == other.scanTime &&
          vulnerabilities == other.vulnerabilities;

  @override 
  int get hashCode => no.hashCode ^ description.hashCode ^ scanTime.hashCode ^ vulnerabilities.hashCode;
}
