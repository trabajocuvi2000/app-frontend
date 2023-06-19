import 'package:flutter/cupertino.dart';

class ShowModalBottomSheet extends StatefulWidget {
  const ShowModalBottomSheet({super.key});

  @override
  State<ShowModalBottomSheet> createState() => _ShowModalBottomSheetState();
}

class _ShowModalBottomSheetState extends State<ShowModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


  // showModalBottomSheet(
  //                           context: context,
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.only(
  //                             topRight: Radius.circular(10),
  //                             topLeft: Radius.circular(10),
  //                           )),
  //                           builder: ((context) {
  //                             return Container(
  //                               padding: EdgeInsets.all(20),
  //                               // color: Colors.redAccent,
  //                               // decoration: BoxDecoration(
  //                               //   borderRadius: BorderRadius.only(
  //                               //     topLeft: Radius.circular(10),
  //                               //     topRight: Radius.circular(10),
  //                               //   ),
  //                               // ),
  //                               height: MediaQuery.of(context).size.height / 3,
  //                               child: Column(
  //                                 children: [
  //                                   Container(
  //                                     child: Text(
  //                                         "Esta seguro de que desa hacer esto"),
  //                                   ),
  //                                   Container(
  //                                     decoration: TemasAyuda()
  //                                         .buttonBoxDecoration(context),
  //                                     child: ElevatedButton(
  //                                       style: TemasAyuda().buttonStyle(),
  //                                       onPressed: () {},
  //                                       child: Padding(
  //                                         padding: EdgeInsets.fromLTRB(
  //                                             40, 10, 40, 10),
  //                                         child: Text(
  //                                           "Aceptar",
  //                                           style: TextStyle(
  //                                             fontSize: 20,
  //                                             color: Colors.white,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             );
  //                           }),
  //                         );