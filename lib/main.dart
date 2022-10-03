import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:http/http.dart' as http;

void main()
{
        runApp(MaterialApp(home: stack_app_api(),));
}


class stack_app_api extends StatefulWidget {
    const stack_app_api({Key? key}) : super(key: key);

    @override
    State<stack_app_api> createState() => _stack_app_apiState();
}

class _stack_app_apiState extends State<stack_app_api> {

    bool status = false;
    List l = [];
    List l1 = [];
    List l2 = [];
    List getimages = [];

    @override
    void initState() {
        super.initState();

        getImages();
        getCategories();
        getAudiobooks();
    }

    Future<List> getImages() async {
        var url = Uri.parse('https://audio-kumbh.herokuapp.com/api/v1/banner');
        var response = await http.get(url);
        print('Response status: ${response.statusCode}');
        print('Response Imagebody: ${response.body}');

        l = jsonDecode(response.body);
        return l;
    }

    Future<List> getCategories() async {
        var url = Uri.parse(
            'https://audio-kumbh.herokuapp.com/api/v2/category/audiobook');
        var response = await http.get(url, headers: {
            "x-guest-token":
            "U2FsdGVkX1+WVxNvXEwxTQsjLZAqcCKK9qqQQ5sUlx8aPkMZ/FyEyAleosfe07phhf0gFMgxsUh2uDnDSkhDaAfn1aw6jYHBwdZ43zdLiTcZedlS9zvVfxYG67fwnb4U454oAiMV0ImECW1DZg/w3aYZGXZIiQ+fiO4XNa1y1lc0rHvjKnPkgrYkgbTdOgAfnxnxaNHiniWClKWmVne/0vO0s6Vh7HpC0lRjs0LKTwM="
        });

        print('Response Category status: ${response.statusCode}');
        print('Response Category body: ${response.body}');

        l1 = jsonDecode(response.body);
        return l1;
    }

