// import 'package:evercook/core/cubit/app_user.dart';
// import 'package:evercook/core/utils/logger.dart';
// import 'package:evercook/core/utils/show_snackbar.dart';
// import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class EditProfilePage extends StatefulWidget {
//   static Route route({required String name, required String bio}) {
//     return MaterialPageRoute(
//       builder: (context) => EditProfilePage(
//         name: name,
//         bio: bio,
//       ),
//     );
//   }

//   final String name;
//   final String bio;

//   const EditProfilePage({Key? key, required this.name, required this.bio}) : super(key: key);

//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _bioController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _usernameController.text = widget.name;
//     _bioController.text = widget.bio;
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _bioController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final name = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
//     final bio = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.bio;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Edit Profile',
//           style: TextStyle(
//             fontSize: 16,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               context.read<AuthBloc>().add(
//                     AuthUpdateUser(
//                       name: _usernameController.text.trim(),
//                       bio: _bioController.text.trim(),
//                     ),
//                   );
//             },
//             child: Text(
//               'Save',
//               style: TextStyle(
//                 color: Color.fromARGB(255, 221, 56, 32),
//                 fontSize: 18,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthFailure) {
//             showSnackBar(context, state.message);
//           } else if (state is AuthUpdateUserSuccess) {
//             LoggerService.logger.i('triggered!');
//             showSnackBar(context, 'User Updated');
//             Navigator.pop(context);
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             children: [
//               Form(
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () {},
//                       child: const CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.red,
//                         child: Center(
//                           child: Text(
//                             '',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     TextFormField(
//                       controller: _usernameController,
//                       decoration: InputDecoration(
//                         filled: true,
//                         hintText: 'Name',
//                         fillColor: Theme.of(context).inputDecorationTheme.fillColor,
//                         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       validator: (value) {
//                         return value;
//                       },
//                       onTapOutside: (event) {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                       },
//                     ),
//                     SizedBox(height: 16),
//                     TextFormField(
//                       controller: _bioController,
//                       decoration: InputDecoration(
//                         filled: true,
//                         hintText: 'Bio',
//                         fillColor: Theme.of(context).inputDecorationTheme.fillColor,
//                         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       validator: (value) {
//                         return value;
//                       },
//                       onTapOutside: (event) {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // SizedBox(
//               //   width: double.infinity,
//               //   height: 60,
//               //   child: ElevatedButton(
//               //     onPressed: () {
//               //       context.read<AuthBloc>().add(
//               //             AuthUpdateUser(
//               //               name: _usernameController.text.trim(),
//               //               bio: _bioController.text.trim(),
//               //             ),
//               //           );
//               //     },
//               //     style: ElevatedButton.styleFrom(
//               //       elevation: 0,
//               //       backgroundColor: Color.fromARGB(255, 221, 56, 32),
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(10),
//               //       ),
//               //     ),
//               //     child: const Text(
//               //       'Save',
//               //       style: TextStyle(
//               //         fontWeight: FontWeight.bold,
//               //         fontSize: 16,
//               //         color: Colors.white,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
