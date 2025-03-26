

import 'package:ecosnap/widgets/category_widget.dart';
import 'package:flutter/material.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({super.key});

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
 

  //track the selected color
  CategoryLabel? _selectedColor = CategoryLabel.litter;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "Cupture Image",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Capture button
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Open Camera'),
            onPressed: () {
              // Add your code here
            },
          ),
          
          const SizedBox(height: 20),
          // Material 3 DropdownMenu for selecting a color
          DropdownMenu<CategoryLabel>(
            label: const Text('Select a category'),
            // The list of dropdown entries from your enum
            dropdownMenuEntries: CategoryLabel.entries,

            // The current selected value
            initialSelection: _selectedColor,

            // Callback when a new color is selected
            onSelected: (CategoryLabel? newColor) {
              setState(() {
                _selectedColor = newColor;
              });
            },
          ),

          const SizedBox(height: 20),

          // Title text field
          const TextField(
            decoration: InputDecoration(
               border: OutlineInputBorder(),
              labelText: 'Title',
              hintText: 'Enter a short title, Maximum 100 characters',
            ),
          ),

          const SizedBox(height: 20),

          // Description text field
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
              hintText: 'Enter a description',
            ),
            maxLines: 3,
          ),
        ],
    ),
    );
  }
}