    Future<List> getAudiobooks() async {
        var url =
        Uri.parse('https://audio-kumbh.herokuapp.com/api/v2/homepage/category');
        var response = await http.post(url, body: {"sectionfor": "audiobook"},
            headers: {
                "x-guest-token":
                "U2FsdGVkX1+WVxNvXEwxTQsjLZAqcCKK9qqQQ5sUlx8aPkMZ/FyEyAleosfe07phhf0gFMgxsUh2uDnDSkhDaAfn1aw6jYHBwdZ43zdLiTcZedlS9zvVfxYG67fwnb4U454oAiMV0ImECW1DZg/w3aYZGXZIiQ+fiO4XNa1y1lc0rHvjKnPkgrYkgbTdOgAfnxnxaNHiniWClKWmVne/0vO0s6Vh7HpC0lRjs0LKTwM="
            });

        print('Response AudioBook status: ${response.statusCode}');
        print('Response AudioBook body: *****************************************************${response.body}');

        l2 = jsonDecode(response.body)["data"]["home_category_list"];
        return l2;
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    FutureBuilder(
                                        builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.done) {
                                                if (snapshot.hasData) {
                                                    List l = snapshot.data as List;
                                                    for (int i = 0; i < l.length; i++) {
                                                        dummyimages d = dummyimages.fromJson(l[i]);
                                                        getimages.add(d.photoUrl);
                                                    }
                                                    return FlutterCarousel(
                                                        options: CarouselOptions(
                                                            height: 200,
                                                            reverse: false,
                                                            autoPlay: true,
                                                            autoPlayInterval: const Duration(seconds: 2),
                                                            initialPage: 0,
                                                            // aspectRatio: 16 / 9,
                                                            pageSnapping: true,
                                                            viewportFraction: 1,
                                                            enableInfiniteScroll: false,
                                                            slideIndicator: CircularSlideIndicator(
                                                                indicatorBorderColor: Colors.black,
                                                                indicatorBackgroundColor: Colors.white)),
                                                        items: getimages.map((i) {
                                                            return Builder(
                                                                builder: (BuildContext context) {
                                                                    return Container(
                                                                        width: MediaQuery.of(context).size.width,
                                                                        // margin: EdgeInsets.all(10),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(15),
                                                                            color: Colors.grey.shade300,
                                                                            image: DecorationImage(
                                                                                image: NetworkImage("$i"),
                                                                                fit: BoxFit.fill)),
                                                                        // child: Text('$i', style: TextStyle(fontSize: 16.0),)
                                                                    );
                                                                },
                                                            );
                                                        }).toList(),
                                                    );
                                                } else {
                                                    Center(child: Text("No Data Here"));
                                                }
                                            }
                                            return Center(child: CircularProgressIndicator());
                                        },
                                        future: getImages(),
                                    ),
                                    SizedBox(height: 18),
                                    Text(
                                        "Categories",
                                        style: TextStyle(
                                            fontSize: 22,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                    ),
                                    SizedBox(height: 10),
                                    FutureBuilder(
                                        builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.done) {
                                                if (snapshot.hasData) {
                                                    List l1 = snapshot.data as List;
                                                    return SizedBox(
                                                        height: 160,
                                                        child: ListView.builder(
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: l1.length,
                                                            itemBuilder: (context, index) {
                                                                dummycategory c = dummycategory.fromJson(l1[index]);
                                                                return Stack(
                                                                    children: [
                                                                        Container(
                                                                            height: 124,
                                                                            width: 170,
                                                                            margin:
                                                                            EdgeInsets.symmetric(horizontal: 5.0),
                                                                            child: Image.network(
                                                                                "${c.photoUrl}",
                                                                                fit: BoxFit.fill,
                                                                            )),
                                                                        Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 15.0, top: 25),
                                                                            child: Text(
                                                                                "${c.name}",
                                                                                style: TextStyle(
                                                                                    fontSize: 20,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    decoration: TextDecoration.underline,
                                                                                    decorationColor: Colors.white,
                                                                                    decorationStyle:
                                                                                    TextDecorationStyle.solid),
                                                                            ),
                                                                        ),
                                                                        Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 15.0, top: 75),
                                                                            child: Text(
                                                                                "${c.count}",
                                                                                style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 16,
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 27.0, top: 75),
                                                                            child: Text("${c.type}",
                                                                                style: TextStyle(
                                                                                    fontSize: 16, color: Colors.white)),
                                                                        ),
                                                                        Padding(
                                                                            padding:
                                                                            const EdgeInsets.only(left: 125, top: 63),
                                                                            child: IconButton(
                                                                                onPressed: () {},
                                                                                icon: CircleAvatar(
                                                                                    maxRadius: 12,
                                                                                    backgroundColor: Colors.white,
                                                                                    child: Icon(
                                                                                        Icons.arrow_forward_ios,
                                                                                        size: 12,
                                                                                    ),
                                                                                )),
                                                                        )
                                                                    ],
                                                                );
                                                            },
                                                        ),
                                                    );
                                                } else {
                                                    Center(child: Text("No Data Here"));
                                                }
                                            }
                                            return Center(child: CircularProgressIndicator());
                                        },
                                        future: getCategories(),
                                    ),

                                    // SizedBox(height: 15),
                                    Text(
                                        "Audiobooks",
                                        style: TextStyle(
                                            fontSize: 22,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                    ),
                                    SizedBox(height: 20),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text(
                                                "Most Popular",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    letterSpacing: 0.4,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                            ),
                                            Text(
                                                "View All",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    letterSpacing: 0.4,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                            ),
                                        ],
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                        height: 280,
                                        child: FutureBuilder(
                                            builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.done) {
                                                    if (snapshot.hasData) {
                                                        List l2 = snapshot.data as List;
                                                        mostpopulardata d = mostpopulardata.fromJson(l2[0]);
                                                        return ListView.builder(
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: d.idList!.length,
                                                            itemBuilder: (context, index) {
                                                                return Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                        Container(
                                                                            height: 215,
                                                                            width: 137,
                                                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage(
                                                                                        "${d.idList![index].audioBookDpUrl}"),
                                                                                    fit: BoxFit.fill)),
                                                                        ),
                                                                        Padding(
                                                                            padding: const EdgeInsets.symmetric(
                                                                                horizontal: 5.0, vertical: 5),
                                                                            child: SizedBox(
                                                                                width: 105,
                                                                                child: Text(
                                                                                    "${d.idList![index].name}",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 17),
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        Padding(
                                                                            padding: const EdgeInsets.symmetric(
                                                                                horizontal: 5.0),
                                                                            child: SizedBox(
                                                                                width: 90,
                                                                                child: Text(
                                                                                    "${d.idList![index].author}",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(letterSpacing: 0.4,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.grey),
                                                                                ),
                                                                            ),
                                                                        )
                                                                    ]);
                                                            },
                                                        );
                                                    }
                                                    return Center(
                                                        child: Text("Something went Wrong"),
                                                    );
                                                }
                                                return Center(
                                                    child: CircularProgressIndicator(),
                                                );
                                            },
                                            future: getAudiobooks(),
                                        ),
                                    ),

                                    SizedBox(height: 20),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text(
                                                "Today's Picks",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    letterSpacing: 0.4,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                            ),
                                            Text(
                                                "View All",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    letterSpacing: 0.4,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                            ),
                                        ],
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                        height: 280,
                                        child: FutureBuilder(
                                            builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.done) {
                                                    if (snapshot.hasData) {
                                                        List l2 = snapshot.data as List;
                                                        mostpopulardata d = mostpopulardata.fromJson(l2[1]);
                                                        return ListView.builder(
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: d.idList!.length,
                                                            itemBuilder: (context, index) {
                                                                return Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                        Container(
                                                                            height: 215,
                                                                            width: 137,
                                                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage(
                                                                                        "${d.idList![index].audioBookDpUrl}"),
                                                                                    fit: BoxFit.fill)),
                                                                        ),
                                                                        Padding(
                                                                            padding: const EdgeInsets.symmetric(
                                                                                horizontal: 5.0, vertical: 5),
                                                                            child: SizedBox(
                                                                                width: 105,
                                                                                child: Text(
                                                                                    "${d.idList![index].name}",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 17),
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        Padding(
                                                                            padding: const EdgeInsets.symmetric(
                                                                                horizontal: 5.0),
                                                                            child: SizedBox(
                                                                                width: 90,
                                                                                child: Text(
                                                                                    "${d.idList![index].author}",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(letterSpacing: 0.4,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.grey),
                                                                                ),
                                                                            ),
                                                                        )
                                                                    ]);
                                                            },
                                                        );
                                                    }
                                                    return Center(
                                                        child: Text("Something went Wrong"),
                                                    );
                                                }
                                                return Center(
                                                    child: CircularProgressIndicator(),
                                                );
                                            },
                                            future: getAudiobooks(),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ),
                )),
        );
    }
}

