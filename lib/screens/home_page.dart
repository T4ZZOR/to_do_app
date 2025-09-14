import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/category_provider.dart';
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
        title: const Text("Moje zadania"),
        bottom: TabBar(
          controller: _tabController, 
          isScrollable: true, 
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