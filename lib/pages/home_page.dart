import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:network/models/UserModel.dart';

import '../models/product_model.dart';
import '../services/network_service.dart';

class HomePage extends StatefulWidget {
  UserModel userModel;
  HomePage({super.key, required this.userModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AllProductModel? allProductModel;
  List<Products> list = [];
  bool isLoading = false;
  TextEditingController textEditingController = TextEditingController();

  Future<void> getAllProducts() async {
    isLoading = false;
    String? result =
    await NetworkService.getData(api: NetworkService.apiGetAllProduct, param: NetworkService.paramEmpty());
    if (result != null) {
      allProductModel = allProductModelFromJson(result);
      list = allProductModel!.products!;
      log(list.toString());
      isLoading = true;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> updateProduct(Products product) async {
    String? result = await NetworkService.updateData(
        api: NetworkService.apiGetAllProduct, param: NetworkService.paramEmpty(), data: product.toJson());
  }

  Future<void> searchProduct(String text) async {
    isLoading = false;
    list = [];
    setState(() {});
    String? result = await NetworkService.getData(
        api: NetworkService.apiSearchProduct, param: NetworkService.paramSearchProduct(text));
    if (result != null) {
      allProductModel = allProductModelFromJson(result);
      list = allProductModel!.products!;
      isLoading = true;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> searchProductId(int i) async {
    isLoading = false;
    list = [];
    setState(() {});
    String? result = await NetworkService.getData(
        api: "${NetworkService.apiGetAllProduct}/$i", param: NetworkService.paramEmpty());
    if (result != null) {
      allProductModel = allProductModelFromJson(result);
      list = allProductModel!.products!;
      isLoading = true;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> getCategory(String text) async {
    isLoading = false;
    list = [];
    setState(() {});
    String? result = await NetworkService.getData(
        api: "${NetworkService.apiCategoryProducts}$text",
        param: NetworkService.paramEmpty());
    if (result != null) {
      allProductModel = allProductModelFromJson(result);
      list = allProductModel!.products!;
      isLoading = true;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: TextField(
              onChanged: (text) async {
                int.tryParse(text)!=null ?
                await searchProductId(int.tryParse(text)!) :
                    await searchProduct(text);
                setState(() {});
              },
              controller: textEditingController,
              decoration: const InputDecoration(
                labelText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, index) {
                var pr = list[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {},
                          autoClose: false,
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                          borderRadius: BorderRadius.circular(20),
                        ),
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          autoClose: false,
                          label: 'Delete',
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ],
                    ),
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Colors.blueGrey.withOpacity(0.3),
                      elevation: 0,
                      child: ListTile(
                        leading: Image.network(pr.images?[0] ??
                            "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg"),
                        title: Text(pr.title ?? "No title"),
                        titleTextStyle: const TextStyle(
                          color: Colors.white
                        ),
                        subtitle: Text("Price: ${pr.price}\$"),
                        subtitleTextStyle: const TextStyle(
                          color: Colors.white
                        ),
                        trailing: Text(
                          pr.category ?? "",
                          style: const TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      "Categories",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.userModel.image!),
                    ),
                
                    const SizedBox(height: 5),
                
                    Text(
                      "${widget.userModel.username} ${widget.userModel.lastName}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24
                      ),
                    )
                  ],
                ),
              )
            ),
            ListTile(
              title: const Text(
                  "SmartPhones",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("smartphones");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Laptops",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("laptops");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Fragrances",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("fragnances");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Skincare",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("skincare");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Groceries",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("groceries");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Home-decoration",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("home-decoration");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Furniture",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("furniture");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Tops",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("tops");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Womens-dresses",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("womens-dresses");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Womens-shoes",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("womens-shoes");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Men-shirts",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("men-shirts");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Mens-shoes",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("mens-shoes");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Mens-wacthes",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("mens-watches");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Womens-watches",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("womens-watches");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Womens-bags",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("womens-bags");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Womens-jewellery",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("womens-jewellery");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Sunglasses",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("sunglasses");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Automative",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("automative");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Motorcycle",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("motorcycle");
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                  "Lighting",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: ()async{
                await getCategory("lighting");
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

}
