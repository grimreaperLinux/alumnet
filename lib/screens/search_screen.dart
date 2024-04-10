import 'package:alumnet/models/community.dart';
import 'package:alumnet/models/discussion.dart';
import 'package:alumnet/profile/otheruser_profile.dart';
import 'package:alumnet/screens/community/discussion_detail_screen.dart';
import 'package:alumnet/screens/community/discussion_screen.dart';
import 'package:flutter/material.dart';
import '../services/typesense_search.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:ui';

class SearchPage extends StatefulWidget {
  static const routename = "search_screen";
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> _searchResults = {
    'Users': [],
    'Communities': [],
    'Discussions': [],
  };

  bool _hasAnythingBeingSearched = false;

  void performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _hasAnythingBeingSearched = true;
    });

    final searchParameters = {
      'Users': {
        'q': query,
        'query_by': 'fullName',
      },
      'Communities': {
        'q': query,
        'query_by': 'name',
      },
      'Discussions': {
        'q': query,
        'query_by': 'headline',
      },
    };

    Future<Map<String, dynamic>> typesenseSearch(
        String collection, Map<String, String> searchParams) async {
      final searchResults = await typesenseClient
          .collection(collection)
          .documents
          .search(searchParams);
      return searchResults;
    }

    try {
      Map<String, dynamic> results = {};
      for (String collection in ['Users', 'Communities', 'Discussions']) {
        final result = await typesenseSearch(
            collection, searchParameters[collection] as Map<String, String>);
        results[collection] = result['hits'];
      }
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
      // Handle the error, maybe show an alert dialog with the error message
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Something went wrong.",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "Search",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
              onFieldSubmitted: performSearch,
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isSearching
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      alignment: Alignment.center,
                      child: LoadingAnimationWidget.inkDrop(
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                  : _searchResults.values.every((list) => list.isEmpty)
                      ? Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Center(
                              child: Text(
                                _hasAnythingBeingSearched
                                    ? 'No matches were found in any of the groups'
                                    : 'Search query will be performed for users, communities and discussions',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          children: [
                            SearchResultBox(
                              title: 'Users',
                              results: _searchResults[
                                  'Users'], // Assume this is filtered for users
                            ),
                            SearchResultBox(
                              title: 'Communities',
                              results: _searchResults[
                                  'Communities'], // Assume this is filtered for communities
                            ),
                            SearchResultBox(
                              title: 'Discussions',
                              results: _searchResults[
                                  'Discussions'], // Assume this is filtered for discussions
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultBox extends StatelessWidget {
  final String title;
  final List<dynamic> results; // Updated to a more specific type for clarity

  SearchResultBox({required this.title, required this.results});

  @override
  Widget build(BuildContext context) {
    Map<String, String> entities_to_img = {
      "Users":
          "https://images.unsplash.com/photo-1526848707818-825332fe55f4?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fHVzZXIlMjBpY29ufGVufDB8fDB8fHww",
      "Communities":
          'https://images.unsplash.com/photo-1444210971048-6130cf0c46cf?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y29tbXVuaXR5JTIwaWNvbnxlbnwwfHwwfHx8MA%3D%3D',
      "Discussions":
          'https://images.unsplash.com/photo-1576670158333-9cf3fbdef080?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZGlzY3Vzc2lvbnMlMjBpY29ufGVufDB8fDB8fHww'
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // to disable ListView's scrolling
              itemCount: results.isEmpty ? 1 : results.length,
              itemBuilder: (context, index) {
                if (results.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('No hits for $title'),
                  );
                }
                final document = results[index]['document'];
                String userId = document['userId'];
                Community community = document['name'];
                Discussion headline = document['headline'];
                Widget destination;
                if (userId != null) {
                  destination = OtherProfile(userId: userId);
                } else if (community != null) {
                  destination = DiscussionScreen(community: community);
                } else if (headline != null) {
                  destination = DiscussionDetailScreen(
                      discussion: headline,
                      community: community,
                      path:
                          "discussions/${community.name}/posts/${headline.id}/comments");
                } else {
                  destination = Text("NN");
                }

                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(entities_to_img[title] as String),
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(
                      document['fullName'] ??
                          document['name'] ??
                          document['headline'] ??
                          'No title',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => destination),
                    );
                    print(document['id']);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
