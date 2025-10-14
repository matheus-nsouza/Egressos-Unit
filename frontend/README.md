# 📱 App Egressos

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-Proprietary-red)]()

Aplicativo mobile multiplataforma (Android e iOS) desenvolvido em Flutter para gestão e engajamento de egressos da instituição de ensino.

## 📋 Sobre o Projeto

O **App Egressos** é uma plataforma completa que conecta ex-alunos com a instituição, oferecendo funcionalidades como:

- 🎓 Histórias de sucesso de egressos
- 📅 Calendário de eventos institucionais
- 💼 Oportunidades de emprego e estágio
- 🎫 Carteirinha digital do egresso
- 💰 Benefícios e parcerias exclusivas
- 📢 Avisos e comunicados importantes
- 📰 Publicação de conquistas profissionais
- 🔔 Notificações push personalizadas

### 🎯 Objetivos

- Fortalecer o relacionamento entre a instituição e seus egressos
- Criar uma comunidade engajada de ex-alunos
- Facilitar o networking e desenvolvimento profissional
- Divulgar eventos, oportunidades e benefícios
- Coletar histórias de sucesso para inspirar atuais e futuros alunos

## 📸 Screenshots

_[Em breve: Adicionar capturas de tela das principais funcionalidades]_

## 🚀 Tecnologias Utilizadas

### Frontend
- **Flutter** 3.x - Framework multiplataforma
- **Dart** 3.x - Linguagem de programação
- **Material Design 3** - Design system

### State Management
- **Flutter Bloc** - Gerenciamento de estado
- **Equatable** - Comparação de objetos

### Backend & Database
- **Firebase Auth** - Autenticação
- **Cloud Firestore** - Banco de dados NoSQL
- **Firebase Storage** - Armazenamento de arquivos
- **Firebase Cloud Messaging** - Notificações push
- **Firebase Analytics** - Analytics
- **Firebase Crashlytics** - Crash reporting

### Navegação
- **Go Router** - Navegação declarativa

### Networking
- **Dio** - Cliente HTTP
- **Connectivity Plus** - Verificação de conectividade

### Local Storage
- **Shared Preferences** - Preferências simples
- **Flutter Secure Storage** - Dados sensíveis
- **Hive** - Banco de dados local

### Imagens
- **Cached Network Image** - Cache de imagens
- **Image Picker** - Seleção de imagens
- **Image Cropper** - Edição de imagens

### UI Components
- **Flutter SVG** - Ícones SVG
- **Shimmer** - Loading placeholders
- **Lottie** - Animações

### Validação
- **Validators** - Validação de dados
- **Mask Text Input Formatter** - Máscaras de input

### Arquitetura
- **Clean Architecture** - Arquitetura em camadas
- **Repository Pattern** - Abstração de dados
- **Dependency Injection** - Get It

## 📁 Estrutura do Projeto

