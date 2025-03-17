int[] calculateRoundKey256(int[] inputList) {
  int antalRunder = 15;
  
  int[] expandedKey = new int[(antalRunder+1)*16]; //Laver den udvidede nøgle med den korrekte størrelse.

  // Kopierer inputList over til den udvidede nøgle.
  // Der skal lave en ny nøgle antalRunder + 1 gange, da det første sæt er den originale nøgle.
  for (int i = 0; i < 32; i++) {
    expandedKey[i] = inputList[i];
  }

  int rconIteration = 1;

  // Laver de forskellige ord herude, så de ikke laves igen og igen en masse gange.
  int[] word0 = new int[4];
  int[] word1 = new int[4];
  int[] word2 = new int[4];
  int[] word3 = new int[4];
  int[] word4 = new int[4];
  int[] word5 = new int[4];
  int[] word6 = new int[4];
  int[] word7 = new int[4];
  int[] word8 = new int[4];
  int[] word9 = new int[4];
  int[] word10 = new int[4];
  int[] word11 = new int[4];
  int[] word12 = new int[4];
  int[] word13 = new int[4];
  int[] word14 = new int[4];
  int[] word15 = new int[4];

  for (int i = 0; i < antalRunder-8; i++) {
    //Til at starte med deles de 24 tidligere bytes op i 4 ord.
    for (int copy = 0; copy < 4; copy++) {
      word0[copy] = expandedKey[copy + 0  + 32*i];
      word1[copy] = expandedKey[copy + 4  + 32*i];
      word2[copy] = expandedKey[copy + 8  + 32*i];
      word3[copy] = expandedKey[copy + 12 + 32*i];
      word4[copy] = expandedKey[copy + 16 + 32*i];
      word5[copy] = expandedKey[copy + 20 + 32*i];
      word6[copy] = expandedKey[copy + 24 + 32*i];
      word7[copy] = expandedKey[copy + 28 + 32*i];
    }

    //Det første nye ord skal i keyExpansionCore dermed:
    word8 = keyExpansionCore(word7, rconIteration++); //rconIteration forøges hver gang dette køres.

    // Da word4 skal bruges i helhed kopieres det over først inden de andre bliver beregnet.
    for (int iteration = 0; iteration < 4; iteration++) {
      word8[iteration] ^= word0[iteration];
    }


    for (int copy = 0; copy < 4; copy++) {
      word9[copy] = word1[copy] ^ word8[copy];
      word10[copy] = word2[copy] ^ word9[copy];
      word11[copy] = word3[copy] ^ word10[copy];
    }
    // I 256 skal word11 substitute bruges til at finde word 12. Dermed laves der et temp ord.
    int[] substituteWord11 = new int[4];

    for (int iteration = 0; iteration < 4; iteration++) {
      substituteWord11[iteration] = substituteBytes(word11[iteration]);
    }
    //Når det er gjort kan dee sidste udregnes.
    for (int copy = 0; copy < 4; copy++) {
      word12[copy] = word4[copy] ^ substituteWord11[copy];
      word13[copy] = word5[copy] ^ word12[copy];
      word14[copy] = word6[copy] ^ word13[copy];
      word15[copy] = word7[copy] ^ word14[copy];
    }

    // Nu hvor den udvidede nøgle er lavet skal det sættes ind i expandedKey
    for (int copy = 0; copy < 4; copy++) {
      expandedKey[i*32+copy+32] = word8[copy];
      expandedKey[i*32+copy+36] = word9[copy];
      expandedKey[i*32+copy+40] = word10[copy];
      expandedKey[i*32+copy+44] = word11[copy];
      expandedKey[i*32+copy+48] = word12[copy];
      expandedKey[i*32+copy+52] = word13[copy];
      expandedKey[i*32+copy+56] = word14[copy];
      expandedKey[i*32+copy+60] = word15[copy];
    }
  }
  println(expandedKey);
  return expandedKey;
}
int[] keyExpansionCore(int[] inputList, int iteration) {

  int[] output = new int[4];

  // Roterer
  output[0] = inputList[1];
  output[1] = inputList[2];
  output[2] = inputList[3];
  output[3] = inputList[0];

  // Substitute bytes
  output[0] = substituteBytes(output[0]);
  output[1] = substituteBytes(output[1]);
  output[2] = substituteBytes(output[2]);
  output[3] = substituteBytes(output[3]);

  // RCon (Round Constant)
  // Udregnes med 2^(iteration-1)
  output[0] ^= int(pow(2, iteration-1));

  while (output[0] > 255) {
    int difference = 6-findMostSignificantBit(output[0]);

    output[0] ^= 283 << difference;
    // Finder forskellen i det største bit for at kunne dividere output[0] med x^8+x^4+x^3+x^1+x^0 skubbet så x^8 bliver forskudt til den største bit i output[0].
    // Det gør at der fåes den korrekte Round Constant og at det passer ind i en byte.
    /*
    if (output[0] > 32768){
     int difference = 6-findMostSignificantBit(output[0]);
     
     output[0] ^= 283 << difference;
     
     }
     
     int difference = 6-findMostSignificantBit(output[0]);
     
     int[] divisionOutput = division(output[0], 283 << difference);
     output[0] = divisionOutput[1]; // Skal bruge resten og ikke kvotienten.
     */
  }

  return output;
}
int[] keyExpansionCoreNew(int[] inputList, int iteration) {

  int[] output = new int[1];

  // Roterer
  output[0] = inputList[0];

  // Substitute bytes
  output[0] = substituteBytes(output[0]);

  // RCon (Round Constant)
  // Udregnes med 2^(iteration-1)
  output[0] ^= int(pow(2, iteration-1));

  while (output[0] > 255) {
    int difference = 6-findMostSignificantBit(output[0]);

    output[0] ^= 283 << difference;
    // Finder forskellen i det største bit for at kunne dividere output[0] med x^8+x^4+x^3+x^1+x^0 skubbet så x^8 bliver forskudt til den største bit i output[0].
    // Det gør at der fåes den korrekte Round Constant og at det passer ind i en byte.
    /*
    if (output[0] > 32768){
     int difference = 6-findMostSignificantBit(output[0]);
     
     output[0] ^= 283 << difference;
     
     }
     
     int difference = 6-findMostSignificantBit(output[0]);
     
     int[] divisionOutput = division(output[0], 283 << difference);
     output[0] = divisionOutput[1]; // Skal bruge resten og ikke kvotienten.
     */
  }

  return output;
}

