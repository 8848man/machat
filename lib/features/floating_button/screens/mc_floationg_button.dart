// import 'package:flutter/material.dart';

// class McFloationgButton extends StatefulWidget {
//   const McFloationgButton({super.key});

//   @override
//   State<McFloationgButton> createState() => _McFloationgButtonState();
// }

// class _McFloationgButtonState extends State<McFloationgButton> {
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton.extended(
//       onPressed: () {
//         if (extended) {
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context) {
//               return const FloatingActionButtonSecondScreen();
//             },
//           ));
//         }
//         setState(() {
//           extended = !extended;
//         });
//       },
//       label: const Text("Click"),
//       isExtended: extended,
//       heroTag: "actionButton",
//       icon: const Icon(
//         Icons.add,
//         size: 30,
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

//       /// 텍스트 컬러
//       foregroundColor: Colors.white,
//       backgroundColor: Colors.red,
//       splashColor: Colors.blue,
//       hoverColor: Colors.green,
//       extendedPadding: const EdgeInsets.all(10),
//       elevation: 10,
//       highlightElevation: 20,
//       extendedIconLabelSpacing: 10,
//     );
//   }
// }
