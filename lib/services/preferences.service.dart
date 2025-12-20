import 'package:rollit/models/dice_category.model.dart';
import 'package:rollit/services/purchase.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences _prefs;

  // paywall keys
  static const String _removeAdsPaywallShowedKey = 'remove_ads_paywall_showed';
  static const String _paywallShowedKey = 'paywall_showed';
  // review keys
  static const _reviewAskedKey = 'review_asked';
  static const _reviewLastAskKey = 'review_last_ask';
  static const _reviewSessionCountKey = 'review_session_count';
  static const _reviewRollCountKey = 'review_roll_count';

  /// Initialisation à faire au démarrage de l’app
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setSound(bool value) async {
    await _prefs.setBool('sound', value);
  }

  static bool getSound() {
    return _prefs.getBool('sound') ?? true;
  }

  static Future<void> setVibration(bool value) async {
    await _prefs.setBool('vibration', value);
  }

  static bool getVibration() {
    return _prefs.getBool('vibration') ?? true;
  }

  static bool getWtfPlusOwned() {
    return _prefs.getBool(PurchaseService.entWtfPlus) ?? false;
  }

  static Future<void> setWtfPlusOwned(bool value) async {
    await _prefs.setBool(PurchaseService.entWtfPlus, value);
  }

  static bool getChallengeExtremeOwned() {
    return _prefs.getBool(PurchaseService.entChallengeExtreme) ?? false;
  }

  static Future<void> setChallengeExtremeOwned(bool value) async {
    await _prefs.setBool(PurchaseService.entChallengeExtreme, value);
  }

  static bool getAdsRemoved() {
    return _prefs.getBool(PurchaseService.entRemoveAds) ?? false;
  }

  static Future<void> setAdsRemoved(bool value) async {
    await _prefs.setBool(PurchaseService.entRemoveAds, value);
  }

  static bool imitationEnabled() {
    return _prefs.getBool('imitation_enabled') ?? true;
  }

  static Future<void> setImitationEnabled(bool value) async {
    await _prefs.setBool('imitation_enabled', value);
  }

  static bool challengeEnabled() {
    return _prefs.getBool('challenge_enabled') ?? true;
  }

  static Future<void> setChallengeEnabled(bool value) async {
    await _prefs.setBool('challenge_enabled', value);
  }

  static bool funEnabled() {
    return _prefs.getBool('fun_enabled') ?? true;
  }

  static Future<void> setFunEnabled(bool value) async {
    await _prefs.setBool('fun_enabled', value);
  }

  static bool wtfEnabled() {
    return _prefs.getBool('wtf_enabled') ?? true;
  }

  static Future<void> setWtfEnabled(bool value) async {
    await _prefs.setBool('wtf_enabled', value);
  }

  static bool wtfPlusEnabled() {
    if (!PurchaseService.instance.wtfPlusOwned) {
      return false;
    }

    return _prefs.getBool('wtf_plus_enabled') ?? true;
  }

  static Future<void> setWtfPlusEnabled(bool value) async {
    await _prefs.setBool('wtf_plus_enabled', value);
  }

  static bool miniGameEnabled() {
    return _prefs.getBool('mini_game_enabled') ?? true;
  }

  static Future<void> setMiniGameEnabled(bool value) async {
    await _prefs.setBool('mini_game_enabled', value);
  }

  static bool challengeExtremeEnabled() {
    if (!PurchaseService.instance.challengeExtremeOwned) {
      return false;
    }

    return _prefs.getBool('challenge_extreme_enabled') ?? true;
  }

  static Future<void> setChallengeExtremeEnabled(bool value) async {
    await _prefs.setBool('challenge_extreme_enabled', value);
  }

  static int getSessionsCount() {
    return _prefs.getInt(_reviewSessionCountKey) ?? 0;
  }

  static Future<void> setSessionsCount(int value) async {
    await _prefs.setInt(_reviewSessionCountKey, value);
  }

  static int getRollsCount() {
    return _prefs.getInt(_reviewRollCountKey) ?? 0;
  }

  static Future<void> setRollsCount(int value) async {
    await _prefs.setInt(_reviewRollCountKey, value);
  }

  static bool getHasAskedForReview() {
    return _prefs.getBool(_reviewAskedKey) ?? false;
  }

  static Future<void> setHasAskedForReview(bool value) async {
    await _prefs.setBool(_reviewAskedKey, value);
  }

  static int? getReviewLastAskMillis() {
    return _prefs.getInt(_reviewLastAskKey);
  }

  static Future<void> setReviewLastAskMillis(int value) async {
    await _prefs.setInt(_reviewLastAskKey, value);
  }

  static bool hasShownRemoveAdsPaywall() {
    return _prefs.getBool(_removeAdsPaywallShowedKey) ?? false;
  }

  static Future<void> setHasShownRemoveAdsPaywall(bool value) async {
    await _prefs.setBool(_removeAdsPaywallShowedKey, value);
  }

  static bool hasShownPaywall() {
    return _prefs.getBool(_paywallShowedKey) ?? false;
  }

  static Future<void> setHasShownPaywall(bool value) async {
    await _prefs.setBool(_paywallShowedKey, value);
  }

  static List<String> getEnabledCategories() {
    final imitationEnabled = PreferencesService.imitationEnabled();
    final challengeEnabled = PreferencesService.challengeEnabled();
    final funEnabled = PreferencesService.funEnabled();
    final wtfEnabled = PreferencesService.wtfEnabled();
    final wtfPlusEnabled = PreferencesService.wtfPlusEnabled();
    final miniGameEnabled = PreferencesService.miniGameEnabled();
    final challengeExtremeEnabled =
        PreferencesService.challengeExtremeEnabled();

    final enabledCategories = <String>[];

    if (imitationEnabled) {
      enabledCategories.add(DiceCategory.imitationCategory);
    }

    if (challengeEnabled) {
      enabledCategories.add(DiceCategory.challengeCategory);
    }

    if (funEnabled) {
      enabledCategories.add(DiceCategory.funCategory);
    }

    if (wtfEnabled) {
      enabledCategories.add(DiceCategory.wtfCategory);
    }

    if (wtfPlusEnabled) {
      enabledCategories.add(DiceCategory.wtfPlusCategory);
    }

    if (miniGameEnabled) {
      enabledCategories.add(DiceCategory.miniGameCategory);
    }

    if (challengeExtremeEnabled) {
      enabledCategories.add(DiceCategory.challengeExtremeCategory);
    }

    return enabledCategories;
  }

  static Future<void> reset() async {
    await _prefs.clear();
  }
}
