import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailSentPage extends StatelessWidget {
  const EmailSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF132465),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header com logo
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 40.0),
                child: Image.asset(
                  'assets/images/illustrations/logo_unit.gif',
                  height: 80,
                  width: 250,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/illustrations/Frame 1316.png',
                    height: 80,
                    width: 250,
                  ),
                ),
              ),

              // Mensagem de sucesso
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    // Ícone de sucesso
                    const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Título
                    const Text(
                      'Redefinir Senha',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Mensagem
                    const Text(
                      'Enviamos sua nova senha para o e-mail cadastrado',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Botão Voltar ao Login
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1C234),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Voltar ao login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Footer
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Ao usar o Egressos, você concorda com os Termos e a Política de Privacidade.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}