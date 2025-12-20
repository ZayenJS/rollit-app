import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rollit/helpers/error.dart';

Future<bool> handleBuy(
  BuildContext context,
  Future<void> Function() callback,
) async {
  try {
    await callback();
    return true;
  } on PlatformException catch (e) {
    if (!context.mounted) return false;

    final errorMsg = purchaseErrorFromPlatformError(e);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMsg),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  } on PurchasesError catch (e) {
    if (!context.mounted) return false;
    final errorMsg = purchaseErrorFromPurchases(e);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMsg),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  } catch (e) {
    if (!context.mounted) return false;

    debugPrint(e.toString());

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Une erreur inattendue est survenue."),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  return false;
}
