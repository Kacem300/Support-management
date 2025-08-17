import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateTicketContinueView extends StatefulWidget {
  const CreateTicketContinueView({super.key});

  @override
  State<CreateTicketContinueView> createState() =>
      _CreateTicketContinueViewState();
}

class _CreateTicketContinueViewState extends State<CreateTicketContinueView> {
  final List<Map<String, dynamic>> _attachedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Création ticket',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle
              Text(
                'Expliquez votre problème, nous le résolvons.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),

              // Attachments Section
              _buildLabel('Attachements'),
              const SizedBox(height: 12),

              // Upload Area (Figma style)
              GestureDetector(
                onTap: () => _pickImageFromGallery(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Icon(
                          Icons.cloud_upload_outlined,
                          color: Color(0xFF1ABC9C),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Upload a cover image for your product.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                          children: const [
                            TextSpan(text: 'File Format '),
                            TextSpan(
                              text: 'jpeg, png ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(text: 'Recommened Size '),
                            TextSpan(
                              text: '600x600 (1:1)',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Upload buttons (Figma style)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.file_upload_outlined,
                          color: Color(0xFF232B55)),
                      label: const Text(
                        'Upload Image',
                        style: TextStyle(
                          color: Color(0xFF232B55),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: () => _pickImageFromGallery(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt_outlined,
                          color: Color(0xFF232B55)),
                      label: const Text(
                        'Camera',
                        style: TextStyle(
                          color: Color(0xFF232B55),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: _pickImageFromCamera,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Attached files list
              if (_attachedFiles.isNotEmpty) ...[
                const SizedBox(height: 20),
                ..._attachedFiles.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> file = entry.value;
                  return _buildFileItem(file, index);
                }),
              ],

              const SizedBox(height: 300), // Spacer to push button to bottom

              // Create Ticket Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    _handleCreateTicket();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Créer votre ticket',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildFileItem(Map<String, dynamic> file, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // File icon or image preview (rounded)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: file['path'] != null &&
                        file['type'] == 'image' &&
                        file['isMock'] != true
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(file['path']),
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              _getFileIcon(file['type']),
                              color: Colors.white,
                              size: 24,
                            );
                          },
                        ),
                      )
                    : Icon(
                        _getFileIcon(file['type']),
                        color: Colors.white,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 14),

              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file['name'] ?? 'image.jpg',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF232B55),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      file['size'] ?? '2.1 MB',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons (pause and delete)
              Row(
                children: [
                  // Pause button (disabled for mock)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFFF5F6FA),
                      child: IconButton(
                        icon: const Icon(Icons.pause,
                            color: Color(0xFFB0B3C7), size: 18),
                        onPressed: null,
                        padding: EdgeInsets.zero,
                        splashRadius: 18,
                      ),
                    ),
                  ),
                  // Delete button
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFFFF0F0),
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Color(0xFFFF4D4F), size: 18),
                      onPressed: () => _removeFile(index),
                      padding: EdgeInsets.zero,
                      splashRadius: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Progress bar (Figma style, always at 0 for mock)
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.0, // Always 0 for mock
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFF4ECDC4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          _attachedFiles.add({
            'name': pickedFile.name,
            'size':
                '${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} MB',
            'type': 'image',
            'path': pickedFile.path,
            'file': file,
            'isMock': false,
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image ajoutée depuis la galerie!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la sélection de l\'image: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          _attachedFiles.add({
            'name': pickedFile.name,
            'size':
                '${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} MB',
            'type': 'image',
            'path': pickedFile.path,
            'file': file,
            'isMock': false,
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image ajoutée depuis la caméra!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la capture de l\'image: $e');
    }
  }

  IconData _getFileIcon(String? fileType) {
    switch (fileType) {
      case 'image':
        return Icons.image_outlined;
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'document':
        return Icons.description_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _removeFile(int index) {
    setState(() {
      _attachedFiles.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fichier supprimé'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleCreateTicket() {
    // Handle ticket creation with attachments
    print('Creating ticket with ${_attachedFiles.length} attachments');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ticket créé avec succès!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to tickets page
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main/tickets',
      (route) => false,
    );
  }
}
