import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrainerDetailsPage extends StatelessWidget {
  final Map<String, dynamic> personalData;

  const TrainerDetailsPage({required this.personalData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Profissional'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Ação de compartilhar
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Ação de adicionar aos favoritos
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações do Personal
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: personalData['foto'] != null
                      ? NetworkImage(personalData['foto'])
                      : AssetImage('images/default_placeholder.jpg')
                          as ImageProvider,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personalData['nome'] ?? 'Nome do Personal',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(personalData['cidade'] ?? 'Cidade'),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange),
                        Text('4.9+'),
                        SizedBox(width: 8),
                        Icon(Icons.comment, color: Colors.grey),
                        Text('4.956 Comentários'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Seção 'Sobre'
            Text(
              'Sobre',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              personalData['sobre'] ??
                  'Carlos é um personal dedicado e especialista em treinamento funcional e de alta intensidade.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Localização
            Text(
              'Localidades de atendimento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                Expanded(
                  child: Text(personalData['endereco'] ?? 'Endereço não disponível'),
                ),
                TextButton(
                  onPressed: () {
                    // Ação para abrir no mapa
                  },
                  child: Text('Ver no Mapa'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(-23.550520, -46.633308), // Exemplo de localização
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('localizacao'),
                    position: LatLng(-23.550520, -46.633308),
                  ),
                },
              ),
            ),
            SizedBox(height: 16),

            // Avaliações
            Text(
              'Avaliações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisar nas avaliações',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                FilterChip(
                  label: Text('Filtrado'),
                  onSelected: (selected) {},
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Verificado'),
                  onSelected: (selected) {},
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Recentes'),
                  onSelected: (selected) {},
                ),
              ],
            ),
            SizedBox(height: 8),

            // Lista de Avaliações
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/default_placeholder.jpg'),
              ),
              title: Text('João Souza'),
              subtitle: Text(
                  'Os treinos com Carlos são ótimos, me ajudaram a melhorar muito minha forma física.'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.orange),
                  Text('5.0'),
                ],
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/default_placeholder.jpg'),
              ),
              title: Text('Maria Oliveira'),
              subtitle: Text(
                  'Os treinos são intensos, mas saio sempre satisfeita e motivada.'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.orange),
                  Text('5.0'),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Botão de enviar mensagem
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Ação para mandar mensagem
                },
                child: Text('Mande uma mensagem'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
