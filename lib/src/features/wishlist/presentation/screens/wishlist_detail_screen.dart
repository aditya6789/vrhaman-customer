import 'package:flutter/material.dart';

class WishlistDetailScreen extends StatefulWidget {
  const WishlistDetailScreen({super.key});

  @override
  State<WishlistDetailScreen> createState() => _WishlistDetailScreenState();
}

class _WishlistDetailScreenState extends State<WishlistDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Honda WR-V 2017',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Manual • Petrol • 5 Seats'),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue),
              SizedBox(width: 4),
              Expanded(
                child: Text('Rajendar Kumar Mahavir Enclave, Main Vij...'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Image.asset('assets/images/car_interior.jpg'),
              ),
              SizedBox(width: 8),
              Column(
                children: [
                  Image.asset('assets/images/car_dashboard.jpg', width: 100),
                  SizedBox(height: 8),
                  Image.asset('assets/images/car_rear.jpg', width: 100),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Ratings & Reviews',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text('4.03', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star_half, color: Colors.amber),
            ],
          ),
          SizedBox(height: 8),
          Text('Based on 59 Trips | 22 Reviews'),
          SizedBox(height: 16),
          ListTile(
            leading: CircleAvatar(child: Text('GK')),
            title: Text('GHANSHYAM KHICHAR'),
            subtitle: Text('1 trips with zoomcar'),
            trailing: Icon(Icons.star, color: Colors.amber),
          ),
          Text(
            'Car was fully fit for driving in all aspects. Had a smooth driving experience. It was my first time using zoomcar. So didn\'t kn...',
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text('Check Availability'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}


