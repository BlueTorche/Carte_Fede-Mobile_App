import 'package:flutter/material.dart';
import 'api_service/view_card_service.dart';
import 'login.dart';
import 'drawer.dart';

class ViewCardPage extends StatefulWidget {
  @override
  _ViewCardPageState createState() => _ViewCardPageState();
}

class _ViewCardPageState extends State<ViewCardPage> {
  final ViewCardService apiService = ViewCardService();
  String? _notificationMessage;
  Color _notificationColor = Colors.red;
  bool _isLoading = false;

  // Les données du tableau
  List<List<String>> data = [
    ["Loading"]
  ];

  Future<void> loadData() async {
    data = await apiService.get();
  }

  void delete(String email) async {
    setState(() {
      _isLoading = true;
      _notificationMessage = null;
    });
    try {
      final response = await apiService.postDelete(email);

      setState(() {
        _isLoading = false;
      });

      if (response["statusCode"] == 200) {
        setState(() {
          _notificationMessage = 'Carte supprimée avec succès !';
          _notificationColor = Colors.white;
        });
      } else if (response["statusCode"] == 401) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else if (response["statusCode"] == 400 ||
          response["statusCode"] == 404) {
        setState(() {
          _notificationMessage = response['msg'].toString();
          _notificationColor = Colors.red;
        });
      } else {
        setState(() {
          _notificationMessage = response['body'].toString();
          _notificationColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        _notificationMessage = e.toString();
        _notificationColor = Colors.red;
      });
    }
  }

  List<DataColumn> _createColumns() {
    return data[0].map((column) {
      return DataColumn(
        label: Text(
          column,
          style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      );
    }).toList();
  }

  List<DataRow> _createRows() {
    return data.sublist(1).map((row) {
      return DataRow(cells: [
        DataCell(Text(row[0], style: const TextStyle(color: Colors.white))),
        DataCell(Text(row[1], style: const TextStyle(color: Colors.white))),
        DataCell(Text(row[2], style: const TextStyle(color: Colors.white))),
        DataCell(Text(row[3], style: const TextStyle(color: Colors.white))),
        DataCell(Text(row[4], style: const TextStyle(color: Colors.white))),
        DataCell(
          ElevatedButton(
            onPressed: () {
              delete(row[5]);
            },
            child: Text('Delete'),
          ),
        ),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: const Color(0xFF2f3293),
              appBar: AppBar(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Liste des Cartes',
                      style: TextStyle(color: Color(0xFF2f3293)),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
              ),
              drawer: AppDrawer(),
              body: const Center(child: CircularProgressIndicator()));
        } else {
          return Scaffold(
              backgroundColor: const Color(0xFF2f3293),
              appBar: AppBar(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Liste des Cartes',
                      style: TextStyle(color: Color(0xFF2f3293)),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
              ),
              drawer: AppDrawer(),
              body: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    if (_notificationMessage != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        _notificationMessage!,
                        style:
                        TextStyle(color: _notificationColor),
                      ),
                    ],
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child:
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: _createColumns(),
                          rows: _createRows(),
                        ),
                      ),
                    )
                  ])));
        }
      },
    );
  }
}
