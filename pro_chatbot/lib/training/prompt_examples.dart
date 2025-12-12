import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';

class PromptExamples extends StatelessWidget {
  const PromptExamples({super.key});

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
                              'Promptvoorbeelden',
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
                              'Concrete, direct te gebruiken prompts gegroepeerd per use case',
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

                          // Category 1: Creatieve projecten
                          _buildCategorySection(
                            title: 'Creatieve & Praktische Projecten',
                            emoji: '🎨',
                            color: Colors.purple,
                            prompts: [
                              {
                                'title': 'Gerecyclede kunst',
                                'prompt':
                                    'Geef me 5 praktische ideeën voor een kunstproject met gerecyclede materialen die ik thuis kan maken',
                                'why':
                                    'Praktisch + hands-on + met beschikbare materialen = direct toepasbaar'
                              },
                              {
                                'title': 'Webstrip maken',
                                'prompt':
                                    'Hoe maak ik een webstrip over mijn eigen ervaringen? Leg uit welke gratis tools ik kan gebruiken en geef tips',
                                'why':
                                    'Persoonlijke expressie + gratis tools = creatief en toegankelijk'
                              },
                              {
                                'title': 'Stop-motion animatie',
                                'prompt':
                                    'Wat zijn de stappen om een stop-motion animatie te maken met mijn smartphone? Maak een simpele checklist',
                                'why':
                                    'Gebruikt wat je hebt (smartphone) + checklist format = makkelijk te volgen'
                              },
                              {
                                'title': 'DIY project',
                                'prompt':
                                    'Geef me ideeën voor een DIY decoratieproject voor mijn kamer met simpele materialen en weinig budget',
                                'why':
                                    'Praktisch doel + budget bewust = realistisch en haalbaar'
                              },
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Category 2: Emotionele & Psychologische Ondersteuning
                          _buildCategorySection(
                            title: 'Emotionele & Psychologische Ondersteuning',
                            emoji: '💙',
                            color: Colors.teal,
                            prompts: [
                              {
                                'title': 'Omgaan met stress',
                                'prompt':
                                    'Ik voel me gestrest door alles wat ik moet doen. Kun je me 5 praktische technieken geven om te ontspannen?',
                                'why':
                                    'Deelt gevoel + vraagt om praktische technieken = krijgt bruikbare hulp'
                              },
                              {
                                'title': 'Motivatie vinden',
                                'prompt':
                                    'Ik heb moeite om gemotiveerd te blijven voor mijn projecten. Hoe kan ik mezelf beter motiveren?',
                                'why':
                                    'Erkent probleem + vraagt om strategie = persoonlijke ondersteuning'
                              },
                              {
                                'title': 'Praten over gevoelens',
                                'prompt':
                                    'Ik voel me down vandaag en weet niet waarom. Kun je me helpen om te begrijpen wat ik voel?',
                                'why':
                                    'Eerlijk over gevoel + vraagt om hulp bij begrip = veilige ruimte om te praten'
                              },
                              {
                                'title': 'Zelfvertrouwen opbouwen',
                                'prompt':
                                    'Ik twijfel vaak aan mezelf. Geef me tips om mijn zelfvertrouwen te vergroten in kleine stappen',
                                'why':
                                    'Erkent kwetsbaarheid + vraagt om kleine stappen = haalbare groei'
                              },
                              {
                                'title': 'Omgaan met frustratie',
                                'prompt':
                                    'Ik word vaak gefrustreerd als iets niet lukt. Hoe kan ik beter omgaan met teleurstellingen?',
                                'why':
                                    'Specifiek gevoel + vraagt om coping strategie = praktische emotionele hulp'
                              },
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Category 3: Technologie & Programmeren
                          _buildCategorySection(
                            title: 'Technologie & Maken',
                            emoji: '💻',
                            color: Colors.blue,
                            prompts: [
                              {
                                'title': 'Spel programmeren',
                                'prompt':
                                    'Ik wil leren een eenvoudig spel te maken. Wat is de makkelijkste manier om te beginnen zonder programmeerervaring?',
                                'why':
                                    'Eerlijk over niveau (beginner) + vraagt om makkelijke start = passende uitleg'
                              },
                              {
                                'title': 'Robot bouwen',
                                'prompt':
                                    'Hoe kan ik een simpele robot bouwen met dingen die ik thuis heb? Geef een stappenplan',
                                'why':
                                    'Gebruikt beschikbare materialen + stappenplan = hands-on leren'
                              },
                              {
                                'title': '3D printen leren',
                                'prompt':
                                    'Ik ben geïnteresseerd in 3D printen maar weet niet waar te beginnen. Wat moet ik weten?',
                                'why':
                                    'Nieuwsgierig + vraagt om basis = introductie tot nieuwe skill'
                              },
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Category 4: Samenwerking & Groepswerk
                          _buildCategorySection(
                            title: 'Samenwerken & Organiseren',
                            emoji: '👥',
                            color: Colors.green,
                            prompts: [
                              {
                                'title': 'Groepsproject organiseren',
                                'prompt':
                                    'Ik moet een project doen met anderen maar weet niet hoe ik het moet organiseren. Help me een plan te maken',
                                'why':
                                    'Erkent onzekerheid + vraagt om structuur = krijgt organisatie hulp'
                              },
                              {
                                'title': 'Communiceren in een groep',
                                'prompt':
                                    'Ik vind het moeilijk om mijn ideeën te delen in een groep. Hoe kan ik beter communiceren?',
                                'why':
                                    'Erkent sociale uitdaging + vraagt om tips = persoonlijke groei'
                              },
                              {
                                'title': 'Conflicten oplossen',
                                'prompt':
                                    'Er is een conflict in mijn groep. Hoe kan ik helpen om het op te lossen zonder dat het erger wordt?',
                                'why':
                                    'Concrete situatie + vraagt om conflict management = praktische sociale hulp'
                              },
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Category 5: Praktische Vaardigheden
                          _buildCategorySection(
                            title: 'Praktische Vaardigheden',
                            emoji: '🔧',
                            color: Colors.orange,
                            prompts: [
                              {
                                'title': 'Iets repareren',
                                'prompt':
                                    'Mijn fiets maakt een raar geluid. Hoe kan ik zelf checken wat het probleem is voordat ik naar de winkel ga?',
                                'why':
                                    'Concrete probleem + DIY aanpak = leert praktische skill'
                              },
                              {
                                'title': 'Koken leren',
                                'prompt':
                                    'Ik wil leren koken maar heb geen ervaring. Geef me 3 super simpele recepten om te beginnen',
                                'why':
                                    'Eerlijk over niveau + vraagt om simpel = opbouw van basics'
                              },
                              {
                                'title': 'Organiseren en plannen',
                                'prompt':
                                    'Ik ben altijd chaotisch en vergeet dingen. Hoe kan ik mezelf beter organiseren met simpele methodes?',
                                'why':
                                    'Erkent probleem + vraagt om simpele methodes = haalbare verandering'
                              },
                              {
                                'title': 'Gereedschap gebruiken',
                                'prompt':
                                    'Ik wil leren werken met gereedschap om dingen te maken. Waarmee moet ik beginnen en hoe leer ik het veilig te gebruiken?',
                                'why':
                                    'Interesse in praktische skill + benadrukt veiligheid = verantwoord leren'
                              },
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Category 6: Media & Expressie
                          _buildCategorySection(
                            title: 'Media & Zelfexpressie',
                            emoji: '📹',
                            color: Colors.red,
                            prompts: [
                              {
                                'title': 'Video maken over mijn ervaring',
                                'prompt':
                                    'Ik wil een video maken over iets wat ik heb meegemaakt. Hoe begin ik en welke gratis apps zijn goed?',
                                'why':
                                    'Persoonlijke expressie + gratis tools = toegankelijke creativiteit'
                              },
                              {
                                'title': 'Muziek maken',
                                'prompt':
                                    'Ik wil mijn eigen muziek maken op mijn telefoon. Welke apps zijn makkelijk voor beginners?',
                                'why':
                                    'Creatief + gebruikt beschikbare middelen (telefoon) = direct starten'
                              },
                              {
                                'title': 'Foto\'s bewerken',
                                'prompt':
                                    'Hoe kan ik mijn foto\'s creatief bewerken zonder dure software? Geef me tips en gratis opties',
                                'why':
                                    'Creatief doel + budget vriendelijk = democratiseert creativiteit'
                              },
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Tips section
                          _buildTipsSection(),

                          const SizedBox(height: 20),

                          // Common mistakes
                          _buildMistakesSection(),

                          const SizedBox(height: 20),

                          // How to improve prompts
                          _buildImprovementSection(),

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
                'Wat vind je hier? 💡',
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
            'Deze pagina bevat concrete voorbeelden van prompts die je direct kunt gebruiken in Luminara AI. Luminara AI is ontworpen voor praktische educatie (hands-on leren, creatieve projecten) en biedt ook emotionele en psychologische ondersteuning voor personen in moeilijkheden.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              height: 1.5,
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
              '💬 Typ gewoon "Vraag het aan Luminara" in het chatveld om te beginnen!',
              style: TextStyle(
                color: Color(0xFF2323AD),
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

  Widget _buildCategorySection({
    required String title,
    required String emoji,
    required Color color,
    required List<Map<String, String>> prompts,
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
          ...prompts.map((prompt) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildPromptExample(
                  title: prompt['title']!,
                  prompt: prompt['prompt']!,
                  why: prompt['why']!,
                  color: color,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPromptExample({
    required String title,
    required String prompt,
    required String why,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          '📌 $title',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        // Prompt box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
          child: Text(
            '"$prompt"',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Why it works
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✓',
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  why,
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade50,
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
                'Tips voor betere prompts ✨',
                style: TextStyle(
                  color: Color(0xFF0F766E),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            '1',
            'Wees eerlijk over je gevoelens',
            'Bij emotionele vragen: deel hoe je je voelt, het is veilig',
            Colors.teal,
          ),
          const SizedBox(height: 10),
          _buildTipItem(
            '2',
            'Geef context',
            'Vertel wat je wilt leren, maken, of bereiken',
            Colors.teal,
          ),
          const SizedBox(height: 10),
          _buildTipItem(
            '3',
            'Vraag om praktische hulp',
            'Hands-on, stap-voor-stap, met wat je hebt - maak het haalbaar',
            Colors.teal,
          ),
          const SizedBox(height: 10),
          _buildTipItem(
            '4',
            'Wees eerlijk over je niveau',
            '"Ik ben beginner", "Ik heb geen ervaring" - dit helpt om passende hulp te krijgen',
            Colors.teal,
          ),
          const SizedBox(height: 10),
          _buildTipItem(
            '5',
            'Vraag om ondersteuning',
            'Motivatie, stressbeheer, zelfvertrouwen - Luminara is er voor emotionele hulp',
            Colors.teal,
          ),
        ],
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

  Widget _buildMistakesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade50,
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
          const Row(
            children: [
              Text(
                'Veelgemaakte fouten ⚠️',
                style: TextStyle(
                  color: Color(0xFFEA580C),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMistakeItem(
            '❌ Te vaag',
            'Slecht: "Help me"\nBeter: "Ik voel me overweldigd door mijn projecten. Kun je me helpen om prioriteiten te stellen?"',
          ),
          const SizedBox(height: 12),
          _buildMistakeItem(
            '❌ Niet eerlijk over niveau',
            'Slecht: "Leg programmeren uit"\nBeter: "Ik heb nog nooit geprogrammeerd. Wat is de simpelste manier om te beginnen?"',
          ),
          const SizedBox(height: 12),
          _buildMistakeItem(
            '❌ Bang om gevoelens te delen',
            'Slecht: "Geef tips"\nBeter: "Ik twijfel vaak aan mezelf. Hoe kan ik meer zelfvertrouwen krijgen?"',
          ),
          const SizedBox(height: 12),
          _buildMistakeItem(
            '❌ Te academisch',
            'Slecht: "Help me met deze wiskundeformule"\nBeter: "Ik wil leren budgetteren. Kun je me praktisch leren rekenen met geld?"',
          ),
        ],
      ),
    );
  }

  Widget _buildMistakeItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFEA580C),
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
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildImprovementSection() {
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
                'Van slecht naar goed 🚀',
                style: TextStyle(
                  color: Color(0xFFBE185D),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildImprovementExample(
            before: 'Help me met iets maken',
            after:
                'Ik wil iets praktisch maken met mijn handen maar weet niet wat. Kun je me 3 simpele DIY projecten voorstellen?',
            improvement:
                'Toegevoegd: type activiteit (hands-on) + niveau (simpel) + aantal ideeën',
          ),
          const SizedBox(height: 16),
          _buildImprovementExample(
            before: 'Ik voel me slecht',
            after:
                'Ik voel me gestrest en weet niet hoe ik moet ontspannen. Kun je me rustige activiteiten voorstellen die ik alleen kan doen?',
            improvement:
                'Toegevoegd: specifiek gevoel + type hulp + context (alleen)',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '💡 Zie je het patroon? Meer details + eerlijkheid = betere ondersteuning!',
              style: TextStyle(
                color: Color(0xFFBE185D),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementExample({
    required String before,
    required String after,
    required String improvement,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Before
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '❌ ',
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: Text(
                  before,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // After
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '✅ ',
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: Text(
                  after,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Improvement note
        Text(
          '→ $improvement',
          style: const TextStyle(
            color: Color(0xFFBE185D),
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
