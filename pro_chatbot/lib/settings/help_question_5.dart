import 'package:flutter/material.dart';

class HelpQuestion5 extends StatefulWidget {
  const HelpQuestion5({super.key});

  @override
  State<HelpQuestion5> createState() => _HelpQuestion5State();
}

class _HelpQuestion5State extends State<HelpQuestion5> {
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
                  'Hoe verwijder ik een gesprek uit de geschiedenis?',
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
                            // Section 1: Toegang tot geschiedenis
                            Text(
                              '1. Toegang tot geschiedenis',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Open de Chat-pagina\n'
                              '• Tik rechtsboven op de knop "View History"\n'
                              '• Je komt nu op de pagina "Chat geschiedenis" met al je opgeslagen gesprekken',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 2: Zoeken naar gesprek
                            Text(
                              '2. Zoeken naar een gesprek',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Onderaan de pagina vind je de zoekbalk met het veld "Een chat zoeken"\n'
                              '• Typ een trefwoord uit de titel of datum van het gesprek\n'
                              '• De lijst wordt automatisch gefilterd terwijl je typt\n'
                              '• Je kunt zoeken op zowel titel als datum',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 3: Gesprek verwijderen
                            Text(
                              '3. Gesprek verwijderen',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Elk gesprek heeft rechts een menu-icoon (3 verticale puntjes)\n'
                              '• Tik op dit icoon om het contextmenu te openen\n'
                              '• Kies de rode optie "Chat verwijderen"\n'
                              '• Het gesprek wordt meteen verwijderd uit je geschiedenis\n'
                              '• Je krijgt een bevestiging te zien: "Chat verwijderd"',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 4: Belangrijke opmerking
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
                              '• Verwijderde gesprekken kunnen niet worden hersteld\n'
                              '• Zorg dat je zeker bent voordat je een gesprek verwijdert\n'
                              '• De lijst met gesprekken toont de meest recente bovenaan\n'
                              '• Je kunt meerdere gesprekken verwijderen, één voor één',
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
