import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/my_colors.dart';

class ProductItems extends StatelessWidget {
  final String? imageURL;
  final String? name;
  final String? cantidad;
  final String? precio;
  final Color? color;
  final double? ancho;
  final double? alto;
  //
  final bool? counterShow;
  final int? counterCantidad;

  const ProductItems({
    Key? key,
    this.imageURL,
    this.name,
    this.precio,
    this.cantidad,
    this.color,
    this.ancho,
    this.alto,
    this.counterShow = false,
    this.counterCantidad = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color ?? MyColors.secondaryColorOpacity,
            borderRadius: BorderRadius.circular(25),
          ),
          width: ancho ?? 170,
          height: alto ?? 220,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              imageURL!.isNotEmpty
                  ? FadeInImage.assetNetwork(
                      width: 120,
                      height: 125,
                      fadeInDuration: const Duration(milliseconds: 500),
                      fadeInCurve: Curves.easeInExpo,
                      fadeOutCurve: Curves.easeOutExpo,
                      placeholder: 'assets/images/gallery.jpg',
                      image: imageURL!,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/gallery.jpg",
                          height: 100,
                          width: 100,
                        );
                      },
                      fit: BoxFit.scaleDown,
                    )
                  : Image.asset(
                      'assets/images/gallery.jpg',
                      height: 100,
                      width: 100,
                    ),
              if (name != null)
                Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text: name!,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (precio != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Precio:"),
                            Text(
                              precio!,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      if (cantidad != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Cantidad:"),
                            Text(
                              cantidad!,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                )
            ],
          ),
        ),
        // if (counterShow!)
        //   Positioned(
        //     child: CircleAvatar(
        //       child: Text("$counterCantidad"),
        //     ),
        //   )
      ],
    );
  }
}
