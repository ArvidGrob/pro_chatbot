import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

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
                              'Hoe het werkt',
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
                              'Uitleg van de chatbot-architectuur en kernconcepten',
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

                          // Section 1: Inputs
                          _buildConceptSection(
                            title: 'Inputs (Invoer)',
                            emoji: '📥',
                            color: Colors.blue,
                            children: [
                              _buildBulletPoint(
                                'Inputs zijn alles wat je naar Luminara AI stuurt',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle('Soorten inputs:'),
                              _buildBulletPoint(
                                '💬 Tekst: Je getypte vragen en berichten',
                              ),
                              _buildBulletPoint(
                                '🎤 Spraak: Gesproken opdrachten via de microfoon',
                              ),
                              _buildBulletPoint(
                                '📷 Afbeeldingen: Foto\'s die je deelt voor visuele vragen',
                              ),
                              _buildBulletPoint(
                                '📄 Bestanden: Documenten die je uploadt voor analyse',
                              ),
                              const SizedBox(height: 12),
                              _buildExampleBox(
                                title: 'Voorbeeld',
                                content:
                                    'Je typt: "Kun je mij helpen met wiskunde?" → Dit is je input',
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/interaction.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Section 2: Outputs
                          _buildConceptSection(
                            title: 'Outputs (Uitvoer)',
                            emoji: '📤',
                            color: Colors.green,
                            children: [
                              _buildBulletPoint(
                                'Outputs zijn de antwoorden die Luminara AI je geeft',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle('Wat gebeurt er?'),
                              _buildBulletPoint(
                                '🧠 De AI analyseert je input',
                              ),
                              _buildBulletPoint(
                                '⚡ Verwerkt de informatie razendsnel',
                              ),
                              _buildBulletPoint(
                                '💡 Genereert een begrijpelijk antwoord',
                              ),
                              _buildBulletPoint(
                                '📝 Toont het resultaat in de chat',
                              ),
                              const SizedBox(height: 12),
                              _buildExampleBox(
                                title: 'Voorbeeld',
                                content:
                                    'Input: "Wat is 5 × 8?"\nOutput: "5 × 8 = 40. Dit betekent dat je 5 groepen van 8 hebt, wat in totaal 40 geeft."',
                              ),
                              const SizedBox(height: 12),
                              _buildImagePlaceholder(
                                  'Screenshot: Chat met input en output'),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Section 3: Context
                          _buildConceptSection(
                            title: 'Context (Samenhang)',
                            emoji: '🔗',
                            color: Colors.purple,
                            children: [
                              _buildBulletPoint(
                                'Context is het "geheugen" van het gesprek',
                              ),
                              _buildBulletPoint(
                                'Luminara AI onthoudt wat je eerder hebt gezegd in dezelfde chat',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle(
                                  'Waarom is context belangrijk?'),
                              _buildBulletPoint(
                                '✅ Maakt vervolgvragen mogelijk zonder alles te herhalen',
                              ),
                              _buildBulletPoint(
                                '✅ De AI begrijpt waar "het" of "dat" naar verwijst',
                              ),
                              _buildBulletPoint(
                                '✅ Gesprekken voelen natuurlijker aan',
                              ),
                              const SizedBox(height: 12),
                              _buildExampleBox(
                                title: 'Voorbeeld met context',
                                content:
                                    'Je: "Wat is de hoofdstad van Frankrijk?"\nAI: "De hoofdstad van Frankrijk is Parijs."\n\nJe: "Hoeveel inwoners heeft het?"\nAI: "Parijs heeft ongeveer 2,2 miljoen inwoners." ← De AI weet dat "het" verwijst naar Parijs dankzij context!',
                              ),
                              const SizedBox(height: 12),
                              _buildWarningBox(
                                '⚠️ Let op: Context werkt alleen binnen één chat-sessie. Als je een nieuwe chat start, begint de AI "vers".',
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Section 4: Tokens
                          _buildConceptSection(
                            title: 'Tokens (Tekstbrokjes)',
                            emoji: '🎫',
                            color: Colors.orange,
                            children: [
                              _buildBulletPoint(
                                'Tokens zijn kleine stukjes tekst die de AI verwerkt',
                              ),
                              _buildBulletPoint(
                                'Een token kan een woord, deel van een woord, of zelfs leesteken zijn',
                              ),
                              const SizedBox(height: 12),
                              _buildSubsectionTitle('Hoe werken tokens?'),
                              _buildBulletPoint(
                                '📊 Je input wordt opgesplitst in tokens',
                              ),
                              _buildBulletPoint(
                                '🔢 Elke chat heeft een token-limiet (max aantal stukjes)',
                              ),
                              _buildBulletPoint(
                                '⏱️ Meer tokens = langere verwerkingstijd',
                              ),
                              const SizedBox(height: 12),
                              _buildExampleBox(
                                title: 'Voorbeeld',
                                content:
                                    'Zin: "Hallo, hoe gaat het?"\nTokens: ["Hallo", ",", " hoe", " gaat", " het", "?"]\n→ Dit zijn 6 tokens',
                              ),
                              const SizedBox(height: 12),
                              _buildInfoBox(
                                '💡 Tip: Wees duidelijk maar beknopt. Langere berichten kosten meer tokens en kunnen langzamer zijn.',
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Architecture Overview
                          _buildArchitectureSection(),

                          const SizedBox(height: 20),

                          // How it all works together
                          _buildWorkflowSection(),

                          const SizedBox(height: 20),

                          // Final tips
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
          const Row(
            children: [
              Text(
                'Wat is Luminara AI? 🤖',
                style: TextStyle(
                  color: Color(0xFF2323AD),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Luminara AI is een intelligente chatbot die kunstmatige intelligentie (AI) gebruikt om je vragen te beantwoorden en taken uit te voeren. Om te begrijpen hoe het werkt, leer je over vier belangrijke concepten: Inputs, Outputs, Context en Tokens.',
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

  Widget _buildConceptSection({
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

  Widget _buildArchitectureSection() {
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
                'De Architectuur 🏗️',
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
            'Zo ziet de chatbot-architectuur eruit:',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildArchitectureStep('1', 'Je stuurt een Input', Colors.blue),
          _buildArchitectureArrow(),
          _buildArchitectureStep('2', 'De AI gebruikt Context', Colors.purple),
          _buildArchitectureArrow(),
          _buildArchitectureStep('3', 'Verwerkt in Tokens', Colors.orange),
          _buildArchitectureArrow(),
          _buildArchitectureStep('4', 'Genereert een Output', Colors.green),
        ],
      ),
    );
  }

  Widget _buildArchitectureStep(String number, String text, Color color) {
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
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF1E3A8A),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchitectureArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          '↓',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E40AF),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkflowSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade50,
            Colors.green.shade50,
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
                  'Alles samen: Een praktisch voorbeeld ⚙️',
                  style: TextStyle(
                    color: Color(0xFF047857),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildWorkflowStep(
            '1',
            'Input',
            'Je: "Wat is de grootste planeet?"',
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildWorkflowStep(
            '2',
            'Tokens',
            'De AI splitst dit op in: ["Wat", " is", " de", " grootste", " planeet", "?"]',
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildWorkflowStep(
            '3',
            'Context',
            'De AI gebruikt vorige berichten om te begrijpen wat je bedoelt',
            Colors.purple,
          ),
          const SizedBox(height: 8),
          _buildWorkflowStep(
            '4',
            'Output',
            'AI: "Jupiter is de grootste planeet in ons zonnestelsel."',
            Colors.green,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '✨ Dit proces gebeurt in minder dan een seconde!',
              style: TextStyle(
                color: Color(0xFF047857),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowStep(
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
    );
  }

  Widget _buildFinalTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
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
                'Wat heb je geleerd? 🎓',
                style: TextStyle(
                  color: Color(0xFFBE185D),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCheckItem('📥 Inputs: Wat je naar de AI stuurt'),
          _buildCheckItem('📤 Outputs: Wat de AI teruggeeft'),
          _buildCheckItem('🔗 Context: Het "geheugen" van het gesprek'),
          _buildCheckItem('🎫 Tokens: Hoe tekst wordt verwerkt'),
          _buildCheckItem('🏗️ Architectuur: Hoe alles samenwerkt'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '👉 Nu begrijp je de basis van hoe Luminara AI werkt! Probeer het uit en experimenteer met verschillende inputs.',
              style: TextStyle(
                color: Color(0xFFBE185D),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFFBE185D),
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

  Widget _buildInfoBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade300, width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue.shade900,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(String description) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 40, color: Colors.grey.shade500),
            const SizedBox(height: 8),
            Text(
              '[INSERT PHOTO HERE]',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
