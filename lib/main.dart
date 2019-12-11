/*
* App de conversor de moedas, esses valores de conversões estão sendo todos obtidos através da internet.
* Então quando o nosso app abriu ele já buscou as conversões através de um site através de uma app.
* Ele utiliza a própria conversão on line e a conversão do momento e então cada vez que você abrir o app
* ele terá a conversão do momento.
* */

/**
 * como funciona o padrão JSON de armazenamento de dados bom padrão, permite que a gente armazena dados em um formato de árvore.
 * Com o JSON você vai armazenando dados no formato de Maps (chave: valor)
 */

/**
 * API: Utilizar o API do HG Finance.
 * API nada mais é do que uma ponte que eu posso utilizar para obter os dados de um serviço.
 */
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=c17f3103";

void main() async{

  //print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
          )
      )
    ),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  /*JSON transforma em mapa*/
  return json.decode(response.body);
}

// stful
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dolar,euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0),
                    textAlign: TextAlign.center,),
                );
              default:
                if(snapshot.hasError){
                  return Center(
                    child: Text("Erro ao carregar dados!",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,),
                  );
                }else{
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Reais",
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            prefixText: "R\$"
                          ),
                          style: TextStyle(
                            color: Colors.amber, fontSize: 25.0
                          ),
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Dolar",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "\$"
                          ),
                          style: TextStyle(
                              color: Colors.amber, fontSize: 25.0
                          ),
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Euro",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "€\$"
                          ),
                          style: TextStyle(
                              color: Colors.amber, fontSize: 25.0
                          ),
                        )
                      ],
                    ),
                  );
                }
            }
          }
      ),
    );
  }
}
