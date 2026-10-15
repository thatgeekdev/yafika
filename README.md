# Yafika Delivery Market

Aplicação Flutter que demonstra um marketplace de produtos e entregas para a cidade da Beira, em Moçambique. Esta versão é um MVP demonstrativo: permite percorrer os principais fluxos de cliente, parceiro, motorista e administrador, sem backend ou integrações reais.

## Funcionalidades

- **Cliente:** consulta e pesquisa produtos, adiciona produtos ao carrinho e acompanha pedidos.
- **Carrinho e checkout:** cada pedido pode incluir produtos de um único parceiro; o cliente informa os dados de entrega, escolhe uma zona e regista uma referência de pagamento.
- **Entrega:** a taxa estimada é calculada com a fórmula `50 MT + 15 MT por km`, com um mínimo de `100 MT`.
- **Parceiro:** aceita pedidos e actualiza o estado para indicar que estão em preparação ou prontos para recolha.
- **Motorista:** aceita entregas e confirma a conclusão com o código de quatro dígitos escolhido pelo cliente.
- **Administrador:** consulta métricas e pedidos e pode alterar o estado dos pedidos.
- **Contas:** inclui contas de demonstração e permite criar contas locais para os perfis disponíveis.

## Contas de demonstração

Use a palavra-passe `123456` com uma das contas seguintes:

| Perfil | Email |
|---|---|
| Cliente | `cliente@yafika.co.mz` |
| Parceiro | `parceiro@yafika.co.mz` |
| Motorista | `motorista@yafika.co.mz` |
| Administrador | `admin@yafika.co.mz` |

## Executar a aplicação

### Requisitos

- Flutter SDK compatível com Dart `^3.8.1`
- Um dispositivo ou emulador configurado para a plataforma pretendida

### Passos

Na raiz do projecto, execute:

```bash
flutter pub get
flutter run
```

Para escolher um dispositivo específico, consulte os dispositivos disponíveis com `flutter devices` e execute `flutter run -d <device-id>`.

## Dados e limitações desta versão

- Os dados são mantidos apenas em memória. Contas criadas, alterações e pedidos desaparecem ao fechar ou reiniciar a aplicação.
- Não existe servidor, base de dados, autenticação remota ou sincronização entre dispositivos.
- M-Pesa, e-Mola e cartão são simulados. A referência informada no checkout é apenas um registo demonstrativo; não confirma uma transacção.
- Os números de pagamento apresentados são dados de demonstração. Não introduza PIN, OTP ou dados reais de cartão.
- As zonas e distâncias são pré-configuradas para o MVP. A taxa não é calculada através de mapas ou rotas reais.
- O código de entrega é definido pelo cliente e validado localmente. Não é gerado nem protegido por um backend.
- O ecrã do parceiro está associado a Shoprite Beira. Os dados e estados de pedidos são partilhados pela instância local da aplicação; não há isolamento por cliente ou parceiro.
- Os valores, produtos, contas, métricas e pedidos iniciais são dados de demonstração, não informação operacional.

## Tecnologias

- Flutter
- Dart
- Material 3

## Estrutura

- `lib/main.dart` — interface, modelos, dados demonstrativos e lógica local da aplicação.
- `pubspec.yaml` — configuração e dependências Flutter.
