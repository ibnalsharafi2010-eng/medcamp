
import '../../core/app_export.dart';
import './widgets/demo_credentials_widget.dart';
import './widgets/login_header_widget.dart';
import './widgets/otp_input_widget.dart';
import './widgets/phone_input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isOtpSent = false;
  bool _isLoading = false;
  String _phoneNumber = '';
  int _resendCountdown = 60;
  bool _canResend = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Replace with Firebase Phone Auth for production
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _isLoading = false;
      _isOtpSent = true;
      _phoneNumber = _phoneController.text.trim();
      _resendCountdown = 60;
      _canResend = false;
    });
    _startResendTimer();
    _slideController.reset();
    _slideController.forward();
  }

  void _startResendTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
        }
      });
      return _resendCountdown > 0 && !_canResend;
    });
  }

  void _autofillCredentials(String phone) {
    // TODO: Replace with Riverpod/Bloc for production
    _phoneController.text = phone;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
        ),
      ),
    );
  }

  Widget _buildPhoneLayout() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          const LoginHeaderWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildFormContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: SizedBox(
          width: 480,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LoginHeaderWidget(isTablet: true),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildFormContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_isOtpSent) ...[
            const SizedBox(height: 8),
            Text(
              'تسجيل الدخول',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'أدخل رقم هاتفك للمتابعة',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            PhoneInputWidget(controller: _phoneController),
            const SizedBox(height: 20),
            _buildSendOtpButton(),
            const SizedBox(height: 24),
            DemoCredentialsWidget(onAutofill: _autofillCredentials),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'التحقق من الرقم',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: 'تم إرسال رمز التحقق إلى '),
                  TextSpan(
                    text: _phoneNumber,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            OtpInputWidget(onCompleted: _verifyOtp),
            const SizedBox(height: 20),
            _buildResendRow(),
            const SizedBox(height: 20),
            _buildChangePhoneButton(),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSendOtpButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _sendOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                'إرسال رمز التحقق',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildResendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('لم تستلم الرمز؟ ', style: Theme.of(context).textTheme.bodyMedium),
        if (_canResend)
          GestureDetector(
            onTap: () {
              setState(() {
                _isOtpSent = false;
              });
            },
            child: Text(
              'إعادة الإرسال',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          )
        else
          Text(
            'إعادة الإرسال بعد ${_resendCountdown}s',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
      ],
    );
  }

  Widget _buildChangePhoneButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isOtpSent = false;
        });
        _slideController.reset();
        _slideController.forward();
      },
      child: Text(
        'تغيير رقم الهاتف',
        style: GoogleFonts.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  void _verifyOtp(String otp) async {
    setState(() => _isLoading = true);
    // TODO: Replace with Firebase Phone Auth OTP verification for production
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.campManagementScreen,
      (route) => false,
    );
  }
}
