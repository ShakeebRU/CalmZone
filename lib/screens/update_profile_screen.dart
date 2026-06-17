import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/login_controller.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateProfileScreen({super.key, required this.data});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _name;
  late TextEditingController _age;
  late TextEditingController _weight;
  late TextEditingController _height;

  String? _gender;

  final List<String> genders = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();

    _name = TextEditingController(text: widget.data['name']);
    _age = TextEditingController(text: widget.data['age'].toString());
    _weight = TextEditingController(text: widget.data['weight'].toString());
    _height = TextEditingController(text: widget.data['height'].toString());
    _gender = widget.data['gender'];
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Provider.of<LoginController>(context, listen: false);

    final success = await controller.updateUserProfile(
      name: _name.text.trim(),
      age: int.parse(_age.text.trim()),
      gender: _gender!,
      weight: double.parse(_weight.text.trim()),
      height: double.parse(_height.text.trim()),
    );

    if (success && mounted) {
      Navigator.pop(context); // back to profile screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.errorMessage ?? "Update failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
        backgroundColor: Constants.getBackgroundColor(isDark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field("Name", _name),
              _field("Age", _age, isNumber: true),
              _field("Weight (kg)", _weight, isNumber: true),
              _field("Height (cm)", _height, isNumber: true),

              const SizedBox(height: 15),

              Text(
                "Gender",
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              ...genders.map((g) {
                return RadioListTile(
                  value: g,
                  groupValue: _gender,
                  onChanged: (val) {
                    setState(() => _gender = val.toString());
                  },
                  title: Text(g),
                );
              }),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _update,
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.outfit(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
