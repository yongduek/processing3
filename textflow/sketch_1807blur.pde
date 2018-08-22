//String [] s;
ArrayList <FallingWord>  words = new ArrayList<FallingWord>();

int NMAXFONT = 3;
PFont[] myFontList = new PFont[NMAXFONT];


int     fontBlurDegreeMax = 4;
float   fontBlurRatio = 0.3; // 20% of the words will be blurred



PFont getFont (int indx)
{
  if (0 <= indx && indx < NMAXFONT)
    return myFontList[indx];
  else
    return myFontList[0];
}

void setup() 
{
  // font setup
  String[] sysFontList = PFont.list();   // Look at the output text and choose Korean font names.
  printArray (sysFontList);

  // choose fonts you like. If you are to use Korean, then choose Korean fonts.
  myFontList[0] = createFont (sysFontList[433], 64);
  myFontList[1] = createFont (sysFontList[439], 42);
  myFontList[2] = createFont (sysFontList[195], 44);
  //
  frameRate(24);
  size(1920, 1080);
  String[] s = loadStrings("image.txt");
  for (int i = 0; i < s.length; i++) {

    String [] lineWords = splitTokens(s[i]);
    for (int j = 0; j < lineWords.length; j++) {
      words.add(new FallingWord(lineWords[j]));
    }
  }

  noStroke();
  smooth();
}

void draw() 
{
  background(0);
  for (FallingWord fw : words) {
    fw.update();
    fw.draw();
  }
}


class FallingWord 
{
  String word;
  float xpos, ypos, speed, acc;
  color filler;
  float fSize;
  int   fontid;
  PGraphics p;
  boolean pinit = false;
  boolean fontBlurFlag = true;
  int fontBlurDegree;

  FallingWord (String _word) {
    fontid = int (random (NMAXFONT));
    word = _word; // + ' ' + (fontid);

    pinit = false;
    fontBlurFlag = false;
    initWord();
  }


  void initWord() {
    xpos   = random (width);
    ypos   = random(-height/2, -10);
    speed  = random(0.3, 1.1);
    acc    = random(0.01, 0.08);
    filler = color(255, 255, 255);
    filler = color(225, 225, 215);
    fSize  = random(30, 100);

    if (random(1) < fontBlurRatio) {
      fontBlurFlag = true;
      fontBlurDegree = int (random(1, fontBlurDegreeMax));
    }
  }




  void update() {
    speed += acc;
    ypos  += speed;
    if (ypos > height ) {
      initWord();
    }
    if (mousePressed)
      initWord();
  }

  void draw() {

    textSize(fSize);
    textFont (getFont (fontid));    

    if (fontBlurFlag == true) {
      if (pinit == false) {
        p = createGraphics (int(textWidth (word)+2), 100);

        p.beginDraw();
        p.background (0, 0, 0, 0);
        p.textSize (fSize);
        p.textFont (getFont(fontid));
        p.text (word, 0, 85);
        //p.fill (filler);
        //p.tint (100, 126);
        p.filter (BLUR, fontBlurDegree);
        p.endDraw();
        pinit = true;
      }
      image (p, xpos, ypos);
    } else {
      textSize(fSize);
      textFont (getFont (fontid));    
      fill(filler);
      text(word, xpos, ypos);
    }
  }
}

// EOF
