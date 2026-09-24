import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/destination.dart';
import '../providers/booking_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

class BookingScreen extends StatefulWidget {
  final Destination destination;
  const BookingScreen({super.key, required this.destination});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _step = 0;
  bool _loading = false;

  // Step 1
  DateTime _date = DateTime.now().add(const Duration(days: 7));
  int _guests = 2;

  // Step 2
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.goldPrimary,
            onPrimary: Colors.black,
            surface: AppColors.darkCard,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    context.read<BookingProvider>().addBooking(
      Booking(
        destination: widget.destination,
        date: _date,
        guests: _guests,
        fullName: _nameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
      ),
    );

    setState(() => _loading = false);
    _showSuccess();
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.goldPrimary.withOpacity(0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.goldGradient,
                  boxShadow: [AppTheme.goldGlow],
                ),
                child: const Icon(Icons.check, color: Colors.black, size: 40),
              ),
              const SizedBox(height: 20),
              Text('Booking Confirmed!',
                  style: GoogleFonts.playfairDisplay(
                      color: AppColors.goldPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text(
                'Your trip to ${widget.destination.name} has been booked successfully.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: AppColors.textMuted, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),
              GradientButton(
                label: 'Done',
                icon: Icons.done_all,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.destination.price * _guests;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.goldPrimary),
                    ),
                    Text('Book Your Trip',
                        style: GoogleFonts.playfairDisplay(
                            color: AppColors.textLight,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              // Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(3, (i) {
                    final active = i <= _step;
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: active ? AppTheme.goldGradient : null,
                          color: active ? null : AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: _step == 0
                        ? _step1()
                        : _step == 1
                        ? _step2()
                        : _step3(total),
                  ),
                ),
              ),
              // Bottom action
              Padding(
                padding: const EdgeInsets.all(20),
                child: GradientButton(
                  label: _step == 2 ? 'Confirm Booking' : 'Continue',
                  icon: _step == 2
                      ? Icons.check_circle
                      : Icons.arrow_forward,
                  isLoading: _loading,
                  onTap: () {
                    if (_step == 2) {
                      _confirm();
                    } else if (_step == 1) {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _step++);
                      }
                    } else {
                      setState(() => _step++);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _step1() {
    return Column(
      key: const ValueKey('s1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Date & Guests',
            style: GoogleFonts.playfairDisplay(
                color: AppColors.textLight,
                fontSize: 22,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        GlassCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_today,
                    color: Colors.black, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Travel Date',
                        style: GoogleFonts.poppins(
                            color: AppColors.textMuted, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(DateFormat('EEE, dd MMM yyyy').format(_date),
                        style: GoogleFonts.poppins(
                            color: AppColors.textLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              TextButton(
                onPressed: _pickDate,
                child: Text('Change',
                    style: GoogleFonts.poppins(
                        color: AppColors.goldPrimary,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.people,
                        color: Colors.black, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text('Guests',
                      style: GoogleFonts.poppins(
                          color: AppColors.textLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  _counterBtn(Icons.remove, () {
                    if (_guests > 1) setState(() => _guests--);
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('$_guests',
                        style: GoogleFonts.poppins(
                            color: AppColors.goldPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                  _counterBtn(Icons.add, () {
                    if (_guests < 10) setState(() => _guests++);
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.darkElevated,
          shape: BoxShape.circle,
          border: Border.all(
              color: AppColors.goldPrimary.withOpacity(0.5)),
        ),
        child: Icon(icon, color: AppColors.goldPrimary, size: 18),
      ),
    );
  }

  Widget _step2() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('s2'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Details',
              style: GoogleFonts.playfairDisplay(
                  color: AppColors.textLight,
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          _field(
            controller: _nameCtrl,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (v) {
              if (v == null || v.trim().length < 3) {
                return 'Enter at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _field(
            controller: _emailCtrl,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboard: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email required';
              final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!regex.hasMatch(v)) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _field(
            controller: _phoneCtrl,
            label: 'Phone',
            icon: Icons.phone_outlined,
            keyboard: TextInputType.phone,
            validator: (v) {
              if (v == null || v.trim().length < 10) {
                return 'Enter a valid phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      style: GoogleFonts.poppins(color: AppColors.textLight),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
        GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _step3(double total) {
    return Column(
      key: const ValueKey('s3'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review & Confirm',
            style: GoogleFonts.playfairDisplay(
                color: AppColors.textLight,
                fontSize: 22,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _review('Destination', widget.destination.name),
              _divider(),
              _review('Country', widget.destination.country),
              _divider(),
              _review('Date', DateFormat('dd MMM yyyy').format(_date)),
              _divider(),
              _review('Guests', '$_guests'),
              _divider(),
              _review('Name', _nameCtrl.text),
              _divider(),
              _review('Email', _emailCtrl.text),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [AppTheme.goldGlow],
          ),
          child: Row(
            children: [
              Text('Total',
                  style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('\$${total.toStringAsFixed(0)}',
                  style: GoogleFonts.playfairDisplay(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _review(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(k,
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted, fontSize: 13)),
          const Spacer(),
          Flexible(
            child: Text(v,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    color: AppColors.textLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
    color: AppColors.silverDark.withOpacity(0.2),
    height: 1,
  );
}