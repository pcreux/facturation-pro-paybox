# Facturation.pro - Paybox

Cette petite application ruby on rails permet de payer des factures
émises depuis [facturation.pro](https://www.facturation.pro/) via le
système [Paybox](http://www1.paybox.com/).

Elle est extraite de l'[application de paiement](http://paiement.la-cordee.net)
de l'espace de coworking [La Cordée](http://la-cordee.net).

C'est une bonne base si vous souhaitez réaliser une application
similaire.

## Utilisation

La page d'accueil permet de saisir un numéro de facture et son
montant. Si ces données sont valides, l'utilisateur est redirigé vers
paybox.

Vous pouvez également payer une facture directement en suivant un lien
du type:

```
http://facturation-pro-paybox.dev/facture?reference=2014-2&montant=82.56
```

Le montant peut être au format `82` ou `82.23` ou `82,23`.

## Notes

Le fichier .env.sample contient les variables d'environnement
nécessaires à faire tourner l'application.

Le code est bien, mais pas top. Le service `FetchInvoice` est une
expérimentation - callbacks mon amour. :)

Have fun!

Philippe Creux pour la Cordée - Feb 2014
