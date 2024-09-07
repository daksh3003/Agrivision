import '../models/product.dart';

List<Product> products = [
  const Product(
    name: "Essential Farming Tips",
    description:
        """Crop Rotation: Crop rotation is a practice where different types of crops are planted in a sequence on the same field. This method helps in maintaining soil fertility, reducing soil erosion, and controlling pests and diseases. For example, planting legumes like beans or peas after cereal crops like wheat can replenish nitrogen levels in the soil, as legumes naturally fix atmospheric nitrogen. This reduces the need for chemical fertilizers, leading to healthier and more sustainable farming.
"Efficient Water Management: Water is a critical resource for farming, and efficient management can greatly improve crop yields. Drip irrigation is a precise method that delivers water directly to the roots of plants, minimizing evaporation and runoff. This method not only conserves water but also ensures that crops receive a consistent supply of moisture, which is crucial during dry spells. Additionally, scheduling irrigation during cooler parts of the day (early morning or late evening) can further reduce water loss due to evaporation.""",
    image: 'assets/farm.jpg',
    price: 9.0,
    unit: 'day(s)',
    rating: 4.35,
  ),
  const Product(
    name: "Pesticide Knowledge",
    description:
        """"Natural Pesticides: Using natural pesticides like neem oil or garlic spray can effectively control pests while minimizing harm to beneficial insects, soil organisms, and the environment. Neem oil works by disrupting the life cycle of pests, making it particularly effective against insects like aphids and whiteflies. Garlic spray, on the other hand, acts as a repellent against a wide range of pests, including caterpillars and beetles. These organic options not only protect your crops but also support sustainable farming practices.
Integrated Pest Management (IPM): IPM is a holistic approach that combines multiple strategies to manage pests effectively. It includes using biological controls (like introducing natural predators), cultural practices (like crop rotation and intercropping), mechanical methods (like traps), and chemical controls (as a last resort). By combining these methods, farmers can reduce pest populations while minimizing the use of harmful pesticides, thereby promoting a healthier ecosystem.
Pesticide Safety and Best Practices: When using synthetic pesticides, it’s crucial to follow safety guidelines to protect both yourself and the environment. Always read and adhere to the instructions on the label, use the recommended protective gear (such as gloves and masks), and apply the pesticide at the right time of day to minimize drift and evaporation. Proper storage and disposal of pesticides are also important to prevent contamination of water sources and harm to non-target species.
 """,
    image: 'assets/pesticide.jpg',
    price: 9.99,
    unit: 'kg',
    rating: 3.86,
  ),
  const Product(
    name: "Natural Soil Fertilization Methods",
    description:
        """" Green Manure: Green manure refers to crops that are specifically grown to be plowed back into the soil. Plants like clover, alfalfa, and rye are commonly used as green manure because they grow quickly and add valuable organic matter and nutrients to the soil. These cover crops can improve soil structure, increase moisture retention, and reduce erosion, making the soil more fertile for subsequent crops.
Bone Meal for Phosphorus: Bone meal is a natural fertilizer made from ground animal bones, rich in phosphorus, which is essential for strong root development and flowering in plants. Applying bone meal to your soil can help promote healthy root systems, improve nutrient uptake, and enhance overall plant growth. It’s especially useful in soils that are deficient in phosphorus and can be applied during planting or as a top dressing.
Encouraging Earthworms: Earthworms are often referred to as nature’s tillers. They aerate the soil, improve drainage, and help decompose organic matter, turning it into nutrient-rich humus. You can encourage earthworm activity by maintaining organic matter in your soil, avoiding excessive tilling, and minimizing the use of chemical fertilizers and pesticides. A healthy earthworm population can significantly improve soil fertility and structure, leading to better crop yields.
""",
    image: 'assets/soil.jpg',
    price: 8.44,
    unit: 'piece',
    rating: 4.18,
  ),
  const Product(
    name: "Crop Selection Based on Soil Type",
    description:
        """"Clay Soil: Clay soil is dense and heavy, with the ability to retain water, making it ideal for moisture-loving crops. Crops like broccoli, cabbage, and rice thrive in clay soils due to their ability to withstand waterlogged conditions. However, proper drainage management is essential to avoid root rot and ensure healthy plant growth.
Sandy Soil: Sandy soil is light and drains quickly, which makes it suitable for crops that prefer well-drained conditions. Carrots, potatoes, and peanuts are examples of crops that perform well in sandy soils. To improve water retention in sandy soil, adding organic matter like compost can be beneficial. Sandy soils also warm up quickly in the spring, giving early crops an advantage.
Loamy Soil: Loamy soil is considered the best soil type for most crops due to its balanced texture, which provides good drainage while retaining adequate moisture and nutrients. Crops like tomatoes, lettuce, and corn thrive in loamy soils because of their need for a consistent supply of water and nutrients. Loamy soil is easy to work with and is ideal for vegetable gardening and mixed cropping. """,
    image: 'assets/crop.jpg',
    price: 14.52,
    unit: 'kg',
    rating: 5.0,
  ),
  const Product(
    name: "Government Schemes and Subsidies",
    description:
        """" Pradhan Mantri Fasal Bima Yojana (PMFBY): This government-backed crop insurance scheme provides financial assistance to farmers in the event of crop failure due to natural disasters like floods, droughts, or pest attacks. The scheme covers a wide range of crops and ensures that farmers can recover from losses and continue their agricultural activities without falling into debt.
Kisan Credit Card (KCC): The Kisan Credit Card scheme offers farmers access to affordable credit, which they can use to meet their agricultural needs, such as buying seeds, fertilizers, and equipment. The loans under this scheme are offered at low-interest rates, making it easier for farmers to invest in their farms and improve productivity without financial strain.
PM-Kisan Samman Nidhi: This direct income support scheme provides eligible farmers with ₹6,000 per year in three equal installments. The funds are directly transferred to the farmer's bank account, helping them cover basic expenses, invest in their farms, and support their families. This scheme aims to provide financial stability to small and marginal farmers across the country.
.""""",
    image: 'assets/subsidy.png',
    price: 14.77,
    unit: 'piece',
    rating: 5.0,
  ),
  const Product(
    name: "Farming Tools Knowledge",

    description:
        """ Seed Drill: A seed drill is an essential tool for modern farming that ensures even distribution of seeds at the correct depth, leading to uniform germination and better crop yields. By planting seeds in well-spaced rows, the seed drill reduces seed wastage and allows for easier weeding and irrigation. This tool is particularly beneficial for large-scale farmers looking to increase efficiency and productivity.
Rotavator: The rotavator is a versatile soil preparation tool that breaks up and tills the soil to a fine consistency, making it ready for sowing seeds. It helps in weed control and mixes crop residues into the soil, improving its organic content. Using a rotavator can significantly reduce the time and labor required for soil preparation, making it a valuable tool for both small and large farms.
Hand-Held Sprayer: For small to medium-sized farms, a hand-held sprayer is a practical tool for applying pesticides, herbicides, and fertilizers evenly across the field. These sprayers are lightweight, easy to operate, and allow for precise application, reducing the amount of chemicals used and minimizing environmental impact.""",
    image: 'assets/farmTool.jpg',
    price: 6.84,
    unit: 'kg',
    rating: 3.22,
  ),

  const Product(
    name: "Daily Farming Updates",
      description:""" Weather Forecasts: Access to accurate and timely weather forecasts is crucial for effective farm management. By staying informed about upcoming weather conditions, farmers can plan their irrigation schedules, protect crops from extreme weather events, and optimize fieldwork for better productivity.
Market Prices: Keeping track of daily market prices allows farmers to make informed decisions about when and where to sell their produce for the best returns. This information can help farmers avoid selling during periods of low prices and maximize their profits during high-demand seasons.
Agricultural News and Trends: Stay updated with the latest developments in the agricultural sector, including new government policies, innovative farming techniques, and emerging market trends. This knowledge can help farmers stay competitive, adopt new technologies, and take advantage of available opportunities to improve their farming practices.""",
      image: 'assets/updatesfarm.jpg',
      price: 6.84,
      unit: 'kg',
      rating: 3.22,
  )
];
