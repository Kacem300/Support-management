import 'package:flutter/material.dart';

class CreateTicketView extends StatefulWidget {
  const CreateTicketView({super.key});

  @override
  State<CreateTicketView> createState() => _CreateTicketViewState();
}

class _CreateTicketViewState extends State<CreateTicketView> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _selectedClients = [
    'Design'
  ]; // Changed to list for multiple selection
  final List<String> _selectedTicketTypes = [
    'Design'
  ]; // Changed to list for multiple selection
  String _selectedDuration = 'Sélectionner une Durée';

  // Text formatting states
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  String _selectedHeading = 'Headline 1';

  final List<String> _availableClients = [
    'Design',
    'Development',
    'Marketing',
    'Sales'
  ];
  final List<String> _availableTicketTypes = [
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle, // Changed to circle shape
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
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
              _buildMultiSelectField(
                selectedItems: _selectedClients,
                availableItems: _availableClients,
                onItemAdded: (item) {
                  setState(() {
                    if (!_selectedClients.contains(item)) {
                      _selectedClients.add(item);
                    }
                  });
                },
                onItemRemoved: (item) {
                  setState(() {
                    _selectedClients.remove(item);
                  });
                },
              ),
              const SizedBox(height: 24),

              // Ticket Type Field
              _buildLabel('Type de ticket*'),
              const SizedBox(height: 8),
              _buildMultiSelectField(
                selectedItems: _selectedTicketTypes,
                availableItems: _availableTicketTypes,
                onItemAdded: (item) {
                  setState(() {
                    if (!_selectedTicketTypes.contains(item)) {
                      _selectedTicketTypes.add(item);
                    }
                  });
                },
                onItemRemoved: (item) {
                  setState(() {
                    _selectedTicketTypes.remove(item);
                  });
                },
              ),
              const SizedBox(height: 24),

              // Duration Field
              _buildLabel('Durée*'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _durations.contains(_selectedDuration)
                    ? _selectedDuration
                    : _durations.first,
                items: _durations,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedDuration = value;
                    });
                  }
                },
                icon: null, // Remove default icon
                inputDecoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/images/calendar2.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
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
                        side: const BorderSide(color: Color(0xFF101828)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'enregistrer et fermer',
                        style: TextStyle(
                          color: Color(0xFF101828),
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
        color: Color(0xFF101828), // Updated color
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
    InputDecoration? inputDecoration,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: inputDecoration ??
            const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget _buildMultiSelectField({
    required List<String> selectedItems,
    required List<String> availableItems,
    required Function(String) onItemAdded,
    required Function(String) onItemRemoved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected items as chips
        if (selectedItems.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedItems.map((item) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => onItemRemoved(item),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 8),

        // Dropdown to add new items
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            key: ValueKey(
                '${selectedItems.length}_${availableItems.length}'), // Add unique key
            value: null, // Always null to show hint
            hint: Text(
              'Sélectionner...',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            dropdownColor: Colors.white,
            items: availableItems
                .where((item) => !selectedItems.contains(item))
                .map((String item) {
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
            onChanged: (String? newValue) {
              if (newValue != null) {
                onItemAdded(newValue);
                // Force rebuild to reset dropdown state
                setState(() {});
              }
            },
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
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
    print('Clients: ${_selectedClients.join(', ')}');
    print('Types: ${_selectedTicketTypes.join(', ')}');
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
