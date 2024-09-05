import 'package:flutter/material.dart';
import 'package:sprylife/widgets/custom_appbar_princi.dart';

class FavoritosScreen extends StatefulWidget {
  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  String selectedCategory = "Personal";
  final List<Map<String, String>> favoritos = [
    {
      'nome': 'Karolene Alcantara',
      'imagem': 'images/prof1.jpg',
      'especialidade': 'Musculação | Online',
      'rating': '4.9',
    },
    {
      'nome': 'Ana Lima',
      'imagem': 'images/prof2.jpg',
      'especialidade': 'Funcional | Presencial',
      'rating': '4.7',
    },
    {
      'nome': 'João Cardoso',
      'imagem': 'images/prof3.jpg',
      'especialidade': 'Pilates | Online',
      'rating': '4.8',
    },
    // Adicione mais profissionais conforme necessário
  ];

  void _showRemoveDialog(Map<String, String> profissional) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Remover dos Favoritos?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(profissional['imagem']!),
                  ),
                  title: Text(profissional['nome']!),
                  subtitle: Text(profissional['especialidade']!),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          favoritos.remove(profissional);
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Remover"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, 
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarPrinci(title: 'Favoritos',),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: _buildFavoritosList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildCategoryTab('Nutricionistas'),
          SizedBox(width: 10),
          _buildCategoryTab('Personal'),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String category) {
    final bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritosList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: favoritos.length,
      itemBuilder: (context, index) {
        final profissional = favoritos[index];
        return GestureDetector(
          onLongPress: () {
            _showRemoveDialog(profissional);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(profissional['imagem']!),
              ),
              title: Text(profissional['nome']!),
              subtitle: Text(profissional['especialidade']!),
              trailing: Icon(Icons.more_vert),
            ),
          ),
        );
      },
    );
  }
}
