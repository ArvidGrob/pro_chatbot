import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HelpQuestion4(),
  ));
}

class HelpQuestion4 extends StatefulWidget {
  const HelpQuestion4({super.key});

  @override
  State<HelpQuestion4> createState() => _HelpQuestion4State();
}

class _HelpQuestion4State extends State<HelpQuestion4> {
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
                  'Hoe wijzig ik mijn\nwachtwoord?',
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
                              'Open de app en ga naar de navigatiepagina. '
                              'Klik op "Instellingen" om het instellingenmenu te openen.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle(
                                'Stap 2: Open Account-instellingen'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'In het Instellingen-menu zie je verschillende opties. '
                              'Selecteer "Account" om je accountinstellingen te openen.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle(
                                'Stap 3: Klik op Wachtwoord wijzigen'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Op de Account-pagina zie je een knop "Wachtwoord wijzigen". '
                              'Tik hierop om naar het wachtwoord-wijzigscherm te gaan.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Stap 4: Vul de velden in'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Je ziet drie velden:\n\n'
                              '• Oud wachtwoord: Voer je huidige wachtwoord in\n'
                              '• Nieuw wachtwoord: Kies een nieuw wachtwoord\n'
                              '• Nieuw wachtwoord bevestigen: Voer het nieuwe wachtwoord opnieuw in',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Stap 5: Bevestig de wijziging'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              'Controleer of beide nieuwe wachtwoorden overeenkomen. '
                              'Klik op de groene "Registreren" knop rechtsonder om de wijziging op te slaan.',
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Belangrijk'),
                            const SizedBox(height: 10),
                            _buildContentText(
                              '• Je moet je oude wachtwoord kennen om het te kunnen wijzigen\n'
                              '• Beide nieuwe wachtwoorden moeten exact hetzelfde zijn\n'
                              '• Kies een wachtwoord dat je kunt onthouden\n'
                              '• Bewaar je wachtwoord op een veilige plaats',
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
