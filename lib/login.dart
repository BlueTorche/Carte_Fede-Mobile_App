import 'package:carte_fede/api_service/api_service.dart';
import 'package:carte_fede/qrcode.dart';
import 'package:flutter/material.dart';
import 'api_service/login_service.dart';
import 'admin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginService apiService = LoginService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        final response = await apiService.post(
          _usernameController.text,
          _passwordController.text,
        );

        setState(() {
          _isLoading = false;
        });

        if (response["statusCode"] == 200) {
          if (ApiService.role==1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminPage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRCodePage()),
            );
          }
        } else if (response["statusCode"] == 401) {
          setState(() {
            _errorMessage = "Connexion échouée, vérifiez vos identifiants.";
          });
        } else {
          setState(() {
            _errorMessage = response['body'].toString();
          });
        }
      } catch(e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'Connexion',
              style: TextStyle(color: Color(0xFF2f3293)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
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
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Adresse Mail",
                        labelStyle: TextStyle(color: Color(0xFF2f3293)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2f3293)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "S'il vous plaît, entrez une adresse mail";
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
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Mot de Passe',
                        labelStyle: TextStyle(color: Color(0xFF2f3293)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2f3293)),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "S'il vous plaît, entrez un mot de passe";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF2f3293), // Text color
                      ),
                      child: const Text('Connexion'),
                    ),
                  ],
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
