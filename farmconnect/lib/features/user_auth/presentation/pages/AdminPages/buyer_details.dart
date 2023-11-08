import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class BuyerDetailsPage extends StatefulWidget {
  @override
  _BuyerDetailsPageState createState() => _BuyerDetailsPageState();
}

class _BuyerDetailsPageState extends State<BuyerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Buyer Details", style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'Buyer').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final buyers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: buyers.length,
            itemBuilder: (context, index) {
              final buyer = buyers[index].data() as Map<String, dynamic>;
              final userId = buyers[index].id;

              final profilePictureUrl = buyer['profileImageUrl'] ?? '';
              var isActive = buyer['isActive'] ?? 'no';

              final tileColors = [
                Colors.purple,
                Colors.lightBlue,
                Colors.lightGreen,
                Colors.amber,
                Colors.pink,
              ];

              final tileColor = tileColors[index % tileColors.length];

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilePictureUrl),
                      radius: 30,
                    ),
                    title: Text(
                      buyer['name'] ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    childrenPadding: EdgeInsets.all(16),
                    children: [
                      SingleChildScrollView(
                        child: _buildDetailItem(
                          icon: Icons.person,
                          label: "Gender",
                          value: buyer['gender'] ?? 'N/A',
                        ),
                      ),
                      SingleChildScrollView(
                        child: _buildDetailItem(
                          icon: Icons.email,
                          label: "Email",
                          value: buyer['email'] ?? 'N/A',
                        ),
                      ),
                      SingleChildScrollView(
                        child: _buildDetailItem(
                          icon: Icons.phone,
                          label: "Phone",
                          value: buyer['phone'] ?? 'N/A',
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildDetailItem(
                          icon: Icons.location_on,
                          label: "Address",
                          value: "${buyer['street'] ?? 'N/A'}, ${buyer['town'] ?? 'N/A'}, ${buyer['district'] ?? 'N/A'}, ${buyer['state'] ?? 'N/A'}, ${buyer['pincode'] ?? 'N/A'}",
                        ),
                      ),
                    ],
                    trailing: Container(
                      width: 70,
                      height: 42,
                      child: Switch(
                        value: isActive == 'yes',
                        onChanged: (value) async {
                          // Update the 'isActive' field in Firestore as a string
                          await FirebaseFirestore.instance.collection('users').doc(userId).update({
                            'isActive': value ? 'yes' : 'no',
                          });
                          setState(() {
                            isActive = value ? 'yes' : 'no';
                          });

                          // Show a Snackbar
                          final snackBarMessage = isActive == 'yes' ? 'User Enabled' : 'User Disabled';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(snackBarMessage),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          // Send a notification email
                          sendNotificationEmail(buyer['email'], isActive == 'yes');
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 28,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void sendNotificationEmail(String recipient, bool isActive) async {
    final smtpServer = gmail('namalthomson2024b@mca.ajce.in', 'Amal664422');
    final message = Message()
      ..from = Address('admin@farmconnect.com', 'FarmConnect Admin')
      ..recipients.add(recipient)
      ..subject = 'Account Status Update'
      ..text = isActive ? 'Your account has been enabled. You can now login to you Account' : 'Your account has been disabled. Please contact Admin for further assistance';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport}');
    } on MailerException catch (e) {
      print('Message not sent. ${e.message}');
    }
  }
}