class dummyimages {
    String? sId;
    String? bannerFor;
    String? forId;
    String? photoUrl;
    String? createdAt;
    String? updatedAt;
    int? iV;
    bool? isLock;
    String? redirectTo;
    String? type;
    String? redirect;

    dummyimages(
        {this.sId,
            this.bannerFor,
            this.forId,
            this.photoUrl,
            this.createdAt,
            this.updatedAt,
            this.iV,
            this.isLock,
            this.redirectTo,
            this.type,
            this.redirect});

    dummyimages.fromJson(Map json) {
        sId = json['_id'];
        bannerFor = json['bannerFor'];
        forId = json['forId'];
        photoUrl = json['photoUrl'];
        createdAt = json['createdAt'];
        updatedAt = json['updatedAt'];
        iV = json['__v'];
        isLock = json['isLock'];
        redirectTo = json['redirectTo'];
        type = json['type'];
        redirect = json['redirect'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        data['bannerFor'] = this.bannerFor;
        data['forId'] = this.forId;
        data['photoUrl'] = this.photoUrl;
        data['createdAt'] = this.createdAt;
        data['updatedAt'] = this.updatedAt;
        data['__v'] = this.iV;
        data['isLock'] = this.isLock;
        data['redirectTo'] = this.redirectTo;
        data['type'] = this.type;
        data['redirect'] = this.redirect;
        return data;
    }
}

class dummycategory {
    String? sId;
    String? type;
    String? photoUrl;
    String? name;
    String? createdAt;
    String? updatedAt;
    int? iV;
    int? count;

    dummycategory(
        {this.sId,
            this.type,
            this.photoUrl,
            this.name,
            this.createdAt,
            this.updatedAt,
            this.iV,
            this.count});

    dummycategory.fromJson(Map<String, dynamic> json) {
        sId = json['_id'];
        type = json['type'];
        photoUrl = json['photoUrl'];
        name = json['name'];
        createdAt = json['createdAt'];
        updatedAt = json['updatedAt'];
        iV = json['__v'];
        count = json['count'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        data['type'] = this.type;
        data['photoUrl'] = this.photoUrl;
        data['name'] = this.name;
        data['createdAt'] = this.createdAt;
        data['updatedAt'] = this.updatedAt;
        data['__v'] = this.iV;
        data['count'] = this.count;
        return data;
    }
}

// ***************************************************************************** Audiobook = 1.Most Popular

class mostpopulardata {
    String? sId;
    List<IdList>? idList;

    mostpopulardata({this.sId, this.idList});

