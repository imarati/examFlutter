import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import '../widgets/item_tile.dart';
import '../widgets/item_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ItemService itemService;
  List<Item> items = [];
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    final client = GraphQLProvider.of(context).value;
    itemService = ItemService(client);
    loadItems();
    super.didChangeDependencies();
  }

  Future<void> loadItems() async {
    setState(() => isLoading = true);

    try {
      final result = await itemService.getItems();

      if (mounted) {
        setState(() {
          items = result;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Успешно загружено ${result.length} элементов'),
              duration: const Duration(seconds: 1),
            ),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки: ${e.toString()}'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint('Error loading items: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void showForm({Item? item}) {
    showDialog(
      context: context,
      builder: (_) => ItemForm(
        initialName: item?.name,
        onSubmit: (name) async {
          if (item == null) {
            await itemService.addItem(name);
          } else {
            await itemService.updateItem(item.id, name);
          }
          await loadItems();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD GraphQL"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : loadItems,  // Блокируем кнопку во время загрузки
            tooltip: 'Обновить список',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: items.map((item) {
          return ItemTile(
            name: item.name,
            onEdit: () => showForm(item: item),
            onDelete: () async {
              await itemService.deleteItem(item.id);
              await loadItems();
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}