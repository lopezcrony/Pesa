import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreguntaPage extends StatefulWidget {
  const PreguntaPage({super.key});

  @override
  State<PreguntaPage> createState() => _PreguntaPageState();
}

class _PreguntaPageState extends State<PreguntaPage> {
  final TextEditingController _controller = TextEditingController();
  String? _imageUrl;
  String? _videoUrl;
  VideoPlayerController? _videoController;

  void _validateAndUpdateContent() {
    final double? peso = double.tryParse(_controller.text);

    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController?.dispose(); // Libera el controlador anterior solo si está inicializado
    }

    if (peso != null) {
      setState(() {
        if (peso <= 50) {
          _imageUrl = null;
          _videoUrl =
              'https://res.cloudinary.com/dvj1bxv5l/video/upload/v1745007654/esqueleto_yz9oud.mp4';
        } else if (peso <= 62) {
          _imageUrl =
              'https://res.cloudinary.com/dvj1bxv5l/image/upload/v1745005934/like_etkxoi.png';
          _videoUrl = null;
        } else if (peso <= 80) {
          _imageUrl =
              'https://res.cloudinary.com/dvj1bxv5l/image/upload/v1745005934/Juzgadora_dil1wk.png';
          _videoUrl = null;
        } else {
          _imageUrl = null;
          _videoUrl = 'https://res.cloudinary.com/dvj1bxv5l/video/upload/v1745012671/oye_gelda_fkpudk.mp4'; // Reemplaza con un link funcional
        }

        if (_videoUrl != null) {
          _videoController = VideoPlayerController.networkUrl(Uri.parse(_videoUrl!))
            ..setLooping(true) // Configura el video para que se repita en bucle
            ..initialize().then((_) {
              _videoController!.play(); // Reproduce automáticamente
              setState(() {}); // Actualiza la vista
            });
        } else {
          _videoController = null; // Asegura que el controlador se limpie si no hay video
        }
      });
    } else {
      setState(() {
        _imageUrl = null;
        _videoUrl = null;
        _videoController = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un número válido.')),
      );
    }
  }

  void _clearContent() {
    // Limpia todo el contenido
    setState(() {
      _imageUrl = null;
      _videoUrl = null;
      _controller.clear(); // Limpia el campo de texto
      _videoController?.dispose();
      _videoController = null;
    });
  }

  bool _isClearButtonVisible() {
    // Determina si el botón de "Limpiar" debe ser visible
    return _imageUrl != null || _videoUrl != null || _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregunta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingresa tu peso:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tu peso aquí',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _validateAndUpdateContent,
                  child: const Text('Enviar'),
                ),
                const SizedBox(width: 10),
                if (_isClearButtonVisible()) // Muestra el botón solo si hay contenido que limpiar
                  ElevatedButton(
                    onPressed: _clearContent,
                    child: const Text('Limpiar'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (_imageUrl != null)
              Center(
                child: Flexible(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                      maxHeight: 200,
                    ),
                    child: Image.network(_imageUrl!),
                  ),
                ),
              ),
            if (_videoController != null && _videoController!.value.isInitialized)
              Center(
                child: Flexible(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                      maxHeight: 200,
                    ),
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
