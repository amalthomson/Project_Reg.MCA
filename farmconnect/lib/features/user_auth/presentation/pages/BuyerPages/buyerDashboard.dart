import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/buyerProfile.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/Cart/cartPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'productsDairy.dart';
import 'productsFruit.dart';
import 'productsPoultry.dart';
import 'productsVegetable.dart';


class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({Key? key});

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      Navigator.popAndPushNamed(context, "/login");
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
          },
          child: Icon(Icons.shopping_cart),
        ),
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Buyer Dashboard",
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.lightBlue[900],
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => _signOut(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.0), // Adjust the spacing between icon and text
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: TabBar(
            isScrollable: true, // Enable scrolling for the TabBar
            tabs: [
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Dairy',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Poultry',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Fruits',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Vegetables',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Profile',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DairyProductsPage(),
            PoultryProductsPage(),
            FruitsProductsPage(),
            VegetableProductsPage(),
            BuyerProfilePage(),
          ],
        ),
      ),
    );
  }
}