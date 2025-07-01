const String getItemsQuery = """
  query {
    items {
      id
      name
    }
  }
""";

const String addItemMutation = """
  mutation AddItem(\$name: String!) {
    addItem(name: \$name) {
      id
      name
    }
  }
""";

const String deleteItemMutation = """
  mutation DeleteItem(\$id: Int!) {
    deleteItem(id: \$id) {
      id
      name
    }
  }
""";

const String updateItemMutation = """
  mutation UpdateItem(\$id: Int!, \$name: String!) {
    updateItem(id: \$id, name: \$name) {
      id
      name
    }
  }
""";
