import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for rentals',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Category Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Chip(label: Text('All')),
                    SizedBox(width: 8.0),
                    Chip(label: Text('Bikes')),
                    SizedBox(width: 8.0),
                    Chip(label: Text('Cars')),
                    SizedBox(width: 8.0),
                    Chip(label: Text('E-Vehicles')),
                    SizedBox(width: 8.0),
                    Chip(label: Text('Scooters')),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Date Picker
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                  
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Tue Oct 08 2024 - Tue Oct 15 2024'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Featured Rental
              Text('Featured Rental', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network('https://images.pexels.com/photos/819805/pexels-photo-819805.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          ),
                        ),
                    Text('Premium Road Bike', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('High performance for enthusiasts'),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('\$15/hour')),
                        Expanded(
                          
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Rent Now'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Popular Rentals
              Text('Popular Rentals', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                children: List.generate(4, (index) {
                  return Container(
                   
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network('https://images.pexels.com/photos/819805/pexels-photo-819805.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          ),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('City Bike', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('\$5/hour'),
                             
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}