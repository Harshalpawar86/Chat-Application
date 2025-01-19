
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageListContainer extends StatelessWidget {
  final String message;
  final String time;
  final bool alignContainer;
  const MessageListContainer(
      {super.key,
      required this.message,
      required this.time,
      required this.alignContainer});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: (alignContainer)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            (alignContainer)
                ? SizedBox(
                    width: width / 2.5,
                  )
                : const SizedBox(),
            Expanded(
              child: Column(
                crossAxisAlignment: (alignContainer)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(191, 113, 247, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: (alignContainer)
                            ? const Radius.circular(20)
                            : const Radius.circular(0),
                        topRight: const Radius.circular(20),
                        bottomLeft: const Radius.circular(20),
                        bottomRight: (alignContainer)
                            ? const Radius.circular(0)
                            : const Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      message,
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      softWrap: true,
                      maxLines: null, //unlimited lines
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Text(
                    time,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            (alignContainer)
                ? const SizedBox()
                : SizedBox(
                    width: width / 2.5,
                  ),
          ],
        ),
      ),
    );
  }
}
