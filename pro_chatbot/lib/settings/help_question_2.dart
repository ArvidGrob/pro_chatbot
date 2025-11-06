import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HelpQuestion2(),
  ));
}

class HelpQuestion2 extends StatefulWidget {
  const HelpQuestion2({super.key});

  @override
  State<HelpQuestion2> createState() => _HelpQuestion2State();
}

class _HelpQuestion2State extends State<HelpQuestion2> {
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
                  'Hoe verander je je stem?',
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
                            _buildSectionTitle('Stap 1: Ga naar Instellingen'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Open de app en ga naar het Instellingen-menu. '
                              'Selecteer vervolgens de optie "Spraak".',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle(
                                'Stap 2: Kies tussen twee stemmen'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'In het Spraak-menu zie je twee opties:\n'
                              '• Vrouwelijke stem\n'
                              '• Mannelijke stem\n\n'
                              'Tik op het blok om te schakelen tussen deze twee stemopties.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle(
                                'Stap 3: De wijziging is direct actief'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Wanneer je een stem selecteert, wordt deze direct geactiveerd. '
                              'Er verschijnt een vinkje naast de gekozen stem. '
                              'Je hoeft niets op te slaan, de wijziging is meteen van kracht.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Let op'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              '• Je kunt op elk moment wisselen tussen de twee stemmen\n'
                              '• De gekozen stem wordt gebruikt voor alle spraakfuncties in de app\n'
                              '• Ga terug naar de chat om de nieuwe stem te horen',
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