```
app_egressos/
│
├── lib/
│   ├── core/                          # Código compartilhado
│   │   ├── constants/                 # Constantes (cores, strings, etc)
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   └── api_constants.dart
│   │   ├── errors/                    # Tratamento de erros
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   ├── network/                   # Cliente HTTP
│   │   ├── routes/                    # Rotas do app
│   │   │   └── app_router.dart
│   │   ├── theme/                     # Tema e estilos
│   │   │   ├── app_theme.dart
│   │   │   └── text_styles.dart
│   │   ├── utils/                     # Utilitários
│   │   │   └── validators.dart
│   │   └── widgets/                   # Widgets compartilhados
│   │       ├── custom_button.dart
│   │       ├── custom_text_field.dart
│   │       ├── loading_widget.dart
│   │       └── error_widget.dart
│   │
│   ├── features/                      # Features do app (Clean Architecture)
│   │   ├── auth/                      # 🔐 Autenticação
│   │   │   ├── data/
│   │   │   │   ├── models/            # Modelos de dados
│   │   │   │   ├── repositories/      # Implementação repositórios
│   │   │   │   └── datasources/       # Fontes de dados
│   │   │   ├── domain/
│   │   │   │   ├── entities/          # Entidades de negócio
│   │   │   │   ├── repositories/      # Contratos repositórios
│   │   │   │   └── usecases/          # Casos de uso
│   │   │   └── presentation/
│   │   │       ├── bloc/              # BLoC (state management)
│   │   │       ├── pages/             # Telas
│   │   │       └── widgets/           # Widgets específicos
│   │   │
│   │   ├── dashboard/                 # 🏠 Dashboard
│   │   ├── events/                    # 📅 Eventos
│   │   ├── opportunities/             # 💼 Oportunidades
│   │   ├── stories/                   # 📖 Histórias de Egressos
│   │   ├── notices/                   # 📢 Avisos Gerais
│   │   ├── benefits/                  # 💰 Benefícios
│   │   ├── card/                      # 🎫 Carteirinha Digital
│   │   ├── news/                      # 📰 Notícias Profissionais
│   │   ├── profile/                   # 👤 Perfil
│   │   └── notifications/             # 🔔 Notificações
│   │
│   ├── app.dart                       # Widget raiz do app
│   ├── main.dart                      # Entry point
│   └── injection_container.dart       # Injeção de dependências
│
├── assets/                            # Recursos estáticos
│   ├── images/                        # Imagens
│   ├── icons/                         # Ícones
│   └── animations/                    # Animações Lottie
│
├── test/                              # Testes
│   ├── unit/                          # Testes unitários
│   ├── widget/                        # Testes de widget
│   └── integration/                   # Testes de integração
│
├── android/                           # Projeto Android
├── ios/                               # Projeto iOS
├── pubspec.yaml                       # Dependências
└── README.md                          # Este arquivo
```

## 🏗️ Arquitetura

O projeto utiliza **Clean Architecture** dividida em 3 camadas:

### 1. Presentation Layer (UI)
- **BLoC** para gerenciamento de estado
- **Pages** (telas/rotas)
- **Widgets** (componentes visuais)

### 2. Domain Layer (Business Logic)
- **Entities** (objetos de negócio)
- **Use Cases** (regras de negócio)
- **Repository Interfaces** (contratos)

### 3. Data Layer (Data Management)
- **Models** (serialização)
- **Repository Implementations**
- **Data Sources** (Remote/Local)

### Fluxo de Dados

```
User Interaction
      ↓
   Widget
      ↓
    BLoC
      ↓
  Use Case
      ↓
 Repository
      ↓
Data Source
      ↓
Firebase/Cache
```

## 🎨 Design System

### Cores Principais
- **Primary**: `#1976D2` (Azul institucional)
- **Secondary**: `#FF6F00` (Laranja)
- **Success**: `#388E3C` (Verde)
- **Error**: `#D32F2F` (Vermelho)
- **Warning**: `#F57C00` (Laranja escuro)

### Tipografia
- **Headings**: Bold (32, 28, 24px)
- **Body**: Regular (16, 14, 12px)
- **Button**: Semi-bold (16px)

## 🔧 Pré-requisitos

