import 'package:flutter/material.dart';
import 'dart:io';

class CreateTicketContinuePage extends StatefulWidget {
  const CreateTicketContinuePage({super.key});

  @override
  State<CreateTicketContinuePage> createState() =>
      _CreateTicketContinuePageState();
}

class _CreateTicketContinuePageState extends State<CreateTicketContinuePage> {
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
              const SizedBox(height: 16),

              // Upload Area
              GestureDetector(
                onTap: () => _pickImageFromGallery(),
                child: _buildUploadArea(),
              ),
              const SizedBox(height: 20),

              // Upload buttons
              Row(
                children: [
                  Expanded(
                    child: _buildUploadButton(
                      icon: Icons.file_upload_outlined,
                      text: 'Upload Image',
                      onTap: () => _pickImageFromGallery(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildUploadButton(
                      icon: Icons.photo_library_outlined,
                      text: 'Gallery',
                      onTap: () => _pickImageFromGallery(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

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

  Widget _buildUploadArea() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[300]!,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4ECDC4),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.file_upload_outlined,
              color: Colors.white,
              size: 30,
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
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              children: const [
                TextSpan(text: 'File Format '),
                TextSpan(
                  text: 'jpeg, png ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: 'Recommended Size '),
                TextSpan(
                  text: '600x600\n(1:1)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(Map<String, dynamic> file, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // File icon or image preview
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: file['path'] != null &&
                    file['type'] == 'image' &&
                    file['isMock'] != true
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(file['path']),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          _getFileIcon(file['type']),
                          color: Colors.white,
                          size: 20,
                        );
                      },
                    ),
                  )
                : Icon(
                    _getFileIcon(file['type']),
                    color: Colors.white,
                    size: 20,
                  ),
          ),
          const SizedBox(width: 12),

          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file['name'] ?? 'image.jpg',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  file['size'] ?? '2.1 MB',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            children: [
              GestureDetector(
                onTap: () => _previewImage(file),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.visibility,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _removeFile(index),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      // Mock implementation - add a sample file
      await _addMockFile();
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la sélection de l\'image: $e');
    }
  }

  Future<void> _addMockFile() async {
    try {
      // Create a mock file entry
      setState(() {
        _attachedFiles.add({
          'name': 'sample_image_${_attachedFiles.length + 1}.jpg',
          'size':
              '${(2.0 + _attachedFiles.length * 0.5).toStringAsFixed(1)} MB',
          'type': 'image',
          'path': null, // No real file path for mock
          'file': null, // No real file for mock
          'isMock': true,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image de démonstration ajoutée!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'ajout du fichier: $e');
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

  void _previewImage(Map<String, dynamic> file) {
    if (file['isMock'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Aperçu non disponible pour les fichiers de démonstration'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (file['path'] != null && file['type'] == 'image') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: InteractiveViewer(
                  child: Image.file(
                    File(file['path']),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Text(
                            'Impossible d\'afficher l\'image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Aperçu non disponible pour ce type de fichier: ${file['name']}'),
          backgroundColor: Colors.orange,
        ),
      );
    }
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
