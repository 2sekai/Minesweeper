import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public boolean gameFin = false;

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r <buttons.length; r++)
    for (int c = 0; c < buttons[r].length; c++)
      buttons[r][c]=new MSButton(r, c);

  setMines();
  //System.out.println(countMines);
}
public void setMines()
{
  while(mines.size() < buttons.length){
  int r = (int)(Math.random()*NUM_ROWS);
  int c = (int)(Math.random()*NUM_COLS);
  if (!mines.contains(buttons[r][c])) {
    mines.add(buttons[r][c]);
  }
  }
  
}

public void draw ()
{
  background( 0 );
  
  if (isWon() == true)
    displayWinningMessage();
  
}
public boolean isWon()
{
  int countm = 0;
  int countx = 0;
  for(int r = 0; r<NUM_ROWS;r++){
  for(int c = 0; c<NUM_COLS;c++){
  if(mines.contains(buttons[r][c])&&buttons[r][c].isFlagged()==true)
  countm++;
  else if(buttons[r][c].clicked==true)
  countx++;
  }
  }
  if(countm==mines.size()&&countx==((NUM_ROWS*NUM_COLS)-mines.size()))
  return true;
  return false;
}
public void displayLosingMessage()
{
 
 for(int r = 0 ; r<NUM_ROWS; r++){
 for (int c = 0; c < NUM_COLS; c++){
  if(mines.contains(buttons[r][c])){
 buttons[r][c].clicked=true; 
  fill(255, 0, 0);
  }
 }
 }
 gameFin = true;
 String str = "YOU LOSE";
 for(int c = 0; c<NUM_COLS;c++)
 buttons[NUM_ROWS/2][c].setLabel(str.substring(c,c+1));
}
public void displayWinningMessage()
{
  String str = "YOU WIN";
 for(int c = 0; c<NUM_COLS;c++)
 buttons[NUM_ROWS/2][c].setLabel(str.substring(c,c+1));
}
public boolean isValid(int r, int c)
{
  for (int row = 0; row < NUM_ROWS; row++)
    for (int col = 0; col < NUM_COLS; col++)
      if (row==r&&col==c)
        return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r<row+2; r++)
    for (int c = col-1; c<col+2; c++)
      if (r==row && c == col)
        numMines+=0;
      else if (isValid(r, c)==true&&mines.contains(buttons[r][c]))
  numMines++;
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
  if(gameFin==true)
    return;
    clicked = true;
    if (mouseButton == RIGHT && flagged == true){
      flagged = false;
      clicked = false;
    }
    else if (mouseButton == RIGHT && flagged == false) {
      flagged = true;

    } else if (mines.contains(this))
       displayLosingMessage();
    else if (countMines(myRow,myCol)>0)
      setLabel(countMines(myRow,myCol));
    else
      for(int r = myRow-1; r<myRow+2;r++)
      for(int c = myCol-1; c<myCol+2;c++)
      if (isValid(r,c)&&!buttons[r][c].clicked==true)
     buttons[r][c].mousePressed();
     
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}




