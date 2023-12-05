// ignore_for_file: use_build_context_synchronously, sort_child_properties_last, avoid_print

import 'package:client_flutter_crud_node/src/pages/Navigator/edit_or_create_product.dart';
import 'package:client_flutter_crud_node/src/provider/product_provider.dart';
import 'package:client_flutter_crud_node/src/provider/user_provider.dart';
import 'package:client_flutter_crud_node/src/widgets/flush_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../dto/responseDTO/product.dart';
import '../../provider/app_state_provider.dart';
import '../../transitions/right_route.dart';
import '../../utils/my_colors.dart';
import '../../widgets/card_products.dart';

class AlmacenGestion extends StatefulWidget {
  const AlmacenGestion({Key? key}) : super(key: key);

  @override
  State<AlmacenGestion> createState() => _AlmacenGestionState();
}

class _AlmacenGestionState extends State<AlmacenGestion> {
  int itemsCount = 0;
  List<Product> products = [];

  List<DropdownMenuItem> dropDownMenuItems = [];

  int idCategoria = 0;

  bool _value = true;
  late ProductProvider productProvider;
  late UserProvider userProvider;

  Future<void> _getAllProducts(String idCategoria, int active) async {
    await productProvider.getAllProducts(idCategoria, active);

    if (productProvider.lista_products == null ||
        productProvider.lista_products!.isEmpty) {
      setState(() {
        itemsCount = 0;
        products = [];
      });
    } else {
      setState(() {
        itemsCount = productProvider.lista_products!.length;
        products = productProvider.lista_products!;
      });
    }
  }

  List<DropdownMenuItem> getMenuItems(List<Categoria> lista) {
    List<DropdownMenuItem> items = [];
    for (var item in lista) {
      items.add(DropdownMenuItem(
        value: item.id,
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            minHeight: 48,
            minWidth: 170,
          ),
          // color: Colors.blue,
          child: Text(
            item.nombre!,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        // onTap: () {},
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    // entitiesProviderField = Provider.of<EntitiesProvider>(context);

    //TIPICO ERROR DE REFRESCAR CADA RATO, SATURA APP
    // _getAllProducts(entitiesProvider);
    itemsCount = productProvider.lista_products!.length;
    products = productProvider.lista_products!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Flexible(
            child: RefreshIndicator(
              onRefresh: () async {
                await _getAllProducts("", _value == true ? 1 : 0);
              },
              child: Container(
                margin: const EdgeInsets.only(
                  // bottom: 50,
                  top: 10,
                  left: 2,
                  right: 2,
                ),
                // padding: const EdgeInsets.all(25),
                height: double.infinity,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // padding: const EdgeInsets.all(25),
                      // margin: EdgeInsets.only(top: 20, left: 15, bottom: 10),
                      decoration: BoxDecoration(
                        // color: Colors.lightGreenAccent[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Consumer<AppStateProvider>(
                            builder: (context, appStateProvider, child) {
                              if (appStateProvider.categorias == null) {
                                return Container(
                                  width: 100,
                                  color: Colors.amber[200],
                                  child: const Text("Categorias Nulas"),
                                );
                              } else {
                                dropDownMenuItems =
                                    getMenuItems(appStateProvider.categorias!);

                                // if (entitiesProvider.productSelected != null) {
                                //   //edit
                                //   idCategoria = idCategoria == 0
                                //       ? entitiesProvider
                                //           .productSelected!.idCategoria!
                                //       : idCategoria;
                                // } else {
                                //   //new
                                //   idCategoria =
                                //       idCategoria == 0 ? 1 : idCategoria;
                                // }

                                idCategoria =
                                    idCategoria == 0 ? 1 : idCategoria;

                                print("COMBO: $idCategoria");
                                return comboBox(dropDownMenuItems);
                              }
                            },
                          ),
                          _switchProduct()
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (products.isEmpty)
                      Center(
                        child: ProductItems(
                          color: Colors.red[100],
                          imageURL: "",
                          name: "No hay productos que mostrar",
                          precio: "0",
                          cantidad: "0",
                        ),
                      ),
                    if (itemsCount != 0)
                    const SizedBox(height: 5.0),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 32,
                          runSpacing: 20,
                          children: [
                            for (var pro in products)
                              GestureDetector(
                                onTap: () async {
                                  Fluttertoast.showToast(
                                      msg: "Cargando",
                                      gravity: ToastGravity.CENTER_RIGHT,
                                      backgroundColor: Colors.indigo,
                                      toastLength: Toast.LENGTH_SHORT);
                                  var rpta = await productProvider
                                      .getProductByIdOrBarCode(
                                    id: "${pro.id}",
                                    barcode: "",
                                    id_user: "${userProvider.userAcceso!.id!}",
                                  );
                                  if (rpta == null) {
                                    FlushBar().snackBarV2("No cargo el objeto",
                                        Colors.red, context);
                                  } else if (!rpta.state!) {
                                    FlushBar().snackBarV2(
                                        rpta.response!, Colors.red, context);
                                  } else if (rpta.state!) {
                                    Navigator.push(
                                      context,
                                      RightRoute(
                                        page: EditOrCreateProduct(
                                          product: rpta.product,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: ProductItems(
                                  imageURL: pro.imagen_url,
                                  name: pro.nombre,
                                  precio: pro.precio.toString(),
                                  cantidad: pro.cantidad.toString(),
                                  alto: 230,
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, RightRoute(page: EditOrCreateProduct()));
          // Navigator.pushNamed(context, "edit/create_product");
        },
        child: const Icon(
          Icons.add_circle_outline_sharp,
          size: 40,
          color: Colors.green,
        ),
        elevation: 15,
        backgroundColor: Colors.green[100],
      ),
    );
  }

  void changedDropDownItem(dynamic value) {
    setState(() {
      idCategoria = value;

      itemsCount = 0;
      products = [];

      _getAllProducts("$idCategoria", _value == true ? 1 : 0);
    });
  }

  Container comboBox(List<DropdownMenuItem> items) {
    if (items.isNotEmpty) {
     return Container(
        height: 100,  // Increase the height
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: MyColors.primaryColor,
            width: 4,
          ),
        ),
        child: Column(
          children: [
            const Text("Categoria"),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                iconSize: 50,
                value: idCategoria,
                items: items,
                onChanged: changedDropDownItem,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 100,
        color: Colors.amber[200],
        child: const Text(
          "Categorias desactivadas!",
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _switchProduct() {
    return Column(
      children: [
        const Text(
          "Ver Activos:",
          style: TextStyle(color: Colors.white),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: _value == true ? Colors.green : Colors.grey,
          ),
          child: CupertinoSwitch(
            value: _value,
            onChanged: (newValue) {
              setState(() {
                _value = newValue;
                _getAllProducts("", _value == true ? 1 : 0);
              });
            },
          ),
        ),
      ],
    );
  }
}
