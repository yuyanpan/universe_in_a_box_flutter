import 'package:flutter/material.dart';

void main() {
  runApp(UniverseInABoxApp());
}

class UniverseInABoxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '盒子里的宇宙',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<_BoxItem> items = [
    _BoxItem(name: '万花筒', icon: Icons.blur_circular, route: KaleidoscopeScreen()),
    _BoxItem(name: '日历', icon: Icons.calendar_month, route: CalendarScreen()),
    _BoxItem(name: '唱歌的勺子', icon: Icons.music_note, route: SingingSpoonScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('盒子里的宇宙')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: items.map((item) => _buildBoxItem(context, item)).toList(),
        ),
      ),
    );
  }

  Widget _buildBoxItem(BuildContext context, _BoxItem item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => item.route),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 48, color: Colors.indigo),
            SizedBox(height: 12),
            Text(item.name, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _BoxItem {
  final String name;
  final IconData icon;
  final Widget route;

  _BoxItem({required this.name, required this.icon, required this.route});
}

class KaleidoscopeScreen extends StatefulWidget {
  @override
  _KaleidoscopeScreenState createState() => _KaleidoscopeScreenState();
}

class _KaleidoscopeScreenState extends State<KaleidoscopeScreen> {
  List<String> pieces = [
    'assets/images/piece1.png',
    'assets/images/piece2.png',
    'assets/images/piece3.png',
    'assets/images/piece4.png'
  ];

  List<String> target = [
    'assets/images/piece1.png',
    'assets/images/piece2.png',
    'assets/images/piece3.png',
    'assets/images/piece4.png'
  ];

  @override
  void initState() {
    super.initState();
    pieces.shuffle();
  }

  void swap(int i, int j) {
    setState(() {
      final temp = pieces[i];
      pieces[i] = pieces[j];
      pieces[j] = temp;
    });
  }

  bool isCompleted() {
    for (int i = 0; i < pieces.length; i++) {
      if (pieces[i] != target[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('万花筒拼图')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('拖动拼图到正确位置', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(pieces.length, (index) {
              return Draggable<String>(
                data: pieces[index],
                feedback: PuzzlePiece(imagePath: pieces[index], dragging: true),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: PuzzlePiece(imagePath: pieces[index]),
                ),
                child: DragTarget<String>(
                  onAccept: (incoming) {
                    final fromIndex = pieces.indexOf(incoming);
                    swap(fromIndex, index);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return PuzzlePiece(imagePath: pieces[index]);
                  },
                ),
              );
            }),
          ),
          SizedBox(height: 30),
          if (isCompleted())
            Text('拼图完成！', style: TextStyle(fontSize: 20, color: Colors.green)),
        ],
      ),
    );
  }
}

class PuzzlePiece extends StatelessWidget {
  final String imagePath;
  final bool dragging;

  const PuzzlePiece({required this.imagePath, this.dragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: dragging ? Colors.indigo.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo, width: 2),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('撕不完的日历')),
      body: Center(child: Text('这里是日历玩法（滑动翻页）')),
    );
  }
}

class SingingSpoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('会唱歌的勺子')),
      body: Center(child: Text('这里是节奏点击小游戏')),
    );
  }
}
