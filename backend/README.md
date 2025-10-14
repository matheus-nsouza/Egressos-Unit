# Backend - App Egressos

Este diretório contém a API em Dart (Shelf) usada pelo projeto App Egressos.

## Visão geral

- Linguagem: Dart 3.x
- Framework: Shelf
- Banco: PostgreSQL (via package `postgres`)
- Entrypoint: `bin/server.dart` (contém a função `main`)

## Variáveis de ambiente

O backend utiliza variáveis de ambiente lidas por `package:dotenv`. Se não existir arquivo `.env`, valores padrão são usados conforme `lib/core/config/env.dart`:

- DB_HOST - padrão: `localhost`
- DB_PORT - padrão: `5432`
- DB_NAME - padrão: `egressos_db` (note: o docker-compose usa `egressos_app`)
- DB_USER - padrão: `postgres`
- DB_PASS - padrão: `senha123`
- PORT - padrão: `8080`

Exemplo de `.env` mínimo (coloque na pasta `backend`):

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=egressos_db
DB_USER=postgres
DB_PASS=senha123
PORT=8080
```

Observação: o `docker-compose.yml` do repositório configura o serviço `postgres` com `POSTGRES_DB: egressos_app` e exporta a porta `5432`, enquanto o serviço `backend` espera por `DB_NAME: egressos_app` quando rodado por docker-compose.

## Rodando localmente (sem Docker)

1. Instale o SDK do Dart (>= 3.x).
2. Entre no diretório `backend`:

```powershell
cd c:\Users\mikha\projetosPessoais\app_egressos\backend
```

3. Instale dependências:

```powershell
dart pub get
```

4. Garanta que o PostgreSQL esteja rodando e acessível com as variáveis configuradas no `.env`.

5. Execute o servidor:

```powershell
# Executa o arquivo que contém `main()`
dart run bin/server.dart
```

Saída esperada:

```
🚀 Servidor rodando em http://0.0.0.0:8080
✅ Conectado ao PostgreSQL em <host>:<port>
```

## Rodando com Docker (recomendado para desenvolvimento rápido)

No nível raiz do repositório existe um `docker-compose.yml` que levanta `postgres`, `backend` e `frontend`.

1. Na raiz do repositório execute:

```powershell
docker compose up --build
```

2. O backend será exposto na porta `8080` (mapeado para a porta `8080` do host). O serviço `backend` usa as variáveis definidas no `docker-compose.yml`:

- DB_HOST=postgres
- DB_PORT=5432
- DB_NAME=egressos_app
- DB_USER=postgres
- DB_PASS= (vazio)
- PORT=8080

3. Para parar e remover containers:

```powershell
docker compose down
```

## Executáveis e Dockerfile

- O `Dockerfile` do backend expõe a porta `8080` e executa `dart run bin/server.dart`.
- Se quiser rodar o container diretamente (sem docker-compose), construa a imagem e execute:

```powershell
docker build -t egressos_backend:local ./backend
docker run -p 8080:8080 --env-file backend/.env egressos_backend:local
```

## Testes

Os testes estão em `backend/test`. Para executar os testes locais:

```powershell
cd backend
dart pub get
dart test
```

Observação: alguns testes de integração podem depender de um banco de dados de testes. Veja `test/helpers/test_database.dart` para detalhes e configure as variáveis conforme necessário.

## Troubleshooting

- Erro: "Invoked Dart programs must have a 'main' function defined"
  - Causa: você tentou executar um arquivo sem `main`, por exemplo `dart run server.dart` dentro de `lib/`. Use `dart run bin/server.dart` ou execute a partir da raiz do pacote.

- Erro de conexão com Postgres
  - Verifique `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS` e se o banco está acessível.
  - Se estiver usando Docker, certifique-se de usar `docker compose up` para que o serviço `postgres` esteja disponível e saudável antes do backend iniciar.

## Próximos passos sugeridos

- (Opcional) Adicionar `executables` no `backend/pubspec.yaml` para facilitar a execução via `dart run backend:server`.
- (Opcional) Criar uma `Makefile` ou `tasks.json` para VSCode com comandos frequentes (run, test, docker-up).

Se quiser, eu implemento automaticamente a opção de `executables` no `pubspec.yaml` e adiciono um `Makefile` simples. Diga se prefere que eu faça isso agora.