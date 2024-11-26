import 'package:flutter/material.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({required this.text, required this.isUser}) 
      : timestamp = DateTime.now();
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];

  final Map<String, List<String>> _doctorResponses = {
    'hola': [
      'Hola, ¿cómo puedo ayudarte hoy?',
      'Buenos días, soy el Dr. Antonio. ¿Tienes alguna consulta?'
    ],
    'síntomas': [
      'Por favor, describe tus síntomas con más detalle.',
      '¿Cuánto tiempo llevas con esos síntomas?'
    ],
    'cita': [
      'Claro, puedo ayudarte a agendar una cita. ¿Qué día te gustaría?',
      '¿Prefieres una cita virtual o presencial?'
    ],
    'dolor': [
      'El dolor es un indicador importante. ¿Puedes describir dónde lo sientes?',
      'Por favor, evalúa tu dolor en una escala del 1 al 10.'
    ],
    'default': [
      'Entiendo tu consulta. Te sugiero programar una cita para más detalles.',
      'Mis respuestas son orientativas. Una consulta presencial sería mejor.'
    ]
  };

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    String userMessage = _messageController.text.trim();
    setState(() {
      _messages.add(Message(text: userMessage, isUser: true));
    });

    _messageController.clear();
    _simulateDoctorResponse(userMessage.toLowerCase());
  }

  void _simulateDoctorResponse(String userMessage) {
    Future.delayed(Duration(milliseconds: 500), () {
      String response = _generateDoctorResponse(userMessage);
      setState(() {
        _messages.add(Message(text: response, isUser: false));
      });
    });
  }

  String _generateDoctorResponse(String userMessage) {
    for (var key in _doctorResponses.keys) {
      if (userMessage.contains(key)) {
        return _doctorResponses[key]![
            DateTime.now().millisecond % _doctorResponses[key]!.length];
      }
    }
    return _doctorResponses['default']![
        DateTime.now().millisecond % _doctorResponses['default']!.length];
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.blue[900] : Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat con el Dr. Antonio', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[600],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              maxLines: null,
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
