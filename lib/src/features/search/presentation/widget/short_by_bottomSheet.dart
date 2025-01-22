import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';

class SortByBottomSheet extends StatefulWidget {
  final Function(String) onSortOptionSelected;
  final String currentFilter;

  const SortByBottomSheet({Key? key, required this.onSortOptionSelected, required this.currentFilter}) : super(key: key);

  @override
  _SortByBottomSheetState createState() => _SortByBottomSheetState();
}

class _SortByBottomSheetState extends State<SortByBottomSheet> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.currentFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort By',
            style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildRadioOption('Relevance'),
          _buildRadioOption('Price - Low to High'),
          _buildRadioOption('Price - High to Low'),
          _buildRadioOption('Ratings - High to Low'),
          _buildRadioOption('Distance - Nearest First'),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Radio<String>(
        value: title,
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value!;
            widget.onSortOptionSelected(selectedOption);
          });
        },
      ),
      title: Text(title),
    );
  }
}
