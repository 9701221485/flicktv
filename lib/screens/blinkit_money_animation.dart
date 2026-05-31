import 'package:flutter/material.dart';
import 'package:lavanya/utils/image_constants.dart';
import 'package:lavanya/utils/string_constants.dart';
import 'package:lottie/lottie.dart';

class BlinkitMoneyAnimation extends StatefulWidget {
  const BlinkitMoneyAnimation({super.key});
  @override
  State<BlinkitMoneyAnimation> createState() => _BlinkitMoneyAnimationState();
}

class _BlinkitMoneyAnimationState extends State<BlinkitMoneyAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> walletScale;
  late Animation<double> headerTranslateY;
  late Animation<double> textOpacity;
  late List<Animation<double>> cardOpacity;
  late List<Animation<Offset>> cardSlide;
  late Animation<double> buttonOpacity;
  late Animation<double> buttonScale;
  late Animation<double> extraContentOpacity;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    );

    walletScale = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.00, 0.16, curve: Curves.elasticOut),
    ));
    headerTranslateY =
        Tween<double>(begin: 0, end: -220).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.22, 0.42, curve: Curves.easeInOutCubic),
    ));
    textOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.10, 0.22, curve: Curves.easeOut),
    ));

    cardOpacity = [];
    cardSlide = [];
    for (int i = 0; i < 3; i++) {
      final start = 0.50 + (i * 0.08);
      cardOpacity.add(Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(start, start + 0.16, curve: Curves.easeOut),
      )));
      cardSlide.add(
          Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
              .animate(CurvedAnimation(
        parent: controller,
        curve: Interval(start, start + 0.16, curve: Curves.easeOutCubic),
      )));
    }

    buttonOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.76, 0.92),
    ));
    buttonScale = Tween<double>(begin: 0.85, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.76, 0.92, curve: Curves.easeOutBack),
    ));
    extraContentOpacity =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.82, 0.95, curve: Curves.easeOut),
    ));

    controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenHeight = MediaQuery.of(context).size.height;
    headerTranslateY =
        Tween<double>(begin: 0, end: -(screenHeight * 0.30)).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.22, 0.42, curve: Curves.easeInOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final List<Map<String, String>> cardData = StringConstants.featureCards;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    const double headerHeight = 210.0;
    final double scrollTopOffset =
        (screenHeight / 2) - (screenHeight * 0.30) + (headerHeight / 2);

    return Scaffold(
      backgroundColor: const Color(0xff0A0A0A),
      body: Stack(
        children: [
          // ── BACKGROUND ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff4A3800),
                  Color(0xff2A2000),
                  Color(0xff141000),
                  Color(0xff080808)
                ],
                stops: [0.0, 0.25, 0.55, 1.0],
              ),
            ),
          ),

          // ── HALFTONE ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: CustomPaint(painter: HalftonePainter()),
          ),

          // ── CONFETTI (Lottie) ──
          IgnorePointer(
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                final p = controller.value;
                if (p < 0.04 || p > 0.62) return const SizedBox.shrink();
                return Lottie.asset(
                  ImageConstants.confettiLottie,
                  fit: BoxFit.fill,
                  repeat: false,
                  frameRate: FrameRate.max,
                );
              },
            ),
          ),

          // ── HEADER ──
          Positioned.fill(
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) => Transform.translate(
                offset: Offset(0, headerTranslateY.value),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                          scale: walletScale, child: _WalletImage()),
                      const SizedBox(height: 10),
                      FadeTransition(
                        opacity: textOpacity,
                        child: Column(children: [
                          const Text(StringConstants.blinkitBrand,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  height: 1,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 8),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                StringConstants.moneyLabel,
                                style: TextStyle(
                                  fontSize: 36,
                                  letterSpacing: 3,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 10
                                    ..color = Colors.black.withOpacity(0.65),
                                ),
                              ),
                              const Text(
                                StringConstants.moneyLabel,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── BOTTOM CONTENT ──
          // Positioned so it starts exactly below the translated header
          Positioned(
            top: scrollTopOffset,
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── FEATURE CARDS ──
                    ...List.generate(
                      3,
                      (index) => FadeTransition(
                        opacity: cardOpacity[index],
                        child: SlideTransition(
                          position: cardSlide[index],
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.10)),
                            ),
                            child: Row(children: [
                              Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                    color: const Color(0xff1E1800),
                                    borderRadius: BorderRadius.circular(14)),
                                child: Center(
                                  child: Image.asset(
                                    ImageConstants.featureCardImages[index],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cardData[index]['title']!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 3),
                                  Text(cardData[index]['subtitle']!,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.90),
                                          fontSize: 12,
                                          height: 1.4)),
                                ],
                              )),
                            ]),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── ADD MONEY BUTTON ──
                    FadeTransition(
                      opacity: buttonOpacity,
                      child: ScaleTransition(
                        scale: buttonScale,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 54,
                          decoration: BoxDecoration(
                              color: const Color(0xff1ED760),
                              borderRadius: BorderRadius.circular(14)),
                          child: const Center(
                              child: Text(StringConstants.addMoneyButton,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── GIFT CARD ROW ──
                    FadeTransition(
                      opacity: extraContentOpacity,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: const Color(0xff2A2000),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Image.asset(
                                ImageConstants.claimGiftCard,
                                width: 22,
                                height: 22,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(StringConstants.claimGiftCard,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(StringConstants.giftCardDescription,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.45),
                                      fontSize: 11)),
                            ],
                          )),
                          Icon(Icons.chevron_right,
                              color: Colors.white.withOpacity(0.4), size: 20),
                        ]),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── FOOTER MESSAGE ──
                    FadeTransition(
                      opacity: extraContentOpacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(StringConstants.footerMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.30),
                                fontSize: 30,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Image.asset(
        ImageConstants.wallet,
        fit: BoxFit.contain,
      ),
    );
  }
}

class HalftonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 13.0;
    const radius = 1.8;
    int row = 0;
    for (double y = 4; y < size.height; y += spacing * 0.85) {
      final offsetX = (row % 2 == 0) ? 0.0 : spacing / 2;
      for (double x = offsetX; x < size.width; x += spacing) {
        final alphaMult = 1.0 - (y / size.height);
        canvas.drawCircle(Offset(x, y), radius,
            Paint()..color = Colors.white.withOpacity(0.09 * alphaMult));
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(covariant HalftonePainter oldDelegate) => false;
}
