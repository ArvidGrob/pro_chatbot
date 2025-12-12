import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';

class AccuracyOfAi extends StatelessWidget {
  const AccuracyOfAi({super.key});
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
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        'Nauwkeurigheid van AI 🎯',
                        style: TextStyle(
                          color: Color(0xFF2323AD),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),

                          // Introduction
                          _buildIntroCard(),

                          const SizedBox(height: 20),

                          // Section 1: Wat is nauwkeurigheid?
                          _buildAccuracyDefinitionSection(),

                          const SizedBox(height: 20),

                          // Section 2: Hoe AI fouten maakt
                          _buildErrorTypesSection(),

                          const SizedBox(height: 20),

                          // Section 3: Wanneer je de AI kunt vertrouwen
                          _buildTrustSection(),

                          const SizedBox(height: 20),

                          // Section 4: Hoe je antwoorden controleert
                          _buildVerificationSection(),

                          const SizedBox(height: 20),

                          // Section 5: De AI verbeteren over tijd
                          _buildImprovementSection(),

                          const SizedBox(height: 20),

                          // Section 6: Praktische tips
                          _buildPracticalTipsSection(),

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

              // Return button at the bottom
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
          Text(
            'Hoe accuraat is Luminara AI? 🤔',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Luminara AI is geen magische kristallen bol - het kan fouten maken! Deze pagina helpt je begrijpen wanneer je de AI kunt vertrouwen, hoe je antwoorden controleert en hoe je betere resultaten krijgt over tijd. Denk aan de AI als een slimme assistent die soms ook niet alles weet.',
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

  Widget _buildAccuracyDefinitionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
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
                '📊',
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Wat is nauwkeurigheid?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Nauwkeurigheid betekent: hoe vaak geeft de AI het juiste antwoord? Maar "juist" hangt af van de vraag:',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildAccuracyItem(
            '✅ Zeer nauwkeurig (>90%)',
            'Creatieve ideeën, brainstorming, conversatie, emotionele ondersteuning',
            Colors.green,
          ),
          const SizedBox(height: 10),
          _buildAccuracyItem(
            '⚠️ Redelijk nauwkeurig (70-90%)',
            'Algemene uitleg, praktische tips, hoe-doe-je-dat instructies',
            Colors.orange,
          ),
          const SizedBox(height: 10),
          _buildAccuracyItem(
            '❌ Minder betrouwbaar (<70%)',
            'Specifieke data, recente gebeurtenissen, technische specificaties, medisch/juridisch advies',
            Colors.red,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '💡 Tip: Hoe specifieker de vraag, hoe belangrijker het is om het antwoord te controleren!',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyItem(String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
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
    );
  }

