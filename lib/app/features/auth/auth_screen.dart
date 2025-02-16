import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/app/features/auth/bloc/auth_bloc.dart';
import 'package:weather_app/app/router/router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Для валидации формы

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Аутентификация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
               context.go('/favorites');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) => (value == null || !value.contains('@')) ? 'Введите корректный email' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Пароль'),
                      obscureText: true,
                      validator: (value) => (value == null || value.length < 6) ? 'Минимум 6 символов' : null,
                    ),
                    const SizedBox(height: 20),
                    if (state is AuthLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthSignUp(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                        child: const Text('Зарегистрироваться'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthLogIn(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                        child: const Text('Войти'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
