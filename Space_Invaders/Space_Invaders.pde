import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port

int buttonState = 0;
int potentiometerState = 0; 
int joystickX = 0;
int joystickY = 0;
int joystickZ = 0;

int pixelsize = 4;
int gridsize  = pixelsize * 7 + 5;
Player player;
ArrayList enemies = new ArrayList();
ArrayList bullets = new ArrayList();
int direction = 1;
boolean incy = false;
int score = 0;
PFont levelFont;
PFont scoreFont;

int level = 0;
int numEnemies = 6;
int nextLevelTimer = 0;
int enemySpeed = 30;

int nextGunOverheat = 0;
int overheatValue = 0;

void setup()
{
  size(500, 500);
  //Used for getting proper port
  //printArray(Serial.list());
  String portName = Serial.list()[2];
  //Used for getting proper port
  //println(portName);
  myPort = new Serial(this, portName, 9600); // ensure baudrate is consistent with arduino sketch
  
  background(0);
  noStroke();
  size(800, 550);
  player = new Player();
  createEnemies();

  scoreFont = createFont("Arial", 36, true);
  levelFont = createFont("Arial", 50, true);
  
  if (myPort.available() > 0) {  
    val = myPort.readStringUntil('\n').trim();  
  }
  if (val != null){
    int[] inputs = int(val.split(","));
    potentiometerState = inputs[1]; 
    if(potentiometerState == 0) {
     nextGunOverheat = 4095; 
    }
    else {
       nextGunOverheat = 0; 
    }
  }
   
}

void draw()
{
  background(0);
  textSize(16);
  noStroke();
  
  if (myPort.available() > 0) {  
    val = myPort.readStringUntil('\n').trim();  
  }
  if (val != null){
    int[] inputs = int(val.split(","));
    buttonState = inputs[0];
    potentiometerState = inputs[1]; 
    joystickX = inputs[2];
    joystickY = inputs[3];
    joystickZ = inputs[4];
    
    /*Test inputs are being read properly */
    /*println("Button: ", buttonState);
    println("Potentiometer: ", potentiometerState);
    println("Joystick: ", joystickX, joystickY, joystickZ);
    
    textAlign(CENTER);
    text(val, width/2, height/2);*/
    
    
    background(0);
    
    if(overheatValue > 0 && overheatValue < 100) {
      overheatValue -= 1;
    }
    if(potentiometerState == nextGunOverheat) {
       overheatValue = 0;
       if(potentiometerState == 0) {
          nextGunOverheat = 4095; 
       }
       else {
           nextGunOverheat = 0; 
       }
    }
    drawScore();
    drawOverheat();

    player.draw();

    for (int i = 0; i < bullets.size(); i++) {
        Bullet bullet = (Bullet) bullets.get(i);
        bullet.draw();
    }

    for (int i = 0; i < enemies.size(); i++) {
        Enemy enemy = (Enemy) enemies.get(i);
        if (enemy.outside() == true) {
            direction *= (-1);
            incy = true;
            break;
        }
    }
  if(nextLevelTimer > 0) {
     nextLevelTimer -=1;
    textFont(levelFont);
    text("Level Complete!", 200, height/2);
  }
  else {

    for (int i = 0; i < enemies.size(); i++) {
        Enemy enemy = (Enemy) enemies.get(i);
        if (!enemy.alive()) {
            enemies.remove(i);
        } else {
            enemy.draw();
        }
    }
    
    if(enemies.size() == 0) {
       triggerNextLevel(); 
    }
  }
    incy = false;
  }    
}

void triggerNextLevel() {
  textFont(levelFont);
  text("Level Complete!", 200, height/2);
  nextLevelTimer = 100;
  level += 1;
  if(level % 3 == 0) {
    numEnemies += 1; 
    enemySpeed += 3;
  }
  else if(enemySpeed > 10) {
     enemySpeed -= 3; 
  }
  createEnemies();
}

