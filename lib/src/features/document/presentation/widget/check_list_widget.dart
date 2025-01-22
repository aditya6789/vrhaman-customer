import 'package:flutter/material.dart';
import 'package:vrhaman/src/features/document/presentation/widget/check_list_item.dart';


  Widget CheckList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckListItem('To get it right make sure the photo is taken in good light'),
        CheckListItem('Details are in focus'),
        CheckListItem('There is no glare on the ID'),
      ],
    );
  }

