import 'package:flutter/material.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedClient = 'Design';
  String _selectedTicketType = 'Design';
  String _selectedDuration = 'Sélectionner une Durée';

  // Text formatting states
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  String _selectedHeading = 'Headline 1';

  final List<String> _clients = ['Design', 'Development', 'Marketing', 'Sales'];
  final List<String> _ticketTypes = [
    'Design',
    'Technical',
    'Support',
    'Bug Report'
  ];
  final List<String> _durations = [
    'Sélectionner une Durée',
    '1 heure',
    '2 heures',
    '4 heures',
    '1 jour',
    '2 jours',
    '1 semaine'
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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

              // Subject Field
              _buildLabel('Sujet Ticket*'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _subjectController,
                hintText: 'Brief description of your issue...',
              ),
              const SizedBox(height: 24),

              // Client Field
              _buildLabel('Client *'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedClient,
                items: _clients,
                onChanged: (value) {
                  setState(() {
                    _selectedClient = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Ticket Type Field
              _buildLabel('Type de ticket*'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedTicketType,
                items: _ticketTypes,
                onChanged: (value) {
                  setState(() {
                    _selectedTicketType = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Duration Field
              _buildLabel('Demande de la réponse'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedDuration,
                items: _durations,
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value!;
                  });
                },
                icon: Icons.access_time,
              ),
              const SizedBox(height: 24),

              // Description Field
              _buildLabel('Description*'),
              const SizedBox(height: 8),
              _buildDescriptionField(),
              const SizedBox(height: 40),

              // Action Buttons
              Column(
                children: [
                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        _handleContinue();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Save and Close Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        _handleSaveAndClose();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'enregistrer et fermer',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.grey[600], size: 20)
              : null,
        ),
        dropdownColor: Colors.white,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                // Heading Dropdown
                DropdownButton<String>(
                  value: _selectedHeading,
                  underline: Container(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  items: ['Headline 1', 'Headline 2', 'Headline 3', 'Normal']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedHeading = newValue!;
                    });
                    _applyHeadingFormat();
                  },
                ),
                const SizedBox(width: 16),

                // Bold Button
                _buildToolbarButton(
                  Icons.format_bold,
                  isActive: _isBold,
                  onTap: () {
                    setState(() {
                      _isBold = !_isBold;
                    });
                    _insertTextFormat('**', '**'); // Markdown style
                  },
                ),
                const SizedBox(width: 8),

                // Italic Button
                _buildToolbarButton(
                  Icons.format_italic,
                  isActive: _isItalic,
                  onTap: () {
                    setState(() {
                      _isItalic = !_isItalic;
                    });
                    _insertTextFormat('*', '*'); // Markdown style
                  },
                ),
                const SizedBox(width: 8),

                // Underline Button
                _buildToolbarButton(
                  Icons.format_underlined,
                  isActive: _isUnderline,
                  onTap: () {
                    setState(() {
                      _isUnderline = !_isUnderline;
                    });
                    _insertTextFormat('<u>', '</u>'); // HTML style
                  },
                ),
                const SizedBox(width: 8),

                // Bullet List Button
                _buildToolbarButton(
                  Icons.format_list_bulleted,
                  onTap: () {
                    _insertBulletPoint();
                  },
                ),
                const SizedBox(width: 8),

                // Numbered List Button
                _buildToolbarButton(
                  Icons.format_list_numbered,
                  onTap: () {
                    _insertNumberedList();
                  },
                ),
              ],
            ),
          ),

          // Text Area
          Expanded(
            child: TextFormField(
              controller: _descriptionController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(
                fontSize: 14,
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                decoration: _isUnderline
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
              decoration: const InputDecoration(
                hintText:
                    'Changement dans la fiche produit au niveau du fonctionnalité, j\'ai besoin du modifier le statut du commande',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon,
      {bool isActive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(color: isActive ? Colors.blue : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
          color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 14,
          color: isActive ? Colors.blue : Colors.grey[600],
        ),
      ),
    );
  }

  // Text formatting helper methods
  void _insertTextFormat(String startTag, String endTag) {
    final text = _descriptionController.text;
    final selection = _descriptionController.selection;

    if (selection.isValid) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$startTag$selectedText$endTag',
      );

      _descriptionController.text = newText;
      _descriptionController.selection = TextSelection.collapsed(
        offset: selection.start +
            startTag.length +
            selectedText.length +
            endTag.length,
      );
    } else {
      // If no text is selected, insert at cursor position
      final cursorPosition = _descriptionController.selection.baseOffset;
      final newText = text.replaceRange(
        cursorPosition,
        cursorPosition,
        '$startTag$endTag',
      );

      _descriptionController.text = newText;
      _descriptionController.selection = TextSelection.collapsed(
        offset: cursorPosition + startTag.length,
      );
    }
  }

  void _applyHeadingFormat() {
    final text = _descriptionController.text;
    final selection = _descriptionController.selection;

    String headingPrefix = '';
    switch (_selectedHeading) {
      case 'Headline 1':
        headingPrefix = '# ';
        break;
      case 'Headline 2':
        headingPrefix = '## ';
        break;
      case 'Headline 3':
        headingPrefix = '### ';
        break;
      default:
        headingPrefix = '';
    }

    if (selection.isValid) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$headingPrefix$selectedText',
      );

      _descriptionController.text = newText;
      _descriptionController.selection = TextSelection.collapsed(
        offset: selection.start + headingPrefix.length + selectedText.length,
      );
    }
  }

  void _insertBulletPoint() {
    final text = _descriptionController.text;
    final cursorPosition = _descriptionController.selection.baseOffset;

    // Find the beginning of the current line
    int lineStart = cursorPosition;
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }

    String bulletText = '';
    if (lineStart == cursorPosition) {
      // Cursor is at the beginning of a line
      bulletText = '• ';
    } else {
      // Cursor is in the middle of a line, create new line with bullet
      bulletText = '\n• ';
    }

    final newText =
        text.replaceRange(cursorPosition, cursorPosition, bulletText);
    _descriptionController.text = newText;
    _descriptionController.selection = TextSelection.collapsed(
      offset: cursorPosition + bulletText.length,
    );
  }

  void _insertNumberedList() {
    final text = _descriptionController.text;
    final cursorPosition = _descriptionController.selection.baseOffset;

    // Count existing numbered items to get the next number
    int itemNumber = 1;
    final lines = text.split('\n');
    for (String line in lines) {
      if (RegExp(r'^\d+\.\s').hasMatch(line.trim())) {
        itemNumber++;
      }
    }

    String numberedText = '';
    // Find the beginning of the current line
    int lineStart = cursorPosition;
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }

    if (lineStart == cursorPosition) {
      // Cursor is at the beginning of a line
      numberedText = '$itemNumber. ';
    } else {
      // Cursor is in the middle of a line, create new line with number
      numberedText = '\n$itemNumber. ';
    }

    final newText =
        text.replaceRange(cursorPosition, cursorPosition, numberedText);
    _descriptionController.text = newText;
    _descriptionController.selection = TextSelection.collapsed(
      offset: cursorPosition + numberedText.length,
    );
  }

  void _handleContinue() {
    // Validate form
    if (_subjectController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Process the ticket creation
    print('Creating ticket...');
    print('Subject: ${_subjectController.text}');
    print('Client: $_selectedClient');
    print('Type: $_selectedTicketType');
    print('Duration: $_selectedDuration');
    print('Description: ${_descriptionController.text}');

    // Navigate to continue page
    Navigator.pushNamed(context, '/main/tickets/create/continue');
  }

  void _handleSaveAndClose() {
    // Save as draft logic
    print('Saving as draft...');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Brouillon sauvegardé'),
        backgroundColor: Colors.blue,
      ),
    );

    Navigator.pop(context);
  }
}
