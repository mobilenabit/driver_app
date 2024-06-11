import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LicensePlateScreen extends StatefulWidget {
  LicensePlateScreen({super.key});

  @override
  State<LicensePlateScreen> createState() => _LicensePlateScreenState();

  int? chosenIndex;
  int? chosenSegment;
  final licensePlateData = [
    {
      'plateNumber': '30A-143.45',
    },
    {
      'plateNumber': '30A-152.89',
    },
    {
      'plateNumber': '30A-325.65',
    },
    {
      'plateNumber': '30A-153.75',
    },
  ];
}

class _LicensePlateScreenState extends State<LicensePlateScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Chọn biển số xe',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //TODO: add working search
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Tìm kiếm",
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                fillColor: Color(0xFFF3F3F7),
                border: InputBorder.none,
                filled: true,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: size.height * 0.025,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.licensePlateData.length,
              itemBuilder: (context, index) {
                final licensePlate =
                    widget.licensePlateData[index]['plateNumber'];
                return ListTile(
                  title: Text(licensePlate!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
