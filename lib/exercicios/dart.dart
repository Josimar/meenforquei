main(){
  // executeScript();

  final r = soma(2, 3);
  print('O valor da soma é: $r');
  somar(2, 3);

  final rf = somarFunction(2, 3, (a, b){
    return a * b + 10;
  });
  print('O resultado é $rf');

  final rf2 = somarFunction(2, 3, (a, b) => a * b + 10);
  print('O resultado é $rf2');
}

soma(int a, int b){
  return a + b;
}

void somar(int a, int b){
  print(a + b);
}

int somarFunction(int a, int b, int Function(int, dynamic) fn){
  return fn(a, b);
}

executeScript(){
  print('Primeiro programa');

  int a = 1;
  double b = 3.1;
  bool estaChovendo = true;
  bool estaFrio = false;

  print('a: ' + a.toString());
  print('b: ' + b.toString());

  var c = 'Você é legal';

  print(c is String);

  print(estaChovendo || estaFrio);

  var nomes = ['Ana', 'Bia', 'Carla'];
  nomes.add('Daniel');
  nomes.add('Daniel');
  nomes.add('Daniel');
  print('Length: ' + nomes.length.toString());
  print(nomes.elementAt(1));
  print(nomes[2]);

  var conjunto = {0, 1, 2, 3, 4, 5}; // não pode ter dados iguais
  print(conjunto.length);
  print(conjunto is Set);

  Map<String, double> notaAlunos = {
    'Ana': 9.7,
    'Bia': 9.2,
    'Carlos': 7.8,
  };
  for (var chave in notaAlunos.keys){
    print('chave = $chave');
  }
  for (var valor in notaAlunos.values){
    print('valor = $valor');
  }
  for (var registro in notaAlunos.entries){
    print('${registro.key} = ${registro.value}');
  }

  // dynamic armazena qualquer coisa
  dynamic x = 'Teste';
  x = 123;
  x = false;

  print('x: ' + x.toString());
  /*
  var varb = 3; // pode ser alterado sempre
  varb = 4;

  final varc = 4; // tempo de compilação quando recebemos um valor
  varc = 5; 
  
  const vard = 5; // tempo de compilação, quando sabemos o valor
  vard = 6;
  */
}

/*
ShowDialog()

new RaisedButton(
  child: new Text("Show Dialog"),
  onPressed: ()async{
    bool shouldUpdate = await showDialog(
      context: this.context,
      child:new AlertDialog(
        content: new FlatButton(
          child: new Text("update home"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
    );
    setState(() {
      shouldUpdate ? this._homeData = "updated" : null;
    });
  },
),
* */