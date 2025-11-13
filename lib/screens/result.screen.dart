import 'dart:math';
import 'package:rollit/models/action.model.dart';
import 'package:rollit/models/category.model.dart';
import 'package:rollit/services/ads.service.dart';
import 'package:rollit/services/data.service.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  List<DiceCategory> _categories = [];
  List<DiceAction> _actions = [];
  String? _categoryLabel;
  String? _categoryIcon;
  String? _actionText;
  late AnimationController _controller;
  late Animation<double> _animation;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadData();

    // animation du lancer
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  Future<void> _loadData() async {
    final categories = await DataService.loadCategories();
    final actions = await DataService.loadActions();

    setState(() {
      _categories = categories;
      _actions = actions;
    });

    _roll();
  }

  void _roll() {
    AdsService.instance.tryShowInterstitial();

    _controller.forward(from: 0);

    final category = _categories[_random.nextInt(_categories.length)];
    final categoryActions = _actions
        .firstWhere((a) => a.category == category.id)
        .actions;

    final action = categoryActions[_random.nextInt(categoryActions.length)];

    setState(() {
      _categoryLabel = category.label;
      _categoryIcon = category.icon;
      _actionText = action;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ready = _categoryLabel != null && _actionText != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      body: SafeArea(
        child: Column(
          children: [
            // bouton retour maison
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.home, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 20),

            // Carte résultat animée
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final scale = 0.8 + (_animation.value * 0.2);
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: ready
                      ? _buildResultCard()
                      : const CircularProgressIndicator(),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // bouton relancer
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C7DF0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _roll,
              child: const Text(
                "Relancer",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_categoryIcon ?? "🎲", style: const TextStyle(fontSize: 50)),
          const SizedBox(height: 12),
          Text(
            _categoryLabel ?? "",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4C7DF0),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _actionText ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
