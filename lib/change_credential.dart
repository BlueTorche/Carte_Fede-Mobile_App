import 'package:carte_fede/api_service/api_service.dart';
import 'package:carte_fede/api_service/change_credentials_service.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'drawer.dart';

class ChangeCredentialPage extends StatefulWidget {
  @override
  _ChangeCredentialPageState createState() => _ChangeCredentialPageState();

}

class _ChangeCredentialPageState extends State<ChangeCredentialPage> {
  final ChangeCredentialService apiService = ChangeCredentialService();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  String? _notificationMessage;
  Color _notificationColor = Colors.red;
  bool _isLoading = false;

  void change()  async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _notificationMessage = null;
      });
      try {
        final response = await apiService.postChange(
            _passwordController.text,
            _oldPasswordController.text);

        setState(() {
          _isLoading = false;
        });

        if (response["statusCode"] == 200) {
          setState(() {
            _notificationMessage = 'Mot de Passe changé avec succès !';
            _notificationColor = Colors.white;
          });
        } else if (response["statusCode"] == 401 ||
            response["statusCode"] == 400 ||
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
              'Modifier le Mot de Passe',
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
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Nouveau Mot de Passe",
                        labelStyle: TextStyle(color: Color(0xFF2f3293)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2f3293)),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "S'il vous plaît, entrez une valeur";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirmer le Mot de Passe',
                        labelStyle: TextStyle(color: Color(0xFF2f3293)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2f3293)),
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
                    TextFormField(
                      controller: _oldPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Ancien Mot de Passe',
                        labelStyle: TextStyle(color: Color(0xFF2f3293)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2f3293)),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "S'il vous plaît, entrez une valeur";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: change,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF2f3293), // Text color
                      ),
                      child: const Text('Changer le Mot de Passe'),
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