import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';

class BestPractices extends StatelessWidget {
  const BestPractices({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Center(
                            child: Text(
                              'Best Practices',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Subtitle
                          const Center(
                            child: Text(
                              'Richtlijnen voor effectieve prompts, tooncontrole en het verminderen van hallucinaties',
                              style: TextStyle(
                                color: Color(0xFF5555CC),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Introduction
                          _buildIntroCard(),

                          const SizedBox(height: 20),

                          // Section 1: Effectieve prompts schrijven
                          _buildPracticeSection(
                            title: 'Effectieve prompts schrijven',
                            emoji: '✍️',
                            color: Colors.blue,
                            children: [
                              _buildSubsectionTitle(
                                  '1. Wees duidelijk en specifiek'),
                              _buildBulletPoint(
                                '✓ Specifiek: "Geef me 3 ideeën voor DIY-projecten met papier"',
                              ),
                              _buildBulletPoint(
                                '✗ Vaag: "Geef me ideeën"',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle(
                                  '2. Geef context en details'),
                              _buildBulletPoint(
                                'Vertel wat je nodig hebt: doel, niveau, materialen, tijdsduur',
                              ),
                              _buildBulletPoint(
                                'Voorbeeld: "Ik ben beginner en wil iets maken in een weekend"',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle('3. Vraag om een format'),
                              _buildBulletPoint(
                                'Stappenplan, checklist, tabel, vergelijking, samenvatting',
                              ),
                              _buildBulletPoint(
                                'Dit helpt de AI om gestructureerd te antwoorden',
                              ),
                              const SizedBox(height: 12),
                              _buildExampleBox(
                                title: 'Goed voorbeeld',
                                content:
                                    '"Maak een stappenplan voor het maken van een stop-motion video met mijn smartphone. Ik heb nog nooit animatie gedaan."',
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Section 2: Toon controleren
                          _buildPracticeSection(
                            title: 'Toon controleren',
                            emoji: '🎭',
                            color: Colors.purple,
                            children: [
                              _buildBulletPoint(
                                'De toon van het antwoord hangt af van hoe je vraagt',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle(
                                  'Voor een vriendelijke toon:'),
                              _buildBulletPoint(
                                '"Kun je me helpen met..." of "Ik zou graag willen..."',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle(
                                  'Voor een professionele toon:'),
                              _buildBulletPoint(
                                '"Geef een overzicht van..." of "Analyseer..."',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle(
                                  'Voor een simpele, begrijpelijke toon:'),
                              _buildBulletPoint(
                                '"Leg uit in simpele woorden..." of "Geef makkelijke voorbeelden..."',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle(
                                  'Voor emotionele ondersteuning:'),
                              _buildBulletPoint(
                                'Deel je gevoelens eerlijk: "Ik voel me..." of "Ik heb moeite met..."',
                              ),
                              const SizedBox(height: 12),
                              _buildComparisonBox(
                                title: 'Vergelijking',
                                example1: 'Direct: "Zeg me hoe dit werkt"',
                                tone1: '→ Zakelijk, kort antwoord',
                                example2:
                                    'Vriendelijk: "Kun je me uitleggen hoe dit werkt? Ik begrijp het nog niet helemaal"',
                                tone2: '→ Uitgebreider, begripvoller antwoord',
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Section 3: Hallucinaties verminderen
                          _buildPracticeSection(
                            title: 'Hallucinaties verminderen',
                            emoji: '🎯',
                            color: Colors.orange,
                            children: [
                              _buildSubsectionTitle('Wat zijn hallucinaties?'),
                              _buildBulletPoint(
                                'Wanneer de AI informatie "verzint" die niet klopt',
                              ),
                              _buildBulletPoint(
                                'Dit gebeurt vooral bij vage of te complexe vragen',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle('Hoe vermijd je dit?'),
                              _buildTipItem(
                                '1',
                                'Wees specifiek',
                                'Hoe specifieker je vraag, hoe betrouwbaarder het antwoord',
                                Colors.orange,
                              ),
                              const SizedBox(height: 10),
                              _buildTipItem(
                                '2',
                                'Vraag om bronnen',
                                'Als je feiten nodig hebt: "Waar kan ik dit controleren?"',
                                Colors.orange,
                              ),
                              const SizedBox(height: 10),
                              _buildTipItem(
                                '3',
                                'Verdeel complexe vragen',
                                'Stel meerdere kleine vragen in plaats van één grote',
                                Colors.orange,
                              ),
                              const SizedBox(height: 10),
                              _buildTipItem(
                                '4',
                                'Corrigeer indien nodig',
                                'Als iets niet klopt: "Dit is niet correct, kun je het herzien?"',
                                Colors.orange,
                              ),
                              const SizedBox(height: 12),
                              _buildWarningBox(
                                '⚠️ Let op: Controleer altijd belangrijke informatie uit meerdere bronnen. Luminara AI is een hulpmiddel, geen vervanging voor feiten checken.',
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Section 4: Do's and Don'ts
                          _buildDosAndDonts(),

                          const SizedBox(height: 20),

                          // Section 5: Iteratief verbeteren
                          _buildIterativeSection(),

                          const SizedBox(height: 20),

                          // Section 6: Speciale situaties
                          _buildSpecialSituations(),

                          const SizedBox(height: 20),

                          // Final tips card
                          _buildFinalTipsCard(),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Fade gradient above return button
              Positioned(
                left: 0,
                right: 0,
                bottom: 30,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF5959FF).withOpacity(0.0),
                        const Color(0xFF5959FF).withOpacity(0.8),
                        const Color(0xFF5959FF),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Background for return button area
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 30,
                child: Container(
                  color: const Color(0xFF5959FF),
                ),
              ),

              // Return button
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Image.asset(
                      'assets/images/return.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.purple.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Waarom zijn best practices belangrijk? 🌟',
                  style: TextStyle(
                    color: Color(0xFF2323AD),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Best practices helpen je om het maximale uit Luminara AI te halen: betere antwoorden, minder fouten, en effectievere communicatie. Leer hoe je prompts schrijft die werken, de juiste toon instelt, en valse informatie vermijdt.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeSection({
    required String title,
    required String emoji,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDosAndDonts() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.red.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Do\'s en Don\'ts ✅❌',
                style: TextStyle(
                  color: Color(0xFF047857),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // DO's
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '✅ DO:',
                  style: TextStyle(
                    color: Color(0xFF047857),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSimpleBullet('Wees specifiek en duidelijk'),
                _buildSimpleBullet('Geef context over je situatie'),
                _buildSimpleBullet('Vraag om stappenplannen of structuur'),
                _buildSimpleBullet(
                    'Deel je gevoelens eerlijk voor emotionele hulp'),
                _buildSimpleBullet('Corrigeer de AI als iets niet klopt'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // DON'Ts
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '❌ DON\'T:',
                  style: TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSimpleBullet('Te vage vragen stellen'),
                _buildSimpleBullet('Te veel vragen in één keer'),
                _buildSimpleBullet('Feiten accepteren zonder te controleren'),
                _buildSimpleBullet('Bang zijn om opnieuw te vragen'),
                _buildSimpleBullet('Verwachten dat de AI alles perfect weet'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIterativeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade50,
            Colors.cyan.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Iteratief verbeteren 🔄',
                style: TextStyle(
                  color: Color(0xFF1E40AF),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Je eerste prompt hoeft niet perfect te zijn! Je kunt altijd verder bouwen:',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildIterativeStep(
            '1',
            'Start breed',
            '"Ik wil leren programmeren"',
            Colors.indigo,
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              '↓',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E40AF),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildIterativeStep(
            '2',
            'Verfijn',
            '"Welke taal is het beste voor beginners?"',
            Colors.indigo,
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              '↓',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E40AF),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildIterativeStep(
            '3',
            'Specificeer',
            '"Maak een stappenplan om Python te leren in 30 dagen"',
            Colors.indigo,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '💡 Tip: Bouw voort op het gesprek! De AI onthoudt wat je eerder hebt gezegd.',
              style: TextStyle(
                color: Color(0xFF1E40AF),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialSituations() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.shade50,
            Colors.red.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Speciale situaties 🎯',
                style: TextStyle(
                  color: Color(0xFFBE185D),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSpecialSituationItem(
            '💙 Voor emotionele ondersteuning',
            'Wees eerlijk en open. Deel hoe je je voelt. De AI oordeelt niet.',
            'Voorbeeld: "Ik voel me gestrest en weet niet hoe ik moet ontspannen"',
          ),
          const SizedBox(height: 12),
          _buildSpecialSituationItem(
            '🛠️ Voor praktische projecten',
            'Vertel wat je hebt (materialen, tools, tijd) en wat je wilt bereiken.',
            'Voorbeeld: "Ik heb karton en lijm. Wat kan ik maken in een middag?"',
          ),
          const SizedBox(height: 12),
          _buildSpecialSituationItem(
            '🤝 Voor groepswerk',
            'Geef details: aantal personen, leeftijd, doel, beschikbare tijd.',
            'Voorbeeld: "We zijn met 4 en moeten samenwerken aan een project. Help ons organiseren"',
          ),
          const SizedBox(height: 12),
          _buildSpecialSituationItem(
            '💻 Voor technische hulp',
            'Wees eerlijk over je niveau. "Ik ben beginner" helpt de AI beter uitleggen.',
            'Voorbeeld: "Ik heb nog nooit code geschreven. Waar begin ik?"',
          ),
        ],
      ),
    );
  }

  Widget _buildFinalTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade50,
            Colors.yellow.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Onthoud dit altijd 📌',
                style: TextStyle(
                  color: Color(0xFFD97706),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCheckItem('Specifieke vragen = betere antwoorden'),
          _buildCheckItem('Context geven helpt de AI je beter begrijpen'),
          _buildCheckItem('Je kunt altijd verduidelijken of corrigeren'),
          _buildCheckItem(
              'Eerlijk zijn over je niveau en gevoelens werkt het beste'),
          _buildCheckItem('Controleer belangrijke feiten altijd'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '🌟 Practice makes perfect! Hoe meer je Luminara AI gebruikt, hoe beter je wordt in het stellen van goede vragen.',
              style: TextStyle(
                color: Color(0xFFD97706),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF5555CC),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Color(0xFF6464FF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleBox({
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.green.shade900,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.green.shade900,
              fontSize: 13,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonBox({
    required String title,
    required String example1,
    required String tone1,
    required String example2,
    required String tone2,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade300, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.purple.shade900,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            example1,
            style: TextStyle(
              color: Colors.purple.shade800,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            tone1,
            style: TextStyle(
              color: Colors.purple.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            example2,
            style: TextStyle(
              color: Colors.purple.shade800,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            tone2,
            style: TextStyle(
              color: Colors.purple.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade400, width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.amber.shade900,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildTipItem(
      String number, String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF115E59),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIterativeStep(
      String number, String title, String example, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  example,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialSituationItem(
      String title, String description, String example) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFBE185D),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          example,
          style: const TextStyle(
            color: Color(0xFFBE185D),
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFFD97706),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
