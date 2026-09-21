import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:orderly_worker_web/models/delivery_order.dart';
import 'package:orderly_worker_web/models/order_payment_type.dart';
import 'package:orderly_worker_web/models/order_status.dart';
import 'package:orderly_worker_web/models/staff_member.dart';
import 'package:orderly_worker_web/services/worker_web_service.dart';

class WorkerWebScreen extends StatefulWidget {
  const WorkerWebScreen({super.key, required this.databaseUrl});

  final String databaseUrl;

  @override
  State<WorkerWebScreen> createState() => _WorkerWebScreenState();
}

class _WorkerWebScreenState extends State<WorkerWebScreen> {
  final TextEditingController _restaurantController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _secretController = TextEditingController();
  WorkerWebService? _service;
  StaffMember? _staff;
  List<DeliveryOrder> _orders = <DeliveryOrder>[];
  Timer? _refreshTimer;
  bool _busy = false;
  String? _error;

  bool get _loggedIn => _staff != null && _service != null;

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _restaurantController.dispose();
    _usernameController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String restaurantId = _restaurantController.text.trim();
    if (restaurantId.length < 4 || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(restaurantId)) {
      setState(() => _error = 'Ø£Ø¯Ø®Ù„ Restaurant ID ØµØ­ÙŠØ­Ø§Ù‹ Ù…Ù† 4 Ø£Ø­Ø±Ù Ø£Ùˆ Ø£Ø±Ù‚Ø§Ù… Ø¹Ù„Ù‰ Ø§Ù„Ø£Ù‚Ù„.');
      return;
    }
    if (widget.databaseUrl.trim().isEmpty) {
      setState(() => _error = 'Ù†Ø³Ø®Ø© Ø§Ù„ÙˆÙŠØ¨ ØºÙŠØ± Ù…Ù‡ÙŠØ£Ø© Ø¨Ø±Ø§Ø¨Ø· Firebase.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final WorkerWebService service = WorkerWebService(
      databaseUrl: widget.databaseUrl,
      restaurantId: restaurantId,
    );
    final result = await service.authenticate(
      username: _usernameController.text,
      secret: _secretController.text,
    );
    if (!mounted) return;
    if (!result.success || result.staff == null || !result.staff!.isWorker) {
      setState(() {
        _busy = false;
        _error = result.staff?.isManager == true
            ? 'Ù‡Ø°Ù‡ Ø§Ù„ÙˆØ§Ø¬Ù‡Ø© Ù…Ø®ØµØµØ© Ù„Ù„Ø¹Ø§Ù…Ù„ ÙÙ‚Ø·.'
            : result.message ?? 'Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¯Ø®ÙˆÙ„ ØºÙŠØ± ØµØ­ÙŠØ­Ø©.';
      });
      return;
    }
    _service = service;
    _staff = result.staff;
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (_) => _loadOrders());
    await _loadOrders();
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _loadOrders() async {
    final StaffMember? staff = _staff;
    final WorkerWebService? service = _service;
    if (staff == null || service == null) return;
    final List<DeliveryOrder> orders = await service.loadOrders(staff.driverPin);
    if (mounted) setState(() => _orders = orders);
  }

  void _logout() {
    _refreshTimer?.cancel();
    setState(() {
      _staff = null;
      _service = null;
      _orders = <DeliveryOrder>[];
      _secretController.clear();
    });
  }

