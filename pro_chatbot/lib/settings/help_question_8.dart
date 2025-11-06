import 'package:flutter/material.dart';

class HelpQuestion8 extends StatefulWidget {
  const HelpQuestion8({super.key});

  @override
  State<HelpQuestion8> createState() => _HelpQuestion8State();
}

class _HelpQuestion8State extends State<HelpQuestion8> {
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
                  'Wat is de Training-sectie en hoe gebruik ik deze?',
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
                            // Section 1: Wat is Training
                            Text(
                              '1. Wat is de Training-sectie?',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'De Training-sectie is een educatieve module die je helpt om:\n'
                              '• Beter te begrijpen hoe Luminara AI werkt\n'
                              '• Effectievere vragen te stellen\n'
                              '• De mogelijkheden en beperkingen van de AI te leren kennen\n'
                              '• Je vaardigheden te verbeteren in het gebruik van de chatbot',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 2: Toegang
                            Text(
                              '2. Toegang tot Training',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Ga naar de hoofdpagina van de app\n'
                              '• Tik op de grote knop "Training"\n'
                              '• Je komt op een overzichtspagina met 6 verschillende secties\n'
                              '• Elke sectie behandelt een specifiek aspect van de AI',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 3: Beschikbare secties
                            Text(
                              '3. Beschikbare trainingssecties',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Getting Started: Basis introductie voor nieuwe gebruikers\n'
                              '• How it Works: Technische uitleg over de AI-werking\n'
                              '• Prompt Examples: Voorbeelden van goede vragen\n'
                              '• Best Practices: Tips voor optimaal gebruik\n'
                              '• Limitations: Wat de AI niet kan of waar je op moet letten\n'
                              '• Accuracy of AI: Informatie over betrouwbaarheid en precisie',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 4: Hoe te gebruiken
                            Text(
                              '4. Hoe gebruik je de Training-sectie?',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Kies een sectie die je interesseert\n'
                              '• Tik op de sectie om deze te openen\n'
                              '• Lees de informatie door in je eigen tempo\n'
                              '• Je kunt op elk moment teruggaan naar het overzicht\n'
                              '• Het is aan te raden om met "Getting Started" te beginnen\n'
                              '• Je kunt de secties in elke volgorde doorlopen',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 5: Ontwikkelingsstatus
                            Text(
                              '5. Belangrijk om te weten',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Sommige secties zijn momenteel nog in ontwikkeling\n'
                              '• Deze tonen de melding "Under Development"\n'
                              '• De inhoud wordt regelmatig uitgebreid en bijgewerkt\n'
                              '• Check regelmatig terug voor nieuwe trainingsmateriaal\n'
                              '• De Training-sectie is volledig optioneel maar wel aanbevolen',
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
