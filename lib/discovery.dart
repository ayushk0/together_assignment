import 'package:flutter/material.dart';
import 'package:together_assignment/api_controller.dart';
import 'package:together_assignment/discovery_model.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  ApiController controller = ApiController();
  DiscoveryModel? res = DiscoveryModel();
  bool isLoading = true;
  bool pageEnd = false;
  bool hasMoreData = true;
  ScrollController scrollController = ScrollController();
  int page = 1;
  int limit = 10;
  List<Data> newList = [];
  @override
  void initState() {
    scrollController.addListener(scrollListener);
    getData(page: 1, limit: limit);
    super.initState();
  }

  getData({required int page, required int limit}) async {
    //calling the api to load data
    res = await controller.dashboard(page: page, limit: limit);
    if (res!.data!.length < limit) {
      setState(() {
        hasMoreData = false;
        pageEnd = true;
      });
    }
    //appending the data recieved int the local list
    newList = newList + res!.data!;
    setState(() {
      newList;
      isLoading = false;
    });
  }

  scrollListener() async {
    if (pageEnd) {
      return;
    }
    //checking if we reached to the end of the list
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        pageEnd = true;
      });
      //increasing the page counter by 1
      page = page + 1;
      //calling the function to load more data
      await getData(page: page, limit: limit);
      //creating 2 sec delay to show the loading bar at the bottom
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          pageEnd = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: (isLoading)
          // Showing loader initially while page loads the data
          ? const Center(child: CircularProgressIndicator())
          // building page when data loads
          : Scaffold(
              body: SingleChildScrollView(
                controller: scrollController,
                child: Column(children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: pageEnd ? newList.length + 1 : newList.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < newList.length) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            //Card for showing data
                            child: Card(
                              elevation: 10,
                              color: Colors.grey[500],
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    //Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        newList[index].imageUrl!,
                                        width: height * 0.15,
                                        height: height * 0.12,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    SizedBox(
                                      width: width * 0.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //title
                                          Text(
                                            newList[index].title!,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              height: 1,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          //description
                                          Text(
                                            newList[index].description!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          //Showing loader at the bottom of the page
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 40),
                            child: Center(
                              child: hasMoreData
                                  ? const Column(
                                      children: [
                                        Text('Hang On, Loading data'),
                                        SizedBox(height: 20),
                                        CircularProgressIndicator(),
                                      ],
                                    )
                                  //show when no more data is coming from the api
                                  : const Text('No more data to load'),
                            ),
                          );
                        }
                      }),
                ]),
              ),
            ),
    );
  }
}
