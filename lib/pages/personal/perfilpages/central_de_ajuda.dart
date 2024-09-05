import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpCenterPage extends StatefulWidget {
  @override
  _HelpCenterPageState createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Central de Ajuda',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "FAQ"),
            Tab(text: "Contato"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFAQSection(),
          _buildContactSection(),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xFFF4F6F9),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterChip('All', true),
              _buildFilterChip('Services', false),
              _buildFilterChip('General', false),
              _buildFilterChip('Account', false),
            ],
          ),
          SizedBox(height: 16),
          _buildFAQItem(
              'Are the workouts suitable for beginners?',
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
          _buildFAQItem('What is the refund policy?', ''),
          _buildFAQItem('How can I cancel my premium subscription?', ''),
          _buildFAQItem('How do I reset my password if I forget it?', ''),
          _buildFAQItem('How do I receive updates and notifications?', ''),
          _buildFAQItem('Is Voice call or Video Call Feature there?', ''),
          _buildFAQItem('How to add review?', ''),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            answer,
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // Lógica para filtrar FAQs
      },
      selectedColor: Colors.blue.withOpacity(0.15),
      backgroundColor: Colors.grey.withOpacity(0.15),
      checkmarkColor: Colors.blue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue : Colors.black,
      ),
    );
  }

  Widget _buildContactSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xFFF4F6F9),
            ),
          ),
          SizedBox(height: 16),
          _buildContactItem(Icons.phone, 'Atendimento', '+55 11 9555-0103'),
          _buildContactItem(FontAwesomeIcons.whatsapp, 'WhatsApp', '+55 11 9555-0103'),
          _buildContactItem(Icons.web, 'Website', 'www.example.com'),
          _buildContactItem(Icons.facebook, 'Facebook', '@example'),
          _buildContactItem(FontAwesomeIcons.twitter, 'Twitter', '@example'),
          _buildContactItem(FontAwesomeIcons.instagram, 'Instagram', '@example'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // Lógica para abrir contato ou link
      },
    );
  }
}
