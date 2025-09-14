import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/category_provider.dart';
import 'package:to_do_app/screens/task_list_page.dart';
import 'package:to_do_app/widgets/add_category_dialog.dart';
import 'package:to_do_app/widgets/category_tab_w.dart';
import 'package:to_do_app/widgets/task_list_w.dart';

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
        title: const Text("My Tasks"),
        // TODO add more colors to tabs
        bottom: TabBar(
          controller: _tabController, 
          isScrollable: true, 
          physics: BouncingScrollPhysics(),
          indicatorColor: Colors.amber,
          indicatorWeight: 4,
          labelColor: Colors.amber,
          tabs: [
            ...categories.map((cat) => CategoryTabW(category: cat)),
            Tab(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddCategoryDialog(),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
        //categories.map((cat) => TaskListW(categoryId: cat.id)).toList(),
          ...categories.map((cat) => TaskListPage(categoryId: cat.id)),
          Container(),
        ]
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // TODO add create task in active categories
        },
        child: const Icon(Icons.add),
      )
    );
  }
}