  Widget _buildErrorTypesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade50,
            Colors.orange.shade50,
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
          Text(
            'Hoe AI fouten maakt 🚨',
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '🎭 Hallucinaties',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'De AI "verzint" informatie die plausibel klinkt maar niet klopt. Vooral bij specifieke feiten, data of namen.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Voorbeeld: "De hoofdstad van Australië is Sydney" (Fout! Het is Canberra)',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '📅 Verouderde informatie',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'De AI heeft geen internettoegang en weet niets van gebeurtenissen na zijn laatste update. Geen actueel nieuws of recente trends.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '🔀 Context vergeten',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Bij lange gesprekken kan de AI eerder genoemde details vergeten of door elkaar halen. Start een nieuwe chat voor een nieuw onderwerp.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '🤷 Te zeker klinken',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'De AI geeft antwoorden met veel vertrouwen, zelfs als het niet 100% zeker is. Let op: zelfverzekerde toon ≠ correcte informatie!',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
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
                '✅',
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Wanneer je de AI kunt vertrouwen',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Item 1
          Text(
            '💭 Creatieve taken',
            style: const TextStyle(
              color: Color(0xFF059669),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ideeën bedenken, verhalen schrijven, brainstormen → AI is hier uitstekend in!',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Item 2
          Text(
            '💬 Emotionele ondersteuning',
            style: const TextStyle(
              color: Color(0xFF059669),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Praten over gevoelens, frustraties delen, bemoediging krijgen → AI luistert zonder te oordelen',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Item 3
          Text(
            '📚 Algemene uitleg',
            style: const TextStyle(
              color: Color(0xFF059669),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Hoe werkt iets? Wat betekent dit? Basisconcept uitleggen → AI is goed in vereenvoudigen',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Item 4
          Text(
            '🛠️ Praktische stappen',
            style: const TextStyle(
              color: Color(0xFF059669),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Hoe maak ik X? Wat zijn de stappen voor Y? → AI geeft goede praktische guidance',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Item 5
          Text(
            '🎨 Projecten plannen',
            style: const TextStyle(
              color: Color(0xFF059669),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Een project organiseren, to-do lijst maken, aanpak bedenken → AI helpt met structuur',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '✨ Vuistregel: AI is betrouwbaar voor proces en ondersteuning, minder voor precieze feiten!',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade50,
            Colors.pink.shade50,
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
          Text(
            'Hoe je antwoorden controleert 🔍',
            style: TextStyle(
              color: Colors.purple.shade700,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _buildVerificationStep(
            '1',
            'Vraag om bronnen of uitleg',
            'Als iets belangrijk is: "Hoe weet je dat?" of "Kun je dit uitleggen?"',
            Colors.purple,
          ),
          const SizedBox(height: 10),
          _buildVerificationStep(
            '2',
            'Cross-check belangrijke feiten',
            'Voor kritische info: Google het, vraag een expert, check meerdere bronnen',
            Colors.purple,
          ),
          const SizedBox(height: 10),
          _buildVerificationStep(
            '3',
            'Let op rode vlaggen',
            'Te specifieke data, exacte cijfers, medisch/juridisch advies → altijd verifiëren!',
            Colors.purple,
          ),
          const SizedBox(height: 10),
          _buildVerificationStep(
            '4',
            'Vraag om alternatieven',
            '"Zijn er ook andere manieren?" - meerdere opties helpen je het beste kiezen',
            Colors.purple,
          ),
          const SizedBox(height: 10),
          _buildVerificationStep(
            '5',
            'Test het in de praktijk',
            'Voor praktische tips: probeer het uit op kleine schaal eerst!',
            Colors.purple,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '⚠️ Gouden regel: Hoe belangrijker de beslissing, hoe meer je moet controleren!',
              style: TextStyle(
                color: Colors.purple.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationStep(
      String number, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
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
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
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
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
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
      ),
    );
  }

  Widget _buildImprovementSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo, width: 2),
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
                '📈',
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'De AI verbeteren over tijd',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Hoe krijg je betere antwoorden na verloop van tijd?',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '🎯 Verfijn je prompts',
            style: const TextStyle(
              color: Color(0xFF4F46E5),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Leer wat werkt: specifieke vragen, context geven, voorbeelden gebruiken. Hoe beter je vraag, hoe beter het antwoord!',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '🔄 Iteratief verbeteren',
            style: const TextStyle(
              color: Color(0xFF4F46E5),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Als het antwoord niet perfect is: vraag om aanpassingen! "Kun je het simpeler maken?" of "Kun je meer details geven?"',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '📝 Geef feedback',
            style: const TextStyle(
              color: Color(0xFF4F46E5),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Als iets fout is, zeg het! "Dit klopt niet, ik bedoel eigenlijk..." - de AI leert binnen het gesprek wat je precies wilt.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '🧪 Experimenteer',
            style: const TextStyle(
              color: Color(0xFF4F46E5),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Probeer verschillende manieren van vragen: formeel/informeel, kort/lang, met/zonder voorbeelden. Ontdek wat voor jou werkt!',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '📚 Bouw context op',
            style: const TextStyle(
              color: Color(0xFF4F46E5),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Binnen een gesprek: de AI onthoudt wat je eerder zei. Gebruik dit! Verwijs naar eerdere vragen voor consistentie.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticalTipsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
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
          Text(
            'Praktische tips voor betere nauwkeurigheid 💡',
            style: TextStyle(
              color: Colors.amber.shade900,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _buildPracticalTip(
            '✅',
            'DO: Vraag de AI om unsure te zijn',
            '"Zeg me als je niet zeker weet" of "Geef alternatieven als er twijfel is"',
            Colors.green,
          ),
          const SizedBox(height: 10),
          _buildPracticalTip(
            '✅',
            'DO: Gebruik AI voor eerste draft',
            'Laat AI een concept maken, dan verbeter je het zelf met je eigen kennis',
            Colors.green,
          ),
          const SizedBox(height: 10),
          _buildPracticalTip(
            '✅',
            'DO: Vraag om stappen in plaats van conclusies',
            '"Hoe kom ik tot een beslissing?" in plaats van "Wat moet ik doen?"',
            Colors.green,
          ),
          const SizedBox(height: 10),
          _buildPracticalTip(
            '❌',
            'DON\'T: Blind vertrouwen op cijfers',
            'Statistieken, data, percentages → altijd verifiëren!',
            Colors.red,
          ),
          const SizedBox(height: 10),
          _buildPracticalTip(
            '❌',
            'DON\'T: Belangrijke beslissingen baseren op AI alleen',
            'AI = hulpmiddel, niet de beslisser. Jij blijft verantwoordelijk!',
            Colors.red,
          ),
          const SizedBox(height: 10),
          _buildPracticalTip(
            '❌',
            'DON\'T: Lange gesprekken voor complexe projecten',
            'Start een nieuwe chat voor elk groot onderwerp - voorkomt verwarring',
            Colors.red,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '🌟 Onthoud: AI is een krachtige assistent, geen alwetende orakel. Gebruik je eigen gezond verstand!',
              style: TextStyle(
                color: Colors.amber.shade900,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticalTip(
      String icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
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
      ),
    );
  }
}
