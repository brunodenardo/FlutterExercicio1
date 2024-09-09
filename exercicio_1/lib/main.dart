import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Exercício 1',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/listaProdutos': (context) => ProductList(),
          "/compraProduto": (context) => BuyPage(),
          "/parabensCompra": (context) => ParabensCompra()
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var produtos = <String>["Goiabada Cascão", "Tijolos", "Queijo prato"];
  var produtoSelecionado = "";
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_basket_rounded, size: 100),
                SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        labelText: "Nome de Usuário",
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira o nome de usuário";
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Senha",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira a senha";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/listaProdutos');
                    }
                  },
                  child: const Text('Entrar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var listaProdutos = appState.produtos;

    return Scaffold(
        body: Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListView(
        children: listaProdutos.map((item) {
          return ListTile(
              tileColor: theme.colorScheme.secondary,
              title: Center(child: Text(item)),
              onTap: () {
                appState.produtoSelecionado = item;
                Navigator.pushNamed(context, "/compraProduto");
              });
        }).toList(),
      ),
    ));
  }
}

class BuyPage extends StatefulWidget {
  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  var _formKey = GlobalKey<FormState>();

  var _numeroCompra = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var produtoSelecionado = appState.produtoSelecionado;
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Form(
            key: _formKey,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Detalhes do pedido"),
                SizedBox(height: 24),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    initialValue: produtoSelecionado,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Produto Selecionado',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    controller: _numeroCompra,
                    keyboardType:
                        TextInputType.number, // Define o teclado numérico
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly // Permite apenas números
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Unidades do produto',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "0") {
                        return "Por favor, insira um número maior que 0";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        appState.produtoSelecionado = "";
                        Navigator.pushNamed(context, '/listaProdutos');
                      },
                      child: const Text('Voltar'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          appState.produtoSelecionado = "";
                          Navigator.pushNamed(context, '/parabensCompra');
                        }
                      },
                      child: const Text('Comprar'),
                    ),
                  ],
                )
              ],
            ))),
      ),
    );
  }
}

class ParabensCompra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_basket_rounded, size: 100),
              SizedBox(height: 40),
              Text("Pedido confirmado"),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  appState.produtoSelecionado = "";
                  Navigator.pushNamed(context, '/listaProdutos');
                },
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
