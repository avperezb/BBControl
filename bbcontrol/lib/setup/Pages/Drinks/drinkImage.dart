import 'package:flutter/cupertino.dart';

class DrinkImage extends StatefulWidget {

  var img;
  var placeholder;
  DrinkImage(String url){
    img = Image.network(url);
    placeholder = AssetImage('assets/images/logo.png');
  }

  @override
  _DrinkImageState createState() => _DrinkImageState();
}

class _DrinkImageState extends State<DrinkImage> {
  bool _loaded = false;

  void initState() {
    super.initState();
    widget.img.image.resolve(ImageConfiguration()).addListener((i, b) {
      if (mounted) {
        setState(() => _loaded = true);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
