class NewCartDetails {
  final String name;
  final String image;
  final double price;

  NewCartDetails({required this.name, required this.image, required this.price});
}

// Sample Data
List<NewCartDetails> newCartDetails = [
  NewCartDetails(name: 'Rake',      image: "assets/rake.jpg", price: 29.99),
  NewCartDetails(name: 'Product 2', image: "assets/services/machinery.jpg", price: 19.99),
  NewCartDetails(name: 'Product 3', image: 'assets/shovel.jpg', price: 9.99),
  NewCartDetails(name: 'Product 4', image: 'assets/pesti.jpg', price: 49.99),
];
