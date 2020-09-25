import 'dart:math';
import 'utils.dart';

int typesOfCards = 20;

class Board {
  int numSingleCards;
  Map<int, int> numForTypeOfCards;
  Map<int, int> positionForType;

  Board(int num) {
    numSingleCards = num;
    numForTypeOfCards = new Map<int, int>();
    positionForType = new Map<int, int>();

    for (int i = 0; i < typesOfCards; i++) {
      numForTypeOfCards.addAll({i: 0});
    }

    for (int i = 0; i < numSingleCards * 2; i++) {
      positionForType.addAll({i: 0});
    }

    printData();
  }

  void generateBoard() {
    int type;
    Random rnd = new Random();

    for (int i = 0; i < numSingleCards; i++) {
      //Select a new type of card

      while (true) {
        type = rnd.nextInt(typesOfCards) + 1;
        if (numForTypeOfCards[type] == 0) {
          numForTypeOfCards[type] = 1;
          break;
        }
      }
      setPositionForExtractedCard(type, rnd);
      setPositionForExtractedCard(type, rnd);

      printData();
    }
  }

  void setPositionForExtractedCard(int type, Random rnd) {
    int position;
    //Select an empty position
    while (true) {
      position = rnd.nextInt(numSingleCards * 2);
      if (positionForType[position] == 0) {
        positionForType[position] = type;
        break;
      }
    }
  }

  void printData() {
    if (debugMode) {
      print('numForTypeOfCards: ' + numForTypeOfCards.toString());
      print('positionForType: ' + positionForType.toString());
    }
  }
}