Antes de começar, você precisa ter instalado:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) >= 3.0.0
- [Dart SDK](https://dart.dev/get-dart) >= 3.0.0
- [Git](https://git-scm.com/)
- [Android Studio](https://developer.android.com/studio) (para Android)
- [Xcode](https://developer.apple.com/xcode/) (para iOS - apenas macOS)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup)

### Verificar Instalação

```bash
flutter doctor
```

Certifique-se de que todos os itens estão marcados com ✓

### Requisitos de Dispositivo

#### Android
- Versão mínima: Android 5.0 (API 21)
- Versão alvo: Android 14 (API 34)

#### iOS
- Versão mínima: iOS 12.0
- Versão alvo: iOS 17.0

## 🚀 Instalação e Configuração

### 1. Clonar o Repositório

```bash
git clone https://github.com/sua-organizacao/app_egressos.git
cd app_egressos
```

### 2. Instalar Dependências

```bash
flutter pub get
```

### 3. Configurar Firebase

#### 3.1 Criar Projeto no Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Crie um novo projeto
3. Habilite os serviços:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Storage
   - Cloud Messaging
   - Analytics
   - Crashlytics

#### 3.2 Configurar FlutterFire

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase no projeto
flutterfire configure
```

Selecione o projeto Firebase e as plataformas (Android, iOS)

#### 3.3 Estrutura do Firestore

```
users/
  └── {userId}/
      ├── name: string
      ├── email: string
      ├── graduationYear: number
      └── course: string

events/
  └── {eventId}/
      ├── title: string
      ├── description: string
      ├── date: timestamp
      └── imageUrl: string

opportunities/
  └── {opportunityId}/
      ├── title: string
      ├── company: string
      ├── type: string (job|internship)
      └── publishedAt: timestamp

stories/
  └── {storyId}/
      ├── graduateName: string
      ├── content: string
      ├── imageUrl: string
      └── createdAt: timestamp
```

### 4. Configurar Android

#### 4.1 Baixar google-services.json

1. No Firebase Console, vá em **Project Settings**
2. Baixe `google-services.json`
3. Coloque em `android/app/`

#### 4.2 Configurar build.gradle

Já está configurado! Verifique:
- `android/build.gradle`
- `android/app/build.gradle`

### 5. Configurar iOS (apenas macOS)

#### 5.1 Baixar GoogleService-Info.plist

1. No Firebase Console, vá em **Project Settings**
2. Baixe `GoogleService-Info.plist`
3. Abra `ios/Runner.xcworkspace` no Xcode
4. Arraste o arquivo para a pasta Runner

#### 5.2 Instalar Pods

```bash
cd ios
pod install
cd ..
```

### 6. Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```env
API_BASE_URL=https://api.exemplo.com
ENVIRONMENT=development
```

## ▶️ Executar o Projeto

### Modo Debug

```bash
# Listar devices disponíveis
flutter devices

# Rodar no device/emulador
flutter run

# Rodar em device específico
flutter run -d <device_id>
```

### Modo Release

```bash
# Android
flutter run --release

# iOS
flutter run --release
```

### Hot Reload

Durante desenvolvimento, pressione:
- `r` - Hot reload
- `R` - Hot restart
- `q` - Quit

## 🧪 Testes

### Executar Todos os Testes

```bash
flutter test
```

### Testes Unitários

```bash
flutter test test/unit/
```

### Testes de Widget

```bash
flutter test test/widget/
```

### Testes de Integração

```bash
flutter test test/integration/
```

### Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📦 Build para Produção

### Android (APK)

```bash
flutter build apk --release
```

Arquivo gerado: `build/app/outputs/flutter-apk/app-release.apk`

### Android (App Bundle - Google Play)

```bash
flutter build appbundle --release
```

Arquivo gerado: `build/app/outputs/bundle/release/app-release.aab`

### iOS (App Store)

```bash
flutter build ios --release
```

Depois abra o Xcode para fazer o upload:
1. Abra `ios/Runner.xcworkspace`
2. **Product** > **Archive**
3. Upload para App Store Connect

## 🐛 Troubleshooting

### Erro: "Gradle build failed"

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Erro: "CocoaPods not installed"

```bash
sudo gem install cocoapods
```

### Erro: "Firebase not configured"

```bash
flutterfire configure
```

### Erro: "Build failed with certificate error" (iOS)

1. Abra Xcode
2. Vá em **Signing & Capabilities**
3. Configure seu Team e Bundle ID

### App lento em modo Debug

Isso é normal! O modo debug inclui ferramentas de desenvolvimento. Teste sempre em **release mode** para avaliar performance real.

## 📊 Debug e Logs

### Ver Logs

```bash
flutter logs
```

### Crashlytics

Crashes são automaticamente reportados ao Firebase Crashlytics em produção.

Forçar um crash de teste:

```dart
FirebaseCrashlytics.instance.crash();
```

### Analytics

Eventos são automaticamente rastreados pelo Firebase Analytics.

Registrar evento customizado:

```dart
FirebaseAnalytics.instance.logEvent(
  name: 'view_story',
  parameters: {'story_id': '123'},
);
```

## 👥 Equipe

### Time de Desenvolvimento (7 membros)

#### Tech Lead (1)
- Responsável pela arquitetura e decisões técnicas
- Code review
- Mentoria do time

#### Backend Team (2 devs)
- APIs e integrações
- Firebase configuration
- Regras de segurança

#### Frontend Team (4 devs)
- Desenvolvimento de features
- UI/UX implementation
- Testes

## 📅 Timeline do Projeto

| Sprint | Duração | Entregáveis | Status |
|--------|---------|-------------|--------|
| Sprint 0 | 3 dias | Setup e configuração | ✅ |
| Sprint 1 | 7 dias | Autenticação + Dashboard | ✅ |
| Sprint 2 | 7 dias | Eventos (visualização) | ✅ |
| Sprint 3 | 7 dias | Eventos + Oportunidades | ✅ |
| Sprint 4 | 7 dias | Oportunidades + Histórias + Avisos | ✅ |
| Sprint 5 | 7 dias | Histórias + Avisos + Notificações | 🔄 |
| Sprint 6 | 3 dias | Polimento e testes finais | ⏳ |

**Total**: 41 dias úteis (~8 semanas)

**MVP Previsto**: 20 de Novembro de 2025

## 📊 Métricas de Qualidade

| Métrica | Meta | Atual |
|---------|------|-------|
| Code Coverage | ≥ 70% | 68% |
| Build Success Rate | ≥ 95% | 97% |
| Crash-Free Rate | ≥ 99% | 99.2% |
| Performance (Carregamento) | < 3s | 2.1s |

## 🤝 Como Contribuir

1. Crie uma branch: `git checkout -b feature/US-XXX-nome`
2. Faça suas alterações
3. Commit: `git commit -m 'feat(modulo): descrição'`
4. Push: `git push origin feature/US-XXX-nome`
5. Abra um Pull Request

### Convenções de Commit

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(auth): implementar login
fix(events): corrigir filtro de data
refactor(dashboard): reorganizar widgets
test(stories): adicionar testes unitários
docs(readme): atualizar instalação
style(theme): ajustar cores
chore(deps): atualizar dependências
```

### Code Review Checklist

- [ ] Código segue o style guide do projeto
- [ ] Testes unitários implementados
- [ ] Documentação atualizada
- [ ] Sem warnings ou erros
- [ ] Performance verificada

## 📗 Links Úteis

- [Firebase Console](https://console.firebase.google.com)
- [Flutter Docs](https://docs.flutter.dev)
- [Dart Docs](https://dart.dev/guides)
- [Material Design 3](https://m3.material.io)
- [Bloc Library](https://bloclibrary.dev)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## 📞 Suporte

Para dúvidas ou problemas:

- 📧 **Email**: dev-team@sua-instituicao.edu.br
- 💬 **Slack**: `#app-egressos`
- 🐛 **Issues**: [GitHub Issues](https://github.com/sua-organizacao/app_egressos/issues)
- 📖 **Wiki**: [Documentação Técnica](https://github.com/sua-organizacao/app_egressos/wiki)

## 📄 Licença

Este projeto é **proprietário e confidencial**.

© 2025 Instituição de Ensino. Todos os direitos reservados.

---

<div align="center">

**Desenvolvido com ❤️ pela equipe de desenvolvimento**

Última atualização: Outubro 2025 | Versão: 1.0.0

[⬆ Voltar ao topo](#-app-egressos)

</div>