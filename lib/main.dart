import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:log_elastic_mobile/log_level.dart';
import 'package:log_elastic_mobile/registro_log.dart';

import 'constantes_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Com ElasticSearch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Com ElasticSearch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
  }

  Future<int?> realizarDivisao(int valor1, int valor2) async {
    try {
      final int calculo = (valor1 / valor2) as int;
      return calculo;
    } catch (e, stacktrace) {
      await salvarLog(e.toString(), stacktrace.toString(), LogLevel.critical);
      return null;
    }
  }

  Future<void> salvarLog(String erro, String stackTrace, LogLevel nivelErro) async {
    try {
      final dio = Dio();
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
          () => HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final dados = RegistroLog(
        Mensagem: erro,
        StackTrace: stackTrace,
        Nivel: nivelErro.logLevel,
      ).toJson();

      const url = 'https://192.168.0.11:9200/log_erros_sistema/_doc';

      await dio.post(
        url,
        data: dados,
        options: Options(headers: {'Authorization': apikey}),
      );
    } on Exception catch (e) {
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController ctrlPrimeiroValor = TextEditingController();
    final TextEditingController ctrlSegundoValor = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: ctrlPrimeiroValor,
                decoration: const InputDecoration(labelText: 'Primeiro Valor'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: ctrlSegundoValor,
                decoration: const InputDecoration(labelText: 'Segundo Valor'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                child: const Text('Realizar Operação'),
                onPressed: () async {
                  final int primeiroValor = int.tryParse(ctrlPrimeiroValor.text)!;
                  final int segundoValor = int.tryParse(ctrlSegundoValor.text)!;
                  final calculo = await realizarDivisao(primeiroValor, segundoValor);
                  if (context.mounted) {
                    if (calculo != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Resultado é $calculo')));
                    }
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Falha na Operação'),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
