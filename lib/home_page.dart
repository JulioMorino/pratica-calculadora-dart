import 'dart:ffi';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String teclasColetadasLadoEsquerdo = '';
  String teclasColetadasLadoDireito  = '';
  double ?resultado;
  int ?numPressionado1;
  int ?numPressionado2;
  String operador = '';
  String apresentacao = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Calculadora Simples',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),

      ),
      body: 
      Column(children: [
        Container(
          height: 50,
          child: const Row(
            children: [
              Center(child: Text('Resultado', style: TextStyle(fontSize: 25)), ),
          ],) 
        
        ),
        SizedBox(
          height: 100,
          child: 
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(apresentacao, textAlign: TextAlign.end, style: const TextStyle(fontSize: 40))
          ],)
        ),
        Expanded(
          child:
          Container(
            color: Colors.orange,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            
            children: [ 
            Row(
              children: [
                  buildButton(textoBotao: '7', tamanhoTexto: 30, valorBotao:  7),
                  buildButton(textoBotao: '8', tamanhoTexto: 30, valorBotao:  8),
                  buildButton(textoBotao: '9', tamanhoTexto: 30, valorBotao:  9),
                  buildButton(textoBotao: '+', tamanhoTexto: 30, valorBotao:  '+')
            ],),
            Row(children: [
                  buildButton(textoBotao: '4', tamanhoTexto: 30, valorBotao:  4),
                  buildButton(textoBotao: '5', tamanhoTexto: 30, valorBotao:  5),
                  buildButton(textoBotao: '6', tamanhoTexto: 30, valorBotao:  6),
                  buildButton(textoBotao: '-', tamanhoTexto: 30, valorBotao: '-')
              ],),
            Row(children: [
                  buildButton(textoBotao: '1', tamanhoTexto: 30, valorBotao:  1),
                  buildButton(textoBotao: '2', tamanhoTexto: 30, valorBotao:  2),
                  buildButton(textoBotao: '3', tamanhoTexto: 30, valorBotao:  3),
                  buildButton(textoBotao: 'x', tamanhoTexto: 30, valorBotao: '*')
            ],),
            Row( children: [
                  buildButton(textoBotao: 'Limpar', tamanhoTexto: 20),
                  buildButton(textoBotao: '0', tamanhoTexto: 30, valorBotao:  0),
                  buildButton(textoBotao: '=', tamanhoTexto: 30, valorBotao:  '='),
                  buildButton(textoBotao: '÷', tamanhoTexto: 30, valorBotao:  '/')
            ],)
          ]
          ),
          ),
 
        )
      ],
      )
    );
  }

  Widget buildButton({String?  textoBotao, double? tamanhoTexto, var valorBotao}){
    
    return Padding (
    padding: EdgeInsets.only(left: 25),
    child: Container(
      width: 70,
      height: 70,

      child: FloatingActionButton(
        onPressed: (){
                  setState(() {
                    verificaTeclaPressionada(valorBotao);
                    
                    switch (textoBotao){
                      case 'Limpar':
                       limpaValores();
                       atualizaApresentacao();
                      break;
                      case '=':
                      if(teclasColetadasLadoDireito != '') {
                        atualizaResultado();
                        atualizaApresentacao();
                      }
                      break;

                      default: break;
                    }
                  });
                },
                child: Text(textoBotao!, style: TextStyle(fontSize: tamanhoTexto),),
      ),
    )
    );

  }

  void verificaTeclaPressionada(var teclaEscolhida){
    if(teclaEscolhida is int && operador == '' && teclasColetadasLadoEsquerdo.length < 11){//nenhum ainda foi clicado
      numPressionado1 = teclaEscolhida;
      teclasColetadasLadoEsquerdo += teclaEscolhida.toString();
      atualizaApresentacao();

    }
    if(operador == '' && teclaEscolhida is String && teclaEscolhida != '='){
      operador = teclaEscolhida;
      atualizaApresentacao();
    }
    if(teclaEscolhida is int && operador != '' && resultado == null && teclasColetadasLadoDireito.length < 11) {
      numPressionado2 = teclaEscolhida;
      teclasColetadasLadoDireito += teclaEscolhida.toString();
      atualizaApresentacao();
    } else if(teclaEscolhida is int && resultado != null){ //trato caso em que comeca outra conta depois de pressionar igual, sem clicar em limpar
      limpaValores();
      teclasColetadasLadoEsquerdo = teclaEscolhida.toString();
      atualizaApresentacao();
    }

    if(teclasColetadasLadoDireito != '' && teclaEscolhida is String && teclaEscolhida !='='){ //tratar caso que o usuario faz conta com mais de dois operandos, ex: 1 + 1 + 1 + 1. A ideia eh ja resolver de 2 em 2 as operacoes. 
                                                                                              //Tambem lida com caso em que, apos pressionar igual, ja pressiono outro operador para comecar outra operacao
      atualizaResultado();
      var temp = resultado;
      limpaValores();

      teclasColetadasLadoEsquerdo = temp.toString();
      operador = teclaEscolhida;
      atualizaApresentacao();
    }
  }

  void atualizaApresentacao(){
    apresentacao = teclasColetadasLadoEsquerdo + operador + teclasColetadasLadoDireito;
    if(resultado != null) apresentacao += ' = $resultado';
  }

  void atualizaResultado(){
    switch(operador){
      case '+':
               resultado = double.parse(teclasColetadasLadoEsquerdo) + double.parse(teclasColetadasLadoDireito);
               break;
      case '-':
               resultado = double.parse(teclasColetadasLadoEsquerdo) - double.parse(teclasColetadasLadoDireito);
               break;
      case '/':
               resultado = double.parse(teclasColetadasLadoEsquerdo) / double.parse(teclasColetadasLadoDireito);
               break;
      case '*':
               resultado = double.parse(teclasColetadasLadoEsquerdo) * double.parse(teclasColetadasLadoDireito);
               break;
      default: 
              break;
    }
  }

  void limpaValores(){
    teclasColetadasLadoEsquerdo = '';
    teclasColetadasLadoDireito  = '';
    
    resultado = null;
    operador = '';
  }
}

