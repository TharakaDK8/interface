import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homePage.dart';
import 'button.dart';
import 'register.dart';

// Route _createRoute(page) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => page,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       final tween = Tween(begin: begin, end: end);
//       final offsetAnimation = animation.drive(tween);
//
//       return SlideTransition(
//         position: offsetAnimation,
//         child: child,
//       );
//     },
//   );
// }

class LoginPage extends StatefulWidget {
  // const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

Widget buildEmail() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('Username',
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoSlab')),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black26)),
        height: 60,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              hintText: 'Username',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ],
  );
}

Widget buildPassword() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('Password',
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoSlab')),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black26)),
        height: 60,
        child: TextField(
          obscureText: true,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: 'Minimum 8 characters',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ],
  );
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
          child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color(0xffffff),
            ),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 80,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'SMART EYE',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoSlab'),
                  ),
                  Text(
                    'Your Safety Net',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 200,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.asset("assets/2.png"),
                    ),
                  ),
                  SizedBox(height: 40),
                  buildEmail(),
                  SizedBox(height: 20),
                  buildPassword(),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: SizedBox(
                      width: 230,
                      height: 50,
                      child: ElevatedButton(
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 17),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ButtonPage()),
                          );
                          // Navigator.of(context)
                          //     .push(_createRoute(
                          //       ButtonPage()
                          //       // RegisterPage()
                          //       ));
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 230,
                      height: 50,
                      child: OutlinedButton(
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                          // Navigator.of(context)
                          //     .push(_createRoute(RegisterPage()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    ));
  }
}
