import 'package:flutter/material.dart';

class HelpQuestion6 extends StatefulWidget {
  const HelpQuestion6({super.key});

  @override
  State<HelpQuestion6> createState() => _HelpQuestion6State();
}

class _HelpQuestion6State extends State<HelpQuestion6> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Title with icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hulp',
                      style: TextStyle(
                        color: Color(0xFF6464FF),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Image.asset(
                      'assets/images/hulp_2.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Question title
                const Text(
                  'Hoe neem ik contact op met ondersteuning?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2323AD),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // Content container with scrollbar
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 8.0,
                    radius: const Radius.circular(10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section 1: Navigatie
                            Text(
                              '1. Navigatie naar contactformulier',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Ga naar de hoofdpagina van de app\n'
                              '• Tik onderaan op "Instellingen"\n'
                              '• Selecteer "Hulp" in het instellingenmenu\n'
                              '• Kies de optie "Contact opnemen"',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 2: Formulier invullen
                            Text(
                              '2. Contactformulier invullen',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Je ziet een formulier met twee velden:\n'
                              '  - "Onderwerp": Geef je vraag een korte titel\n'
                              '  - "Vraag/opmerking": Beschrijf je probleem of vraag in detail\n'
                              '• Vul beide velden zorgvuldig in\n'
                              '• Wees zo specifiek mogelijk voor een snelle oplossing',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 3: Versturen
                            Text(
                              '3. Bericht versturen',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Controleer je bericht nog een keer\n'
                              '• Tik op de knop "Verzenden" onderaan het formulier\n'
                              '• Je ontvangt een bevestiging dat je bericht is verzonden\n'
                              '• Het ondersteuningsteam zal zo snel mogelijk reageren',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 4: Tips
                            Text(
                              '4. Tips voor effectieve hulpvragen',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Beschrijf het probleem zo precies mogelijk\n'
                              '• Vermeld welke stappen je al hebt geprobeerd\n'
                              '• Geef aan wanneer het probleem optreedt\n'
                              '• Voeg relevante details toe zoals foutmeldingen\n'
                              '• Wees vriendelijk en geduldig - het team doet zijn best!',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Return button
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/images/return.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
