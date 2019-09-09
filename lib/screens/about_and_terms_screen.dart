import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String type;

  Details(this.type);

  @override
  _Details createState() => _Details();
}

class _Details extends State<Details> {
  bool ppAccepted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 45),
          child: Image.asset(
            "images/logo.png",
            color: Colors.blue,
            width: 120.0,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            widget.type == "About"
                                ? "About us"
                                : "Terms and Conditions",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Image.asset(
                          'images/about.jpg',
                          width: 140.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.type == "About"
                                    ? "Wisapedia is a platform that brings you together with other travelers in a tourist destination that will accompany you during your trip. We offer flexibility in organizing and planning your trip according to your requests and needs. Not just accompanying, the 'Buddies' will also share stories and inspiring local knowledge that will make your adventure more memorable."
                                    : "By using the Wisapedia Platform, you agree to this policy. By 'Platform' we mean a set of APIs, SDKs, plugins, code, specifications, documentation, technology, and services (such as content) that enable others, including application developers and website operators, to retrieve data from Instagram or provide data to us. We reserve the right to change this policy at any time without notice, so please check it regularly. Your continued use of the Instagram Platform constitutes acceptance of any changes. You also agree to and are responsible for ensuring that you comply with the Wisapedia Terms of Use and Instagram Community Guidelines.\nWe provide the Wisapedia Platform to support several types of apps and services. First, we provide them to help members of our community share their own content with apps or services.  Finally, we provide the Wisapedia Platform to help travelers and publishers discover content, get digital rights to media, and share media using apps embeds. The Wisapedia Platform is not intended for other types of apps or services. For those we do support, the following terms and information also apply: \n 1. Wisapedia is not responsible for the accuracy of information, pictures and description, including but not limited to details of the trip route, description, departure date, return date, telephone number provided by the proposer. You are advised to contact the proposer directly to verify the information sought.\n2. The user understands and agrees that the use and implementation of activities in connection with the Service by the user is at the user's own discretion and risk and the user himself is fully responsible for the user's material\n 3. The user specifically acknowledges that Wisapedia will not be responsible for defamatory material or acts, acts that violate, or actions that are against the law",
                                style: TextStyle(color: Colors.lightBlue),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
