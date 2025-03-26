// Type definition for convenience
import 'dart:collection';

import 'package:flutter/material.dart';

typedef CategoryEntry = DropdownMenuEntry<CategoryLabel>;

// Example enum for color labels
enum CategoryLabel {
  litter('Litter'),
  pollution('Pollution');

  const CategoryLabel(this.label);
  final String label;


  // Create a list of DropdownMenuEntry from the enum values
  static final List<CategoryEntry> entries = UnmodifiableListView<CategoryEntry>(
    values.map<CategoryEntry>(
      (CategoryLabel category) => DropdownMenuEntry<CategoryLabel>(
        value: category,
        label: category.label,
      ),
    ),
  );
}
