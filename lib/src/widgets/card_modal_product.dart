import 'package:animate_do/animate_do.dart';
import 'package:client_flutter_crud_node/src/widgets/flush_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../dto/requestDTO/product_selected.dart';
import '../provider/products_in_out_provider.dart';
import '../utils/my_colors.dart';

class CardModalProduct extends StatefulWidget {
  ProductSelected? productSelectedTempSet;
  CardModalProduct(this.productSelectedTempSet, {Key? key}) : super(key: key);

  @override
  State<CardModalProduct> createState() => _CardModalProductState();
}

class _CardModalProductState extends State<CardModalProduct> {
  TextEditingController controlCantidad = TextEditingController();

  TextEditingController controlPrecio = TextEditingController();

  late ProductSelected productSelectedTempSet;

  @override
  void initState() {
    super.initState();
    if (widget.productSelectedTempSet != null) {
      productSelectedTempSet = widget.productSelectedTempSet!;

      controlCantidad.text = "${productSelectedTempSet.cantidadSelected}";
      controlCantidad.selection = TextSelection.fromPosition(
          TextPosition(offset: controlCantidad.text.length));

      controlPrecio.text = "${productSelectedTempSet.precioCompra}";
      controlPrecio.selection = TextSelection.fromPosition(
          TextPosition(offset: controlPrecio.text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    var productSelectedProvider = Provider.of<ProductsInOutProvider>(context);

    return SafeArea(
      top: true,
      right: false,
      bottom: true,
      left: false,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(137, 4, 40, 82),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            SingleChildScrollView(
              child: ZoomIn(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  // height: 300,
                  // margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 100,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text("Ingrese Precio y Cantidad"),
                        ],
                      ),
                      _txtDatosQuantityOrPrice(
                        'Cantidad',
                        Icons.format_list_numbered_rounded,
                        9,
                        TextInputType.number,
                        controlCantidad,
                        onlyNumbers: true,
                        // read: true,
                      ),
                      _txtDatosQuantityOrPrice(
                        'Precio',
                        Icons.monetization_on,
                        10,
                        TextInputType.number,
                        controlPrecio,
                        twoDecimals: true,
                        // read: true,
                      ),
                      _buttomRegistrarOrUpdate(productSelectedProvider),
                      _buttomRemoveProductFromCart(
                          productSelectedProvider, Colors.red)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _txtDatosQuantityOrPrice(String label, IconData icon, int maxLength,
      TextInputType type, TextEditingController controller,
      {bool onlyNumbers = false, bool twoDecimals = false, bool read = false}) {
    return Container(
      height: 80,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: MyColors.secondaryColorOpacity,
          // borderRadius: BorderRadius.circular(25),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          )),
      child: TextField(
        readOnly: read,
        style: const TextStyle(fontSize: 20),
        controller: controller,
        maxLength: maxLength,
        keyboardType: type,
        inputFormatters: [
          if (twoDecimals && onlyNumbers == false)
            //FUNCIONA  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
            //https://www.debuggex.com/r/4OwPfvp8lhwV_GZC
            //https://regex101.com/
            //FUNCIONA con 2 decimales
            FilteringTextInputFormatter.allow(
                RegExp(r'^\d+((.)|(.\d{0,2})?)$')),
          if (onlyNumbers && twoDecimals == false)
            FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          // hintText: hintText,
          hintStyle: TextStyle(
            color: MyColors.primaryColor,
          ),
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buttomRegistrarOrUpdate(
      ProductsInOutProvider productSelectedProvider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: () async {
          if (controlCantidad.text.trim().isNotEmpty ||
              controlPrecio.text.trim().isNotEmpty) {
            ProductSelected updateProduct = productSelectedTempSet;
            updateProduct.cantidadSelectedSet = int.parse(controlCantidad.text);
            updateProduct.precioCompraSet = double.parse(controlPrecio.text);

            //ponemos un nuevo obj del producto actualizado
            productSelectedProvider.putProductInBucket(updateProduct);
            //cerramos modal
            productSelectedProvider.isActiveModal = false;

            FlushBar().snackBarV2(
                "Producto Actualizado!", Colors.indigo[900]!, context);
          }
        },
        child: const Text(
          "REGISTRAR",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buttomRemoveProductFromCart(
    ProductsInOutProvider productSelectedProvider,
    Color? colors,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            primary: colors ?? MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: () async {
          productSelectedProvider.quitProductInBucket(productSelectedTempSet);
          //cerramos modal
          productSelectedProvider.isActiveModal = false;

          FlushBar().snackBarV2(
              "Producto Actualizado!", Colors.indigo[900]!, context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.delete_forever_rounded),
            Text(
              "RETIRAR",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
