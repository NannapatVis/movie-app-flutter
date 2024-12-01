import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart'; // นำเข้ารูปแบบของ Movie

class MovieAddScreen extends StatefulWidget {
  final Movie? movie; // สำหรับการแก้ไขข้อมูล

  const MovieAddScreen({super.key, this.movie});

  @override
  _MovieAddScreenState createState() => _MovieAddScreenState();
}

class _MovieAddScreenState extends State<MovieAddScreen> {
  final _nameController = TextEditingController();
  final _ratingController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController =
      TextEditingController(); // เพิ่มตัวแปรสำหรับ URL รูปภาพ
  DateTime _watchedDate = DateTime.now(); // เก็บวันที่ดู

  String? _nameError; // สำหรับข้อความแจ้งเตือนชื่อหนัง
  String? _ratingError; // สำหรับข้อความแจ้งเตือนคะแนนรีวิว

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _nameController.text = widget.movie!.name;
      _ratingController.text = widget.movie!.rating.toString();
      _descriptionController.text =
          widget.movie!.description ?? ''; // กรณีไม่มีคำอธิบาย
      _imageUrlController.text = widget.movie!.imageUrl;
      _watchedDate = widget.movie!.watchedDate; // กำหนดวันที่ดูจากหนังที่มีอยู่
    }
  }

  // ฟังก์ชันในการเลือกวันที่
  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _watchedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _watchedDate) {
      setState(() {
        _watchedDate = pickedDate;
      });
    }
  }

  void saveMovie() {
    setState(() {
      _nameError = null; // รีเซ็ตข้อผิดพลาดชื่อหนัง
      _ratingError = null; // รีเซ็ตข้อผิดพลาดคะแนนรีวิว
    });

    // ตรวจสอบข้อมูลที่กรอก
    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Please enter the movie name.';
      });
      return;
    }

    double rating = 0;
    try {
      rating = double.parse(_ratingController.text);
    } catch (e) {
      setState(() {
        _ratingError = 'Please enter a valid rating.';
      });
      return;
    }

    if (rating > 10) {
      setState(() {
        _ratingError = 'Rating must be between 0 and 10.';
      });
      return;
    }

    // Logic สำหรับการบันทึกข้อมูลหนัง
    final newMovie = Movie(
      imageUrl: _imageUrlController.text, // ใช้ URL ที่กรอก
      name: _nameController.text,
      rating: rating, // คะแนนรีวิว
      watchedDate: _watchedDate, // วันที่ดู
      description: _descriptionController.text,
    );
    Navigator.pop(context, newMovie); // ส่งกลับข้อมูลหนัง
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.movie == null
            ? const Text('Add Movie')
            : const Text('Edit Movie'),
      ),
      body: SingleChildScrollView(
        // เพิ่ม SingleChildScrollView เพื่อให้สามารถเลื่อนหน้าจอได้
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ชื่อหนัง
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Movie Name',
                errorText: _nameError, // แสดงข้อผิดพลาดของชื่อหนัง
              ),
            ),
            const SizedBox(height: 10),
            // คะแนนรีวิว
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(
                labelText: 'Rating',
                errorText: _ratingError, // แสดงข้อผิดพลาดของคะแนนรีวิว
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // คำอธิบาย
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            // URL รูปภาพ
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 20),
            // วันที่ดู
            Row(
              children: [
                Text(
                  'Watched Date: ${_watchedDate.toLocal().toString().split(' ')[0]}', // แสดงวันที่ในรูปแบบ 'YYYY-MM-DD'
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ปุ่มบันทึก
            ElevatedButton(
              onPressed: saveMovie,
              child: Text(widget.movie == null ? 'Add Movie' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
