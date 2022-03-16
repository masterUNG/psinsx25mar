import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/dmsx_model.dart';
import 'package:psinsx/pages/show_cusname_detail.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/widgets/show_proogress.dart';
import 'package:psinsx/widgets/show_tetle.dart';

class DmsxListPage extends StatefulWidget {
  final List<Dmsxmodel> dmsxModels;
  const DmsxListPage({Key key, @required this.dmsxModels}) : super(key: key);

  @override
  _DmsxListPageState createState() => _DmsxListPageState();
}

class _DmsxListPageState extends State<DmsxListPage> {
  List<Dmsxmodel> dmsxModels;
  List<Dmsxmodel> searchDmsxModels;
  final debouncer = Debouncer(millisecond: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupData();
  }

  Future<void> setupData() async {
    dmsxModels = widget.dmsxModels;
    searchDmsxModels = dmsxModels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ข้อมูล ${dmsxModels.length} รายการ',
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: dmsxModels.isEmpty
          ? ShowProgress()
          : SingleChildScrollView(
              child: GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(FocusScopeNode()),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    buildSearch(),
                    listDmsx(),
                  ],
                ),
              ),
            ),
    );
  }

  Container buildSearch() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        child: TextFormField(
          onChanged: (value) {
            debouncer.run(() {
              setState(() {
                searchDmsxModels = dmsxModels
                    .where((element) => element.cusName
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            });
          },
          decoration: InputDecoration(
            hintText: 'ค้นหา',
            prefixIcon: Icon(Icons.search_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ));
  }

  ListView listDmsx() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: searchDmsxModels.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
         
          Navigator.pop(context, [searchDmsxModels[index]]);

          //   return Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         ShowCusnameDetail(dmsxmodel: searchDmsxModels[index]),
          //   ),
          // );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShowTitle(
                        title: searchDmsxModels[index].cusName.trim(),
                        textStyle: MyConstant().h3Style(),
                      ),
                      ShowTitle(
                        title: searchDmsxModels[index].line.trim(),
                        textStyle: MyConstant().h4Style(),
                      ),
                      Row(
                        children: [
                          Text(
                            'ล่าสุด: ',
                            style: TextStyle(fontSize: 10),
                          ),
                          ShowTitle(
                            title: searchDmsxModels[index].statusTxt.trim(),
                            textStyle: MyConstant().h5Style(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: searchDmsxModels[index].images.isEmpty
                      ? SizedBox()
                      : showImage(searchDmsxModels[index].images),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showImage(String images) {
    List<Widget> widgets = [];
    String string = images;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');

    for (var item in strings) {
      widgets.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 60,
          height: 60,
          child: CachedNetworkImage(
            imageUrl: '${MyConstant.domainImage}${item.trim()}',
            fit: BoxFit.cover,
            placeholder: (context, url) => ShowProgress(),
            errorWidget: (context, url, error) => SizedBox(),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: widgets,
    );
  }
}

class Debouncer {
  final int millisecond;
  VoidCallback voidCallback;
  Timer timer;

  Debouncer({@required this.millisecond});

  run(VoidCallback voidCallback) {
    if (timer != null) {
      timer.cancel();
    }
    timer = Timer(Duration(milliseconds: millisecond), voidCallback);
  }
}
