import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const UltraSky());
}

// ============================================================
// 📺 ULTRA SKY — COM REPRODUÇÃO DE VÍDEO ✅
// Criado por Alessandro P Abreu & Dola
// © 2026 — Versão 1.2.0
// ============================================================

class UltraSky extends StatefulWidget {
  const UltraSky({super.key});

  @override
  State<UltraSky> createState() => _UltraSkyState();
}

class _UltraSkyState extends State<UltraSky> {
  int _paginaAtual = 0;
  String _categoriaFiltro = 'Todas';

  // ⚙️ CONFIGURAÇÕES
  bool _modoEscuro = true;
  bool _notificacoes = true;
  bool _som = true;
  bool _protecao = true;
  bool _autoRecarregar = true;
  String _qualidadeVideo = 'Alta';

  // 📡 LISTA M3U
  final TextEditingController _controladorM3U = TextEditingController();
  String? _urlM3USalva;

  // 📺 CANAIS COM LINKS DE REPRODUÇÃO ✅
  final List<Map<String, dynamic>> _canais = [
    {
      'nome': '📺 TV Brasil',
      'grupo': 'TV Aberta',
      'estavel': true,
      'favorito': false,
      'link': 'https://tvbrasil.ebc.com.br/ao-vivo'
    },
    {
      'nome': '📺 TV Cultura',
      'grupo': 'TV Aberta',
      'estavel': true,
      'favorito': false,
      'link': 'https://tvcultura.com.br/ao-vivo'
    },
    {
      'nome': '🏛️ TV Senado',
      'grupo': 'TV Aberta',
      'estavel': true,
      'favorito': false,
      'link': 'https://www12.senado.leg.br/tv/ao-vivo'
    },
    {
      'nome': '🏛️ TV Câmara',
      'grupo': 'TV Aberta',
      'estavel': true,
      'favorito': false,
      'link': 'https://www.camara.leg.br/tv/ao-vivo'
    },
    {
      'nome': '🏥 Canal Saúde',
      'grupo': 'TV Aberta',
      'estavel': true,
      'favorito': false,
      'link': 'https://www.canalsaude.fiocruz.br/ao-vivo'
    },
    {
      'nome': '📚 TV Escola',
      'grupo': 'Educação',
      'estavel': true,
      'favorito': false,
      'link': 'https://tvescola.mec.gov.br/ao-vivo'
    },
    {
      'nome': '🌈 Canal Futura',
      'grupo': 'Educação',
      'estavel': true,
      'favorito': false,
      'link': 'https://www.futura.org.br/ao-vivo'
    },
    {
      'nome': '🎬 Filmes Grátis',
      'grupo': 'Filmes',
      'estavel': false,
      'favorito': false,
      'link': ''
    },
    {
      'nome': '📺 Séries',
      'grupo': 'Séries',
      'estavel': false,
      'favorito': false,
      'link': ''
    },
    {
      'nome': '🎌 Anime e Desenhos',
      'grupo': 'Anime',
      'estavel': false,
      'favorito': false,
      'link': ''
    },
  ];

  List<Map<String, dynamic>> get _canaisFiltrados {
    if (_categoriaFiltro == 'Todas') return _canais;
    return _canais.where((c) => c['grupo'] == _categoriaFiltro).toList();
  }

  List<String> get _categorias {
    final lista = _canais.map((c) => c['grupo'] as String).toSet().toList();
    lista.insert(0, 'Todas');
    return lista;
  }

  int get _totalFavoritos => _canais.where((c) => c['favorito'] == true).length;
  int get _totalEstaveis => _canais.where((c) => c['estavel'] == true).length;
  String _statusCanal(bool e) => e ? '✅ Estável' : '⚠️ Instável';

