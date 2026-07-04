import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/animated_background.dart';
import '../widgets/glow_text_field.dart';

/// Combined Sign-in / Register screen with a tab toggle.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  /// Drives the gentle fade-in of the hero, used when the screen mounts.
  late final AnimationController _entryController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  @override
  void dispose() {
    _tabController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final curved = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );

    return Scaffold(
      body: AnimatedGradientBackground(
        colors: [
          scheme.surface,
          const Color(0xFFEDEFFE),
          scheme.primaryContainer.withValues(alpha: 0.4),
        ],
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeTransition(
                      opacity: curved,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.2),
                          end: Offset.zero,
                        ).animate(curved),
                        child: Center(child: _HeroBadge(scheme: scheme)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: curved,
                      child: Text(
                        'Welcome to Notes',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _entryController,
                        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                      ),
                      child: Text(
                        'Sign in to sync your notes across devices.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _entryController,
                        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                      ),
                      child: _SegmentedTabs(controller: _tabController),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 380,
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          _EmailForm(mode: _AuthMode.signIn),
                          _EmailForm(mode: _AuthMode.register),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating badge above the welcome text with rotating rings.
class _HeroBadge extends StatefulWidget {
  final ColorScheme scheme;
  const _HeroBadge({required this.scheme});

  @override
  State<_HeroBadge> createState() => _HeroBadgeState();
}

class _HeroBadgeState extends State<_HeroBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.scheme;
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Transform.rotate(
                angle: _controller.value * 6.28,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.10),
                      width: 1.2,
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Transform.rotate(
                angle: -_controller.value * 6.28 * 0.7,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.18),
                      width: 1.2,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primaryContainer,
                  scheme.primaryContainer.withValues(alpha: 0.65),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 32,
              color: scheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final TabController controller;
  const _SegmentedTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return TabBar(
            controller: controller,
            indicator: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: scheme.onSurface,
            unselectedLabelColor: scheme.onSurfaceVariant,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'Sign in'),
              Tab(text: 'Register'),
            ],
          );
        },
      ),
    );
  }
}

enum _AuthMode { signIn, register }

class _EmailForm extends StatefulWidget {
  final _AuthMode mode;

  const _EmailForm({required this.mode});

  @override
  State<_EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<_EmailForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthService();
  bool _isSubmitting = false;
  bool _obscurePassword = true;

  /// Animates the password field's eye icon swap.
  late final AnimationController _toggleController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _toggleController.dispose();
    super.dispose();
  }

  bool get _isRegister => widget.mode == _AuthMode.register;

  String _friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address doesn\'t look right.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'An account with that email already exists.';
      case 'weak-password':
        return 'Choose a password with at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection. Check your network and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      if (_isRegister) {
        await _auth.register(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await _auth.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
      // Auth state listener in main.dart will route away.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_friendlyError(e))));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlowFocus(
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@example.com',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              validator: (value) {
                final v = value?.trim() ?? '';
                if (v.isEmpty) return 'Email is required';
                if (!v.contains('@') || !v.contains('.')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 14),
          GlowFocus(
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _isSubmitting ? null : _submit(),
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: _isRegister ? 'At least 6 characters' : '••••••',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: AnimatedBuilder(
                  animation: _toggleController,
                  builder: (context, child) {
                    return RotationTransition(
                      turns: Tween<double>(
                        begin: 0,
                        end: 0.5,
                      ).animate(_toggleController),
                      child: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                            _toggleController.forward(from: 0);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (_isRegister && value.length < 6) {
                  return 'Use at least 6 characters';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          _PressableSubmit(
            isSubmitting: _isSubmitting,
            isRegister: _isRegister,
            onPressed: _submit,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _isSubmitting
                ? null
                : () {
                    _emailController.clear();
                    _passwordController.clear();
                  },
            child: Text(_isRegister ? 'Clear' : 'Reset'),
          ),
        ],
      ),
    );
  }
}

class _PressableSubmit extends StatefulWidget {
  final bool isSubmitting;
  final bool isRegister;
  final VoidCallback onPressed;

  const _PressableSubmit({
    required this.isSubmitting,
    required this.isRegister,
    required this.onPressed,
  });

  @override
  State<_PressableSubmit> createState() => _PressableSubmitState();
}

class _PressableSubmitState extends State<_PressableSubmit>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    reverseDuration: const Duration(milliseconds: 180),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = !widget.isSubmitting;

    return SizedBox(
      height: 52,
      child: GestureDetector(
        onTapDown: enabled ? (_) => _controller.forward() : null,
        onTapUp: enabled ? (_) => _controller.reverse() : null,
        onTapCancel: enabled ? () => _controller.reverse() : null,
        onTap: enabled ? widget.onPressed : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = Curves.easeOut.transform(_controller.value);
            return Transform.scale(scale: 1 - 0.04 * t, child: child);
          },
          child: FilledButton.icon(
            onPressed: widget.onPressed,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            icon: widget.isSubmitting
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: scheme.onPrimary,
                    ),
                  )
                : Icon(
                    widget.isRegister
                        ? Icons.person_add_rounded
                        : Icons.login_rounded,
                  ),
            label: Text(widget.isRegister ? 'Create account' : 'Sign in'),
          ),
        ),
      ),
    );
  }
}
