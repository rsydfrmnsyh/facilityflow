import 'package:facilityflow/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/views/login_register_view.dart';
import 'inspectionlist_view.dart';

class DashboardView extends StatefulWidget {
  final User user;
  DashboardView({required this.user});
  
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      HomeView(user: widget.user),
      InspectionList(),
    ];

    List<String> _titles = [
      'Home',
      'Inspections',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blueGrey[50],
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  widget.user.email ?? 'user',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                accountEmail: Text(
                  widget.user.email ?? '',
                  style: TextStyle(
                    fontSize: 14, // Increased font size
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: widget.user.photoURL != null
                      ? NetworkImage(widget.user.photoURL!)
                      : null,
                  child: widget.user.photoURL == null ? Icon(Icons.person) : null,
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(13, 102, 129, 1), // Header background color
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 18, // Increased font size
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Inspections',
                  style: TextStyle(
                    fontSize: 18, // Increased font size
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                leading: Icon(Icons.report),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
