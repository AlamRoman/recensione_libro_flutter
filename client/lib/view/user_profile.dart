import 'package:flutter/material.dart';
import 'package:ink_review/control/user_controller.dart';
import 'package:ink_review/model/users.dart';
import 'package:ink_review/view/books_screen.dart';
import 'package:ink_review/view/home_content.dart';
import 'package:ink_review/view/reviews_screen.dart';
import 'package:ink_review/view/settings_content.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserProfileScreen> {
  int _currentIndex = 3;
  bool _inUserPage = true;
  final List<Widget> _screens = [
    const HomeContent(),
    const BooksContent(),
    const ReviewsContent(),
    const SettingContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Image.asset(
                  '../resources/logo.png',
                  height: 40,
                ),
                const SizedBox(width: 15),
                const Text(
                  'Ink Review',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.purpleAccent],
          ),
        ),
        child: (_inUserPage)
            ? const UserProfileContent()
            : _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() {
            _currentIndex = index;
            _inUserPage = false;
          }),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Books',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rate_review),
              label: 'My Reviews',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileContent extends StatefulWidget {
  const UserProfileContent({super.key});

  @override
  State<UserProfileContent> createState() => _UserProfileContentState();
}

class _UserProfileContentState extends State<UserProfileContent> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late UserController _controller;
  Users? _user;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = UserController();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _controller.fetchUser('http://localhost/web_service/ink_review/get_user_details');
      
      setState(() {
        _user = user;
        _firstNameController.text = user.nome ?? '';
        _lastNameController.text = user.cognome ?? '';
        _loading = false;
      });
    } catch (err) {
      setState(() => _loading = false);
      await _showErrorDialog('Fetch Error', err.toString());
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      _user!..nome = _firstNameController.text
            ..cognome = _lastNameController.text;
      await _controller.updateUser(_user!, "http://localhost/web_service/ink_review/update_user_details");
      await _showErrorDialog('Success', 'Profile updated successfully');
    } catch (err) {
      await _showErrorDialog('Save Error', err.toString());
    } finally {
      setState(() => _saving = false);
    }
  }

  Future<void> _showErrorDialog(String title, String message) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

   @override
    Widget build(BuildContext context) {
      if (_loading) return const Center(child: CircularProgressIndicator());
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'User Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildProfileField(
                        context,
                        label: 'Username',
                        initialValue: _user!.username,
                        icon: Icons.person_outlined,
                        enabled: false,
                      ),
                      const SizedBox(height: 25),
                      _buildEditableField(
                        context,
                        controller: _firstNameController,
                        label: 'First Name',
                        icon: Icons.badge_outlined,
                        validator: (v) => v?.isEmpty ?? true ? 'Please enter your first name' : null,
                      ),
                      const SizedBox(height: 25),
                      _buildEditableField(
                        context,
                        controller: _lastNameController,
                        label: 'Last Name',
                        icon: Icons.assignment_ind_outlined,
                        validator: (v) => v?.isEmpty ?? true ? 'Please enter your last name' : null,
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _saving ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: _saving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'SAVE CHANGES',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                      color: Colors.white
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Widget _buildProfileField(BuildContext context, {required String label, required String initialValue, required IconData icon, bool enabled = true}) {
      return TextFormField(
        initialValue: initialValue,
        enabled: enabled,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          suffixIcon: !enabled
              ? const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.lock_outline, color: Colors.white54, size: 20),
                )
              : null,
        ),
      );
    }

    Widget _buildEditableField(BuildContext context, {required TextEditingController controller, required String label, required IconData icon, required FormFieldValidator<String> validator}) {
      return TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white54, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          errorStyle: const TextStyle(color: Colors.amber),
        ),
        validator: validator,
      );
    }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