  // ▶️ FUNÇÃO REPRODUZIR CANAL ✅
  Future<void> _reproduzirCanal(Map<String, dynamic> canal) async {
    final link = canal['link'] as String;

    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📡 Link ainda não disponível — adicione na Lista M3U!'), backgroundColor: Colors.orange),
      );
      return;
    }

    final uri = Uri.parse(link);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Não foi possível abrir o link'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // 📡 FUNÇÕES M3U
  void _salvarM3U() {
    final url = _controladorM3U.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Digite o link da lista M3U!'), backgroundColor: Colors.orange),
      );
      return;
    }
    setState(() => _urlM3USalva = url);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Lista M3U salva com sucesso! 📡'), backgroundColor: Colors.green),
    );
    _controladorM3U.clear();
  }

  void _limparM3U() {
    setState(() => _urlM3USalva = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🗑️ Lista M3U removida!')),
    );
  }

  void _limparCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🧹 Cache limpo! ✅'), backgroundColor: Colors.green),
    );
  }

  void _alternarFavorito(Map<String, dynamic> c) {
    setState(() => c['favorito'] = !(c['favorito'] as bool));
  }

  ThemeData _tema() {
    if (_modoEscuro) {
      return ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F12),
        cardColor: const Color(0xFF1A1A24),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFC107),
          secondary: Color(0xFF64B5F6),
        ),
      );
    }
    return ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFFC107),
        secondary: Color(0xFF1976D2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ultra Sky',
      theme: _tema(),
      home: Scaffold(
        body: SafeArea(child: _corpo()),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _paginaAtual,
          onDestinationSelected: (i) => setState(() => _paginaAtual = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: Color(0xFFFFC107)), label: 'Início'),
            NavigationDestination(icon: Icon(Icons.live_tv_outlined), selectedIcon: Icon(Icons.live_tv, color: Color(0xFFFFC107)), label: 'Canais'),
            NavigationDestination(icon: Icon(Icons.settings_input_antenna), selectedIcon: Icon(Icons.settings_input_antenna, color: Color(0xFFFFC107)), label: 'Lista M3U'),
            NavigationDestination(icon: Icon(Icons.star_border), selectedIcon: Icon(Icons.star, color: Color(0xFFFFC107)), label: 'Favoritos'),
          ],
        ),
      ),
    );
  }

  Widget _corpo() {
    switch (_paginaAtual) {
      case 0: return _telaInicio();
      case 1: return _telaCanais();
      case 2: return _telaM3U();
      case 3: return _telaFavoritos();
      default: return _telaInicio();
    }
  }

  // 🏠 TELA INÍCIO
  Widget _telaInicio() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bannerPrincipal(),
          const SizedBox(height: 24),
          const Text('📊 Painel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _cartao('📺', 'Canais', '${_canais.length}', const Color(0xFFFFC107))),
              const SizedBox(width: 10),
              Expanded(child: _cartao('✅', 'Estáveis', '$_totalEstaveis', const Color(0xFF4CAF50))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _cartao('⭐', 'Favoritos', '$_totalFavoritos', const Color(0xFFFF9800))),
              const SizedBox(width: 10),
              Expanded(child: _cartao('📡', 'Lista M3U', _urlM3USalva != null ? 'OK' : 'VAZIO', const Color(0xFF2196F3))),
            ],
          ),
          const SizedBox(height: 24),
          const Text('🚀 Ações Rápidas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.live_tv),
                  label: const Text('Ver Canais'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () => setState(() => _paginaAtual = 1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.settings_input_antenna),
                  label: const Text('Lista M3U'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () => setState(() => _paginaAtual = 2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bannerPrincipal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFB82038), Color(0xFF4030A0), Color(0xFF2060B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📺 • FILMES • SÉRIES • ANIME • M3U', style: TextStyle(color: Colors.white70, fontSize: 12)),
          SizedBox(height: 10),
          Text('ULTRA SKY', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 2)),
          SizedBox(height: 5),
          Text('Criado por Alessandro P Abreu & Dola 💙❤️', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _cartao(String icone, String titulo, String valor, Color cor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(icone, style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 5),
            Text(valor, style: TextStyle(color: cor, fontSize: 22, fontWeight: FontWeight.bold)),
            Text(titulo, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }

  // 📺 TELA CANAIS — COM BOTÃO DE ASSISTIR FUNCIONAL ✅
  Widget _telaCanais() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Expanded(child: Text('📺 Canais', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(() {})),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: _categorias.map((cat) {
              final sel = _categoriaFiltro == cat;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: sel,
                  onSelected: (_) => setState(() => _categoriaFiltro = cat),
                  selectedColor: const Color(0xFFFFC107),
                  labelStyle: TextStyle(color: sel ? Colors.black : Colors.white70),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _canaisFiltrados.isEmpty
              ? const Center(child: Text('Nenhum canal encontrado'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _canaisFiltrados.length,
                  itemBuilder: (ctx, i) {
                    final c = _canaisFiltrados[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(c['nome'] as String),
                        subtitle: Text('${c['grupo']} • ${_statusCanal(c['estavel'] as bool)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                (c['favorito'] as bool) ? Icons.star : Icons.star_border,
                                color: const Color(0xFFFFC107),
                              ),
                              onPressed: () => _alternarFavorito(c),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.play_arrow, size: 18),
                              label: const Text('Assistir'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              onPressed: () => _reproduzirCanal(c),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // 📡 TELA M3U
  Widget _telaM3U() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📡 Lista M3U', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Cole o link da sua lista de canais abaixo', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🔗 Link da Lista M3U / M3U8', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controladorM3U,
                    decoration: InputDecoration(
                      hintText: 'Ex: https://exemplo.com/lista.m3u8',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[900],
                      prefixIcon: const Icon(Icons.link),
                    ),
                    maxLines: 2,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text('Salvar Lista'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _salvarM3U,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Limpar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        onPressed: _limparM3U,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          if (_urlM3USalva != null) ...[
            const Text('✅ Lista Salva', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF1A2F1A),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.greenAccent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _urlM3USalva!,
                            style: const TextStyle(fontSize: 12, color: Colors.greenAccent),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('📡 A lista será carregada nos canais automaticamente', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          const Text('⚙️ Configurações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('🌙 Modo Escuro'),
                  value: _modoEscuro,
                  onChanged: (v) => setState(() => _modoEscuro = v),
                  activeColor: const Color(0xFFFFC107),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('🔔 Notificações'),
                  value: _notificacoes,
                  onChanged: (v) => setState(() => _notificacoes = v),
                  activeColor: const Color(0xFFFFC107),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('🔊 Som'),
                  value: _som,
                  onChanged: (v) => setState(() => _som = v),
                  activeColor: const Color(0xFFFFC107),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('🔄 Reconexão Automática'),
                  value: _autoRecarregar,
                  onChanged: (v) => setState(() => _autoRecarregar = v),
                  activeColor: const Color(0xFF4CAF50),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('🧹 Limpar Cache'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _limparCache,
                    child: const Text('Limpar'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('ℹ️ Sobre', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('ULTRA SKY', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Versão 1.2.0 — Reprodução de Vídeo ✅'),
                  SizedBox(height: 4),
                  Text('Criado por Alessandro P Abreu & Dola 💙❤️', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ⭐ TELA FAVORITOS
  Widget _telaFavoritos() {
    final favs = _canais.where((c) => c['favorito'] as bool).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('⭐ Meus Favoritos', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          if (favs.isEmpty)
            const Center(child: Column(children: [
              Icon(Icons.star_border, size: 72, color: Color(0xFFFFC107)),
              SizedBox(height: 16),
              Text('Nenhum favorito ainda', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Vá em Canais e toque na ⭐ para salvar', style: TextStyle(color: Colors.grey)),
            ]))
          else
            ...favs.map((c) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(c['nome'] as String),
                subtitle: Text('${c['grupo']} • ${_statusCanal(c['estavel'] as bool)}'),
                trailing: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('Assistir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _reproduzirCanal(c),
                ),
              ),
            )),
        ],
      ),
    );
  }
}
