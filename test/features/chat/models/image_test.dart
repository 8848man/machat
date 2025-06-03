import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/chat/models/image.dart';

void main() {
  group('McImage Model Tests', () {
    test(
        'McImage.fromJson should create an McImage instance with correct values',
        () {
      final json = {
        'imageUrl': 'https://example.com/image.jpg',
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
        'isMine': false,
      };
      final image = McImage.fromJson(json);
      expect(image.imageUrl, 'https://example.com/image.jpg');
      expect(image.createdBy, 'user123');
      expect(image.createdAt, '2023-01-01T00:00:00Z');
      expect(image.isMine, false);
    });

    test(
        'McImage.toJson should convert an McImage instance to a Map with correct values',
        () {
      final image = McImage(
        imageUrl: 'https://example.com/image.jpg',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final json = image.toJson();
      expect(json['imageUrl'], 'https://example.com/image.jpg');
      expect(json['createdBy'], 'user123');
      expect(json['createdAt'], '2023-01-01T00:00:00Z');
      expect(json['isMine'], false);
    });

    test(
        'McImage.copyWith should create a new McImage instance with updated values',
        () {
      final image = McImage(
        imageUrl: 'https://example.com/image.jpg',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final updatedMcImage =
          image.copyWith(imageUrl: 'https://example.com/updated-image.jpg');
      expect(updatedMcImage.imageUrl, 'https://example.com/updated-image.jpg');
      expect(updatedMcImage.createdBy, 'user123');
      expect(updatedMcImage.createdAt, '2023-01-01T00:00:00Z');
      expect(updatedMcImage.isMine, false);
    });

    test('McImage equality operator should work correctly', () {
      final image1 = McImage(
        imageUrl: 'https://example.com/image.jpg',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final image2 = McImage(
        imageUrl: 'https://example.com/image.jpg',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final image3 = McImage(
        imageUrl: 'https://example.com/different-image.jpg',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      expect(image1, equals(image2));
      expect(image1, isNot(equals(image3)));
    });

    test(
        'McImage.toString should return a string representation of the McImage instance',
        () {
      final image = McImage(
        imageUrl: 'https://example.com/image.jpg',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final expectedString =
          'McImage(imageUrl: https://example.com/image.jpg, createdBy: user123, createdAt: 2023-01-01T00:00:00Z, isMine: false)';
      expect(image.toString(), expectedString);
    });

    test('McImage.hashCode should be consistent with equality', () {
      final image1 = McImage(
        imageUrl: 'https://example.com/image.jpg',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final image2 = McImage(
        imageUrl: 'https://example.com/image.jpg',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      expect(image1.hashCode, equals(image2.hashCode));
    });

    test('McImage.fromJson should handle missing fields correctly', () {
      final json = {
        'imageUrl': 'https://example.com/image.jpg',
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
      };
      final image = McImage.fromJson(json);
      expect(image.imageUrl, 'https://example.com/image.jpg');
      expect(image.createdBy, 'user123');
      expect(image.createdAt, '2023-01-01T00:00:00Z');
      expect(image.isMine, false);
    });

    test('McImage.fromJson should handle null values correctly', () {
      final json = {
        'imageUrl': 'https://example.com/image.jpg',
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
        'isMine': null,
      };
      final image = McImage.fromJson(json);
      expect(image.imageUrl, 'https://example.com/image.jpg');
      expect(image.createdBy, 'user123');
      expect(image.createdAt, '2023-01-01T00:00:00Z');
      expect(image.isMine, false);
    });

    test('McImage.fromJson should handle invalid JSON correctly', () {
      final json = {
        'imageUrl': 'https://example.com/image.jpg',
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
        'isMine': 'invalid',
      };
      expect(() => McImage.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('McImage.fromJson should handle empty JSON correctly', () {
      final Map<String, dynamic> json = {};
      expect(() => McImage.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('McImage.fromJson should handle extra fields correctly', () {
      final json = {
        'imageUrl': 'https://example.com/image.jpg',
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
        'isMine': false,
        'extraField': 'extra',
      };
      final image = McImage.fromJson(json);
      expect(image.imageUrl, 'https://example.com/image.jpg');
      expect(image.createdBy, 'user123');
      expect(image.createdAt, '2023-01-01T00:00:00Z');
      expect(image.isMine, false);
    });

    test('McImage.fromJson should handle invalid field types correctly', () {
      final json = {
        'imageUrl': 123,
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
        'isMine': false,
      };
      expect(() => McImage.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}
