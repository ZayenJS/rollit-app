import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

String purchaseErrorFromPlatformError(PlatformException e) {
  final code = PurchasesErrorHelper.getErrorCode(e);

  switch (code) {
    case PurchasesErrorCode.purchaseNotAllowedError:
      return "Achats indisponibles : ce compte/appareil n’est pas autorisé à acheter.";
    case PurchasesErrorCode.storeProblemError:
      return "Problème avec le store. Veuillez réessayer plus tard.";
    case PurchasesErrorCode.purchaseCancelledError:
      return "Achat annulé.";
    default:
      return "Erreur d’achat. Réessayez plus tard.";
  }
}

String purchaseErrorFromPurchases(PurchasesError error) {
  final code = error.code;

  switch (code) {
    case PurchasesErrorCode.purchaseNotAllowedError:
      return "Achats indisponibles : ce compte/appareil n’est pas autorisé à acheter.";
    case PurchasesErrorCode.storeProblemError:
      return "Problème avec le store. Veuillez réessayer plus tard.";
    case PurchasesErrorCode.purchaseCancelledError:
      return "Achat annulé.";
    case PurchasesErrorCode.paymentPendingError:
      return "Le paiement est en attente. Veuillez finaliser le paiement pour accéder à la fonctionnalité premium.";
    case PurchasesErrorCode.productNotAvailableForPurchaseError:
      return "Le produit demandé n’est pas disponible à l’achat.";
    case PurchasesErrorCode.invalidCredentialsError:
      return "Problème de connexion aux serveurs d’achat. Veuillez réessayer plus tard.";
    case PurchasesErrorCode.networkError:
      return "Problème de connexion réseau. Veuillez vérifier votre connexion et réessayer.";
    case PurchasesErrorCode.invalidReceiptError:
      return "Le reçu d’achat est invalide. Veuillez réessayer.";
    case PurchasesErrorCode.unknownBackendError:
      return "Erreur inconnue du serveur. Veuillez réessayer plus tard.";
    case PurchasesErrorCode.invalidAppUserIdError:
      return "Identifiant utilisateur invalide. Veuillez réessayer.";
    case PurchasesErrorCode.operationAlreadyInProgressError:
      return "Une opération d’achat est déjà en cours. Veuillez patienter.";
    case PurchasesErrorCode.receiptInUseByOtherSubscriberError:
      return "Le reçu est déjà utilisé par un autre abonné.";
    case PurchasesErrorCode.missingReceiptFileError:
      return "Le fichier de reçu est manquant. Veuillez réessayer.";
    case PurchasesErrorCode.productAlreadyPurchasedError:
      return "Ce produit a déjà été acheté.";
    default:
      return "Erreur d’achat. Réessayez plus tard.";
  }
}
