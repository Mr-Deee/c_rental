import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
class adminn_selection extends StatelessWidget {
  final String image;
  final String title;

  const adminn_selection(
      {Key? key, required this.image, required this.title,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay:const Duration(milliseconds: 1500),
      child: Column(
        children: [
          Container(
            // duration: const Duration(milliseconds: 400),
            // scaleFactor: 1.5,
            // onPressed: ontap,
            child: Container(
              height: 120,
              width: 119,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(1.0, 1.0), // shadow direction: bottom right
                    )
                  ],
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.scaleDown, scale: 2)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}