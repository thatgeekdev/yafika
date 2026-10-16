# Yafika Delivery Market

Aplicação Flutter que demonstra um marketplace de produtos e entregas para a cidade da Beira, Moçambique. O MVP permite experimentar os fluxos locais de cliente, parceiro, motorista e administração, incluindo um modelo financeiro demonstrativo de comissões e liquidações.

> **Demonstração apenas:** não há backend nem integração com operadores. Nenhuma cobrança, confirmação de fundos ou transferência é executada pela aplicação.

## Funcionalidades

### Cliente

- Criar conta local ou entrar com uma conta de demonstração.
- Pesquisar produtos e adicionar itens ao carrinho.
- O carrinho aceita produtos de um único parceiro por pedido.
- No checkout, escolher zona de entrega, método demonstrativo e código de entrega.
- Consultar o estado do pedido e o código de quatro dígitos na confirmação.

### Parceiro e motorista

- O parceiro aceita pedidos e actualiza o estado para preparação e pronto para recolha. O fluxo só fica disponível após o recebimento estar marcado como confirmado no dashboard.
- O motorista aceita uma entrega e confirma a conclusão com o código do cliente.
- A conclusão da entrega torna os montantes elegíveis para liquidação; **não** marca automaticamente o parceiro ou motorista como pagos.

### Comissões e livro financeiro

Taxas predefinidas para demonstração:

| Base de cálculo | Comissão Yafika | Destinatário do remanescente |
|---|---:|---|
| Subtotal dos produtos | 5% | Parceiro |
| Taxa de entrega | 10% | Motoboy |

As percentagens são configuráveis no dashboard administrativo para **novos pedidos**. Cada pedido mantém as taxas registadas no momento em que foi criado. Os montantes das comissões são arredondados a duas casas decimais.

Exemplo com produtos de `335 MT` e entrega de `113 MT`:

- Comissão sobre produtos: `16,75 MT`; líquido do parceiro: `318,25 MT`.
- Comissão sobre entrega: `11,30 MT`; líquido do motoboy: `101,70 MT`.
- Comissão bruta estimada da Yafika: `28,05 MT`.

O checkout apresenta a divisão estimada antes de confirmar o pedido. O dashboard lista, por encomenda, valores brutos e líquidos, taxas aplicadas, estado do recebimento, referências e histórico local das operações. A tarifa do operador é mantida separada, mas ainda não está configurada; por isso o dashboard **não calcula lucro líquido**.

### Administração

- Consultar métricas e o livro financeiro por pedido.
- Registar manualmente uma confirmação de recebimento em modo demo.
- Após recebimento e entrega confirmados, registar as referências demonstrativas das liquidações ao parceiro e ao motoboy.
- Consultar o histórico de recebimento e liquidações, incluindo data, referência e actor local.

Estes registos não executam operações financeiras: uma referência digitada não substitui confirmação técnica do operador nem comprovativo validado.

## Contas de demonstração

Palavra-passe para todas as contas: `123456`.

| Perfil | Email |
|---|---|
| Cliente | `cliente@yafika.co.mz` |
| Parceiro | `parceiro@yafika.co.mz` |
| Motorista | `motorista@yafika.co.mz` |
| Administrador | `admin@yafika.co.mz` |

## Executar

### Requisitos

- Flutter SDK com Dart compatível com `^3.8.1`.
- Dispositivo ou emulador configurado para a plataforma pretendida.

Na raiz do projecto:

```bash
flutter pub get
flutter run
```

Para seleccionar um dispositivo, execute `flutter devices` e depois `flutter run -d <device-id>`.

## Testes e análise

Os testes mantidos cobrem a abertura do login, o cálculo e arredondamento das comissões, a validação/configuração das taxas, a elegibilidade e registo das liquidações e a apresentação do dashboard financeiro.

```bash
flutter analyze
flutter test
```

O teste de contador Flutter predefinido foi removido por não corresponder à aplicação Yafika.

## Limitações e próximos passos para produção

- Os dados, contas, pedidos, taxas e histórico existem apenas em memória; são perdidos ao reiniciar e não são partilhados entre dispositivos.
- A confirmação de pagamento é manual e local. M-Pesa, e-Mola e cartão são apenas opções visuais, sem cobrança ou confirmação automática.
- As referências de liquidação são registos demonstrativos: não movimentam fundos nem comprovam uma transferência.
- Para receber o pagamento total na Yafika e liquidar parceiros e motoboys, será necessário um backend seguro, integração oficial com operador/agregador autorizado, reconciliação de transacções e prevenção de duplicados.
- As taxas de 5% e 10% são propostas para discussão, não condições comerciais aprovadas. Custos do operador, impostos, reembolsos e responsabilidade pelas tarifas precisam de ser definidos; a receita mostrada é bruta, não lucro.
- O cálculo de entrega usa zonas e distâncias pré-configuradas: `50 MT + 15 MT/km`, com mínimo de `100 MT`. Não utiliza mapas ou rotas reais.
- O código de entrega é escolhido pelo cliente e validado localmente, não gerado nem protegido por servidor.
- As contas de demonstração têm credenciais fixas e não servem para autenticação em produção.
- O painel de parceiro está associado a Shoprite Beira; ainda não há isolamento por parceiro nem gestão real de registos, documentos, disputas ou estornos.
- Os dados e produtos iniciais, contas, métricas, números e referências são demonstrativos. Não introduza PIN, OTP ou dados reais de cartão.
- A marca Yafika no login e no registo é desenhada com widgets Flutter e não depende de imagem externa.

Antes de operar com dinheiro real, validar os requisitos legais e fiscais em Moçambique, os contratos e capacidades dos operadores e os termos de adesão de parceiros e entregadores.

## Tecnologias e estrutura

- Flutter, Dart e Material 3.
- `lib/main.dart` — interface, modelos, dados de demonstração e lógica local.
- `test/app_store_finance_test.dart` — testes de fluxos financeiros e dashboard.
- `pubspec.yaml` — configuração e dependências Flutter.
