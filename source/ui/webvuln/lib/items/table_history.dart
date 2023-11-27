import 'package:flutter/material.dart';
import 'package:webvuln/model/url.dart';
import 'package:webvuln/model/urls.dart';

class SortableTable extends StatefulWidget {
  const SortableTable({super.key});

  @override
  State<SortableTable> createState() => _SortableTableState();
}

class _SortableTableState extends State<SortableTable> {
  late List<urlScanned> urlHistory;
  bool isAscending = true;
  int? sortColumnIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.urlHistory = List.of(allUrls);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: buildDataTable());
  }

  Widget buildDataTable() {
    final columns = ['No', 'Vulnerabilities', 'Description', 'Date&Time'];
    return DataTable(columns: getColumns(columns), rows: getRows(urlHistory));
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<urlScanned> urls) => urls.map((urlScanned url) {
        final cells = [
          url.no,
          url.description,
          url.vulnerabilities,
          url.scanTime
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      urlHistory.sort((urlHistory1, urlHistory2) =>
          compareString(ascending, urlHistory1.no, urlHistory2.no));
    } else if (columnIndex == 1) {
      urlHistory.sort((urlHistory1, urlHistory2) => compareString(
          ascending, urlHistory1.vulnerabilities, urlHistory2.vulnerabilities));
    } else if (columnIndex == 3) {
      urlHistory.sort((urlHistory1, urlHistory2) => compareString(
          ascending, '${urlHistory1.scanTime}', '${urlHistory2.scanTime}'));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
