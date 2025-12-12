import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';

class GettingStarted extends StatelessWidget {
  const GettingStarted({super.key});

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
                              'Aan de slag',
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
                              'Snelle oriëntatie: account, app layout en eerste taak',
                              style: TextStyle(
                                color: Color(0xFF5555CC),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Welcome section
                          _buildSectionCard(
                            title: '👋 Welkom!',
                            content:
                                'Welkom bij Luminara AI! Deze gids helpt je om snel vertrouwd te raken met de belangrijkste functies van de app. In een paar minuten ben je klaar om te beginnen met chatten met je AI-assistent!',
                          ),

                          const SizedBox(height: 20),

                          // Section 1: Account Setup
                          _buildStepSection(
                            stepNumber: '1',
                            title: 'Je account instellen',
                            children: [
                              _buildBulletPoint(
                                'Log in met je gebruikers-ID en wachtwoord die je van de beheerder hebt ontvangen',
                              ),
                              _buildBulletPoint(
                                'Na het inloggen kom je direct op de navigatiepagina',
                              ),
                              _buildBulletPoint(
                                'Je kunt later je instellingen aanpassen via het Instellingen menu',
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/login_page.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Section 2: App Layout
                          _buildStepSection(
                            stepNumber: '2',
                            title: 'De app verkennen',
                            children: [
                              _buildSubsectionTitle('🏠 Navigatiepagina'),
                              _buildBulletPoint(
                                'Chat: Start een gesprek met Luminara AI',
                              ),
                              _buildBulletPoint(
                                'Training: Leer hoe je de app optimaal gebruikt',
                              ),
                              _buildBulletPoint(
                                'Instellingen: Pas je account, thema en voorkeuren aan',
                              ),
                              _buildBulletPoint(
                                'Admin: (Voor beheerders) Beheer studenten, docenten en klassen',
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/navigation_page.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildSubsectionTitle('💬 Chat functie'),
                              _buildBulletPoint(
                                'Tik op de Chat-knop om een nieuw gesprek te beginnen',
                              ),
                              _buildBulletPoint(
                                'Stel vragen in het tekstveld: "Vraag het aan Luminara"',
                              ),
                              _buildBulletPoint(
                                'Gebruik de + knop voor extra functies: spraak, foto\'s of bestanden',
                              ),
                              _buildBulletPoint(
                                'Luminara antwoordt met "Hallo! Hoe kan ik u helpen?" wanneer je begint',
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/chat_page.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildSubsectionTitle('📚 Chat geschiedenis'),
                              _buildBulletPoint(
                                'Bekijk je eerdere gesprekken via de geschiedenis-knop (bovenaan)',
                              ),
                              _buildBulletPoint(
                                'Zoek gesprekken op titel of datum',
                              ),
                              _buildBulletPoint(
                                'Voorbeelden: "Gerecyclede kunst", "Webstrip maken", "Spel programmeren"',
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/chat_history.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildSubsectionTitle(
                                  '🎨 Thema\'s personaliseren'),
                              _buildBulletPoint(
                                'Kies je favoriete kleur: ga naar Instellingen → Thema',
                              ),
                              _buildBulletPoint(
                                'Beschikbare thema\'s: Blauw (standaard), Groen, Paars, Roze, Oranje',
                              ),
                              _buildBulletPoint(
                                'Het thema past de achtergrond, knoppen en wave-animatie aan',
                              ),
                              _buildBulletPoint(
                                'Je keuze wordt automatisch opgeslagen en toegepast bij elke sessie',
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/thema_page.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildSubsectionTitle('🚪 Uitloggen'),
                              _buildBulletPoint(
                                'Om uit te loggen: ga naar Instellingen → scroll naar beneden',
                              ),
                              _buildBulletPoint(
                                'Tik op de rode "Uitloggen" knop onderaan',
                              ),
                              _buildBulletPoint(
                                'Je wordt teruggebracht naar het login scherm',
                              ),
                              _buildBulletPoint(
                                'Log altijd uit op gedeelde apparaten voor je privacy!',
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/uitloggen.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Section 3: First Task
                          _buildStepSection(
                            stepNumber: '3',
                            title: 'Je eerste taak: Een chat starten',
                            children: [
                              _buildTaskCard(
                                taskTitle: '🎯 Praktische oefening',
                                steps: [
                                  'Ga naar de Navigatiepagina',
                                  'Tik op de blauwe "Chat" knop',
                                  'Wacht tot Luminara je begroet met "Hallo! Hoe kan ik u helpen?"',
                                  'Type een eenvoudige vraag in het tekstveld onderaan',
                                  'Verstuur je bericht door op de verzendknop te tikken',
                                  'Wacht enkele seconden op het antwoord van Luminara AI',
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/starten_chat.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Tips section
                          _buildTipsCard(),

                          const SizedBox(height: 20),

                          // Next steps
                          _buildNextStepsCard(),

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

  Widget _buildSectionCard({
    IconData? icon,
    Color? iconColor,
    required String title,
    required String content,
  }) {
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
              if (icon != null && iconColor != null) ...[
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF2323AD),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepSection({
    required String stepNumber,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6464FF), width: 2),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF6464FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF2323AD),
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

  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF5555CC),
          fontSize: 17,
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

  Widget _buildTaskCard({
    required String taskTitle,
    required List<String> steps,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.teal.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            taskTitle,
            style: const TextStyle(
              color: Color(0xFF2D5F2E),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade50,
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
          const Row(
            children: [
              Text(
                '💡 Handige tips',
                style: TextStyle(
                  color: Color(0xFFD97706),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            '✨ Wees specifiek in je vragen voor betere antwoorden',
          ),
          _buildTipItem(
            '🔍 Gebruik de zoekfunctie om eerdere chats terug te vinden',
          ),
          _buildTipItem(
            '🎤 Probeer de spraakfunctie voor hands-free gebruik',
          ),
          _buildTipItem(
            '📸 Je kunt ook afbeeldingen delen voor visuele vragen',
          ),
          _buildTipItem(
            '💾 Je gesprekken worden automatisch opgeslagen',
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '→ ',
            style: TextStyle(
              color: Color(0xFFD97706),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade50,
            Colors.indigo.shade50,
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
                '🚀 Volgende stappen',
                style: TextStyle(
                  color: Color(0xFF7C3AED),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Nu je de basis kent, kun je:',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _buildNextStepItem('Verken de geavanceerde functies'),
          _buildNextStepItem('Bekijk andere trainingsmodules'),
          _buildNextStepItem('Begin met je dagelijkse taken'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '📚 Vergeet niet: Je kunt altijd terugkomen naar deze gids als je iets wilt nakijken!',
              style: TextStyle(
                color: Color(0xFF7C3AED),
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

  Widget _buildNextStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF7C3AED),
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