int substituteBytes(int input){
 int output = 0;

 int[] sboks = {
   99, 124, 119, 123, 242, 107, 111, 197, 48, 1, 103, 43, 254, 215, 171, 118,
   202, 130, 201, 125, 250, 89, 71, 240, 173, 212, 162, 175, 156, 164, 114, 192,
   183, 253, 147, 38, 54, 63, 247, 204, 52, 165, 229, 241, 113, 216, 49, 21,
   4, 199, 35, 195, 24, 150, 5, 154, 7, 18, 128, 226, 235, 39, 178, 117, 
   9, 131, 44, 26, 27, 110, 90, 160, 82, 59, 214, 179, 41, 227, 47, 132, 
   83, 209, 0, 237, 32, 252, 177, 91, 106, 203, 190, 57, 74, 76, 88, 207,
   208, 239, 170, 251, 67, 77, 51, 133, 69, 249, 2, 127, 80, 60, 159, 168,
   81, 163, 64, 143, 146, 157, 56, 245, 188, 182, 218, 33, 16, 255, 243, 210,
   205, 12, 19, 236, 95, 151, 68, 23, 196, 167, 126, 61, 100, 93, 25, 115,
   96, 129, 79, 220, 34, 42, 144, 136, 70, 238, 184, 20, 222, 94, 11, 219,
   224, 50, 58, 10, 73, 6, 36, 92, 194, 211, 172, 98, 145, 149, 228, 121,
   231, 200, 55, 109, 141, 213, 78, 169, 108, 86, 244, 234, 101, 122, 174, 8,
   186, 120, 37, 46, 28, 166, 180, 198, 232, 221, 116, 31, 75, 189, 139, 138,
   112, 62, 181, 102, 72, 3, 246, 14, 97, 53, 87, 185, 134, 193, 29, 158,
   225, 248, 152, 17, 105, 217, 142, 148, 155, 30, 135, 233, 206, 85, 40, 223,
   140, 161, 137, 13, 191, 230, 66, 104, 65, 153, 45, 15, 176, 84, 187, 22
  };
 
  output = sboks[input];
 
 return output;
}

int[] division(int tæller, int nævner) {
  int quotient = 0;
  int index = 0;
  int remainder = tæller;
  int tempNævner = nævner;
  int mostSignificantBitITæller = 8; // Sat til 7 for at vælge det laveste bit

  while (true) {

    mostSignificantBitITæller = findMostSignificantBit(tæller);

    if (binary(tæller, 15).charAt(mostSignificantBitITæller) == binary(tempNævner,15).charAt(mostSignificantBitITæller)) { // Ændret fra 9

      tæller ^= tempNævner;
      tempNævner = nævner;

      quotient += 1 << index;
      index = 0;

      if (tæller > nævner) {

        int temp = tæller ^ nævner;

        if (temp == 1) {
          remainder = tæller;

          return new int[] {quotient, remainder};
        } else {
        }
      } else {
        remainder = tæller;
        
        return new int[] {quotient, remainder};
      }
    } else {
      index++;
      tempNævner = tempNævner << 1;
    }
  }
}

int findMostSignificantBit(int input) {

  if (input == 0) {
    return 0;
  }

  int mostSignificantBit = 14; 

  input /= 2;
  while (input != 0) {
    input /= 2;
    mostSignificantBit--;
  }
  return mostSignificantBit;
}
