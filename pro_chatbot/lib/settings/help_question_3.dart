import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HelpQuestion3(),
  ));
}

class HelpQuestion3 extends StatefulWidget {
  const HelpQuestion3({super.key});

  @override
  State<HelpQuestion3> createState() => _HelpQuestion3State();
}

class _HelpQuestion3State extends State<HelpQuestion3> {
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
                  'Hoe importeer ik een\nbestand in de chat?',
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
                            _buildSectionTitle('Stap 1: Open de chat'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Ga naar het Chat-scherm via de navigatiepagina. '
                              'Je ziet onderaan het scherm een invoerveld voor je berichten.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Stap 2: Open het bijlage-menu'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Naast het tekstinvoerveld zie je een plus (+) knop. '
                              'Tik hierop om het menu met bijlage-opties te openen.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Stap 3: Kies een optie'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Er verschijnt een menu met vier iconen:\n\n'
                              '• Bestand-icoon: Selecteer elk type bestand (PDF, DOC, etc.)\n'
                              '• Galerij-icoon: Kies een foto uit je fotogalerij\n'
                              '• Camera-icoon: Maak direct een foto met je camera\n'
                              '• Microfoon-icoon: Neem een spraakbericht op',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Stap 4: Selecteer je bestand'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Na het kiezen van een optie opent de bestandskiezer of camera. '
                              'Selecteer het gewenste bestand of neem een foto.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Stap 5: Voeg een bericht toe'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Er verschijnt een dialoogvenster met een voorbeeldweergave van je bestand. '
                              'Je kunt een optioneel bericht toevoegen dat samen met het bestand wordt verzonden. '
                              'Klik op "Verzenden" om het bestand te uploaden.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Belangrijk om te weten'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              '• Maximale bestandsgrootte: 10 MB\n'
                              '• Alle bestandstypes worden geaccepteerd\n'
                              '• Upload wordt getoond met een voortgangsbalk\n'
                              '• Je kunt annuleren tijdens het dialoogvenster',
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
