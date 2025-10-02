import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/category_provider.dart';
import 'package:to_do_app/screens/task_list_page.dart';
import 'package:to_do_app/widgets/add_category_dialog.dart';
import 'package:to_do_app/widgets/category_tab_w.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? _tabController;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final categories = context.read<CategoryProvider>().categories;

    _tabController?.dispose();

    _tabController = TabController(length: categories.length + 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;
  
    return DefaultTabController(
      length: categories.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Tasks"),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.amber,//categories[categoryId].color,
            indicatorWeight: 4,
            labelColor: Colors.amber,
            onTap: (index) {
              if (index == categories.length) {
                showDialog(
                  context: context,
                  builder: (_) => const AddCategoryDialog(),
                );
              }
            },
            tabs: [
              ...categories.map((cat) => CategoryTabW(category: cat)),
              const Tab(icon: Icon(Icons.add)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ...categories.map((cat) => TaskListPage(categoryId: cat.id)),
            Container(), // placeholder dla "+"
          ],
        ),
      ),
    );
  }
}