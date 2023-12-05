// ignore_for_file: use_build_context_synchronously, sort_child_properties_last, deprecated_member_use

import 'package:client_flutter_crud_node/src/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

//import '../../dto/requestDTO/product_selected.dart';
import '../../dto/requestDTO/product_selected.dart';
import '../../provider/products_in_out_provider.dart';
import '../../provider/user_provider.dart';
import '../../widgets/card_modal_product.dart';
import '../../widgets/card_products.dart';
import '../../widgets/flush_bar.dart';

class IngresoAlmacen extends StatefulWidget {
  const IngresoAlmacen({Key? key}) : super(key: key);

  @override
  State<IngresoAlmacen> createState() => _IngresoAlmacenState();
}

class _IngresoAlmacenState extends State<IngresoAlmacen> {
  ProductSelected? productSelectedTempSet;
  late ProductProvider productProvider;
  late ProductsInOutProvider productSelectedProvider;
  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    productSelectedProvider = Provider.of<ProductsInOutProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 2, right: 2, top: 150, bottom: 10),
            height: double.infinity,
            child: ListView(
              children: [
                if (productSelectedProvider.bucketProductSelected.isEmpty)
                  Center(
                    child: ProductItems(
                      color: Colors.red[100],
                      imageURL: "",
                      name: "No hay productos seleccionados!",
                      ancho: 250,
                    ),
                  ),
                if (productSelectedProvider.bucketProductSelected.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 32,
                      runSpacing: 10,
                      children: [
                        for (var key in productSelectedProvider
                            .bucketProductSelected.keys)
                          GestureDetector(
                            onTap: () {
                              productSelectedProvider.isActiveModal = true;
                              Fluttertoast.showToast(msg: "TEST ITEM MODAL");
                              //OPEN MODAL
                              //FOR CANTIDAD & PRECIO GLOBAL

                              //pasamos el producto del bucle
                              setState(() {
                                productSelectedTempSet = productSelectedProvider
                                    .bucketProductSelected[key]!;
                              });

                              //INTERACTURAR CON EL MAP
                              //contador de map map.lenght
                              //remove map.remove(key);
                            },
                            child: ProductItems(
                              counterShow: true,
                              imageURL: productSelectedProvider
                                  .bucketProductSelected[key]!.imagenUrl,
                              name: productSelectedProvider
                                  .bucketProductSelected[key]!.nombre,
                              counterCantidad: productSelectedProvider
                                  .bucketProductSelected[key]!
                                  .cantidadSelected!,
                            ),
                          ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.1,
            bottom: 14,
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue[900],
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "${productSelectedProvider.bucketProductSelected.length}" +
                    " Productos Seleccionados",
                style: const TextStyle(fontSize: 17, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 15,
            child: buttonIngresoAlmacen(productSelectedProvider),
          ),
          Positioned(
            right: 15,
            bottom: 80,
            child: buttomCamera(),
          ),
          // Positioned(
          //   right: 10,
          //   bottom: 10,
          //   child: buttomCameraV2(entitiesProvider),
          // ),
          Visibility(
            visible: productSelectedProvider.isActiveModal,
            child: WillPopScope(
              child: CardModalProduct(productSelectedTempSet),
              onWillPop: () async {
                productSelectedProvider.isActiveModal = false;
                return false;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buttomCamera() {
    return FloatingActionButton(
      isExtended: true,
      onPressed: () async {
        try {
          //abri la camara de codigo de barra
          await Permission.camera.request();
          String? barcode = await scanner.scan();
          if (mounted) {
            FlushBar().snackBarV2("$barcode", Colors.blue, context,
                milliseconds: 5000);
          }

          if (barcode == null) {
            if (mounted) {
              FlushBar().snackBarV2("No hay codigo!", Colors.red, context);
            }
          } else {
            // barcode;
            var value = await productProvider.getProductByIdOrBarCode(
              id: "",
              barcode: barcode,
              id_user: "${userProvider.userAcceso!.id!}",
            );
            if (value != null && value.product != null) {
              //agregar producto en el MAP
              var producto = value.product;
              ProductSelected productSelected = ProductSelected(
                id: producto!.id,
                imagenUrl: producto.imagen_url,
                nombre: producto.nombre,
                cantidadSelected: 0,
                precioCompra: 0,
              );
              int rpta =
                  productSelectedProvider.putProductInBucket(productSelected);
              switch (rpta) {
                case 2:
                  FlushBar().snackBarV2("El producto ya esta seleccionado",
                      Colors.purple[900]!, context);
                  break;
                default:
              }
            } else {
              if (mounted) {
                FlushBar()
                    .snackBarV2("No cargo el producto!", Colors.red, context);
              }
            }
          }
        } catch (e) {
          if (mounted) {
            FlushBar().snackBarV2("Error: $e", Colors.red, context);
          }
        }
      },
      child: const Icon(
        Icons.camera_alt_rounded,
        size: 40,
      ),
      backgroundColor: Colors.green[700],
      tooltip: "BUSCAR POR CODIGO DE BARRA",
    );
  }

  Widget buttonIngresoAlmacen(ProductsInOutProvider productsInOutProvider) {
    return Tooltip(
      message: "INGRESAR PRODUCTOS!!!",
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.blue[900],
          elevation: 13,
          primary: Colors.blue,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(4),
        ),
        onPressed: () {
          var res = productsInOutProvider.sendCompraSerial();
          res.then((value) {
            if (value[0] == 1) {
              Fluttertoast.showToast(msg: "${value[1]}");
            } else {
              Fluttertoast.showToast(
                  msg: "${value[1]}", backgroundColor: Colors.red);
            }
          });
        },
        child: const Icon(
          Icons.add,
          size: 45,
        ),
      ),
    );
  }
}
