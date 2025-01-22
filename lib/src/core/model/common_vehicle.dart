class CommonVehicle {
  final PickupLocation pickupLocation;
  final String id;
  final Vendor vendor;
  final Model model;
  final int year;
  final String variant;
  final int pricePerDay;
  final String availabilityStatus;
  final int engineCc;
  final String fuelType;
  final String bodyType;
  final int mileage;
  final List<String> features;
  final List<String> images;
  final int weight;
  final int topSpeed;
  final int horsepower;
  final int torque;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  CommonVehicle({
    required this.pickupLocation,
    required this.id,
    required this.vendor,
    required this.model,
    required this.year,
    required this.variant,
    required this.pricePerDay,
    required this.availabilityStatus,
    required this.engineCc,
    required this.fuelType,
    required this.bodyType,
    required this.mileage,
    required this.features,
    required this.images,
    required this.weight,
    required this.topSpeed,
    required this.horsepower,
    required this.torque,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  }

class PickupLocation {
  final String type;
  final List<double> coordinates;

  PickupLocation({
    required this.type,
    required this.coordinates,
  });


}

class Vendor {
  final String id;
  final String businessName;

  Vendor({
    required this.id,
    required this.businessName,
  });


}

class Model {
  final String id;
  final Make make;
  final String model;
  final String type;
  final List<String> variants;

  Model({
    required this.id,
    required this.make,
    required this.model,
    required this.type,
    required this.variants,
  });


}

class Make {
  final String id;
  final String name;

  Make({
    required this.id,
    required this.name,
  });

}