void drawScore() {
    textFont(scoreFont);
    text("Score: " + String.valueOf(score), 300, 50);
}

void drawOverheat() {
 fill(0);
 stroke(255);
 rect(width - 28, height - 108, 22, 102);
 fill(255, 0, 0);
 rect(width - 27, height - 8 - overheatValue, 20, overheatValue);
}

void createEnemies() {
    for (int i = 0; i < width/gridsize/2; i++) {
        for (int j = 0; j < numEnemies; j++) {
            enemies.add(new Enemy(i*gridsize, j*gridsize + 70));
        }
    }
}

class SpaceShip {
    int x, y;
    String sprite[];
    color baseColor = color(255, 255, 255);
    color nextColor = baseColor;

    void draw() {
        updateObj();
        drawSprite(x, y);
    }

    void drawSprite(int xpos, int ypos) {
        fill(nextColor);
        noStroke();
        
        nextColor = baseColor;
        for (int i = 0; i < sprite.length; i++) {
            String row = (String) sprite[i];

            for (int j = 0; j < row.length(); j++) {
                if (row.charAt(j) == '1') {
                    rect(xpos+(j * pixelsize), ypos+(i * pixelsize), pixelsize, pixelsize);
                }
            }
        }
        fill(255, 255, 255);
    }

    void updateObj() {
    }
}

class Player extends SpaceShip {
    boolean canShoot = true;
    int shootdelay = 0;

    Player() {
        x = width/gridsize/2;
        y = height - (10 * pixelsize);
        sprite    = new String[5];
        sprite[0] = "0010100";
        sprite[1] = "0110110";
        sprite[2] = "1111111";
        sprite[3] = "1111111";
        sprite[4] = "0111110";
    }

    void updateObj() {
        if (joystickX < 1000) {
            x -= 5;
        }
        
        if (joystickX > 3000) {
            x += 5;
        }
        
        if (buttonState == 0 && canShoot) {
          if(overheatValue < 100) {
            bullets.add(new Bullet(x, y));
            canShoot = false;
            shootdelay = 0;
            overheatValue += 24;
            if(overheatValue > 100) {
               overheatValue = 100; 
            }
          }
        }
        

        shootdelay++;
        
        if (shootdelay >= 20) {
            canShoot = true;
        }
    }
}

class Enemy extends SpaceShip {
    int life = 3;
    
    color[] enemyColors = {
      color(0, 255, 255),
      color(0, 255, 0),
      color(255, 255, 0),
    };
    
    Enemy(int xpos, int ypos) {
        x = xpos;
        y = ypos;
        baseColor = enemyColors[int(random(3))];
        sprite    = new String[5];
        sprite[0] = "1011101";
        sprite[1] = "0101010";
        sprite[2] = "1111111";
        sprite[3] = "0101010";
        sprite[4] = "1000001";
    }

    void updateObj() {
        if (frameCount%enemySpeed == 0) {
            x += direction * gridsize;
        }
        
        if (incy == true) {
            y += gridsize / 2;
        }
    }

    boolean alive() {
        for (int i = 0; i < bullets.size(); i++) {
            Bullet bullet = (Bullet) bullets.get(i);
            
            if (bullet.x > x && bullet.x < x + 7 * pixelsize + 5 && bullet.y > y && bullet.y < y + 5 * pixelsize) {
                bullets.remove(i);
                
                life--;
                nextColor = color(255, 0, 0);
                
                if (life == 0) {
                    score += 50 + 25 * level;
                    return false;
                }
                
                break;
            }
        }

        return true;
    }

    boolean outside() {
        return x + (direction*gridsize) < 0 || x + (direction*gridsize) > width - gridsize;
    }
}

class Bullet {
    int x, y;

    Bullet(int xpos, int ypos) {
        x = xpos + gridsize/2 - 4;
        y = ypos;
    }

    void draw() {
        fill(255);
        rect(x, y, pixelsize, pixelsize);
        y -= pixelsize * 2;
    }
}
