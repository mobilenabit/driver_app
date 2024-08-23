import "package:flutter/material.dart";
import "package:intl/intl.dart";

class UserInfoCard extends StatelessWidget {
  final String userName;
  //final String selectedLicensePlate;
  final int? userId;
  final String avatar;

  const UserInfoCard({
    super.key,
    required this.userName,
    //required this.selectedLicensePlate,
    required this.userId,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    avatar != ""
                        ? Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(avatar),
                              ),
                            ),
                          )
                        : const Icon(Icons.account_circle, size: 40),
                    SizedBox(width: size.width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userName != ""
                            ? Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const CircularProgressIndicator(),
                        if (userId != null)
                          Text(
                            userId.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF82869E),
                            ),
                          ),
                        // if (selectedLicensePlate != null)
                        //   Text(
                        //     selectedLicensePlate,
                        //     style: const TextStyle(
                        //       fontSize: 13,
                        //       fontWeight: FontWeight.w400,
                        //       color: Color(0xFF82869E),
                        //     ),
                        //   ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFbcd1e1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF4e86af),
                      ),
                    ),
                    child: Center(
                      // TODO: make this actually update
                      child: Text(
                        DateFormat("EEEE, dd/MM/yyyy", "vi_VN")
                            .format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
