import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController sectionController =
      TextEditingController();
  final TextEditingController courseController =
      TextEditingController();


  final TextEditingController subjectController =
      TextEditingController();
  final TextEditingController timeController =
      TextEditingController();

  int currentStep = 0;

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;


  Future<void> saveData() async {
    try {
      // One subject only
      List<Map<String, dynamic>> subjects = [
        {
          'subject': subjectController.text.trim(),
          'time': timeController.text.trim(),
        }
      ];

      // Save everything to Firestore
      await firestore.collection('mybiodata-app').add({
        'name': nameController.text.trim(),
        'section': sectionController.text.trim(),
        'course': courseController.text.trim(),
        'subjects': subjects,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enrollment saved successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      clearForm();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error saving data: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void clearForm() {
    nameController.clear();
    sectionController.clear();
    courseController.clear();
    subjectController.clear();
    timeController.clear();

    setState(() {
      currentStep = 0;
    });
  }


  @override
  void dispose() {
    nameController.dispose();
    sectionController.dispose();
    courseController.dispose();
    subjectController.dispose();
    timeController.dispose();

    super.dispose();
  }

  Widget customTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }


  Widget registrationPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Registration',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          customTextField(
            controller: nameController,
            label: 'Name',
            hint: 'Enter your name',
          ),

          const SizedBox(height: 16),

          customTextField(
            controller: sectionController,
            label: 'Section',
            hint: 'Example: IT-305',
          ),

          const SizedBox(height: 16),

          customTextField(
            controller: courseController,
            label: 'Course',
            hint: 'Example: BSIT',
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    sectionController.text.isEmpty ||
                    courseController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please complete the fields.',
                      ),
                    ),
                  );

                  return;
                }

                setState(() {
                  currentStep = 1;
                });
              },
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // STEP 2 - ONE SUBJECT
  // ---------------------------------------------------------

  Widget subjectEnrollmentPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subject Enrollment',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Card(
            margin: const EdgeInsets.only(bottom: 15),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subject',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  customTextField(
                    controller: subjectController,
                    label: 'Subject',
                    hint: 'Example: BMC',
                  ),

                  const SizedBox(height: 12),

                  customTextField(
                    controller: timeController,
                    label: 'Time',
                    hint: 'Example: 7:30 - 10:30',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentStep = 0;
                    });
                  },
                  child: const Text('Back'),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (subjectController.text.trim().isEmpty ||
                        timeController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please complete the subject and time.',
                          ),
                        ),
                      );

                      return;
                    }

                    setState(() {
                      currentStep = 2;
                    });
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget verificationPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subject Verification',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          verificationRow(
            'Name',
            nameController.text,
          ),

          verificationRow(
            'Section',
            sectionController.text,
          ),

          verificationRow(
            'Course',
            courseController.text,
          ),

          const SizedBox(height: 20),

          const Text(
            'Subject',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subject',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subjectController.text,
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Time: ${timeController.text}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentStep = 1;
                    });
                  },
                  child: const Text('Back'),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: saveData,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget verificationRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Enrollment',
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: currentStep == 0
            ? registrationPage()
            : currentStep == 1
                ? subjectEnrollmentPage()
                : verificationPage(),
      ),
    );
  }
}