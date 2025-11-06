import 'package:flutter/material.dart';

class HelpQuestion10 extends StatefulWidget {
  const HelpQuestion10({super.key});

  @override
  State<HelpQuestion10> createState() => _HelpQuestion10State();
}

class _HelpQuestion10State extends State<HelpQuestion10> {
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
                  'Welke bestandsformaten kan ik uploaden?',
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
                            // Section 1: Ondersteunde formaten
                            Text(
                              '1. Ondersteunde bestandsformaten',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Luminara accepteert alle bestandsformaten!\n\n'
                              '• Documenten: PDF, Word, Excel, PowerPoint, TXT, etc.\n'
                              '• Afbeeldingen: JPG, PNG, GIF, BMP, SVG, WebP, etc.\n'
                              '• Video\'s: MP4, AVI, MOV, WMV, etc.\n'
                              '• Audio: MP3, WAV, M4A, OGG, etc.\n'
                              '• Archieven: ZIP, RAR, 7Z, etc.\n'
                              '• En veel meer!',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 2: Bestandsgrootte
                            Text(
                              '2. Maximum bestandsgrootte',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• De maximum bestandsgrootte is 10 MB per bestand\n'
                              '• Bestanden groter dan 10 MB worden geweigerd\n'
                              '• Je krijgt een foutmelding als het bestand te groot is\n'
                              '• Comprimeer grote bestanden indien nodig\n'
                              '• Je kunt meerdere kleinere bestanden uploaden',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 3: Upload opties
                            Text(
                              '3. Upload opties',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Je hebt 4 manieren om content te uploaden:\n\n'
                              '• Bestand: Kies een bestand van je apparaat\n'
                              '• Galerij: Selecteer een foto of video uit je galerij\n'
                              '• Camera: Maak direct een nieuwe foto\n'
                              '• Microfoon: Neem audio op of gebruik spraak-naar-tekst\n\n'
                              'Alle opties zijn toegankelijk via het (+) menu in de chat.',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 4: Tips en aanbevelingen
                            Text(
                              '4. Tips en aanbevelingen',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Controleer de bestandsgrootte voordat je uploadt\n'
                              '• Gebruik duidelijke bestandsnamen voor overzicht\n'
                              '• Afbeeldingen in lagere resolutie uploaden sneller\n'
                              '• Comprimeer grote video\'s voordat je ze uploadt\n'
                              '• Je kunt een optioneel bericht toevoegen bij elk bestand\n'
                              '• Wacht tot de upload compleet is voordat je verder gaat',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // Section 5: Probleemoplossing
                            Text(
                              '5. Veelvoorkomende problemen',
                              style: TextStyle(
                                color: Color(0xFF2323AD),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• "Bestand te groot": Comprimeer of deel het bestand op\n'
                              '• "Upload mislukt": Controleer je internetverbinding\n'
                              '• Upload loopt vast: Sluit de app en probeer opnieuw\n'
                              '• Bestand niet zichtbaar: Wacht tot upload 100% is\n'
                              '• Bij blijvende problemen: Neem contact op met ondersteuning',
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
