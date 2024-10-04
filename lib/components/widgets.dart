import 'package:flutter/material.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:perfil_professor/components/colors.dart';

// Widget para exibir a linha de checkboxes
Widget buildCheckboxRow({
  required bool value,
  required String label,
  required ValueChanged<bool?> onChanged,
}) {
  return Row(
    children: [
      Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: personalColor,
      ),
      Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ],
  );
}

// Widget para o campo de texto de busca
Widget buildSearchTextField({
  required TextEditingController searchController,
  required VoidCallback onChanged,
  required VoidCallback onClear,
}) {
  return TextField(
    controller: searchController,
    decoration: InputDecoration(
      suffixIcon: searchController.text.isNotEmpty
          ? IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close, color: Colors.red),
            )
          : null,
      prefixIcon: const Icon(Icons.search),
      fillColor: Colors.grey.shade200,
      filled: true,
      contentPadding: const EdgeInsets.all(10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintText: 'Procurar...',
    ),
    onChanged: (_) => onChanged(),
  );
}

// Widget para exibir as sugestões de localização
Widget buildLocationSuggestions({
  required List<dynamic> listOfLocation,
  required ValueChanged<String> onSelectLocation,
}) {
  return SizedBox(
    height: 200,
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listOfLocation.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onSelectLocation(listOfLocation[index]["description"]);
          },
          child: ListTile(
            title: Text(listOfLocation[index]["description"]),
          ),
        );
      },
    ),
  );
}

// Widget para exibir o resultado da busca
Widget buildSearchResultSection({
  required String selectedLocation,
  required VoidCallback onAddNewLocation,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'RESULTADO DA BUSCA',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const GradientIcon(
            icon: Icons.place,
            size: 30,
            gradient: LinearGradient(
              colors: [personalColor, secondaryColor],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                selectedLocation.isNotEmpty ? selectedLocation : 'Local',
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: onAddNewLocation,
                child: Text(
                  'Não achou a sua academia?',
                  style: TextStyle(fontSize: 15, color: personalColor),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 27),
            child: Container(
              width: 200,
              child: Divider(
                indent: 12,
                endIndent: 0,
                color: personalColor,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// Função para construir o bottom sheet
void buildBottomSheet(BuildContext context) {
  final academiaController = TextEditingController();
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    'Inserir academia',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 10),
              buildBottomSheetTextField(label: 'Nome da academia', controller: academiaController),
              const SizedBox(height: 10),
              buildBottomSheetTextField(label: 'Rua', controller: ruaController),
              const SizedBox(height: 10),
              buildBottomSheetTextField(label: 'Bairro', controller: bairroController),
              const SizedBox(height: 10),
              buildBottomSheetTextField(label: 'Cidade', controller: cidadeController),
              const SizedBox(height: 8),
              buildSaveButton(context),
            ],
          ),
        ),
      );
    },
  );
}

// Widget para o campo de texto do bottom sheet
Widget buildBottomSheetTextField({
  required String label,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(label, style: TextStyle(fontSize: 15)),
      TextField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );
}

// Widget para o botão de salvar no bottom sheet
Widget buildSaveButton(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.057,
    width: MediaQuery.of(context).size.width * 0.3,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      gradient: const LinearGradient(
        colors: [personalColor, secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: FloatingActionButton(
      onPressed: () {
        Navigator.pop(context);
      },
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Text(
        'Salvar',
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}