    mostpopulardata.fromJson(Map<String, dynamic> json) {
        sId = json['_id'];
        if (json['idList'] != null) {
            idList = <IdList>[];
            json['idList'].forEach((v) {
                idList!.add(new IdList.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        if (this.idList != null) {
            data['idList'] = this.idList!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class IdList {
    String? sId;
    String? audioBookDpUrl;
    String? name;
    String? tags;
    Category? category;
    String? author;
    String? publisher;
    String? description;
    String? reader;
    List<Files>? files;
    String? createdAt;
    String? updatedAt;
    int? iV;
    bool? isLock;
    bool? isNewAudiobook;
    String? authorDpUrl;
    String? language;
    String? publisherDpUrl;

    IdList(
        {this.sId,
            this.audioBookDpUrl,
            this.name,
            this.tags,
            this.category,
            this.author,
            this.publisher,
            this.description,
            this.reader,
            this.files,
            this.createdAt,
            this.updatedAt,
            this.iV,
            this.isLock,
            this.isNewAudiobook,
            this.authorDpUrl,
            this.language,
            this.publisherDpUrl});

    IdList.fromJson(Map<String, dynamic> json) {
        sId = json['_id'];
        audioBookDpUrl = json['audioBookDpUrl'];
        name = json['name'];
        tags = json['tags'];
        category = json['category'] != null
            ? new Category.fromJson(json['category'])
            : null;
        author = json['author'];
        publisher = json['publisher'];
        description = json['description'];
        reader = json['reader'];
        if (json['files'] != null) {
            files = <Files>[];
            json['files'].forEach((v) {
                files!.add(new Files.fromJson(v));
            });
        }
        createdAt = json['createdAt'];
        updatedAt = json['updatedAt'];
        iV = json['__v'];
        isLock = json['isLock'];
        isNewAudiobook = json['isNewAudiobook'];
        authorDpUrl = json['authorDpUrl'];
        language = json['language'];
        publisherDpUrl = json['publisherDpUrl'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        data['audioBookDpUrl'] = this.audioBookDpUrl;
        data['name'] = this.name;
        data['tags'] = this.tags;
        if (this.category != null) {
            data['category'] = this.category!.toJson();
        }
        data['author'] = this.author;
        data['publisher'] = this.publisher;
        data['description'] = this.description;
        data['reader'] = this.reader;
        if (this.files != null) {
            data['files'] = this.files!.map((v) => v.toJson()).toList();
        }
        data['createdAt'] = this.createdAt;
        data['updatedAt'] = this.updatedAt;
        data['__v'] = this.iV;
        data['isLock'] = this.isLock;
        data['isNewAudiobook'] = this.isNewAudiobook;
        data['authorDpUrl'] = this.authorDpUrl;
        data['language'] = this.language;
        data['publisherDpUrl'] = this.publisherDpUrl;
        return data;
    }
}

class Category {
    String? sId;
    String? type;
    String? photoUrl;
    String? name;
    String? createdAt;
    String? updatedAt;
    int? iV;
    int? count;

    Category(
        {this.sId,
            this.type,
            this.photoUrl,
            this.name,
            this.createdAt,
            this.updatedAt,
            this.iV,
            this.count});

    Category.fromJson(Map<String, dynamic> json) {
        sId = json['_id'];
        type = json['type'];
        photoUrl = json['photoUrl'];
        name = json['name'];
        createdAt = json['createdAt'];
        updatedAt = json['updatedAt'];
        iV = json['__v'];
        count = json['count'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        data['type'] = this.type;
        data['photoUrl'] = this.photoUrl;
        data['name'] = this.name;
        data['createdAt'] = this.createdAt;
        data['updatedAt'] = this.updatedAt;
        data['__v'] = this.iV;
        data['count'] = this.count;
        return data;
    }
}

class Files {
    String? fileType;
    String? sId;
    String? title;
    int? playCount;
    int? seconds;
    String? fileUrl;

    Files(
        {this.fileType,
            this.sId,
            this.title,
            this.playCount,
            this.seconds,
            this.fileUrl});

    Files.fromJson(Map<String, dynamic> json) {
        fileType = json['fileType'];
        sId = json['_id'];
        title = json['title'];
        playCount = json['playCount'];
        seconds = json['seconds'];
        fileUrl = json['fileUrl'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['fileType'] = this.fileType;
        data['_id'] = this.sId;
        data['title'] = this.title;
        data['playCount'] = this.playCount;
        data['seconds'] = this.seconds;
        data['fileUrl'] = this.fileUrl;
        return data;
    }
}

// ***************************************************************************** Audiobook = 1.Most Popular

class AudioDummyData {
    String? sId;
    List<IdList>? idList;

    AudioDummyData({this.sId, this.idList});

    AudioDummyData.fromJson(Map<String, dynamic> json) {
        sId = json['_id'];
        if (json['idList'] != null) {
            idList = <IdList>[];
            json['idList'].forEach((v) {
                idList!.add(new IdList.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        if (this.idList != null) {
            data['idList'] = this.idList!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class IdList1 {
    String? sId;
    String? audioBookDpUrl;
    String? name;
    String? tags;
    Category? category;
    String? author;
    String? publisher;
    String? description;
    String? reader;
    List<Files>? files;
    String? createdAt;
    String? updatedAt;
    int? iV;
    bool? isLock;
    bool? isNewAudiobook;
    String? authorDpUrl;
    String? language;
    String? publisherDpUrl;

    IdList1(
        {this.sId,
            this.audioBookDpUrl,
            this.name,
            this.tags,
            this.category,
            this.author,
            this.publisher,
            this.description,
            this.reader,
            this.files,
            this.createdAt,
            this.updatedAt,
            this.iV,
            this.isLock,
            this.isNewAudiobook,
            this.authorDpUrl,
            this.language,
            this.publisherDpUrl});

    IdList1.fromJson(Map<String, dynamic> json) {
        sId = json['_id'];
        audioBookDpUrl = json['audioBookDpUrl'];
        name = json['name'];
        tags = json['tags'];
        category = json['category'] != null
            ? new Category.fromJson(json['category'])
            : null;
        author = json['author'];
        publisher = json['publisher'];
        description = json['description'];
        reader = json['reader'];
        if (json['files'] != null) {
            files = <Files>[];
            json['files'].forEach((v) {
                files!.add(new Files.fromJson(v));
            });
        }
        createdAt = json['createdAt'];
        updatedAt = json['updatedAt'];
        iV = json['__v'];
        isLock = json['isLock'];
        isNewAudiobook = json['isNewAudiobook'];
        authorDpUrl = json['authorDpUrl'];
        language = json['language'];
        publisherDpUrl = json['publisherDpUrl'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        data['audioBookDpUrl'] = this.audioBookDpUrl;
        data['name'] = this.name;
        data['tags'] = this.tags;
        if (this.category != null) {
            data['category'] = this.category!.toJson();
        }
        data['author'] = this.author;
        data['publisher'] = this.publisher;
        data['description'] = this.description;
        data['reader'] = this.reader;
        if (this.files != null) {
            data['files'] = this.files!.map((v) => v.toJson()).toList();
        }
        data['createdAt'] = this.createdAt;
        data['updatedAt'] = this.updatedAt;
        data['__v'] = this.iV;
        data['isLock'] = this.isLock;
        data['isNewAudiobook'] = this.isNewAudiobook;
        data['authorDpUrl'] = this.authorDpUrl;
        data['language'] = this.language;
        data['publisherDpUrl'] = this.publisherDpUrl;
        return data;
    }
}

class Category1 {
    String? sId;
    String? type;
    String? photoUrl;
    String? name;
    String? createdAt;
    String? updatedAt;
    int? iV;
    int? count;

    Category1(
        {this.sId,
            this.type,
            this.photoUrl,
            this.name,
            this.createdAt,
            this.updatedAt,
            this.iV,
            this.count});

    Category1.fromJson(Map<String, dynamic> json) {
        sId = json['_id'];
        type = json['type'];
        photoUrl = json['photoUrl'];
        name = json['name'];
        createdAt = json['createdAt'];
        updatedAt = json['updatedAt'];
        iV = json['__v'];
        count = json['count'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        data['type'] = this.type;
        data['photoUrl'] = this.photoUrl;
        data['name'] = this.name;
        data['createdAt'] = this.createdAt;
        data['updatedAt'] = this.updatedAt;
        data['__v'] = this.iV;
        data['count'] = this.count;
        return data;
    }
}

class Files1 {
    String? fileType;
    String? sId;
    String? title;
    int? playCount;
    int? seconds;
    String? fileUrl;

    Files1(
        {this.fileType,
            this.sId,
            this.title,
            this.playCount,
            this.seconds,
            this.fileUrl});

    Files1.fromJson(Map<String, dynamic> json) {
        fileType = json['fileType'];
        sId = json['_id'];
        title = json['title'];
        playCount = json['playCount'];
        seconds = json['seconds'];
        fileUrl = json['fileUrl'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['fileType'] = this.fileType;
        data['_id'] = this.sId;
        data['title'] = this.title;
        data['playCount'] = this.playCount;
        data['seconds'] = this.seconds;
        data['fileUrl'] = this.fileUrl;
        return data;
    }
}


