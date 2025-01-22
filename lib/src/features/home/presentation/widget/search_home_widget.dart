import 'package:flutter/material.dart';
import 'package:vrhaman/src/features/search/presentation/screen/search_screen.dart';
class SearchHomeWidget extends StatelessWidget {
  const SearchHomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen())),
      decoration: InputDecoration(
        hintText: 'Search for rentals',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon:
            const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0),
      ),
    );
  }
}
