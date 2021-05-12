import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ombredev/common_widgets.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = new TextEditingController();
  var events;
  bool _isSearching;
  String _searchText = "";
  List searchResult = new List();

  @override
  void initState() {
    super.initState();
    registerListeners();
    _isSearching = false;
  }

  void registerListeners() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  String sampleImgURL =
      "https://storage.googleapis.com/ombre-prod-6d284.appspot.com/crawler/mixcloud/mix-goinglive-20210512.png?GoogleAccessId=ombre-data-extraction%40ombre-prod-6d284.iam.gserviceaccount.com&Expires=1765497600&Signature=x2uIZqm5kmLpD5X7USpzak3mD6UE%2Fya%2F%2F%2BmTLDBCOkTVTpBAYfYRdh4we%2FRNN2RyTr%2FKDowUsZkgxXwsnRcHkDECE8HFU5qmRgI7a068O5LYWAAx8U8MVApcVcL94pW7CVmuvSP7SSW9N6MrMq%2FsA22wEnOCvJ7nH8NARGf962slvdcipJx7cZ%2BmMUR2aQgLY7cHIEDwvIqafuzrFOaVvFP2VKWWZ1p6OsQJGhkLkcpD6uZeEu0uAyOrimSp8NvFOXCn26eUeFwnjCGfrtULNU2%2BSu3RkN9ZihMqx8a9gKWZB2mtPzQQLIq%2F2N8MHlt9fvmWgkq9QoP9sb3QiWrzRg%3D%3D";

  Widget getTF() {
    return Container(
      child: TextField(
        style: TextStyle(
          color: Colors.white,
        ),
        controller: _controller,
        onChanged: (String sText) {
          setState(() {
            searchOperation(sText);
          });
        },
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          contentPadding: EdgeInsets.all(10),
          border: new OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          filled: true,
          hintStyle: new TextStyle(
            color: Colors.white,
          ),
          hintText: "Search...",
          fillColor: Colors.grey,
        ),
      ),
    );
  }

  Widget getCW(
    String t1,
    String t2,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t1,
          style: TextStyle(
            color: Colors.pink,
          ),
        ),
        Text(
          t2,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget getLI(
    final String eName,
    final String eGenre,
    final String eUrl,
  ) {
    return Container(
      padding: EdgeInsets.only(
        top: 7.5,
        bottom: 7.5,
      ),
      margin: EdgeInsets.only(
        left: 5,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(eUrl),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(
                left: 10,
              ),
              child: getCW(
                eGenre,
                eName,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getLV(var events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (BuildContext ctxt, int i) {
        String eName = events[i]['name'];
        String eGenre = events[i]['genre'];
        String eUrl = events[i]['url'];
        return getLI(eName, eGenre, eUrl);
      },
    );
  }

  Widget getBody() {
    CollectionReference users = FirebaseFirestore.instance.collection('events');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: getCPB(),
          );
        }
        events = snapshot.data.docs;
        if (searchResult.length != 0 || _controller.text.isNotEmpty) {
          return getLV(searchResult);
        } else {
          return getLV(events);
        }
      },
    );
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (_isSearching != null) {
      int numberOfMatches = 0;
      for (int i = 0; i < events.length; i++) {
        var event = events[i];
        String eventDetails = event["name"] + event["genre"];
        if (eventDetails.toLowerCase().contains(searchText.toLowerCase())) {
          numberOfMatches++;
          searchResult.add(event);
        } else {
          // no match, so dont add
        }
      }
      print("\n\nno of events in search results: $numberOfMatches");
    }
  }

  void startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void endSearch() {
    setState(() {
      _isSearching = false;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: getTF(),
      ),
      body: Container(
        color: Colors.black,
        child: getBody(),
      ),
    );
  }
}
