import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Products>> fetchProductsData() async {
  final response = await http.get(Uri.parse('https://dummyjson.com/products'));

  if (response.statusCode == 200) {
    var data = json.decode(response.body)['products'] as List;
    List<Products> productsList =
        data.map((i) => Products.fromJson(i)).toList();
    return productsList;
  } else {
    throw Exception('Failed to load products');
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Products>>(
            future: fetchProductsData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, i) {
                      var item = snapshot.data![i];

                      return Card(
                        color: const Color.fromARGB(255, 181, 234, 183),
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.network(
                                item.thumbnail!,
                                width: MediaQuery.of(context).size.width * 1.25,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title.length > 20
                                          ? item.title.substring(0, 20) + '...'
                                          : item.title,
                                    ),
                                  ),
                                  // Displaying the price
                                  Text('\$${item.price}'),
                                  // Eye icon
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_red_eye_sharp),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Wrap(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: item.images
                                                              .map((url) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Image.network(
                                                                  url,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      2.5),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(item.title,
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(item.description!),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              '\$${item.price}',
                                                              style: const TextStyle(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          // const Spacer(),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Wrap(
                                                              children: [
                                                                const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .yellow),
                                                                Text(
                                                                    '${item.rating}'),
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                            // alignment: Alignment
                                                            //     .bottomRight,
                                                            child: Wrap(
                                                              alignment:
                                                                  WrapAlignment
                                                                      .start,
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .local_offer,
                                                                    color: Colors
                                                                        .green),
                                                                Text(
                                                                    '${item.discountPercentage!}'),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(width: 10),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                ],
                              ),
                              // Description below the Row
                              SizedBox(height: 4.0),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(item.description!),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}

class Products {
  int? id;
  String title;
  String? description;
  int? price;
  double? discountPercentage;
  dynamic rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<dynamic> images;

  Products({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      description: json['description'],
      id: json['id'],
      title: json['title'],
      brand: json['brand'],
      price: json['price'],
      discountPercentage: json['discountPercentage'],
      rating: json['rating'],
      stock: json['stock'],
      category: json['category'],
      thumbnail: json['thumbnail'],
      images: json['images'] ?? [], // Default to empty list if null
    );
  }
}
