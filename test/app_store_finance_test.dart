import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yafika/main.dart';

void main() {
  testWidgets('login opens with the built-in Yafika brand mark', (
    tester,
  ) async {
    await tester.pumpWidget(const YafikaApp());
    await tester.pumpAndSettle();

    expect(find.text('YAFIKA'), findsOneWidget);
    expect(find.text('Bem-vindo à Yafika'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
  });

  group('AppStore financial ledger', () {
    late AppStore store;

    setUp(() {
      store = AppStore();
    });

    test('splits product and delivery amounts using pilot commissions', () {
      store.addToCart(store.products.first);
      final order = store.createOrder(
        customerName: 'Cliente Demo',
        phone: '841234567',
        address: 'Ponta-Gêa, Beira',
        paymentMethod: PaymentMethod.mpesa,
        paymentReference: 'CLIENT-REF-01',
        deliveryCode: '1234',
        deliveryZone: store.deliveryZones.first,
      );

      expect(order.productsTotal, 335);
      expect(order.deliveryFee, 113);
      expect(order.grandTotal, 448);
      expect(order.partnerCommission, closeTo(16.75, 0.001));
      expect(order.partnerNetAmount, closeTo(318.25, 0.001));
      expect(order.driverCommission, closeTo(11.3, 0.001));
      expect(order.driverNetAmount, closeTo(101.7, 0.001));
      expect(order.yafikaCommissionRevenue, closeTo(28.05, 0.001));
      expect(order.yafikaNetRevenue, isNull);
      expect(
        order.paymentCollectionStatus,
        PaymentCollectionStatus.awaitingConfirmation,
      );
    });

    test(
      'requires confirmed funds and delivery before settling participants',
      () {
        store.addToCart(store.products.first);
        final order = store.createOrder(
          customerName: 'Cliente Demo',
          phone: '841234567',
          address: 'Ponta-Gêa, Beira',
          paymentMethod: PaymentMethod.mpesa,
          paymentReference: 'CLIENT-REF-02',
          deliveryCode: '2468',
          deliveryZone: store.deliveryZones.first,
        );

        expect(
          store.registerDriverPayout(order: order, reference: 'PAYOUT-01'),
          isFalse,
        );

        store.updateOrderStatus(order, OrderStatus.delivering);
        expect(store.confirmDelivery(order: order, code: '2468'), isTrue);
        expect(order.driverPayoutStatus, SettlementStatus.pending);
        expect(order.partnerSettlementStatus, SettlementStatus.pending);

        expect(
          store.confirmPaymentCollection(
            order: order,
            reference: 'YAFIKA-RECEIPT-02',
          ),
          isTrue,
        );
        expect(order.driverPayoutStatus, SettlementStatus.eligible);
        expect(order.partnerSettlementStatus, SettlementStatus.eligible);

        expect(
          store.registerPartnerSettlement(
            order: order,
            reference: 'PARTNER-PAYOUT-02',
          ),
          isTrue,
        );
        expect(
          store.registerDriverPayout(
            order: order,
            reference: 'DRIVER-PAYOUT-02',
          ),
          isTrue,
        );
        expect(order.partnerSettlementStatus, SettlementStatus.paid);
        expect(order.driverPayoutStatus, SettlementStatus.paid);
        expect(order.financialHistory, hasLength(3));
        expect(
          store.registerDriverPayout(
            order: order,
            reference: 'DUPLICATE-PAYOUT',
          ),
          isFalse,
        );
      },
    );

    test('validates commission settings and snapshots rates per order', () {
      expect(
        store.configureCommissionRates(partnerRate: 1, driverRate: 0.10),
        isFalse,
      );
      expect(
        store.configureCommissionRates(
          partnerRate: double.nan,
          driverRate: 0.10,
        ),
        isFalse,
      );
      expect(store.partnerCommissionRate, 0.05);

      expect(
        store.configureCommissionRates(partnerRate: 0.07, driverRate: 0.12),
        isTrue,
      );

      store.addToCart(store.products.first);
      final order = store.createOrder(
        customerName: 'Cliente Demo',
        phone: '841234567',
        address: 'Ponta-Gêa, Beira',
        paymentMethod: PaymentMethod.emola,
        paymentReference: 'CLIENT-REF-03',
        deliveryCode: '9876',
        deliveryZone: store.deliveryZones.first,
      );

      expect(order.partnerCommissionRate, 0.07);
      expect(order.driverCommissionRate, 0.12);
      expect(order.partnerCommission, closeTo(23.45, 0.001));
      expect(order.driverCommission, closeTo(13.56, 0.001));
    });

    testWidgets('admin dashboard exposes the financial ledger', (tester) async {
      await tester.pumpWidget(MaterialApp(home: AdminPage(store: store)));
      await tester.scrollUntilVisible(
        find.text('Comissões do piloto (configuráveis)'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Comissões do piloto (configuráveis)'), findsOneWidget);
      expect(find.text('Resumo financeiro (MT)'), findsOneWidget);
      expect(find.text('Pedidos e livro financeiro'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.textContaining('Pagamento M-Pesa • estado:'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('REGISTAR RECEBIMENTO (DEMO)'), findsNothing);
      expect(find.textContaining('Pagamento M-Pesa • estado:'), findsOneWidget);
      expect(find.text('Comissão bruta Yafika'), findsOneWidget);
    });
  });
}
