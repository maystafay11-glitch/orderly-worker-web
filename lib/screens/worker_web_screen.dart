import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orderly_worker_web/models/delivery_order.dart';
import 'package:orderly_worker_web/models/staff_member.dart';
import 'package:orderly_worker_web/services/worker_web_service.dart';

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
  bool _showLogin = false;

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
      setState(() => _error = 'أدخل معرف المطعم بشكل صحيح، لا يقل عن 4 أحرف أو أرقام.');
      return;
    }
    if (widget.databaseUrl.trim().isEmpty || widget.databaseUrl.contains('YOUR_DATABASE')) {
      setState(() => _error = 'توجد مشكلة في إعداد قاعدة البيانات، يرجى مراجعة إعدادات التطبيق.');
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
      backgroundColor: const Color(0xff0b1014),
      body: SafeArea(child: _staff == null ? _landingView() : _homeView()),
    );
  }

  Widget _landingView() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFF04070B),
                  Color(0xFF0B121A),
                  Color(0xFF0E171E),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _ParticleBackgroundPainter(),
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0F1E14),
                      border: Border.all(color: const Color(0xFF2AD39F), width: 2.5),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0xFF2AD39F),
                          blurRadius: 26,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      size: 42,
                      color: Color(0xFF82F0C3),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Orderly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF15252A),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFF2F4D52), width: 1),
                    ),
                    child: const Text(
                      'نظام إدارة التوصيل الذكي',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFA9D9D0),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => setState(() => _showLogin = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: <Color>[
                            Color(0xFF6F5DEB),
                            Color(0xFF4B7BFF),
                          ],
                        ),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x664b7bff),
                            blurRadius: 22,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: const Text(
                                'تسجيل دخول السائقين أو العمال',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.directions_car_filled_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showLogin) ...<Widget>[
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101A22),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFF263B46), width: 1),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x66000000),
                            blurRadius: 24,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextField(
                            controller: _restaurant,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'معرف أو اسم المطعم',
                              hintText: 'Restaurant ID',
                              hintStyle: const TextStyle(color: Color(0xFF859293)),
                              labelStyle: const TextStyle(color: Color(0xFFB3C5C4)),
                              prefixIcon: const Icon(Icons.storefront_rounded, color: Color(0xFF7EEDC1)),
                              filled: true,
                              fillColor: const Color(0xFF0C141A),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF263B46)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF263B46)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF2CD6A2), width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _user,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'اسم العامل',
                              hintText: 'Username',
                              hintStyle: const TextStyle(color: Color(0xFF859293)),
                              labelStyle: const TextStyle(color: Color(0xFFB3C5C4)),
                              prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF7EEDC1)),
                              filled: true,
                              fillColor: const Color(0xFF0C141A),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF263B46)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF263B46)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF2CD6A2), width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _secretController,
                            obscureText: true,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور أو PIN',
                              hintText: 'Password / PIN',
                              hintStyle: const TextStyle(color: Color(0xFF859293)),
                              labelStyle: const TextStyle(color: Color(0xFFB3C5C4)),
                              prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF7EEDC1)),
                              filled: true,
                              fillColor: const Color(0xFF0C141A),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF263B46)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF263B46)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF2CD6A2), width: 1.5),
                              ),
                            ),
                          ),
                          if (_error != null) ...<Widget>[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0x1AF44336),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFFF6B6B), width: 1),
                              ),
                              child: Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Color(0xFFFFCACA), fontSize: 13),
                              ),
                            ),
                          ],
                          const SizedBox(height: 22),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Color(0xFF19B489),
                                  Color(0xFF13795B),
                                ],
                              ),
                            ),
                            child: FilledButton.icon(
                              onPressed: _busy ? null : _login,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              icon: Icon(_busy ? Icons.hourglass_top_rounded : Icons.login_rounded),
                              label: Text(
                                _busy ? 'جارٍ التحقق...' : 'دخول العامل',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 26),
                  const Text(
                    'محمي بنظام رموز سرية مشفرة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF7E8D95),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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

class _ParticleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = const Color(0xFF6EE7B7).withValues(alpha: 0.15);
    for (int i = 0; i < 60; i++) {
      final double x = (i * 97.3) % size.width;
      final double y = ((i * 53.7) % size.height) * 0.98;
      final double radius = 1.8 + (i % 4) * 0.7;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
