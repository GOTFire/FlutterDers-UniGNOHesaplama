import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness:  Brightness.dark,
      ),
      home: AnaEkran(),
    );
  }
}

class AnaEkran extends StatefulWidget {
  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfKredi = 4;
  List<Ders> tumDersler;
  double ortalama = 0;
  static int dismisSayac = 0;

  var formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Üniversite ortalama hesaplama"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formkey.currentState.validate()) {
            formkey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(builder: (context, orientationNe) {
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          return AnaGovdeDikey();
        } else {
          return AnaGovdeYatay();
        }
      }),
    );
  }

  Widget AnaGovdeDikey() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Static  veri giriş alanı
          Container(
            child: Container(
              padding: EdgeInsets.all(10),
              //color: Colors.blue,
              child: Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Dersin adını gir",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 3)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 3)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 3)),
                        labelStyle: TextStyle(fontSize: 22),
                        hintStyle: TextStyle(fontSize: 22),
                        hintText: "Lütfen dersin adını gir",
                      ),
                      validator: (girilen) {
                        if (girilen.length <= 0) {
                          return "Dersin adını girmelisin";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (girilmisOlan) {
                        dersAdi = girilmisOlan;
                        setState(() {
                          tumDersler.add(Ders(dersAdi, dersHarfKredi, dersKredi,
                              rastGeleRenk()));
                          _ortalamaHesapla();
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.orange, width: 3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                items: dropElemanlari(),
                                value: dersKredi,
                                onChanged: ((secilen) {
                                  setState(() {
                                    dersKredi = secilen;
                                  });
                                })),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.orange, width: 3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                items: harfNotu(),
                                value: dersHarfKredi,
                                onChanged: ((gelen) {
                                  setState(() {
                                    dersHarfKredi = gelen;
                                  });
                                })),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
              height: 70,
              color: Colors.blue,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: tumDersler.length == 0
                            ? "Ders eklermisin?"
                            : "Ortalaman ",
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                    TextSpan(
                        text: tumDersler.length == 0
                            ? ""
                            : ortalama.toStringAsFixed(2),
                        style: TextStyle(fontSize: 30, color: Colors.yellow))
                  ]),
                ),
              )),
          //Notların listelendiği alan
          Expanded(
              child: ListView.builder(
            itemBuilder: _listeOlustur,
            itemCount: tumDersler.length,
          ))
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dropElemanlari() {
    List<DropdownMenuItem<int>> gecici = [];

    for (int i = 1; i <= 10; i++) {
      gecici.add(DropdownMenuItem(
        value: i,
        child: Text(
          "$i Kredi  ",
          style: TextStyle(fontSize: 30),
        ),
      ));
    }
    return gecici;
  }

  List<DropdownMenuItem<double>> harfNotu() {
    List<DropdownMenuItem<double>> geciciListe = [
      DropdownMenuItem(
          child: Text(
            " AA ",
            style: TextStyle(fontSize: 30),
          ),
          value: 4),
      DropdownMenuItem(
          child: Text(
            " AB ",
            style: TextStyle(fontSize: 30),
          ),
          value: 3.5),
      DropdownMenuItem(
          child: Text(
            " BB ",
            style: TextStyle(fontSize: 30),
          ),
          value: 3),
      DropdownMenuItem(
          child: Text(
            " BC ",
            style: TextStyle(fontSize: 30),
          ),
          value: 2.5),
      DropdownMenuItem(
          child: Text(
            " CC ",
            style: TextStyle(fontSize: 30),
          ),
          value: 2),
      DropdownMenuItem(
          child: Text(
            " CD ",
            style: TextStyle(fontSize: 30),
          ),
          value: 1.5),
      DropdownMenuItem(
          child: Text(
            " DD ",
            style: TextStyle(fontSize: 30),
          ),
          value: 1),
      DropdownMenuItem(
          child: Text(
            " FF ",
            style: TextStyle(fontSize: 30),
          ),
          value: 0),
    ];
    return geciciListe;
  }

  Widget _listeOlustur(BuildContext context, int index) {
    return Dismissible(
      key: Key((dismisSayac++).toString()),
      onDismissed: (yon) {
        setState(() {
          tumDersler.removeAt(index);
          _ortalamaHesapla();
        });
      },
      child: Card(
        color: tumDersler[index].renk,
        child: ListTile(
          leading: Icon(Icons.book),
          trailing: Icon(Icons.arrow_forward),
          title: Text(tumDersler[index].ad),
          subtitle: Text(
              "kredi : ${tumDersler[index].kredi} not : ${tumDersler[index].harfDegeri}"),
        ),
      ),
    );
  }

  void _ortalamaHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;

    for (var oanki in tumDersler) {
      var kredi = oanki.kredi;
      var not = oanki.harfDegeri;

      toplamNot += kredi * not;
      toplamKredi += kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Color rastGeleRenk() {
    return Color.fromARGB(50+Random().nextInt(155), 50+Random().nextInt(155),
        Random().nextInt(155)+60, Random().nextInt(155));
  }

  Widget AnaGovdeYatay() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                //color: Colors.blue,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Dersin adını gir",
                          border: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.orange, width: 3)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.orange, width: 3)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.purple, width: 3)),
                          labelStyle: TextStyle(fontSize: 22),
                          hintStyle: TextStyle(fontSize: 22),
                          hintText: "Lütfen dersin adını gir",
                        ),
                        validator: (girilen) {
                          if (girilen.length <= 0) {
                            return "Dersin adını girmelisin";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (girilmisOlan) {
                          dersAdi = girilmisOlan;
                          setState(() {
                            tumDersler.add(Ders(dersAdi, dersHarfKredi, dersKredi,
                                rastGeleRenk()));
                            _ortalamaHesapla();
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Colors.orange, width: 3),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  items: dropElemanlari(),
                                  value: dersKredi,
                                  onChanged: ((secilen) {
                                    setState(() {
                                      dersKredi = secilen;
                                    });
                                  })),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Colors.orange, width: 3),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  items: harfNotu(),
                                  value: dersHarfKredi,
                                  onChanged: ((gelen) {
                                    setState(() {
                                      dersHarfKredi = gelen;
                                    });
                                  })),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),Expanded(
                child: Container(
                  margin: EdgeInsets.all(9),
                    color: Colors.blue,
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: tumDersler.length == 0
                                  ? "Ders eklermisin?"
                                  : "Ortalaman ",
                              style: TextStyle(fontSize: 30, color: Colors.white)),
                          TextSpan(
                              text: tumDersler.length == 0
                                  ? ""
                                  : ortalama.toStringAsFixed(2),
                              style: TextStyle(fontSize: 30, color: Colors.yellow))
                        ]),
                      ),
                    )),
              ),
            ],
          ),flex: 1,),
          Expanded(
              child: ListView.builder(
                itemBuilder: _listeOlustur,
                itemCount: tumDersler.length,
              )
            ,flex: 1,),
        ],
      ),
    );
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;
  Color renk;

  Ders(this.ad, this.harfDegeri, this.kredi, this.renk);
}
