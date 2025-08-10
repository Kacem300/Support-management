class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
    };
  }

  OnboardingModel copyWith({
    String? title,
    String? description,
    String? imagePath,
  }) {
    return OnboardingModel(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

// Onboarding data
final List<OnboardingModel> onboardingData = [
  const OnboardingModel(
    title: "Suivez chaque ticket en temps réel",
    description:
        "Accédez à toutes les réclamations clients, filtrez-les facilement et restez à jour sur chaque évolution.",
    imagePath: "assets/images/Object.png",
  ),
  const OnboardingModel(
    title: "Collaborez efficacement",
    description:
        "Travaillez à plusieurs sur un ticket, mentionnez vos collègues et échangez via le chat interne.",
    imagePath: "assets/images/Object2.png",
  ),
  const OnboardingModel(
    title: "Répondez avec empathie",
    description:
        "Ajoutez des commentaires visibles au client et assurez un suivi personnalisé pour chaque demande.",
    imagePath: "assets/images/Object3.png",
  ),
  const OnboardingModel(
    title: "Accédez aux fichiers rapidement",
    description:
        "Consultez, prévisualisez et téléchargez les pièces jointes en toute sécurité.",
    imagePath: "assets/images/Object4.png",
  ),
  const OnboardingModel(
    title: "Automatisez et gagnez du temps",
    description:
        "Grâce à l'automatisation, affectez les tickets, envoyez des réponses automatiques et suivez les priorités.",
    imagePath: "assets/images/Object5.png",
  ),
  const OnboardingModel(
    title: "Prêt à commencer ?",
    description:
        "Gérez vos tickets comme un pro. Centralisé, rapide, collaboratif.",
    imagePath: "assets/images/Object6.png",
  ),
];
