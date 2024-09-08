import '../models/seller_product.dart';

List<SellerProduct> sellerProducts = [
  const SellerProduct(
    name: "Benefits for Sellers",
    description:
    """Direct Access to Farmers: Highlight how sellers can connect directly with local farmers to reduce middlemen and access fresh produce.
Cost-Efficiency: Mention how the platform provides competitive prices due to the absence of intermediaries.
Diverse Range of Products: Emphasize the availability of a wide range of fresh produce, grains, and farm products.
Transparency and Quality Assurance: Guarantee that all products are fresh and meet certain quality standards.
""",
    image: 'assets/buying.png',
    price: 9.0,
    unit: 'day(s)',
    rating: 4.35,
  ),
  const SellerProduct(
    name: "How It Works",
    description:
    """A visual or text-based breakdown of how sellers can:
Browse available farm products.
Place bulk orders.
Coordinate delivery or pick-up schedules with farmers.
Track orders and manage payments.
 """,
    image: 'assets/howitworks.png',
    price: 9.99,
    unit: 'kg',
    rating: 3.86,
  ),
  const SellerProduct(
    name: " Categories",
    description:
    """Featured Product Listings: Show off the most popular items, such as seasonal fruits, vegetables, grains, dairy, or organic produce. Highlight these with brief descriptions, pricing details, and “Add to Cart” buttons.
Category Filters: Allow sellers to browse by categories such as "Fruits," "Vegetables," "Organic Produce," "Dairy," and "Livestock." Make the filters easily accessible and visible on the page to streamline navigation.
 This section acts like a mini marketplace on the home page, where sellers can get a taste of the product variety. Each product should have a clean, high-quality image, and prices should be clearly marked.""",
    image: 'assets/freshproduce.png',
    price: 8.44,
    unit: 'piece',
    rating: 4.18,
  ),
  const SellerProduct(
    name: "Seller Testimonials",
    description:
    """Testimonials from existing sellers can be powerful in building trust. Feature quotes from satisfied users who highlight the quality of the produce, ease of use, and reliability of the platform.
Design Tip: Pair each testimonial with a small image of the seller (or store) and their name, business name, and location to make the feedback more relatable and authentic """,
    image: 'assets/sellertestimonial.jpg',
    price: 14.52,
    unit: 'kg',
    rating: 5.0,
  ),
  const SellerProduct(
    name: "Special Offers and Discounts",
    description:
    """Entice sellers with promotions such as bulk purchase discounts, seasonal offers, or reduced delivery fees for first-time users. Include a countdown timer or banner for time-limited offers to create urgency.
.""""",
    image: 'assets/Discount.png',
    price: 14.77,
    unit: 'piece',
    rating: 5.0,
  ),
  const SellerProduct(
    name: "Sustainability & Local Support",

    description:
    """Emphasize the impact that sellers have by supporting local farmers. Focus on how sourcing products locally not only ensures freshness but also helps reduce the carbon footprint and supports sustainable farming practices""",
    image: 'assets/supportfarmers.jpg',
    price: 6.84,
    unit: 'kg',
    rating: 3.22,
  ),

  const SellerProduct(
    name: " FAQs",
    description:"""Anticipate common questions sellers might have about the platform. Cover topics such as:
Delivery options
Payment methods
How to handle product returns
Minimum order quantities""",
    image: 'assets/FAQs.png',
    price: 6.84,
    unit: 'kg',
    rating: 3.22,
  ),

  const SellerProduct(
    name: "Contact Information and Support",
    description:"""Provide sellers with multiple ways to get in touch for assistance. Include:
A live chat option for immediate support
A dedicated support email address
A phone number for direct inquiries
A contact form""",
    image: 'assets/CustomerService.png',
    price: 6.84,
    unit: 'kg',
    rating: 3.22,
  )
];
