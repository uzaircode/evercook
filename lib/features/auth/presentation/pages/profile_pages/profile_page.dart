import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ProfilePage());
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedTheme = 'Light'; // Default theme

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              alwaysShowMiddle: false,
              largeTitle: Text(
                'Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              middle: Text(
                'Profile',
                style: TextStyle(
                  fontFamily: GoogleFonts.notoSerif().fontFamily,
                  color: Color.fromARGB(255, 64, 64, 64),
                  fontWeight: FontWeight.w700,
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 223, 223, 235),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Color.fromARGB(255, 113, 113, 137),
                    size: 22,
                  ),
                ),
              ),
              trailing: GestureDetector(
                onTap: () {
                  // Handle trailing button tap
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 223, 223, 235),
                  ),
                  child: Icon(
                    Icons.more_vert_outlined,
                    color: Color.fromARGB(255, 113, 113, 137),
                    size: 22,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Info Container
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 239, 245),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(22, 16, 22, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Personal Info', style: Theme.of(context).textTheme.titleMedium),
                                  Text(
                                    'Update your photo and personal details here',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            ClipOval(
                              child: Image.network(
                                'https://lh3.googleusercontent.com/a/ACg8ocK6xCHK3meZn4GXuEROw3GwSrcaPQ3EI-8qmq0Bqg3ROirau1pk=s96-c',
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Full Name',
                          style: TextStyle(
                            color: Color.fromARGB(255, 38, 37, 59), // Change label text color
                          ),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 228, 228, 238),
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 215, 214, 228),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 215, 214, 228),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 215, 214, 228),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Password',
                          style: TextStyle(
                            color: Color.fromARGB(255, 38, 37, 59),
                          ),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 228, 228, 238),
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 215, 214, 228),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 215, 214, 228),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 215, 214, 228),
                              ),
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Primary Email',
                          style: TextStyle(
                            color: Color.fromARGB(255, 38, 37, 59),
                          ),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 228, 228, 238),
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 215, 214, 228),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 215, 214, 228),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 215, 214, 228),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                // Features Container
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 239, 245),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(22, 16, 22, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
                          SizedBox(height: 3),
                          Text(
                            'Customize your app interface',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Theme',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 39, 37, 59),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 228, 228, 238),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 215, 214, 228),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedTheme,
                                    items: <String>['Light', 'Dark'].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        // Apply style to the text inside the dropdown
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ), // Smaller text size
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedTheme = newValue!;
                                      });
                                    },
                                    dropdownColor:
                                        Color.fromARGB(255, 228, 228, 238), // Matched the container's background color
                                    // Additional styling for when the dropdown is clicked
                                    underline: Container(
                                      height: 0, // Removes the underline
                                    ),
                                    style: TextStyle(color: Colors.black), // Default text color for all items
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                // App Info Container
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 239, 245),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(22, 16, 22, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Evercook',
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 38, 37, 59),
                          ),
                        ),
                        Text('Version 1.0.0'),
                        SizedBox(height: 20),
                        ListView(
                          padding: EdgeInsetsDirectional.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              contentPadding: EdgeInsetsDirectional.zero,
                              leading: Icon(Icons.info_outline),
                              title: Text(
                                'About',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                // Navigate to about page or show dialog
                              },
                            ),
                            Divider(color: Color.fromARGB(255, 215, 214, 228)),
                            ListTile(
                              contentPadding: EdgeInsetsDirectional.zero,
                              leading: Icon(Icons.lock_outline),
                              title: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                // Navigate to privacy policy page
                              },
                            ),
                            Divider(color: Color.fromARGB(255, 215, 214, 228)),
                            ListTile(
                              contentPadding: EdgeInsetsDirectional.zero,
                              leading: Icon(Icons.feedback_outlined),
                              title: Text(
                                'Send Feedback',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () async {
                                await launchUrl(
                                  Uri.parse('mailto:nikuzairsc@gmail.com?subject=Feedback'),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





//todo separate to business logic
//   child: ElevatedButton(
//     onPressed: () async {
//       LoggerService.logger.i('Button Clicked');
//       await Supabase.instance.client.rpc('delete_user_account', params: {'user_id': userId});
//       if (mounted) {
//         context.read<AuthBloc>().add(AuthSignOut());
//       }
//                          context.read<AuthBloc>().add(AuthSignOut());
// leading: GestureDetector(
//   onTap: () {
//     ThemeService().switchTheme();
//   },
//   child: Icon(Icons.cloud),
// ),