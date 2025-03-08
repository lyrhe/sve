Bugs :
- [x] ~~Déplacer une carte dans une zone restand toutes les cartes rest de la zone d'origine et de la nouvelle zone.~~
- [x] ~~Déplacer une carte depuis la main la fait disparaître en dessous de celles du Field et de l'Ex Area.~~
- [x] ~~Token qui refuse de se placer dans une zone avec deux slots libres ou moins~~
- [x] ~~Empêcher les tokens de s'ajouter au deck~~
- [x] ~~Shuffle va réinitialiser le deck avant de le shuffle (eg. les cartes sorties du decks seront remplacées)~~
- [ ] Reparent ExArea/Field full

Todo:
- [x] ~~Une carte ne peut être rest que sur le terrain~~
- [x] ~~Bug changement de zone Evolved~~
- [x] ~~Spécificités Field~~
	- [x] ~~Ne peut pas acueillir de spells~~
- [x] ~~Clic molette pour dupliquer les tokens~~
- [x] ~~Spécificités Deck~~
	- [x] ~~Ajouter send to top/bottom~~
	- [x] ~~Ajouter gestion carte Evolved~~
	- [x] ~~Check top X~~
 	- [x] ~~Shuffle button~~
- [ ] Spécificités Evolve Deck
	- [x] ~~Charger Evolve Deck en même temps que le deck~~
	- [x] ~~Faceup/facedown~~
	- [ ] Une carte Evolved ne peut sortir de l'Evolve Deck que pour aller sur le terrain
		- [ ] Menu contextuel ? 	
- [x] ~~Points d'Evo~~
- [x] ~~Montrer carte plus grande quand hovered~~
- [x] ~~Agrandir carte dragged~~
- [x] ~~Supprimer hand.gd ?~~
- [x] ~~Limiter field et EX Area à 5~~
- [ ] Previews banish/cimetière/""""evolve deck""""
- [x] ~~Life counter~~
- [ ] Mana counter
- [x] ~~Compteurs (+x/+x, buffs, damage, etc...)~~
	- [ ] Conserver changements de stats entre Field et Ex Area 
- [ ] Compteurs spéciaux (fable, etc)
	- [ ] Ctrl+click?
- [x] ~~Axe Z~~

Features:
- [ ] Deckbuilder
- [ ] Online
- [ ] Lien vers la FAQ ?
- [ ] Distinguer zones et "piles" ?
	- [ ] Déplacer _on_deck_changed et spawn_cards dans Zone (piles) ?
- [ ] Simplifier add_child() ? La façon de reparent sur une zone illégale de manière générale ?
- [ ] Changer la façon dont la CollisionShape du tokens deck est désactivée ?
- [x] ~~Supprimer deck autoloaded~~
- [ ] Necessité d'une scène pour le terrain ? 


UI:
- [ ] Afficher le nom du container
