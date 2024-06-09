import 'package:carte_fede/api_service/api_service.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'admin.dart';
import 'gestion_admin.dart';
import 'view_card.dart';
import 'qrcode.dart';
import 'change_credential.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF2f3293),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Color(0xFF2f3293),
            ),
            title: const Text('Deconnexion',
                style: TextStyle(color: Color(0xFF2f3293))),
            onTap: () {
              ApiService.logout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          if(ApiService.role == 1) ... [ListTile(
            leading: const Icon(
              Icons.credit_card,
              color: Color(0xFF2f3293),
            ),
            title: const Text('Créer une Carte',
                style: TextStyle(color: Color(0xFF2f3293))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPage()),
              );
            },
          ),
            ListTile(
            leading: const Icon(
              Icons.view_list,
              color: Color(0xFF2f3293),
            ),
            title: const Text('Voir les Cartes',
                style: TextStyle(color: Color(0xFF2f3293))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewCardPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.supervisor_account,
              color: Color(0xFF2f3293),
            ),
            title: const Text('Gérer les Admins',
                style: TextStyle(color: Color(0xFF2f3293))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GestionAdminPage()),
              );
            },
          )]
          else ...[
            ListTile(
              leading: const Icon(
                Icons.supervisor_account,
                color: Color(0xFF2f3293),
              ),
              title: const Text('Ma Carte Fédé',
                  style: TextStyle(color: Color(0xFF2f3293))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRCodePage()),
                );
              },
            )
          ],
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              color: Color(0xFF2f3293),
            ),
            title: const Text('Modifier le Mot de Passe',
                style: TextStyle(color: Color(0xFF2f3293))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeCredentialPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF2f3293),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Color(0xFF2f3293),
            ),
            title: const Text('Deconnexion',
                style: TextStyle(color: Color(0xFF2f3293))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.qr_code,
              color: Color(0xFF2f3293),
            ),
            title: const Text('Ma Carte',
                style: TextStyle(color: Color(0xFF2f3293))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Color(0xFF2f3293),
            ),
            title: const Text('Modifier le Profil',
                style: TextStyle(color: Color(0xFF2f3293))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}