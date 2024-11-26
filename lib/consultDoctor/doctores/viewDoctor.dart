import 'package:consult_doctor/consultDoctor/doctores/medicalChatApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:consult_doctor/data/dto/dto.dart';
import 'package:consult_doctor/data/service/services.dart';
import 'package:share/share.dart';

class ViewDoctor extends StatefulWidget {
  final int idDoctor;
  const ViewDoctor({super.key, required this.idDoctor});

  @override
  State<ViewDoctor> createState() => _ViewDoctorState();
}

class _ViewDoctorState extends State<ViewDoctor> {
  late Future<DoctorDtoOther> _dataDoctor;
  String nombreDoctor = "";
  final TextEditingController _commentController = TextEditingController();
  final List<DoctorReview> _reviews = [
    DoctorReview(
      name: "María Gonzalez",
      rating: 4.5,
      comment: "Excelente doctor, muy profesional y atento.",
      date: "2 días ago",
    ),
    DoctorReview(
      name: "Juan Pérez",
      rating: 5.0,
      comment: "Muy recomendado, me ayudó mucho con mi tratamiento.",
      date: "1 semana ago",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _dataDoctor = getOneDoctorData(widget.idDoctor);
  }

  void _addReview() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _reviews.insert(0, DoctorReview(
          name: "Paciente Anónimo",
          rating: 4.0,
          comment: _commentController.text,
          date: "Hace un momento",
        ));
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        title: const Text('Perfil del Doctor', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              const String textToShare = 'Conoce al doctor en nuestra app de Consult Doctor';
              Share.share(textToShare);
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<DoctorDtoOther>(
        future: _dataDoctor,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildDoctorHeader(snapshot.data!),
                ),
                SliverToBoxAdapter(
                  child: _buildDoctorDetails(snapshot.data!),
                ),
                SliverToBoxAdapter(
                  child: _buildReviewSection(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildReviewCard(_reviews[index]),
                    childCount: _reviews.length,
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildDoctorHeader(DoctorDtoOther doctor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Hero(
            tag: 'doctor-image-${doctor.id}',
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue.shade300, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(doctor.photo),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            doctor.nombre,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          Text(
            doctor.especialidad,
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(height: 8),
          RatingBar.builder(
            initialRating: 4.5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            unratedColor: Colors.grey.shade300,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber.shade500,
            ),
            onRatingUpdate: (rating) {},
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorDetails(DoctorDtoOther doctor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del Doctor',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            icon: Icons.schedule,
            title: 'Horario de Trabajo',
            subtitle: doctor.horario_trabajo,
          ),
          const SizedBox(height: 8),
          _buildDetailCard(
            icon: Icons.phone,
            title: 'Teléfono',
            subtitle: doctor.telefono,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade600, size: 30),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.blue.shade700),
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comentarios',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Escribe tu comentario...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Icon(Icons.send, color: Colors.white,),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(DoctorReview review) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                Text(
                  review.date,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: review.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20,
              ignoreGestures: true,
              unratedColor: Colors.grey.shade300,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber.shade500,
              ),
              onRatingUpdate: (rating) {},
            ),
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: TextStyle(color: Colors.blue.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showCallDialog(),
              icon: const Icon(Icons.phone, color: Colors.white),
              label: const Text('Llamar', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(doctor: "doctor.nombre ",),
                  ),
                )
              },
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: const Text('Sacar Cita', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Llamar'),
          content: const Text('¿Desea llamar al doctor?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Llamada aceptada. Se le notificará cuando el doctor esté disponible.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

class DoctorReview {
  final String name;
  final double rating;
  final String comment;
  final String date;

  DoctorReview({
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
  });
}