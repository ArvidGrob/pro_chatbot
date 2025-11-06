import 'package:flutter/material.dart';

class HelpQuestion7 extends StatefulWidget {
  const HelpQuestion7({super.key});

  @override
  State<HelpQuestion7> createState() => _HelpQuestion7State();
}

class _HelpQuestion7State extends State<HelpQuestion7> {
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
                  'Hoe werk ik met de spraak-naar-tekst functie?',
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
                            // Section 1: Microfoon openen
                            Text(
                              '1. Spraakfunctie activeren',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Open een chat met Luminara\n'
                              '• Onderaan rechts zie je het (+) plusmenu\n'
                              '• Tik op het (+) icoon om het menu te openen\n'
                              '• Je ziet 4 opties verschijnen in een blauw menu\n'
                              '• De vierde optie is het Microfoon-icoon',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 2: Opname starten
                            Text(
                              '2. Spraakopname gebruiken',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Tik op het Microfoon-icoon\n'
                              '• Er verschijnt een dialoogvenster\n'
                              '• Geef toestemming voor microfoontoegang (indien gevraagd)\n'
                              '• Begin duidelijk te spreken wanneer het venster is geopend\n'
                              '• Je spraak wordt automatisch omgezet naar tekst',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 3: Tekst verzenden
                            Text(
                              '3. Opname afronden',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Stop met spreken wanneer je klaar bent\n'
                              '• De tekst verschijnt in het dialoogvenster\n'
                              '• Controleer of de tekst correct is herkend\n'
                              '• Je kunt de tekst eventueel nog bewerken\n'
                              '• Bevestig om de tekst als bericht te versturen',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 4: Tips
                            Text(
                              '4. Tips voor beste resultaten',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Spreek duidelijk en in een normaal tempo\n'
                              '• Zorg voor een stille omgeving zonder achtergrondgeluid\n'
                              '• Houd je apparaat op ongeveer 15-20 cm afstand\n'
                              '• Spreek in volledige zinnen voor betere herkenning\n'
                              '• Bij een fout kun je de opname opnieuw proberen\n'
                              '• De functie werkt het best in het Nederlands',
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
