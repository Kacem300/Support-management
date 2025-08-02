class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

final List<OnboardingItem> onboardingData = [
  OnboardingItem(
    title: "Suivez chaque ticket en temps réel",
    description:
        "Accédez à toutes les réclamations clients, filtrez-les facilement et restez à jour sur chaque évolution.",
    imagePath: "assets/images/Object.png",
  ),
  OnboardingItem(
    title: "Collaborez efficacement",
    description:
        "Travaillez à plusieurs sur un ticket, mentionnez vos collègues et échangez via le chat interne.",
    imagePath: "assets/images/Object2.png",
  ),
  OnboardingItem(
    title: "Répondez avec empathie",
    description:
        "Ajoutez des commentaires visibles au client et assurez un suivi personnalisé pour chaque demande.",
    imagePath: "assets/images/Object3.png",
  ),
  OnboardingItem(
    title: "Accédez aux fichiers rapidement",
    description:
        "Consultez, prévisualisez et téléchargez les pièces jointes en toute sécurité.",
    imagePath: "assets/images/Object4.png",
  ),
  OnboardingItem(
    title: "Automatisez et gagnez du temps",
    description:
        "Grâce à l’automatisation, affectez les tickets, envoyez des réponses automatiques et suivez les priorités.",
    imagePath: "assets/images/Object5.png",
  ),
  OnboardingItem(
    title: "Prêt à commencer ?",
    description:
        "Gérez vos tickets comme un pro. Centralisé, rapide, collaboratif.",
    imagePath: "assets/images/Object6.png",
  ),
  OnboardingItem(
    title: "En commence",
    description: "",
    imagePath: "assets/images/Object7.png",
  ),
];
