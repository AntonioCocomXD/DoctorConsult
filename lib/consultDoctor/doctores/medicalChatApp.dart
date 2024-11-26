import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  final doctor;

  const ChatScreen({super.key, this.doctor,});
  

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];

  // Mapa de respuestas pregrabadas del doctor
  final Map<String, List<String>> _doctorResponses = {
    'hola': [
      'Hola, ¿en qué puedo ayudarte hoy?',
      'Buenos días, soy el Dr. Ramírez. ¿Cómo te encuentras?'
    ],
    'síntomas': [
      'Es importante describir detalladamente tus síntomas para poder ayudarte mejor.',
      'Necesito más detalles sobre lo que estás experimentando.'
    ],
    'dolor': [
      'El dolor puede tener múltiples causas. Necesitaré más información.',
      'La intensidad y localización del dolor son importantes para un diagnóstico.'
    ],
    'default': [
      'Entiendo tu consulta. Te recomiendo agendar una cita presencial.',
      'Mis respuestas son orientativas. Una consulta personalizada sería lo ideal.'
    ]
  };

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _messages.add(Message(
        text: _messageController.text,
        isUser: true,
      ));
    });

    String userMessage = _messageController.text.toLowerCase();
    String doctorResponse = _generateDoctorResponse(userMessage);

    _messageController.clear();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _messages.add(Message(
          text: doctorResponse,
          isUser: false,
        ));
      });
    });
  }

  String _generateDoctorResponse(String userMessage) {
    for (var key in _doctorResponses.keys) {
      if (userMessage.contains(key)) {
        return _doctorResponses[key]![
          DateTime.now().millisecond % _doctorResponses[key]!.length
        ];
      }
    }
    return _doctorResponses['default']![
      DateTime.now().millisecond % _doctorResponses['default']!.length
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Dr. Antonio Cocom', style: TextStyle(color: Colors.white)),
          ],
        ),
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
                return Align(
                  alignment: message.isUser 
                    ? Alignment.centerRight 
                    : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message.isUser 
                        ? Colors.blue[100] 
                        : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.blue[900] : Colors.black,
                      ),
                    ),
                  ),
                );
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