  Future<void> _showCreateOrder() async {
    final String? created = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CreateOrderSheet(
        onCreate: (String number, double amount, OrderPaymentType payment, String? image) async {
          final service = _service;
          final staff = _staff;
          if (service == null || staff == null) return false;
          final bool ok = await service.createOrder(
            driverPin: staff.driverPin,
            driverName: staff.name,
            orderNumber: number,
            amount: amount,
            paymentType: payment,
            proofImageData: image,
          );
          if (ok && mounted) await _loadOrders();
          return ok;
        },
      ),
    );
    if (created != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(created)));
    }
  }

  Future<void> _updateStatus(DeliveryOrder order, OrderStatus status) async {
    final service = _service;
    final staff = _staff;
    if (service == null || staff == null) return;
    setState(() => _busy = true);
    final bool ok = await service.updateOrderStatus(
      driverPin: staff.driverPin,
      orderId: order.id,
      status: status,
    );
    await _loadOrders();
    if (mounted) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? 'ØªÙ… ØªØ­Ø¯ÙŠØ« Ø­Ø§Ù„Ø© Ø§Ù„Ø·Ù„Ø¨.' : 'ØªØ¹Ø°Ø± ØªØ­Ø¯ÙŠØ« Ø§Ù„Ø·Ù„Ø¨.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      body: SafeArea(child: _loggedIn ? _buildWorkerHome() : _buildLogin()),
    );
  }

  Widget _buildLogin() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Card(
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Icon(Icons.delivery_dining, size: 52, color: Color(0xFF13795B)),
                  const SizedBox(height: 12),
                  const Text('Ø¨ÙˆØ§Ø¨Ø© Ø§Ù„Ø¹Ø§Ù…Ù„', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Ø¯Ø®ÙˆÙ„ ÙˆØ¥Ø¯Ø§Ø±Ø© Ø·Ù„Ø¨Ø§ØªÙƒ ÙÙ‚Ø·', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 26),
                  TextField(controller: _restaurantController, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'Restaurant ID', prefixIcon: Icon(Icons.storefront_outlined))),
                  const SizedBox(height: 12),
                  TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù…', prefixIcon: Icon(Icons.person_outline))),
                  const SizedBox(height: 12),
                  TextField(controller: _secretController, obscureText: true, keyboardType: TextInputType.visiblePassword, decoration: const InputDecoration(labelText: 'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø£Ùˆ PIN', prefixIcon: Icon(Icons.lock_outline))),
                  if (_error != null) ...<Widget>[
                    const SizedBox(height: 14),
                    Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(onPressed: _busy ? null : _login, icon: const Icon(Icons.login), label: Text(_busy ? 'Ø¬Ø§Ø± Ø§Ù„ØªØ­Ù‚Ù‚...' : 'Ø¯Ø®ÙˆÙ„ Ø§Ù„Ø¹Ø§Ù…Ù„')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkerHome() {
    final staff = _staff!;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
          child: Row(
            children: <Widget>[
              const Icon(Icons.delivery_dining, color: Color(0xFF13795B)),
              const SizedBox(width: 8),
              Expanded(child: Text('Ù…Ø±Ø­Ø¨Ø§Ù‹ ${staff.name}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _logout, tooltip: 'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø®Ø±ÙˆØ¬', icon: const Icon(Icons.logout)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(children: <Widget>[Expanded(child: Text('${_orders.length} Ø·Ù„Ø¨', style: const TextStyle(color: Colors.black54))), FilledButton.icon(onPressed: _busy ? null : _showCreateOrder, icon: const Icon(Icons.add), label: const Text('Ø·Ù„Ø¨ Ø¬Ø¯ÙŠØ¯'))]),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _orders.isEmpty
              ? const Center(child: Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ø·Ù„Ø¨Ø§Øª Ø­Ø§Ù„ÙŠØ§Ù‹'))
              : ListView.builder(padding: const EdgeInsets.all(18), itemCount: _orders.length, itemBuilder: (_, int index) => _OrderCard(order: _orders[index], onPickedUp: () => _updateStatus(_orders[index], OrderStatus.pickedUp), onDelivered: () => _updateStatus(_orders[index], OrderStatus.delivered))),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onPickedUp, required this.onDelivered});
  final DeliveryOrder order;
  final VoidCallback onPickedUp;
  final VoidCallback onDelivered;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          Row(children: <Widget>[Expanded(child: Text('Ø·Ù„Ø¨ ${order.displayNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))), Text('${order.amount.toStringAsFixed(0)} Ø¯.Ø¹')]),
          const SizedBox(height: 8),
          Text('${order.displayPayment} â€¢ ${order.status.label}', style: TextStyle(color: order.status.color, fontWeight: FontWeight.w600)),
          if (order.proofImageData != null) ...<Widget>[const SizedBox(height: 10), Image.memory(base64Decode(order.proofImageData!.split(',').last), height: 110, fit: BoxFit.cover)],
          if (order.status == OrderStatus.preparing) ...<Widget>[const SizedBox(height: 12), FilledButton.icon(onPressed: onPickedUp, icon: const Icon(Icons.two_wheeler), label: const Text('ØªÙ… Ø§Ù„Ø§Ø³ØªÙ„Ø§Ù… Ù…Ù† Ø§Ù„Ù…Ø·Ø¹Ù…'))],
          if (order.status == OrderStatus.pickedUp) ...<Widget>[const SizedBox(height: 12), FilledButton.icon(onPressed: onDelivered, icon: const Icon(Icons.done_all), label: const Text('ØªÙ… Ø§Ù„ØªØ³Ù„ÙŠÙ… Ù„Ù„Ø²Ø¨ÙˆÙ†'))],
        ]),
      ),
    );
  }
}

class _CreateOrderSheet extends StatefulWidget {
  const _CreateOrderSheet({required this.onCreate});
  final Future<bool> Function(String, double, OrderPaymentType, String?) onCreate;
  @override
  State<_CreateOrderSheet> createState() => _CreateOrderSheetState();
}

class _CreateOrderSheetState extends State<_CreateOrderSheet> {
  final TextEditingController _number = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  OrderPaymentType _payment = OrderPaymentType.cash;
  String? _image;
  bool _busy = false;

  @override
  void dispose() { _number.dispose(); _amount.dispose(); super.dispose(); }

  Future<void> _capture() async {
    final XFile? file = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 62, maxWidth: 1280);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (bytes.length > 900000) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ø§Ù„ØµÙˆØ±Ø© ÙƒØ¨ÙŠØ±Ø© Ø¬Ø¯Ø§Ù‹ØŒ Ø­Ø§ÙˆÙ„ Ø§Ù„ØªÙ‚Ø§Ø· ØµÙˆØ±Ø© Ø£ÙˆØ¶Ø­ Ø¨Ø­Ø¬Ù… Ø£ØµØºØ±.')));
      return;
    }
    setState(() => _image = 'data:image/jpeg;base64,${base64Encode(bytes)}');
  }

  Future<void> _submit() async {
    final double? amount = double.tryParse(_amount.text.trim().replaceAll(',', ''));
    if (_number.text.trim().isEmpty || amount == null || amount < 0) return;
    setState(() => _busy = true);
    final bool ok = await widget.onCreate(_number.text, amount, _payment, _image);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, 'ØªÙ… Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø·Ù„Ø¨ ÙˆÙ…Ø²Ø§Ù…Ù†ØªÙ‡ Ù…Ø¹ Ø§Ù„Ù…Ø·Ø¹Ù….');
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(18, 18, 18, MediaQuery.viewInsetsOf(context).bottom + 18),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          const Text('Ø·Ù„Ø¨ Ø¬Ø¯ÙŠØ¯', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          TextField(controller: _number, decoration: const InputDecoration(labelText: 'Ø±Ù‚Ù… Ø§Ù„Ø·Ù„Ø¨')),
          const SizedBox(height: 10),
          TextField(controller: _amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Ø§Ù„Ù…Ø¨Ù„Øº')),
          const SizedBox(height: 10),
          DropdownButtonFormField<OrderPaymentType>(initialValue: _payment, decoration: const InputDecoration(labelText: 'Ø·Ø±ÙŠÙ‚Ø© Ø§Ù„Ø¯ÙØ¹'), items: OrderPaymentType.values.map((item) => DropdownMenuItem(value: item, child: Text(item.label))).toList(), onChanged: (value) => setState(() => _payment = value ?? _payment)),
          const SizedBox(height: 12),
          OutlinedButton.icon(onPressed: _busy ? null : _capture, icon: Icon(_image == null ? Icons.camera_alt_outlined : Icons.check_circle), label: Text(_image == null ? 'Ø§Ù„ØªÙ‚Ø§Ø· ØµÙˆØ±Ø© Ø¥Ø«Ø¨Ø§Øª' : 'ØªÙ… Ø¥Ø±ÙØ§Ù‚ Ø§Ù„ØµÙˆØ±Ø©')),
          const SizedBox(height: 14),
          FilledButton.icon(onPressed: _busy ? null : _submit, icon: const Icon(Icons.send), label: Text(_busy ? 'Ø¬Ø§Ø± Ø§Ù„Ø¥Ø±Ø³Ø§Ù„...' : 'Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø·Ù„Ø¨')),
        ]),
      );
}
