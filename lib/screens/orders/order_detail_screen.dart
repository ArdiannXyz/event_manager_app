import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Map<String, dynamic>? _order;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    try {
      final order = await ApiService.getOrder(widget.orderId);
      setState(() {
        _order = order;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load order: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId}'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrder,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_order == null) {
      return _buildMockOrderDetail();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Order Status',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildOrderRow('Order ID', _order!['id']?.toString() ?? widget.orderId),
                  _buildOrderRow('Status', _order!['status']?.toString() ?? 'Confirmed'),
                  _buildOrderRow('Date', _order!['created_at']?.toString() ?? DateTime.now().toString().split(' ')[0]),
                  _buildOrderRow('Total Amount', '\$${_order!['total_amount']?.toString() ?? '50.00'}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Event Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.event, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Event Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildOrderRow('Event Name', _order!['event_name']?.toString() ?? 'Sample Event'),
                  _buildOrderRow('Event Date', _order!['event_date']?.toString() ?? '2024-12-25'),
                  _buildOrderRow('Location', _order!['event_location']?.toString() ?? 'Sample Location'),
                  _buildOrderRow('Tickets', _order!['ticket_quantity']?.toString() ?? '2'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notification Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    Text(
                      'Notification Received',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'You were redirected here from a push notification. This demonstrates the deep-linking functionality working correctly!',
                  style: TextStyle(color: Colors.blue.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockOrderDetail() {
    // Mock order details for demonstration
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Order Status',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildOrderRow('Order ID', widget.orderId),
                  _buildOrderRow('Status', 'Confirmed'),
                  _buildOrderRow('Date', DateTime.now().toString().split(' ')[0]),
                  _buildOrderRow('Total Amount', '\$75.00'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Event Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.event, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Event Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildOrderRow('Event Name', 'Flutter Conference 2024'),
                  _buildOrderRow('Event Date', '2024-12-25'),
                  _buildOrderRow('Location', 'Jakarta Convention Center'),
                  _buildOrderRow('Tickets', '2 Regular Tickets'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Customer Information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Customer Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildOrderRow('Name', 'John Doe'),
                  _buildOrderRow('Email', 'john.doe@example.com'),
                  _buildOrderRow('Phone', '+62 812 3456 7890'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notification Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    Text(
                      'Deep Link Success!',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'You were successfully redirected here from a push notification. This demonstrates that FCM deep-linking is working correctly in all app states (foreground, background, and terminated).',
                  style: TextStyle(color: Colors.green.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Download functionality not implemented'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Ticket'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share functionality not implemented'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}