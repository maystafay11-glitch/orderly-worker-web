import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orderly_worker_web/models/delivery_order.dart';
import 'package:orderly_worker_web/models/staff_member.dart';
import 'package:orderly_worker_web/services/worker_web_service.dart';

const String _workerPortal = '\u{0628}\u{0648}\u{0627}\u{0628}\u{0629} \u{0627}\u{0644}\u{0639}\u{0627}\u{0645}\u{0644}';
const String _workerOnly = '\u{062f}\u{062e}\u{0648}\u{0644} \u{0648}\u{0625}\u{062f}\u{0627}\u{0631}\u{0629} \u{0637}\u{0644}\u{0628}\u{0627}\u{062a}\u{0643} \u{0641}\u{0642}\u{0637}';
const String _username = '\u{0627}\u{0633}\u{0645} \u{0627}\u{0644}\u{0645}\u{0633}\u{062a}\u{062e}\u{062f}\u{0645}';
const String _secret = '\u{0643}\u{0644}\u{0645}\u{0629} \u{0627}\u{0644}\u{0645}\u{0631}\u{0648}\u{0631} \u{0623}\u{0648} PIN';
const String _loginLabel = '\u{062f}\u{062e}\u{0648}\u{0644} \u{0627}\u{0644}\u{0639}\u{0627}\u{0645}\u{0644}';

class WorkerWebScreen extends StatefulWidget {
  const WorkerWebScreen({super.key, required this.databaseUrl});
  final String databaseUrl;
  @override
  State<WorkerWebScreen> createState() => _WorkerWebScreenState();
}

class _WorkerWebScreenState extends State<WorkerWebScreen> {
  final TextEditingController _restaurant = TextEditingController();
  final TextEditingController _user = TextEditingController();
  final TextEditingController _secretController = TextEditingController();
  WorkerWebService? _service;
  StaffMember? _staff;
  List<DeliveryOrder> _orders = <DeliveryOrder>[];
  Timer? _timer;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _timer?.cancel();
    _restaurant.dispose();
    _user.dispose();
    _secretController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String rid = _restaurant.text.trim();
    if (rid.length < 4 || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(rid)) {
      setState(() => _error = 'Restaurant ID must contain at least 4 letters or numbers.');
      return;
    }
    if (widget.databaseUrl.trim().isEmpty || widget.databaseUrl.contains('YOUR_DATABASE')) {
      setState(() => _error = 'Firebase URL is not configured for this web app.');
      return;
    }
    setState(() { _busy = true; _error = null; });
    final WorkerWebService service = WorkerWebService(databaseUrl: widget.databaseUrl, restaurantId: rid);
    final result = await service.authenticate(username: _user.text.trim(), secret: _secretController.text.trim());
    if (!mounted) return;
    if (!result.success || result.staff == null || !result.staff!.isWorker) {
      setState(() { _busy = false; _error = result.staff?.isManager == true ? 'Manager accounts cannot use this page.' : (result.message ?? 'Invalid worker credentials.'); });
      return;
    }
    _service = service;
    _staff = result.staff;
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _loadOrders());
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
    _timer?.cancel();
    setState(() { _staff = null; _service = null; _orders = <DeliveryOrder>[]; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f7f5),
      body: SafeArea(child: _staff == null ? _loginView() : _homeView()),
    );
  }

  Widget _loginView() {
    return Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(26), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        const Icon(Icons.delivery_dining, size: 56, color: Color(0xff13795b)),
        const SizedBox(height: 12),
        const Text(_workerPortal, textAlign: TextAlign.center, style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
        const SizedBox(height: 7),
        const Text(_workerOnly, textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 26),
        TextField(controller: _restaurant, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'Restaurant ID', prefixIcon: Icon(Icons.storefront_outlined))),
        const SizedBox(height: 12),
        TextField(controller: _user, decoration: const InputDecoration(labelText: _username, prefixIcon: Icon(Icons.person_outline))),
        const SizedBox(height: 12),
        TextField(controller: _secretController, obscureText: true, decoration: const InputDecoration(labelText: _secret, prefixIcon: Icon(Icons.lock_outline))),
        if (_error != null) ...<Widget>[const SizedBox(height: 14), Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: Colors.red))],
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: _busy ? null : _login, icon: const Icon(Icons.login), label: Text(_busy ? 'Checking...' : _loginLabel)),
      ]))),
    )));
  }

  Widget _homeView() {
    final StaffMember staff = _staff!;
    return Column(children: <Widget>[
      Padding(padding: const EdgeInsets.all(18), child: Row(children: <Widget>[const Icon(Icons.delivery_dining, color: Color(0xff13795b)), const SizedBox(width: 8), Expanded(child: Text(staff.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))), IconButton(onPressed: _logout, icon: const Icon(Icons.logout))])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Align(alignment: Alignment.centerRight, child: Text('${_orders.length} orders'))),
      Expanded(child: _orders.isEmpty ? const Center(child: Text('No orders yet')) : ListView.builder(padding: const EdgeInsets.all(18), itemCount: _orders.length, itemBuilder: (_, int i) => _OrderCard(order: _orders[i]))),
    ]);
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final DeliveryOrder order;
  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
    Text('Order ${order.displayNumber}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    Text('${order.amount.toStringAsFixed(0)} IQD - ${order.status.label}'),
    if (order.proofImageData != null) ...<Widget>[const SizedBox(height: 10), Image.memory(base64Decode(order.proofImageData!.split(',').last), height: 120, fit: BoxFit.cover)],
  ])));
}
