import 'package:flutter/material.dart';

Widget emptyPage({@required context,@required String image,@required String text}) => Center(
  child: SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26, width: 5),

            shape: BoxShape.circle,

            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(image),
            ),
          ),
        ),
        SizedBox(height: 50,),

        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,

            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    ),
  ),
);



