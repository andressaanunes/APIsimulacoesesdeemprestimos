import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:dropdown_search/dropdown_search.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variáveis para armazenar os dados do formulário
  String valorEmprestimo = '';
  List<String> instituicoesSelecionadas = [];
  List<String> conveniosSelecionados = [];
  String parcelasSelecionadas = '';

  // Função para obter as instituições e convênios da API
  Future<List<String>> getInstituicoesConvenios() async {
    final url = Uri.parse('http://localhost');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<String> instituicoes = jsonResponse['instituicoes'];
      List<String> convenios = jsonResponse['convenios'];
      return [instituicoes.toString(), convenios.toString()];
    } else {
      throw Exception('Falha ao carregar instituições e convênios');
    }
  }

  // Função para enviar os dados do formulário para a API
  Future<void> enviarDados() async {
    final url = Uri.parse('http://localhost');
    var response = await http.post(
      url,
      body: {
        'valor': valorEmprestimo,
        'instituicoes': instituicoesSelecionadas,
        'convenios': conveniosSelecionados,
        'parcelas': parcelasSelecionadas,
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      // Processar e exibir os dados retornados da simulação
    } else {
      throw Exception('Falha ao enviar dados');
    }
  }

  @override
  Widget build(BuildContext context) {
    var _selectController;
    return Scaffold(
        appBar: AppBar(
          title: Text('Simulação de Empréstimos'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _selectController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Valor do Empréstimo', prefixText: 'R\$ '),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              DropdownSearch<String>(
                items: ["Instituição A", "Instituição B", "Instituição C"],
                onChanged: print,
                selectedItem: "Instituição A",
              ),
              // Assumindo que a API retorna uma lista de strings para os convênios
              DropdownSearch<String>(
                items: ["Convênio A", "Convênio B", "Convênio C"],
                onChanged: print,
                selectedItem: "Convênio A",
              ),
              // Assumindo que a API retorna uma lista de strings para as parcelas
              DropdownSearch<String>(
                items: ["12 Parcelas", "24 Parcelas", "36 Parcelas"],
                onChanged: print,
                selectedItem: "12 Parcelas",
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  var _formKey;
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processando dados')),
                    );
                  }
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ));
  }
}
