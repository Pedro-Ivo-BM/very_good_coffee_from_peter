import 'dart:async';

import 'package:connectivity_helper/connectivity_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  group('ConnectivityHelper', () {
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockConnectivity = MockConnectivity();
      ConnectivityHelper.resetInstance();
    });

    tearDown(() {
      ConnectivityHelper.resetInstance();
    });

    group('instance management', () {
      test('returns singleton instance', () {
        final instance1 = ConnectivityHelper.instance;
        final instance2 = ConnectivityHelper.instance;
        expect(instance1, same(instance2));
      });

      test('configureInstance sets custom instance', () {
        final customHelper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(customHelper);
        expect(ConnectivityHelper.instance, same(customHelper));
      });

      test('resetInstance clears the singleton', () {
        final instance1 = ConnectivityHelper.instance;
        ConnectivityHelper.resetInstance();
        final instance2 = ConnectivityHelper.instance;
        expect(instance1, isNot(same(instance2)));
      });
    });

    group('checkStatuses', () {
      test('returns connectivity results', () async {
        final results = [ConnectivityResult.wifi];
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => results);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final statuses = await ConnectivityHelper.checkStatuses();
        expect(statuses, equals(results));
        verify(() => mockConnectivity.checkConnectivity()).called(1);
      });

      test('returns empty list when no connection', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final statuses = await ConnectivityHelper.checkStatuses();
        expect(statuses, equals([ConnectivityResult.none]));
      });
    });

    group('hasConnection', () {
      test('returns true when connected to wifi', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final hasConnection = await ConnectivityHelper.hasConnection();
        expect(hasConnection, isTrue);
      });

      test('returns true when connected to mobile', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.mobile]);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final hasConnection = await ConnectivityHelper.hasConnection();
        expect(hasConnection, isTrue);
      });

      test('returns false when no connection', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final hasConnection = await ConnectivityHelper.hasConnection();
        expect(hasConnection, isFalse);
      });

      test('returns true when multiple connections exist', () async {
        when(() => mockConnectivity.checkConnectivity()).thenAnswer(
          (_) async => [ConnectivityResult.wifi, ConnectivityResult.mobile],
        );
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final hasConnection = await ConnectivityHelper.hasConnection();
        expect(hasConnection, isTrue);
      });
    });

    group('onStatusChange', () {
      test('emits connectivity result changes', () async {
        final controller = StreamController<List<ConnectivityResult>>();
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final results = <List<ConnectivityResult>>[];
        final subscription = ConnectivityHelper.onStatusChange.listen(results.add);

        controller.add([ConnectivityResult.wifi]);
        controller.add([ConnectivityResult.mobile]);
        await Future<void>.delayed(Duration.zero);

        expect(results, equals([
          [ConnectivityResult.wifi],
          [ConnectivityResult.mobile],
        ]));

        await subscription.cancel();
        await controller.close();
      });
    });

    group('onConnectionChange', () {
      test('emits true when connected', () async {
        final controller = StreamController<List<ConnectivityResult>>();
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final results = <bool>[];
        final subscription = ConnectivityHelper.onConnectionChange.listen(results.add);

        controller.add([ConnectivityResult.wifi]);
        await Future<void>.delayed(Duration.zero);

        expect(results, equals([true]));

        await subscription.cancel();
        await controller.close();
      });

      test('emits false when disconnected', () async {
        final controller = StreamController<List<ConnectivityResult>>();
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final results = <bool>[];
        final subscription = ConnectivityHelper.onConnectionChange.listen(results.add);

        controller.add([ConnectivityResult.none]);
        await Future<void>.delayed(Duration.zero);

        expect(results, equals([false]));

        await subscription.cancel();
        await controller.close();
      });

      test('uses distinct to avoid duplicate emissions', () async {
        final controller = StreamController<List<ConnectivityResult>>();
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final results = <bool>[];
        final subscription = ConnectivityHelper.onConnectionChange.listen(results.add);

        controller.add([ConnectivityResult.wifi]);
        controller.add([ConnectivityResult.mobile]);
        controller.add([ConnectivityResult.none]);
        await Future<void>.delayed(Duration.zero);

        expect(results, equals([true, false]));

        await subscription.cancel();
        await controller.close();
      });
    });

    group('listen', () {
      test('subscribes to status changes', () async {
        final controller = StreamController<List<ConnectivityResult>>();
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final results = <List<ConnectivityResult>>[];
        final subscription = ConnectivityHelper.listen(results.add);

        controller.add([ConnectivityResult.wifi]);
        await Future<void>.delayed(Duration.zero);

        expect(results, equals([[ConnectivityResult.wifi]]));

        await subscription.cancel();
        await controller.close();
      });

      test('handles errors with onError callback', () async {
        final controller = StreamController<List<ConnectivityResult>>();
        final error = Exception('Connection error');
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        Object? capturedError;
        final subscription = ConnectivityHelper.listen(
          (_) {},
          onError: (e, _) => capturedError = e,
        );

        controller.addError(error);
        await Future<void>.delayed(Duration.zero);

        expect(capturedError, equals(error));

        await subscription.cancel();
        await controller.close();
      });
    });

    group('listenForConnection', () {
      test('subscribes to connection changes', () async {
        final controller = StreamController<List<ConnectivityResult>>();
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        final results = <bool>[];
        final subscription = ConnectivityHelper.listenForConnection(results.add);

        controller.add([ConnectivityResult.wifi]);
        await Future<void>.delayed(Duration.zero);

        expect(results, equals([true]));

        await subscription.cancel();
        await controller.close();
      });

      test('handles errors with onError callback', () async {
        final controller = StreamController<List<ConnectivityResult>>();
        final error = Exception('Connection error');
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);
        
        final helper = ConnectivityHelper(connectivity: mockConnectivity);
        ConnectivityHelper.configureInstance(helper);

        Object? capturedError;
        final subscription = ConnectivityHelper.listenForConnection(
          (_) {},
          onError: (e, _) => capturedError = e,
        );

        controller.addError(error);
        await Future<void>.delayed(Duration.zero);

        expect(capturedError, equals(error));

        await subscription.cancel();
        await controller.close();
      });
    });
  });
}

