import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';

class Limitations extends StatelessWidget {
  const Limitations({super.key});

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
                              'Beperkingen',
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
                              'Duidelijke lijst van modelbeperkingen, fouten en wanneer je niet op de AI moet vertrouwen',
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

                          // Section 1: Wat Luminara AI NIET kan
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.red, width: 2),
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
                                      '⛔',
                                      style: const TextStyle(fontSize: 40),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Wat Luminara AI NIET kan',
                                        style: TextStyle(
                                          color: Colors.red,
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
                                  '🚫 Real-time informatie',
                                  style: const TextStyle(
                                    color: Color(0xFFDC2626),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Luminara AI heeft geen toegang tot het internet en kan geen actueel nieuws, weersvoorspellingen of live data geven.',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Gebruik: Vaste kennisbasis, geen recente gebeurtenissen',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Item 2
                                Text(
                                  '🚫 Professionele diagnoses',
                                  style: const TextStyle(
                                    color: Color(0xFFDC2626),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Kan geen medische, psychologische of juridische diagnoses stellen. Dit is emotionele ondersteuning, geen therapie.',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Gebruik: Voor ernstige problemen, zoek een professional',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Item 3
                                Text(
                                  '🚫 Perfecte waarheid',
                                  style: const TextStyle(
                                    color: Color(0xFFDC2626),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'De AI kan fouten maken of informatie "verzinnen" (hallucineren). Controleer altijd belangrijke feiten.',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Gebruik: Altijd verifiëren bij belangrijke beslissingen',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Item 4
                                Text(
                                  '🚫 Persoonlijke meningen',
                                  style: const TextStyle(
                                    color: Color(0xFFDC2626),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Heeft geen echte gevoelens, overtuigingen of persoonlijke ervaringen. Het is een hulpmiddel, geen mens.',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Gebruik: Voor advies en ondersteuning, niet voor echte vriendschap',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Item 5
                                Text(
                                  '🚫 Externe acties',
                                  style: const TextStyle(
                                    color: Color(0xFFDC2626),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Kan geen e-mails sturen, telefoontjes plegen, betalingen doen of direct met andere apps communiceren.',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Gebruik: Alleen binnen de chat-interface',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Section 2: Technische beperkingen
                          _buildLimitationSection(
                            title: 'Technische beperkingen',
                            emoji: '⚙️',
                            color: Colors.orange,
                            children: [
                              _buildTechItem(
                                'Bestandsgrootte',
                                'Maximum 10 MB per bestand',
                                'Foto\'s, documenten en andere bestanden kunnen worden geüpload tot 10 MB',
                              ),
                              const SizedBox(height: 10),
                              _buildTechItem(
                                'Context geheugen',
                                'Beperkt tot de huidige chat-sessie',
                                'Een nieuwe chat begint met een leeg geheugen. Context werkt alleen binnen één gesprek',
                              ),
                              const SizedBox(height: 10),
                              _buildTechItem(
                                'Tekstlengte',
                                'Lange teksten worden in stukken verwerkt',
                                'Voor zeer lange documenten: splits in kleinere delen voor betere resultaten',
                              ),
                              const SizedBox(height: 10),
                              _buildTechItem(
                                'Taalondersteuning',
                                'Voornamelijk Nederlands en Engels',
                                'Andere talen zijn mogelijk maar minder accuraat',
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Section 3: Wanneer NIET te vertrouwen
                          _buildWarningSection(),

                          const SizedBox(height: 20),

                          // Section 4: Wat de AI WEL kan doen
                          _buildCapabilitiesSection(),

                          const SizedBox(height: 20),

                          // Section 5: Failure modes (hoe het fout gaat)
                          _buildFailureModesSection(),

                          const SizedBox(height: 20),

                          // Section 6: Best gebruik scenario's
                          _buildBestUseCasesSection(),

                          const SizedBox(height: 20),

                          // Final safety tips
                          _buildSafetyTipsCard(),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Waarom beperkingen kennen belangrijk is 🎯',
                  style: TextStyle(
                    color: Color(0xFFD97706),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Luminara AI is een krachtig hulpmiddel, maar het is belangrijk om te weten wat het NIET kan en wanneer je het NIET moet gebruiken. Deze pagina helpt je om de AI veilig en effectief te gebruiken door duidelijk te maken waar de grenzen liggen.',
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

  Widget _buildLimitationSection({
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

  Widget _buildWarningSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade50,
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
            'Wanneer NIET te vertrouwen op de AI ⚠️',
            style: TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),

          // Item 1
          Text(
            '🏥 Medische noodgevallen',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Bij pijn, verwondingen, ziekte: ga naar een dokter, niet naar de AI',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Item 2
          Text(
            '😰 Ernstige psychische problemen',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Suïcidale gedachten, ernstige depressie, trauma: zoek professionele hulp',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Item 3
          Text(
            '💰 Financiële beslissingen',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Grote aankopen, investeringen, contracten: raadpleeg experts',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Item 4
          Text(
            '⚖️ Juridische zaken',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Legal advies, rechtszaken, contracten: neem een advocaat',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Item 5
          Text(
            '🔐 Veiligheidskritische situaties',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Gevaarlijke projecten, elektrische werken, gasfittingen: huur een professional',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Item 6
          Text(
            '📊 Verificatie van feiten',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Belangrijke historische data, wetenschappelijke claims: controleer meerdere bronnen',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '⚠️ Regel: Als het echt belangrijk is, controleer altijd bij een echte expert!',
              style: TextStyle(
                color: Color(0xFFDC2626),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilitiesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.teal.shade50,
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
                  'Wat de AI WEL goed kan doen ✅',
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
          _buildCapabilityItem('🎨 Creatieve ideeën genereren'),
          _buildCapabilityItem('📝 Uitleg geven over concepten en procedures'),
          _buildCapabilityItem(
              '💙 Emotionele ondersteuning bieden (geen therapie)'),
          _buildCapabilityItem('🛠️ Stappen plannen voor praktische projecten'),
          _buildCapabilityItem('💡 Brainstormen en alternatieven voorstellen'),
          _buildCapabilityItem('📖 Informatie organiseren en structureren'),
          _buildCapabilityItem('🗣️ Oefenen met conversaties en communicatie'),
          _buildCapabilityItem('📷 Foto\'s analyseren (tot 10 MB)'),
          _buildCapabilityItem('🎤 Spraak naar tekst converteren'),
          _buildCapabilityItem('📄 Documenten lezen en samenvatten'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '✨ Best voor: leren, maken, ontdekken, ondersteuning en praktische hulp!',
              style: TextStyle(
                color: Color(0xFF047857),
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

  Widget _buildFailureModesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Hoe het fout kan gaan (Failure Modes) 🔍',
                  style: TextStyle(
                    color: Color(0xFF6366F1),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFailureModeItem(
            '1. Hallucinaties',
            'De AI "verzint" feiten die overtuigend klinken maar niet waar zijn',
            'Let op: Namen, datums, statistieken kunnen verzonnen zijn',
          ),
          const SizedBox(height: 12),
          _buildFailureModeItem(
            '2. Verouderde informatie',
            'Gebaseerd op oude kennisbasis, geen recente updates',
            'Let op: Technologie, prijzen, huidige gebeurtenissen zijn niet actueel',
          ),
          const SizedBox(height: 12),
          _buildFailureModeItem(
            '3. Context vergeten',
            'Bij lange gesprekken kan de AI eerdere info vergeten',
            'Let op: Herhaal belangrijke details als het gesprek lang wordt',
          ),
          const SizedBox(height: 12),
          _buildFailureModeItem(
            '4. Overconfident antwoorden',
            'De AI geeft antwoorden met zekerheid, zelfs als het onzeker is',
            'Let op: "Ik denk" en "ik weet" zijn beide gegenereerde tekst',
          ),
          const SizedBox(height: 12),
          _buildFailureModeItem(
            '5. Bias in training data',
            'Kan vooroordelen uit trainingsdata overnemen',
            'Let op: Kritisch blijven bij stereotypen of eenzijdige standpunten',
          ),
        ],
      ),
    );
  }

  Widget _buildBestUseCasesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Beste gebruiksscenario\'s 🌟',
                  style: TextStyle(
                    color: Color(0xFF0369A1),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildUseCaseItem(
            '✅ Leren en verkennen',
            'Nieuwe concepten begrijpen, vaardigheden oefenen, kennisbasis verbreden',
          ),
          const SizedBox(height: 10),
          _buildUseCaseItem(
            '✅ Praktische projecten',
            'Stappenplannen, DIY-ideeën, creatieve oplossingen met beschikbare middelen',
          ),
          const SizedBox(height: 10),
          _buildUseCaseItem(
            '✅ Emotionele check-ins',
            'Praten over gevoelens, stress management, motivatie vinden (niet voor therapie)',
          ),
          const SizedBox(height: 10),
          _buildUseCaseItem(
            '✅ Brainstormen en plannen',
            'Ideeën genereren, organiseren, verschillende perspectieven verkennen',
          ),
          const SizedBox(height: 10),
          _buildUseCaseItem(
            '✅ Oefenen en experimenteren',
            'Nieuwe dingen proberen in een veilige omgeving zonder oordeel',
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow.shade50,
            Colors.amber.shade50,
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
                  'Veiligheidstips 🛡️',
                  style: TextStyle(
                    color: Color(0xFFD97706),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCheckItem('Controleer feiten uit meerdere bronnen'),
          _buildCheckItem(
              'Deel geen persoonlijke data (wachtwoorden, bankinformatie)'),
          _buildCheckItem('Bij twijfel, vraag een menselijke expert'),
          _buildCheckItem('Gebruik voor ondersteuning, niet voor diagnoses'),
          _buildCheckItem('Wees kritisch, niet alles is waar'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '🎯 Onthoud: Luminara AI is een slim hulpmiddel, maar jij blijft de baas van je beslissingen!',
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

  Widget _buildTechItem(String title, String limit, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.orange.shade900,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            limit,
            style: TextStyle(
              color: Colors.orange.shade800,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Color(0xFF047857),
              fontSize: 18,
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

  Widget _buildFailureModeItem(
      String title, String description, String warning) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF6366F1),
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
          warning,
          style: const TextStyle(
            color: Color(0xFF6366F1),
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildUseCaseItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF0369A1),
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
