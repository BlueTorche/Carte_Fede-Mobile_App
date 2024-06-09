import 'package:flutter/material.dart';
import 'api_service/gestion_admin_service.dart';
import 'login.dart';
import 'drawer.dart';

class GestionAdminPage extends StatefulWidget {
  @override
  _GestionAdminPageState createState() => _GestionAdminPageState();
}

class _GestionAdminPageState extends State<GestionAdminPage> {
  final GestionAdminService apiService = GestionAdminService();
  final _formKey = GlobalKey<FormState>();
  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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

  void create() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _notificationMessage = null;
      });
      try {
        final response = await apiService.postCreate(
            _emailController.text,
            _prenomController.text,
            _nomController.text,
            _passwordController.text);

        setState(() {
          _isLoading = false;
        });

        if (response["statusCode"] == 200) {
          setState(() {
            _notificationMessage = 'Compte créé avec succès !';
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
          _notificationMessage = 'Compte supprimé avec succès !';
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
        DataCell(
          ElevatedButton(
            onPressed: () {
              delete(row[0]);
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
                      'Gestion des Cartes',
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
                      'Gestion des Admins',
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Form(
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
                                        const Text('Créer un Administrateur',
                                            style: TextStyle(
                                                color: Color(0xFF2f3293),
                                                fontSize: 20)),
                                        TextFormField(
                                          controller: _emailController,
                                          decoration: const InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: TextStyle(
                                                color: Color(0xFF2f3293)),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF2f3293)),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                          controller: _prenomController,
                                          decoration: const InputDecoration(
                                            labelText: "Prénom",
                                            labelStyle: TextStyle(
                                                color: Color(0xFF2f3293)),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF2f3293)),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "S'il vous plaît, entrez une valeur";
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _nomController,
                                          decoration: const InputDecoration(
                                            labelText: 'Nom',
                                            labelStyle: TextStyle(
                                                color: Color(0xFF2f3293)),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF2f3293)),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "S'il vous plaît, entrez une valeur";
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _passwordController,
                                          decoration: const InputDecoration(
                                            labelText: 'Mot de Passe',
                                            labelStyle: TextStyle(
                                                color: Color(0xFF2f3293)),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF2f3293)),
                                            ),
                                          ),
                                          obscureText: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "S'il vous plaît, entrez un mot de passe";
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller:
                                              _confirmPasswordController,
                                          decoration: const InputDecoration(
                                            labelText:
                                                'Confirmer le Mot de Passe',
                                            labelStyle: TextStyle(
                                                color: Color(0xFF2f3293)),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF2f3293)),
                                            ),
                                          ),
                                          obscureText: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "S'il vous plaît, entrez un mot de passe";
                                            }
                                            if (value !=
                                                _passwordController.text) {
                                              return "Les mots de passe ne correspondent pas";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: create,
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                Color(0xFF2f3293), // Text color
                                          ),
                                          child: const Text(
                                              "Créer l'Administateur"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_notificationMessage != null) ...[
                                    const SizedBox(height: 20),
                                    Text(
                                      _notificationMessage!,
                                      style:
                                          TextStyle(color: _notificationColor),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: _createColumns(),
                                rows: _createRows(),
                              ),
                            ),
                          ],
                        ),
                      )));
        }
      },
    );
  }
}
