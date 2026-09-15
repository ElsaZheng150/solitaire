import 'card.dart';

abstract class Pile {
  bool canMoveCard(Card card); //check if card is allowed to be moved
  bool canAcceptCard(Card card); //check if card's placement is valid
  void removeCard(Card card); //kick card from pile
  void acquireCard(Card card); //add card to pile
  void returnCard(Card card); //send card back
}//end of Pile