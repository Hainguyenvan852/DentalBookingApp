import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

Future<String> makePayment(BuildContext context, String amount, String currency, String description, String customerName, String customerEmail, String customerPhoneNumber, Address address) async {
  final paymentIntentData = await fetchPaymentIntent(amount, currency, description, customerName, customerEmail, customerPhoneNumber);
  final clientSecret = paymentIntentData?['clientSecret'];
  final ephemeralKey = paymentIntentData?['ephemeralKey'];
  final customerId = paymentIntentData?['customerId'];
  final paymentIntentId = paymentIntentData?['paymentIntentId'];

  try {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        customerEphemeralKeySecret: ephemeralKey,
        customerId: customerId,
        merchantDisplayName: 'Dental Booking Clinic',
        style: ThemeMode.light,
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'VN',
          testEnv: true,
          currencyCode: 'vnd',
        ),
        appearance: PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            primary: Colors.blue,
          ),
          shapes: PaymentSheetShape(
            borderRadius: 12.0,
          ),
        ),
        billingDetails: BillingDetails(
          name: customerName,
          email: customerEmail,
          phone: customerPhoneNumber,
          address: address,
        ),
      ),
    );

    await Stripe.instance.presentPaymentSheet();

    return 'success';
  } on StripeException catch (e) {
    if (e.error.code == FailureCode.Canceled) {
      final result = await cancelOrder(paymentIntentId!);

      if(result == 'success'){
        return 'fail';
      } else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Error'),
              backgroundColor: Colors.blue.withOpacity(0.5),
            )
        );
        return 'error 2';
      }
    } else {
      debugPrint('Lỗi thanh toán: ${e.error.localizedMessage}');
      return 'Lỗi thanh toán: ${e.error.localizedMessage}';
    }
  } catch (e) {
    debugPrint('Lỗi hệ thống khác: $e');
    return 'Lỗi hệ thống khác: $e';
  }
}

Future<Map<String, String>?> fetchPaymentIntent(String amount, String currency, String description, String customerName, String customerEmail, String customerPhoneNumber) async {
  try {
    const url = 'http://10.0.2.2:5001/dental-booking-app-8934f/us-central1/createPaymentIntent';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
        'description': description,
        'customerEmail': customerEmail,
        'customerName': customerName,
        'customerPhoneNumber': customerPhoneNumber
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return {
        'clientSecret': jsonResponse['clientSecret'],
        'ephemeralKey': jsonResponse['ephemeralKey'],
        'customerId': jsonResponse['customerId'],
        'paymentIntentId': jsonResponse['paymentIntentId']
      };
    } else {
      debugPrint('Lỗi Backend: ${response.body}');
      return null;
    }
  } catch (e) {
    debugPrint('Lỗi kết nối: $e');
    return null;
  }
}

Future<String> cancelOrder(String paymentIntentId) async {
  try {
    const url = 'http://10.0.2.2:5001/dental-booking-app-8934f/us-central1/cancelOrder';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'paymentIntentId': paymentIntentId,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if(jsonResponse['status'] == 'canceled'){
        return 'success';
      }
      else{
        return 'fail';
      }
    } else {
      debugPrint('Lỗi Backend: ${response.body}');
      return 'Lỗi Backend';
    }
  } catch (e) {
    debugPrint('Lỗi kết nối: $e');
    return 'Lỗi kết nối: $e';
  }

}
