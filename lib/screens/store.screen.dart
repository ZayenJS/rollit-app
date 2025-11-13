import 'package:rollit/services/purchase.service.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      appBar: AppBar(
        title: const Text(
          "Boutique",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionTitle("Packs Premium"),

          const SizedBox(height: 16),

          _storeCard(
            title: "WTF+",
            subtitle: "Débloque 20 actions WTF supplémentaires",
            price: "1,49€",
            color: const Color(0xFF9A5DF5),
            icon: "🤪",
            onTap: () {
              PurchaseService.instance.buyWtfPlus();
            },
          ),

          const SizedBox(height: 22),

          _storeCard(
            title: "Défis Extrêmes",
            subtitle: "Bientôt disponible",
            price: "Prochainement",
            color: const Color(0xFFFF8F5A),
            icon: "🔥",
            locked: true,
            onTap: () {},
          ),

          const SizedBox(height: 22),

          _sectionTitle("Autres options"),

          const SizedBox(height: 16),

          _storeCard(
            title: "Supprimer les pubs",
            subtitle: "Plus aucune interruption",
            price: "2,99€",
            color: const Color(0xFF55E6C1),
            icon: "🚫",
            onTap: () {
              PurchaseService.instance.removeAds();
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF4C7DF0),
      ),
    );
  }

  Widget _storeCard({
    required String title,
    required String subtitle,
    required String price,
    required String icon,
    required Color color,
    bool locked = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: locked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icone du pack
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 32)),
              ),
            ),

            const SizedBox(width: 18),

            // Texte + sous-titre
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locked ? "$title (Bientôt)" : title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: locked
                          ? Colors.grey.shade500
                          : Colors.grey.shade900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Prix
            Text(
              price,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: locked ? Colors.grey.shade400 : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
