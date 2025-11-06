import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HelpQuestion1(),
  ));
}

class HelpQuestion1 extends StatefulWidget {
  const HelpQuestion1({super.key});

  @override
  State<HelpQuestion1> createState() => _HelpQuestion1State();
}

class _HelpQuestion1State extends State<HelpQuestion1> {
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
                  'Hoe gebruik je de app?',
                  style: TextStyle(
                    color: Color(0xFF2323AD),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // Content container with grey bubble
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 8.0,
                      radius: const Radius.circular(10),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('1. Inloggen'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Open de app en voer je studentnaam en wachtwoord in. '
                              'Klik op "Inloggen" om toegang te krijgen tot de applicatie.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('2. Chat starten'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Ga naar het Chat-scherm via het navigatiemenu onderaan. '
                              'Typ je vraag of bericht in het invoerveld en druk op de verzendknop.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('3. Bestanden uploaden'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Klik op het paperclip-icoon in de chat om een bestand te selecteren. '
                              'Je kunt documenten, afbeeldingen en andere bestanden uploaden.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('4. Spraakfunctie'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Gebruik het microfoon-icoon om een spraakbericht in te spreken. '
                              'De app zal je spraak omzetten naar tekst.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('5. Geschiedenis bekijken'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Ga naar het Geschiedenis-scherm om eerdere gesprekken terug te vinden. '
                              'Je kunt oude chats opnieuw bekijken of verwijderen.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('6. Instellingen aanpassen'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Open het Instellingen-menu om je profiel te bewerken, '
                              'meldingen aan te passen of je wachtwoord te wijzigen.',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF2323AD),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContentText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF2323AD),
        fontSize: 16,
        height: 1.5,
      ),
    );
  }
}
