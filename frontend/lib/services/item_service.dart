import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/queries.dart';
import '../models/item.dart';

class ItemService {
  final GraphQLClient client;

  ItemService(this.client);

  Future<List<Item>> getItems() async {
    try {
      debugPrint('Fetching items...');

      final result = await client.query(
        QueryOptions(
          document: gql(getItemsQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      _validateResponse(result, 'items');

      return (result.data!['items'] as List)
          .map((json) => Item.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('GetItems error: $e');
      rethrow;
    }
  }

  Future<Item> addItem(String name) async {
    try {
      debugPrint('Adding item: $name');

      final result = await client.mutate(
        MutationOptions(
          document: gql(addItemMutation),
          variables: {'name': name},
        ),
      );

      _validateResponse(result, 'addItem');

      return Item.fromJson(result.data!['addItem']);
    } catch (e) {
      debugPrint('AddItem error: $e');
      rethrow;
    }
  }

  Future<Item> updateItem(int id, String name) async {
    try {
      debugPrint('Updating item $id with name: $name');

      final result = await client.mutate(
        MutationOptions(
          document: gql(updateItemMutation),
          variables: {'id': id, 'name': name},
        ),
      );

      _validateResponse(result, 'updateItem');

      return Item.fromJson(result.data!['updateItem']);
    } catch (e) {
      debugPrint('UpdateItem error: $e');
      rethrow;
    }
  }

  Future<bool> deleteItem(int id) async {
    try {
      debugPrint('Deleting item $id');

      final result = await client.mutate(
        MutationOptions(
          document: gql(deleteItemMutation),
          variables: {'id': id},
        ),
      );

      _validateResponse(result, 'deleteItem');

      return result.data!['deleteItem'] != null;
    } catch (e) {
      debugPrint('DeleteItem error: $e');
      return false;
    }
  }

  void _validateResponse(QueryResult result, String operation) {
    if (result.hasException) {
      throw Exception('GraphQL $operation error: ${result.exception}');
    }

    if (result.data == null || result.data![operation] == null) {
      throw Exception('Server returned invalid $operation response');
    }

    debugPrint('$operation success: ${result.data}');
  }
}