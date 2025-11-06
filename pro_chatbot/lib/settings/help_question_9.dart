import 'package:flutter/material.dart';

class HelpQuestion9 extends StatefulWidget {
  const HelpQuestion9({super.key});

  @override
  State<HelpQuestion9> createState() => _HelpQuestion9State();
}

class _HelpQuestion9State extends State<HelpQuestion9> {
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
                  'Hoe wijzig ik mijn naam in mijn profiel?',
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
                              '1. Navigatie naar accountinstellingen',
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
                              '• Selecteer "Account" in het instellingenmenu\n'
                              '• Kies de optie "Naam wijzigen"',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 2: Velden invullen
                            Text(
                              '2. Nieuwe naam invoeren',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Je ziet twee invoervelden:\n'
                              '  - "Voornaam": Voer je voornaam in\n'
                              '  - "Naam": Voer je achternaam in\n'
                              '• Beide velden kunnen worden aangepast\n'
                              '• Typ de nieuwe naam zoals je deze wilt hebben\n'
                              '• Zorg ervoor dat je naam correct is gespeld',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 3: Opslaan
                            Text(
                              '3. Wijzigingen opslaan',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Controleer of beide namen correct zijn ingevuld\n'
                              '• Tik op de knop "Registreren" onderaan rechts\n'
                              '• Je nieuwe naam wordt direct bijgewerkt in het systeem\n'
                              '• Je krijgt een bevestiging te zien dat de wijziging is opgeslagen\n'
                              '• De nieuwe naam verschijnt nu in je profiel',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 4: Belangrijk
                            Text(
                              '4. Belangrijk om te weten',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Je kunt je naam zo vaak wijzigen als je wilt\n'
                              '• De wijziging wordt direct doorgevoerd\n'
                              '• Zorg dat je officiële naam gebruikt voor administratieve doeleinden\n'
                              '• Als je problemen ondervindt, neem contact op met ondersteuning\n'
                              '• Je gebruikersnaam (studentnaam) voor inloggen blijft hetzelfde',
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
