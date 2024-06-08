// import "package:flutter/foundation.dart";
// import "package:flutter/material.dart";
// import "package:driver_app/components/pump_card.dart";

// import "../components/shimmer.dart";
// import "../components/user_info_card.dart";
// import "../core/api_client.dart";

// class InfoScreen extends StatefulWidget {
//   final Map<String, dynamic>? userData;
//   const InfoScreen({super.key, required this.userData});

//   @override
//   State<InfoScreen> createState() => _InfoScreenState();
// }

// class _InfoScreenState extends State<InfoScreen> {
//   Future<Map<String, dynamic>>? _pumpData;

//   @override
//   void initState() {
//     super.initState();

//     _pumpData = ApiClient().getPumps();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;

//     return SafeArea(
//       child: Container(
//         decoration: BoxDecoration(
//           image: const DecorationImage(
//             image: AssetImage("assets/images/pvcb_info_logo.png"),
//           ),
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               const Color(0xFFFFC923),
//               const Color(0xFFFFF2CC),
//               const Color(0xFFFFFFFF),
//               const Color(0xFFFFFFFF),
//             ],
//           ),
//         ),
//         child: Align(
//           alignment: Alignment.center,
//           child: Container(
//             constraints: const BoxConstraints.expand(),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsetsDirectional.only(top: 10),
//                     child: UserInfoCard(
//                       userName: widget.userData?["data"]["displayName"] ?? "",
//                       userId: widget.userData?["data"]["id"],
//                       avatar: widget.userData?["data"]["avatar"] ?? "",
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.02),
//                   Container(
//                     padding: const EdgeInsetsDirectional.only(bottom: 10),
//                     width: size.width * 0.9,
//                     child: FutureBuilder(
//                       future: _pumpData,
//                       builder: (BuildContext context,
//                           AsyncSnapshot<Map<String, dynamic>> snapshot) {
//                         if (snapshot.connectionState != ConnectionState.done ||
//                             snapshot.data?["data"].length == null) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }

//                         return ListView.separated(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: snapshot.data?["data"].length,
//                           itemBuilder: (BuildContext context, int index) {
//                             final pump = snapshot.data?["data"][index];
//                             if (kDebugMode) {
//                               print(pump.toString());
//                             }
//                             var fullName = pump["pumpName"].split(" - ");
//                             var pumpName = "${fullName[0]} - ${fullName[1]}";
//                             var productName = fullName[2];
//                             var pumpLogs = ApiClient().getPumpLogs(
//                                 widget.userData?["data"]["branchId"],
//                                 pump["id"].toString());

//                             return FutureBuilder(
//                               future: pumpLogs,
//                               builder: (BuildContext context,
//                                   AsyncSnapshot<Map<String, dynamic>>
//                                       snapshot) {
//                                 if (kDebugMode) {
//                                   print(snapshot.data);
//                                 }
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.done) {
//                                   return PumpCard(
//                                     userData: widget.userData,
//                                     pumpId: pump["id"],
//                                     pumpName: pumpName,
//                                     productName: productName,
//                                     pumpLogs: snapshot.data,
//                                   );
//                                 }

//                                 // TODO: make this better
//                                 return Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 10,
//                                     vertical: 10,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.05),
//                                         blurRadius: 8,
//                                         offset: const Offset(0, 4),
//                                       )
//                                     ],
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           ShimmerLoading(
//                                             isLoading: true,
//                                             child: Container(
//                                               width: 44,
//                                               height: 44,
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(width: size.width * 0.025),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               ShimmerLoading(
//                                                 isLoading: true,
//                                                 child: Container(
//                                                   width: size.width * 0.4,
//                                                   height: 16,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.black,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             12),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                   height: size.height * 0.005),
//                                               ShimmerLoading(
//                                                 isLoading: true,
//                                                 child: Container(
//                                                   width: size.width * 0.2,
//                                                   height: 16,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.black,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             12),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                           separatorBuilder: (BuildContext context, int index) =>
//                               const SizedBox(height: 10),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home'),
    );
  }
}
