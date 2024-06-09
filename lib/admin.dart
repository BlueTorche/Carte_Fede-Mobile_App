import 'package:flutter/material.dart';
import 'api_service/admin_service.dart';
import 'drawer.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final AdminService apiService = AdminService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _cardNumbercontroller = TextEditingController();
  String? _notificationMessage;
  Color _notificationColor = Colors.red;
  bool _isLoading = false;


  final study_years = [
    'BAB1', 'BAB1 Archi', 'BAB2', 'BAB2 Archi', 'BAB3 Archi', 'BAB3 Chimie',
    'BAB3 Elec', 'BAB3 IG', 'BAB3 Meca', 'BAB3 Mines', 'MAB1 Archi',
    'MAB1 Chimie', 'MAB1 Elec', 'MAB1 IG', 'MAB1 Meca', 'MAB1 Mines',
    'MAB2 Archi', 'MAB2 Chimie', 'MAB2 Elec', 'MAB2 IG', 'MAB2 Meca',
    'MAB2 Mines', 'Exté', 'Autre'
  ];

  String selectedYear = "";
  String selectedStudyYear = "";

  void create() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _notificationMessage = null;
      });

      try {
        String cardSelected = "";
        if (_cardNumbercontroller.text != null) {
          cardSelected = _cardNumbercontroller.text;
        }

        final response = await apiService.post(
            _emailController.text,
            _nomController.text,
            _prenomController.text,
            selectedStudyYear,
            selectedYear,
            cardSelected
        );

        if (response["statusCode"] == 200) {
          setState(() {
            _notificationMessage = response["msg"].toString();
            _notificationColor = Colors.white;
          });
        } else if (response["statusCode"] == 401 ||
            response["statusCode"] == 400 ||
            response["statusCode"] == 408) {
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

      } catch(e) {
        setState(() {
          _notificationMessage = e.toString();
          _notificationColor = Colors.red;
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  String calculateValidity() {
    DateTime today = DateTime.now();

    int startYear;
    if (today.month >= 9) {
      // If current month is September or later
      startYear = today.year;
    } else {
      startYear = today.year - 1;
    }

    int endYear = startYear + 1;
    return "$startYear-$endYear";
  }

  List<String> calculateAllValidityYears() {
    String thisYear = calculateValidity();
    int year1 = int.parse(thisYear.split("-")[0]);

    List<String> allValidity = [];

    for (int i = -5; i <= 5; i++) {
      allValidity.add("${year1 + i}-${year1 + i + 1}");
    }

    return allValidity;
  }

  @override
  Widget build(BuildContext context) {
    List<String> validity_years = calculateAllValidityYears();
    selectedYear = calculateValidity();
    selectedStudyYear = study_years[0];

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
              'Créer une Carte',
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Color(0xFF2f3293)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2f3293)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "S'il vous plaît, entrez une valeur";
                        }
                        String pattern =
                            r'^[a-zA-Z0-9]+[a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return "Entrez une adresse email valide";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(
                        labelText: 'Prénom',
                        labelStyle: TextStyle(color: Color(0xFF2f3293)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2f3293)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "S'il vous plaît, entrez une valeur";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _prenomController,
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        labelStyle: TextStyle(color: Color(0xFF2f3293)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2f3293)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "S'il vous plaît, entrez une valeur";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedStudyYear,
                      items: study_years.map((year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedStudyYear = value!;
                      },
                      decoration: const InputDecoration(
                        labelText: "Année d'Étude",
                        labelStyle: TextStyle(color: Color(0xFF2f3293)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2f3293)),
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedYear,
                      items: validity_years.map((year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedYear = value!;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Année de validité',
                        labelStyle: TextStyle(color: Color(0xFF2f3293)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2f3293)),
                        ),
                      ),
                    ),
                TextFormField(
                  controller: _cardNumbercontroller,
                  keyboardType: TextInputType.number, // Accepts only numeric input
                  decoration: const InputDecoration(
                    labelText: 'Numéro de Carte',
                    labelStyle: TextStyle(color: Color(0xFF2f3293)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF2f3293)),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      // Validate if the input is an integer
                      if (int.tryParse(value) == null) {
                        return 'Entrez un nombre entier valide';
                      }
                    }
                    return null; // No validation error if the field is empty or contains an integer
                  },),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: create,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF2f3293),
                      ),
                      child: const Text('Créer la Carte'),
                    ),
                  ],
                ),
              ),
              if (_notificationMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  _notificationMessage!,
                  style: TextStyle(color: _notificationColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
