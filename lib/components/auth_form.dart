import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  bool _isLogin() => _authMode == AuthMode.Login;
  //bool _isSignup() => _authMode == AuthMode.Signup;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.linear,
    ));

    _slideAnimation = Tween(
      begin: Offset(0.0, -1.5),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.linear,
    ));

    //_heightAnimation?.addListener(() => setState(() {}));
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await auth.signUp(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      // Mostrar um alerta ao usuário em caso de erro
      print(error.key.toString());
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado');
    }
    setState(() => _isLoading = false);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller?.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.Login;
        _controller?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 9,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        height: _isLogin() ? 310 : 400,
        //height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (_email) {
                  _authData['email'] = _email as String ?? "";
                },
                validator: (_email) {
                  final email = _email ?? "";
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Insira um email valido';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _passwordController,
                onSaved: (_password) {
                  _authData['password'] = _password as String ?? "";
                },
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty) {
                    return "O campo de senha é obrigatório.";
                  } else {
                    return null;
                  }
                },
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Confirme a senha'),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: _isLogin()
                          ? null
                          : (_password) {
                              final password = _password ?? '';
                              if (password != _passwordController.text) {
                                return "As senhas não conferem.";
                              } else {
                                null;
                              }
                            },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                      _authMode == AuthMode.Login ? "ENTRAR" : "REGISTRAR"),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      )),
                ),
              Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                    _isLogin() ? "DESEJA REGISTRAR?" : "JÁ POSSUI UMA CONTA?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
