import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:practice/Common/Common.dart';
import 'package:practice/Common/Constant.dart';
import 'package:practice/Model/MoviesModelBean.dart';

import '../Api/ApiFuntions.dart';

class DashBoardActivity extends StatefulWidget {
  const DashBoardActivity({Key? key}) : super(key: key);

  @override
  State<DashBoardActivity> createState() => _DashBoardActivity();
}

class _DashBoardActivity extends State<DashBoardActivity> {
  int _selectedIndex = 0;
  late ApiFuntions apis;
  List<MoviesModelData> moviesdata = <MoviesModelData>[];
  List<MoviesModelData> datanew = <MoviesModelData>[];
  var searchController = TextEditingController();
  late MoviesModelBean moviesModelBean;

  @override
  void initState() {
    // TODO: implement initState
    apis = ApiFuntions();
    Future.delayed(Duration.zero, () {
      getmoviesbean(Constant.getnowmovies);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF5B969),
        title: Container(
          height: 40,
          child: TextField(
            controller: searchController,
            onChanged: (text) {
              filterSearchResults(text);
            },
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration:  InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10,5,5,5),
              hintText: 'Search...',
              hintStyle: const TextStyle(color: Colors.black),
              filled: true, // Set the filled property to true
              fillColor: Colors.white, // Set the fillColor property to the color you want
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: Colors.white, width: 1, style: BorderStyle.solid)),
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: Colors.white, width: 1, style: BorderStyle.solid)),
            ),
          )
        ),
      ),
      backgroundColor: Color(Common.basecolor),
      body: moviesdata.length > 0
          ? setlistview()
          : const Center(
              child: Text("NO data found"),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffF5B969),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.movie_filter_outlined,
              //AssetImage('assets/images/dashbosrds.png'),
              size: 27,
            ),
            label: 'Now Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              //AssetImage('assets/images/progress.png'),
              size: 27,
            ),
            label: 'Top Rated',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 14),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      getmoviesbean(Constant.getnowmovies);
    }
    if (index == 1) {
      getmoviesbean(Constant.gettopstars);
    }
  }

  Widget setlistview() {
    return ListView.builder(
        itemCount: datanew.length,
        itemBuilder: (ctx, index) {
          return Container(
              margin: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Image.network(
                        height: 100,
                        width: 80,
                        "https://s3.ap-south-1.amazonaws.com/browsecart.com/v1-docs/products/39/gallery_ab2bbcb4-0a8f-41f0-8486-7fd2bf31f3ff.jpg",
                        fit: BoxFit.fill),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.only(top: 5, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            datanew[index].originalTitle ?? "",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                datanew[index].overview ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  getmoviesbean(String endpoint) async {
    var response = await apis.getdata(context, endpoint);
    var data = MoviesModelBean.fromJson(jsonDecode(response.body));
    setState(() {
      datanew.clear();
      moviesdata.clear();
      datanew.addAll(data.moviesModelData!);
      moviesdata = data.moviesModelData!;
    });
    print(
        "Value ======================================================${moviesdata}");
  }
  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<MoviesModelData> dummyListData = [];
      moviesdata.forEach((item) {
        if (item.originalTitle!
            .toLowerCase()
            .contains(searchController.text.toString().toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        datanew.clear();
        datanew.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        datanew.clear();
        datanew.addAll(moviesdata);
      });
    }
  }
}
