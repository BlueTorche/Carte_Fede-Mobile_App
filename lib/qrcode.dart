import 'package:carte_fede/api_service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'api_service/qrcode_service.dart';
import 'drawer.dart';

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final QRCodeService apiService = QRCodeService();
  String? _errorMessage;
  bool _isLoading = false;

  // Les données du tableau
  late Map<String, dynamic> data;

  String card_number = "";
  String card_year = "";
  String user_name = "";
  String user_first_name = "";
  String card_study = "";
  String link = "";

  Future<void> loadData() async {
    _isLoading = true;
    data = await apiService.get();

    if (data["statusCode"] == 200) {
      card_number = data["msg"]["card_number"];
      card_year = data["msg"]["card_year"];
      user_name = data["msg"]["user_name"];
      user_first_name = data["msg"]["user_first_name"];
      card_study = data["msg"]["card_study"];
      link = data["msg"]["link"];
    } else {
      _errorMessage = "Error Code ${data["statusCode"]} : ${data["msg"]}";
    }
    _isLoading = false;
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
                        'Ma Carte Fédé',
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
                        'Ma Carte Fédé',
                        style: TextStyle(color: Color(0xFF2f3293)),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white,
                ),
                drawer: AppDrawer(),
                body: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                            child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(children: [
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 20),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ] else ...[
                              Stack(alignment: Alignment.center, children: [
                                QrImageView(
                                  data: link,
                                  version: QrVersions.auto,
                                  size: 300.0,
                                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                                  foregroundColor: const Color(0xFF2f3293),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 75,
                                    height: 75,
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              ]),
                              Text(
                                "Numéro de carte : ${card_number}",
                                style: TextStyle(
                                    color: Color(0xFF2f3293),
                                    fontSize: 20
                                    ),
                              ),
                              Text(
                                "Année : ${card_year}",
                                style: TextStyle(
                                    color: Color(0xFF2f3293),
                                    fontSize: 20
                                ),
                              ),
                              Text(
                                "Nom : ${user_name}",
                                style: TextStyle(
                                    color: Color(0xFF2f3293),
                                    fontSize: 20
                                ),
                              ),
                              Text(
                                "Prénom : ${user_first_name}",
                                style: TextStyle(
                                    color: Color(0xFF2f3293),
                                    fontSize: 20
                                ),
                              ),
                              Text(
                                "Étude : ${card_study}",
                                style: TextStyle(
                                    color: Color(0xFF2f3293),
                                    fontSize: 20
                                ),
                              ),
                            ]
                          ]),
                        )))
                    ]));
          }
        });
  }
}
