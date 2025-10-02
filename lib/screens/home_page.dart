import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/category_provider.dart';
import 'package:to_do_app/widgets/category_tab_w.dart';
import 'package:to_do_app/widgets/task_list_w.dart';
import 'package:to_do_app/widgets/task_title_w.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final categories = context.watch<CategoryProvider>().categories;
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Moje zadania"),
        bottom: TabBar(
          controller: _tabController, 
          isScrollable: true, 
          tabs: categories
            .map((cat) => CategoryTabW(category: cat)).toList(),
          ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories
          .map((cat) => TaskListW(categoryId: cat.id)).toList(),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: const Icon(Icons.add),
      )
    );
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: DefaultTabController(
  //       length: 3,
  //       child: Scaffold(
  //         appBar: AppBar(
  //           bottom: const TabBar(
  //             tabs: [
  //               Tab(icon: Icon(Icons.directions_car)),
  //               Tab(icon: Icon(Icons.directions_transit)),
  //               Tab(icon: Icon(Icons.directions_bike)),
  //             ],
  //           ),
  //           title: const Text('Tabs Demo'),
  //         ),
  //         body: const TabBarView(
  //           children: [
  //             Icon(Icons.directions_car),
  //             Icon(Icons.directions_transit),
  //             Icon(Icons.directions_bike),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }