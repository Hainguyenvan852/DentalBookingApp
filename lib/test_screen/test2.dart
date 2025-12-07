import 'dart:convert';

import 'package:dental_booking_app/data/model/invoice_model.dart';
import 'package:dental_booking_app/data/model/payment_model.dart';
import 'package:dental_booking_app/data/repository/invoice_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../data/repository/payment_repository.dart';
import '../firebase_options.dart';


// Account Test: Visa: 4242424242424242 | Mastercard: 5555555555554444
// "C:\Users\ADMIN\AppData\Local\Android\Sdk\platform-tools\adb.exe" reverse tcp:5001 tcp:5001
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey = 'pk_test_51SZ7SG1a3xlBuZAXlFWSbEVOePEy1psJqe18cTRp9IyVKzwzwqKMqSocYOxbhE9mvtzVvpDV9TOgEBGcRpRnaPQo00hhmvKZPS';
  Stripe.urlScheme = 'flutterstripe';
  
  runApp(
    MaterialApp(
      home: MyApp(),
    )
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final invoiceRepo = InvoiceRepository();
  final paymentRepo = PaymentRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            final result1 = await makePayment(context, '150000', 'vnd', 'Test thanh toán lần 1', 'Nguyễn Thế Định', 'hainguyenvan2852@gmail.com', '0988888888');
            if(result1 == 'success'){
              final payment = Payment(
                  id: 'tmp',
                  method: 'banking',
                  createdAt: DateTime.now(),
                  amount: 150000,
                  userId: '123',
                  description: 'Test thanh toan va tao hoa don'
              );
              final result2 = await paymentRepo.createNewPayment(payment);

              if(result2 == 'error'){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Error'),
                      backgroundColor: Colors.blue.withOpacity(0.5),
                    )
                );
              } else{
                final invoice = Invoice(id: 'tmp',
                    status: 'paid',
                    amountPaid: 150000,
                    balance: 0,
                    invoiceType: 'purchase',
                    createdAt: DateTime.now(),
                    totalAmount: 150000,
                    patientId: '124',
                    paymentId: result2,
                    paymentType: 'pay_now',
                    description: 'Test thanh toan va tao hoa don lan 2',
                    lineItems: []
                );
                invoiceRepo.createNewInvoice(invoice);
              }
            }
          },
          child: Text('Tạo thanh toán')
        ),
      ),
    );
  }
}


Future<String> makePayment(BuildContext context, String amount, String currency, String description, String customerName, String customerEmail, String customerPhoneNumber) async {
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
          address: Address(
            city: 'Hà Nội',
            country: 'VN',
            line1: '123 Đường Láng',
            line2: '',
            postalCode: '10000',
            state: 'Hanoi',
          ),
        ),
      ),
    );

    await Stripe.instance.presentPaymentSheet();

    if(!context.mounted) return 'erorr';
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: const Text('Thanh toán thành công', style: TextStyle(fontSize: 18),)),
          backgroundColor: Colors.blue.withOpacity(0.5),
        )
    );
    return 'success';
  } on StripeException catch (e) {
    if (e.error.code == FailureCode.Canceled) {
      final result = await cancelOrder(paymentIntentId!);

      if(result == 'success'){
        if(!context.mounted) return 'error';
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(child: const Text('Bạn đã hủy thanh toán', style: TextStyle(fontSize: 18),)),
              backgroundColor: Colors.blue.withOpacity(0.5),
            )
        );
        return 'fail';
      } else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Error'),
              backgroundColor: Colors.blue.withOpacity(0.5),
            )
        );
        return 'error';
      }
    } else {
      debugPrint('Lỗi thanh toán: ${e.error.localizedMessage}');
      return 'error';
    }
  } catch (e) {
    debugPrint('Lỗi hệ thống khác: $e');
    return 'error';
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