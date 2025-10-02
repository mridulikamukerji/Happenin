import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'UPI';
  bool _isProcessing = false;

  final List<String> _paymentMethods = [
    'UPI',
    'Netbanking',
    'Credit/Debit Card',
    'Wallet'
  ];

  // Simulated payment processing (always successful for now)
  Future<void> _processPayment(BuildContext context) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Simulate a delay for processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    // ✅ Always successful (no failure simulation)
    bool isSuccess = true;

    showDialog(
      context: context,
      barrierDismissible: false, // Force user to press OK
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          isSuccess ? 'Payment Successful' : 'Payment Failed',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          isSuccess
              ? 'Your payment was successful!'
              : 'Payment failed. Please try again later.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.pop(context, isSuccess);
              // ✅ Return result to previous page
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(String method, IconData icon) {
    return Card(
      color: _selectedPaymentMethod == method
          ? const Color(0xFF2E0B5C)
          : Colors.grey[850],
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          method,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: _selectedPaymentMethod == method
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF2E0B5C),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/static_loading_page.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPaymentMethodTile('UPI', Icons.account_balance_wallet),
            _buildPaymentMethodTile('Netbanking', Icons.account_balance),
            _buildPaymentMethodTile('Credit/Debit Card', Icons.credit_card),
            _buildPaymentMethodTile(
                'Wallet', Icons.account_balance_wallet_outlined),
            const SizedBox(height: 40),
            _isProcessing
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2E0B5C),
                    ),
                  )
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2E0B5C),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.payment),
                    label: const Text(
                      'Pay Now',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _processPayment(context),
                  ),
          ],
        ),
      ),
    );
  }
}
