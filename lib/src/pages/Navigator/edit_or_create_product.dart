import 'package:client_flutter_crud_node/src/provider/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:provider/provider.dart';

import '../../dto/responseDTO/product.dart';
import '../../provider/app_state_provider.dart';
import '../../provider/user_provider.dart';
import '../../utils/my_colors.dart';
import '../../widgets/flush_bar.dart';
import '../../widgets/input_data_text_field.dart';

class EditOrCreateProduct extends StatefulWidget {
  Product? product;

  EditOrCreateProduct({this.product, Key? key}) : super(key: key);

  @override
  State<EditOrCreateProduct> createState() => _EditOrCreateProductState();
}

class _EditOrCreateProductState extends State<EditOrCreateProduct>
    with TickerProviderStateMixin {
  Product? product;

  TextEditingController controlNombreProduct = TextEditingController();
  TextEditingController controlComentario = TextEditingController();
  TextEditingController controlCantidad = TextEditingController();
  TextEditingController controlStockMin = TextEditingController();
  TextEditingController controlPrecio = TextEditingController();
  // r'(?=.*?\d)^(([1-9]\d{0,2}(\' + this.thousandsSeparator + '\\d{3})*)|\\d+)?(\\' + this.decimalSeparator + '\\d{2})?\$'
  // CATEGORIA
  // ACTIVE
  TextEditingController barCode = TextEditingController();
  TextEditingController imagen_url = TextEditingController();

  int idCategoria = 0;
  int idProduct = 0;

  int index = 0;

  late TabController _tabController;

  Product? productoCreateOrEdit;

  List<DropdownMenuItem> dropDownMenuItems = [];

  bool? _value;

  late String _registerOrUpdate = "REGISTRAR";
  late String _labelAppBar = "Nuevo Produco";

  late ProductProvider productProvider;
  // late AppStateProvider appStateProvider;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      index = _tabController.index;
    });
    _tabController.index = index;
    // WidgetsBinding.instance!.addPostFrameCallback((_) => _tabController.animateTo(index, duration: const Duration(seconds: 4)));
    if (widget.product != null) {
      product = widget.product!;

      idProduct = product!.id!;
      controlNombreProduct.text = product!.nombre!;
      controlComentario.text = product!.comentario!;
      controlCantidad.text = product!.cantidad!.toString();
      controlStockMin.text = product!.stock_min!.toString();
      controlPrecio.text = product!.precio!.toString();
      barCode.text = product!.barcode!;
      imagen_url.text = product!.imagen_url!;

      _registerOrUpdate = "ACTUALIZAR";
      _labelAppBar = product!.nombre!;
    }
  }

  @override
  void dispose() {
    index = _tabController.index;
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem> getMenuItems(List<Categoria> lista) {
    List<DropdownMenuItem> items = [];
    for (var item in lista) {
      items.add(DropdownMenuItem(
        value: item.id,
        child: Text(item.nombre!),
        onTap: () {},
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    // loadProductData(entitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_labelAppBar),
        backgroundColor: Colors.black,
        bottom: TabBar(
          indicator: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Colors.white,
          ),
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          onTap: (index) {},
          tabs: [
            Tab(
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.orange[500]!,
                  ),
                  const Text("Registro y Edicion")
                ],
              ),
            ),
            Tab(
              child: Row(
                children: const [
                  Icon(
                    Icons.receipt_rounded,
                    color: Colors.grey,
                    size: 50,
                  ),
                  Text("Reporte")
                ],
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Stack(children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  // if (entitiesProvider.productSelected != null)
                  _productImage(product == null ? "" : product!.imagen_url!),
                  TextDataBasic(
                      size: 100,
                      label: 'Nombre',
                      icon: Icons.card_giftcard,
                      maxLength: 50,
                      type: TextInputType.name,
                      controller: controlNombreProduct),
                  TextDataBasic(
                      label: 'Comentario',
                      size: 200,
                      maxLines: null,
                      icon: Icons.comment_bank_outlined,
                      maxLength: 200,
                      type: TextInputType.multiline,
                      controller: controlComentario),
                  _txtDatosQuantityOrPrice(
                    'Cantidad',
                    Icons.format_list_numbered_rounded,
                    9,
                    TextInputType.number,
                    controlCantidad,
                    onlyNumbers: true,
                    read: true,
                  ),
                  _txtDatosQuantityOrPrice(
                    'Stock Min',
                    Icons.format_list_numbered_rounded,
                    9,
                    TextInputType.number,
                    controlStockMin,
                    onlyNumbers: true,
                    read: false,
                  ),
                  _txtDatosQuantityOrPrice(
                    'Precio',
                    Icons.monetization_on,
                    10,
                    TextInputType.number,
                    controlPrecio,
                    twoDecimals: true,
                    read: true,
                  ),
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

                      if (product != null) {
                        //edit
                        idCategoria = idCategoria == 0
                            ? product!.idCategoria!
                            : idCategoria;
                      } else {
                        //new
                        idCategoria = idCategoria == 0 ? 1 : idCategoria;
                      }
                      print("COMBO: $idCategoria");
                      return comboBox(dropDownMenuItems);
                    }
                  }),
                  _switchProduct(),
                  TextDataBasic(
                    size: 100,
                    label: 'Codigo de barras',
                    icon: Icons.document_scanner_outlined,
                    maxLength: 50,
                    type: TextInputType.number,
                    controller: barCode,
                    readOnly: true,
                    onTapSuffix: () async {
                      await Permission.camera.request();
                      String? barcode = await scanner.scan();
                      if (barcode == null) {
                        FlushBar().snackBarV2(
                            "Campos vacios!!!", Colors.red, context);
                      } else {
                        barCode.text = barcode;
                      }
                    },
                    iconSuffix: Icons.photo_camera_sharp,
                  ),
                  TextDataBasic(
                    label: 'URL imagen',
                    size: 150,
                    maxLines: null,
                    icon: Icons.card_giftcard,
                    // maxLength: 50,
                    type: TextInputType.name,
                    controller: imagen_url,
                    iconSuffix: Icons.delete_forever_sharp,
                    colorIconSuffix: Colors.red,
                    onTapSuffix: () {
                      imagen_url.clear();
                    },
                  ),
                  _buttomRegistrarOrUpdate(),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buttomRegistrarOrUpdate() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: () async {
          if (validarCamposVacios()) {
            var rpta = productProvider.productAddOrEdit(productoCreateOrEdit!);

            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              //SI EL TECLADO ESTA ACTIVO LO QUITAMOS
              FocusManager.instance.primaryFocus!.unfocus();
            }

            rpta.then((value) async {
              switch (value[0]) {
                case 1:
                  FlushBar()
                      .snackBarV2(value[1].toString(), Colors.green, context);
                  //REGRESO A LA PAG ANTERIOR
                  productProvider.getAllProducts("", 1);
                  await Future.delayed(const Duration(seconds: 1));
                  Navigator.pop(context);
                  break;
                case 2:
                  FlushBar()
                      .snackBarV2(value[1].toString(), Colors.red, context);
                  break;
                case 3:
                  FlushBar()
                      .snackBarV2(value[1].toString(), Colors.red, context);
                  break;
                default:
              }
            });
          } else {
            FlushBar().snackBarV2("Campos vacios!!!", Colors.red, context);
          }
        },
        child: Text(
          _registerOrUpdate,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _switchProduct() {
    if (product == null) {
      _value = _value ?? true;
    } else {
      _value = _value ?? product!.active!;
    }
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: MyColors.secondaryColorOpacity,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Habilitado: ",
            style: TextStyle(fontSize: 20),
          ),
          CupertinoSwitch(
            value: _value!,
            onChanged: (newValue) {
              setState(() {
                _value = newValue;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _productImage(String imagen_url) {
    String image = "";
    if (imagen_url.isEmpty) {
      image = 'https://shpl.info/sites/default/files/2020-11/new.jpg';
    } else {
      image = imagen_url;
    }

    return FadeInImage.assetNetwork(
      height: 300,
      width: 300,
      fadeInDuration: const Duration(milliseconds: 500),
      fadeInCurve: Curves.easeInExpo,
      fadeOutCurve: Curves.easeOutExpo,
      placeholder: 'assets/images/gallery.jpg',
      image: image,
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset(
          "assets/images/gallery.jpg",
          height: 300,
          width: 300,
        );
      },
      fit: BoxFit.contain,
    );
  }

  Widget _txtDatosQuantityOrPrice(String label, IconData icon, int maxLength,
      TextInputType type, TextEditingController controller,
      {bool onlyNumbers = false, bool twoDecimals = false, bool read = false}) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: MyColors.secondaryColorOpacity,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
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
        counterText: "", // Agrega esta línea para eliminar el contador de caracteres
        prefixIcon: Icon(
          icon,
          color: MyColors.primaryColor,
        ),
      ),
    ),
    );
  }

  void changedDropDownItem(dynamic value) {
    setState(() {
      idCategoria = value;
    });
  }

  Container comboBox(List<DropdownMenuItem> items) {
    if (items.isNotEmpty) {
      return Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        padding: const EdgeInsets.all(3),
        // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: MyColors.primaryColor, width: 4)),
        child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Categoria"),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                iconSize: 50,
                isExpanded: true,
                value: idCategoria,
                items: items,
                onChanged: changedDropDownItem,
              ),
            ),
          ],
        ),
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

  bool validarCamposVacios() {
    //ADD
    //id = 0
    //nombre
    //comentario
    //barcode (solo con camera) NULL
    //imagen_url NULL
    //id_categoria

    //edit
    //id = id_real

    String controlNombreProductText = controlNombreProduct.text.trim();
    String controlComentarioText = controlComentario.text.trim();

    if (controlNombreProductText.isEmpty) {
      return false;
    }
    if (controlComentarioText.isEmpty) {
      return false;
    }

    productoCreateOrEdit = Product(
      id: idProduct,
      nombre: controlNombreProductText,
      comentario: controlComentarioText,
      barcode: barCode.text.trim(),
      stock_min: int.parse(controlStockMin.text),
      imagen_url: imagen_url.text.trim(),
      idCategoria: idCategoria,
      active: _value,
      id_user: userProvider.userAcceso!.id,
    );

    return true;
  }
}
