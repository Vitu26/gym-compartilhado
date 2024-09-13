import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprylife/pages/personal/faturasAndPlanos/criar_fatura.dart';
import 'package:sprylife/pages/personal/faturasAndPlanos/planos_screen._page.dart';
import 'package:sprylife/utils/colors.dart';

class AlunoFaturaScreen extends StatefulWidget {
  final Map<String, dynamic> alunoData;
  final Map<String, dynamic> personalData; // Adicione personalData aqui

  AlunoFaturaScreen({
    required this.alunoData,
    required this.personalData, // Receber também o personalData
  });

  @override
  _AlunoFaturaScreenState createState() => _AlunoFaturaScreenState();
}

class _AlunoFaturaScreenState extends State<AlunoFaturaScreen> {
  int _selectedIndex = 0;
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final String alunoId =
        widget.alunoData['id']?.toString() ?? 'ID não disponível';
    final String personalId = widget.personalData['id']?.toString() ??
        'ID do personal não disponível';

    final double recebido = widget.alunoData['recebido'] != null
        ? widget.alunoData['recebido'].toDouble()
        : 0.0;
    final double emAberto = widget.alunoData['em_aberto'] != null
        ? widget.alunoData['em_aberto'].toDouble()
        : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          iconSize: 24,
        ),
        title: Text(
          'Detalhes do Aluno',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildPeriodSection(context),
          Divider(height: 1),
          _buildValuesSection(recebido, emAberto),
          Divider(height: 1),
          const SizedBox(
            height: 10,
          ),
          _buildButtonBar(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    String? personalId = widget.alunoData['personal_id']?.toString();

    if (_selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CriarFaturaScreen(
                alunoId: widget.alunoData['id'].toString(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: personalColor,
      );
    } else if (_selectedIndex == 2 &&
        personalId != null &&
        personalId.isNotEmpty) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlanosScreen(personalId: personalId),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: personalColor,
      );
    } else if (_selectedIndex == 2 &&
        (personalId == null || personalId.isEmpty)) {
      return FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ID do personal não encontrado.')),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: personalColor,
      );
    }

    return SizedBox.shrink(); // Retorna um widget vazio quando não há ação
  }

  Widget _buildHeader() {
    final userData = widget.alunoData['user'];
    final addressData = widget.alunoData['address'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(
                'images/${(userData?['name']?.replaceAll(' ', '').toLowerCase()) ?? 'default_image'}.jpg'),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData?['name'] ?? 'Nome Indisponível',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.alunoData['status'] ?? 'Status Indisponível',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              Text(
                addressData?['cidade'] ?? 'Localização Indisponível',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSection(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateRange(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Período\n${DateFormat('dd/MM/yyyy').format(_startDate)} - ${DateFormat('dd/MM/yyyy').format(_endDate)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.calendar_today, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildValuesSection(double recebido, double emAberto) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 100,
            width: 180,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Recebido'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('R\$ ${recebido.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 100,
            width: 180,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Em aberto'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('R\$ ${emAberto.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildFaturasPagasContent();
      case 1:
        return _buildFaturasEmAbertoContent();
      case 2:
        return _buildPlanosContent();
      default:
        return Container();
    }
  }

  Widget _buildFaturasPagasContent() {
    List<dynamic> faturasPagas = widget.alunoData['faturasPagas'] ?? [];

    if (faturasPagas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text('Nenhuma fatura paga encontrada.'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: faturasPagas.map((fatura) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Valor: R\$ ${fatura['valor']?.toStringAsFixed(2) ?? 'Valor não disponível'}'),
                Text(
                    'Vencimento: ${fatura['vencimento'] ?? 'Data não disponível'}'),
                Text('Pago em: ${fatura['pagoEm'] ?? 'Data não disponível'}'),
                Text('Status: Pago', style: TextStyle(color: Colors.green)),
                Text('Descrição: ${fatura['descricao'] ?? 'Sem descrição'}'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFaturasEmAbertoContent() {
    List<dynamic> faturasEmAberto = widget.alunoData['faturasEmAberto'] ?? [];

    if (faturasEmAberto.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text('Nenhuma fatura em aberto encontrada.'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: faturasEmAberto.map((fatura) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Valor: R\$ ${fatura['valor']?.toStringAsFixed(2) ?? 'Valor não disponível'}'),
                Text(
                    'Vencimento: ${fatura['vencimento'] ?? 'Data não disponível'}'),
                Text('Pago em: ${fatura['pagoEm'] ?? '-'}'),
                Text('Status: Aberto', style: TextStyle(color: Colors.red)),
                Text('Descrição: ${fatura['descricao'] ?? 'Sem descrição'}'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlanosContent() {
    final plano = widget.alunoData['planoAtual'];

    if (plano == null) {
      return Center(
        child: Text('Nenhum plano disponível.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plano Atual: ${plano['nome'] ?? 'Nome não disponível'}'),
          plano['descricao'] != null
              ? Text('Descrição: ${plano['descricao']}')
              : Container(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                final personalData =
                    await getPersonalLogado(); // Buscando o personal logado
                final String personalId = personalData['id'];

                if (personalId.isNotEmpty) {
                  debugPrint(
                      'Navegando para PlanosScreen com personalId: $personalId');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlanosScreen(
                        personalId:
                            personalId, // Passando o ID do personal logado
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'ID do personal não encontrado. Não é possível editar o plano.'),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao obter o personal logado: $e'),
                  ),
                );
              }
            },
            child: Text(plano != null ? 'Editar Plano' : 'Novo Plano'),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildButton('Faturas Pagas', 0),
          SizedBox(height: 8),
          _buildButton('Faturas em Aberto', 1),
          SizedBox(height: 8),
          _buildButton('Planos', 2),
        ],
      ),
    );
  }

  Widget _buildButton(String label, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: _selectedIndex == index ? Colors.white : personalColor,
        backgroundColor: _selectedIndex == index ? personalColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: personalColor),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(label),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null &&
        picked != DateTimeRange(start: _startDate, end: _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<Map<String, dynamic>> getPersonalLogado() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? personalId = prefs.getString('personal_id');
    final String? personalNome = prefs.getString('personal_nome');

    if (personalId != null && personalNome != null) {
      return {
        'id': personalId,
        'nome': personalNome,
      };
    } else {
      throw Exception('Nenhum personal logado encontrado');
    }
  }
}
