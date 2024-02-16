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
  ScrollController scrollController = ScrollController();
  int page = 1;
  List<Data> newList = [];
  @override
  void initState() {
    scrollController.addListener(scrollListener);
    getData(page: 1);
    super.initState();
  }

  getData({required int page}) async {
    res = await controller.dashboard(page: page);
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
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        pageEnd = true;
      });
      page = page + 1;
      // Future.delayed(Duration(seconds: 2), () async {
      //   await getData(page: page);
      // });
      await getData(page: page);
      setState(() {
        pageEnd = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: (isLoading)
          ? const Center(child: CircularProgressIndicator())
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
                            child: Card(
                              elevation: 10,
                              color: Colors.grey[500],
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
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
                          return const CircularProgressIndicator();
                        }
                      }),
                ]),
              ),
            ),
    );
  }
}
