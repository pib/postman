DECLARE SUB wingame ()
DECLARE SUB gameover ()
DECLARE SUB clrtext ()
DECLARE SUB intro ()
DECLARE SUB biblio ()
DECLARE SUB pause ()
DECLARE SUB putenemy (enum!, EX!, ey!)
DECLARE SUB fight ()
DECLARE SUB loadlevel ()
DECLARE SUB mapedit ()
DECLARE SUB w (a$, x%, y%, Co%, Bkgd%, Shadow%)
DECLARE SUB msgbox (msg1$, msg2$)
DECLARE SUB loadtiles ()
DECLARE SUB loadmaps ()
DECLARE SUB dopal ()
DECLARE SUB rotatepal ()
DECLARE SUB loadpal (touse() AS LONG)
DECLARE SUB putplayer (tilex!, tiley!)
DECLARE SUB movedown ()
DECLARE SUB moveleft ()
DECLARE SUB moveright ()
DECLARE SUB moveup ()
DECLARE SUB puttile (tilex!, tiley!)
DECLARE SUB drawmap ()
SCREEN 13
RANDOMIZE TIMER
'ON ERROR GOTO errfix
CONST numtiles = 19, nummaps = 37, numenemy = 5
 
DIM SHARED tile(numtiles - 1, 19, 19)
DIM SHARED enemy(numenemy - 1, 19, 19)
DIM SHARED map(nummaps - 1, 15, 8)
DIM SHARED player(3, 1, 19, 19)
DIM SHARED curmap, playerx, playery, playerdir, movenum, curtile, msgon, ded
DIM SHARED pale(255) AS LONG

TYPE maptype
  left AS INTEGER
  right AS INTEGER
  up AS INTEGER
  down AS INTEGER
END TYPE
DIM SHARED maps(nummaps - 1) AS maptype
                     '-Info About Player-
TYPE playertype      '(also used for enemys)
  HP AS INTEGER      'HitPoints
  maxHP AS INTEGER   'Maximum HitPoints
  EX AS INTEGER      'Experience
  LVL AS INTEGER     'Level
  STR AS SINGLE     'Strength
  SPD AS INTEGER     'Speed
  DEFEN AS INTEGER   'Defense
  NAM AS STRING * 20 'Name
END TYPE
DIM SHARED playerstats AS playertype 'Player Info
playerstats.HP = 32
playerstats.maxHP = 32
playerstats.EX = 0
playerstats.LVL = 1
playerstats.STR = 2
playerstats.SPD = 5
playerstats.DEFEN = 2.5
playerstats.NAM = "John"
DIM SHARED enemytype(numenemy - 1) AS playertype 'Constant info on enemies


dopal    'Load custom palette
loadmaps 'Load game maps
loadtiles'Load game tiles

intro 'Show introduction

'play game
LINE (0, 180)-(319, 180), 40 'Draw
LINE (0, 181)-(319, 181), 4  '    Bar across
LINE (0, 182)-(319, 182), 40 '              Bottom
curmap = 3  'Start on this map
playerx = 8 'Player Starting
playery = 2 '               Position
playerdir = 2 ' Player starting direction
drawmap 'Draw the current map
putplayer playerx, playery 'Show the player

DO 'Main game loop
  IF ded THEN GOTO endit
  k$ = INKEY$ 'Check for keyboard input and clear keyboard buffer
  SELECT CASE UCASE$(RIGHT$(k$, 1)) '<--- Upper case so we don't have to mess
    CASE "H" 'Was the up key pressed?     with capslock
      moveup 'If so, move the guy up
      IF map(curmap, playerx, playery) < 3 THEN fight 'if on grass, dirt. or
    CASE "P" 'Was the down key pressed?                tree, then fight
      movedown ' If so, move the guy down
      IF map(curmap, playerx, playery) < 3 THEN fight 'ditto
    CASE "K" 'Was the left key pressed?
      moveleft 'If so, move the guy left
      IF map(curmap, playerx, playery) < 3 THEN fight 'ditto ditto
    CASE "M" 'Was the right key pressed?
      moveright 'If so, move the guy right
      IF map(curmap, playerx, playery) < 3 THEN fight 'ditto ditto ditto
    CASE "F" 'Did the person playing the game get bored and press the "F" key?
      fight 'If so, then enter the fight routine
   CASE CHR$(27) 'Was the Escape key pressed?
      EXIT DO 'If so...ESCAPE!
  END SELECT 'If anything else was pressed, Too Bad
  IF curmap = 15 THEN
    pause
    wingame
    GOTO endit
  END IF

LOOP 'End of main program loop

GOTO endit
errfix:
RESUME NEXT
endit:
msgbox "Goodbye and have a nice day!", ""
pause

SUB clrtext

  LINE (0, 183)-(319, 199), 0, BF

END SUB

SUB dopal

  'shades of yellow to shades of red
  FOR i = 1 TO 63
    OUT &H3C8, i + 15
    OUT &H3C9, i
    OUT &H3C9, 0
    OUT &H3C9, 0
  NEXT i
  FOR i = 1 TO 20
    OUT &H3C8, i + 15
    OUT &H3C9, i + 43
    OUT &H3C9, i + 43
    OUT &H3C9, 0
  NEXT i

  'shades of blue-green to green
  FOR i = 1 TO 63
    OUT &H3C8, i + 78
    OUT &H3C9, 0
    OUT &H3C9, i
    OUT &H3C9, 0
  NEXT i
  FOR i = 1 TO 20
    OUT &H3C8, i + 78
    OUT &H3C9, 0
    OUT &H3C9, i + 43
    OUT &H3C9, i + 43
  NEXT i

  'shades of purple to shades of blue
  FOR i = 1 TO 63
    OUT &H3C8, i + 141
    OUT &H3C9, 0
    OUT &H3C9, 0
    OUT &H3C9, i
  NEXT i
  FOR i = 1 TO 20
    OUT &H3C8, i + 141
    OUT &H3C9, i + 43
    OUT &H3C9, 0
    OUT &H3C9, i + 43
  NEXT i

' now load some custom colors
 
  ' skin color
  OUT &H3C8, 205
  OUT &H3C9, 54
  OUT &H3C9, 53
  OUT &H3C9, 28

  'black
  OUT &H3C8, 206
  OUT &H3C9, 0
  OUT &H3C9, 0
  OUT &H3C9, 0

  'light grey
  OUT &H3C8, 207
  OUT &H3C9, 50
  OUT &H3C9, 50
  OUT &H3C9, 50
  
  'lighter skin color
  OUT &H3C8, 208
  OUT &H3C9, 55
  OUT &H3C9, 54
  OUT &H3C9, 29

  'even lighter skin color
  OUT &H3C8, 209
  OUT &H3C9, 56
  OUT &H3C9, 55
  OUT &H3C9, 30

  'EVEN LIGHTER skin color
  OUT &H3C8, 210
  OUT &H3C9, 57
  OUT &H3C9, 56
  OUT &H3C9, 31

END SUB

SUB drawmap

  FOR y = 0 TO 8
    FOR x = 0 TO 15
      puttile x, y
    NEXT x
  NEXT y

END SUB

SUB fight

  tofight = INT(15 * RND) 'A one in 15 chance
  IF tofight = 1 THEN     'that we will fight
    tempmap = curmap 'remember what map we are on
    tempdir = playerdir 'remember
    curmap = 8 'set to the fight map
    msgbox "Entering Battle...", ""  'Tell the player what we're doing
    drawmap 'Now draw the fight scene
    playerdir = 0 'Make the player facing north...
    putplayer 7, 8 '...and put him where we want him
    SELECT CASE playerstats.LVL 'What level is the player?
      CASE IS <= 3
        tofight = 1
      CASE IS > 3 < 6 'Depending on that, don't make him
        tofight = 2    'fight someone too strong
      CASE IS >= 6
        tofight = 3
    END SELECT
    tofight = INT((tofight + 1) * RND)
    SELECT CASE tofight 'depending on what we got above..
      CASE 0 OR 1
        IF playerstats.LVL <= 5 THEN 'choose the proper enemy
          enum = INT((playerstats.LVL) * RND)
        ELSE
          enum = INT((6) * RND) + 1
        END IF
      CASE 2
        IF playerstats.LVL > 5 <= 10 THEN
          enum = INT((INT(playerstats.LVL / 2)) * RND)
        ELSE
          enum = INT((4) * RND)
        END IF
      CASE 3
        IF playerstats.LVL > 15 THEN
          enum = INT((INT(playerstats.LVL / 3)) * RND)
        ELSE
          enum = INT((3) * RND)
        END IF
    END SELECT
    DIM enemystats(enum)   AS playertype
    FOR i = 0 TO enum
      putenemy tofight, 7 + i, 5
      enemystats(i).NAM = enemytype(tofight).NAM
      enemystats(i).HP = enemytype(tofight).HP
      enemystats(i).EX = enemytype(tofight).EX
      enemystats(i).DEFEN = enemytype(tofight).DEFEN
      enemystats(i).STR = enemytype(tofight).STR
    NEXT i
    clrtext
    IF enum > 0 THEN
      msgbox "You are being attacked by some ", RTRIM$(enemytype(tofight).NAM) + "s"
    ELSE
      msgbox "You are being attacked by a ", RTRIM$(enemytype(tofight).NAM)
    END IF
    pause
   
    DO 'Main Fight Loop
    IF ran THEN
        ran = 0
        dead = 0
        FOR i = 0 TO enum
          IF enemystats(i).HP > 0 THEN
            attack = INT(((INT(RND * 3) + 2) * enemystats(i).STR) - ((INT(RND * 3) + 2) * playerstats.DEFEN))
            puttile 7 + i, 5
            putenemy tofight, 7 + i, 6
            IF attack > 0 THEN
              FOR j = 1 TO 3
                puttile 7, 8
                putplayer 7, 8
              NEXT j
              clrtext
              msgbox "The " + RTRIM$(enemystats(toattack).NAM), " attacks you and does" + STR$(attack) + " damage"
              playerstats.HP = playerstats.HP - attack
              pause
              puttile 7 + i, 6
              putenemy tofight, 7 + i, 5
              clrtext
            ELSE
              clrtext
              msgbox "The " + RTRIM$(enemystats(toattack).NAM) + " missed you", ""
              pause
              puttile 7 + i, 6
              putenemy tofight, 7 + i, 5
              clrtext
            END IF
            IF playerstats.HP < 1 THEN gameover
            'done = 1
          ELSE
            dead = dead + 1
            IF dead = enum + 1 THEN
              IF enum > 0 THEN
                clrtext
                msgbox "You killed all the " + RTRIM$(enemytype(tofight).NAM) + "s", ""
                pause
                clrtext
              END IF
              done = 1
            END IF
          END IF
        NEXT i
       
       
    END IF
    clrtext
    msgbox "What do you want to do? (F)ight (R)un", "HP" + STR$(playerstats.HP) + "/" + STR$(playerstats.maxHP)
    k$ = UCASE$(INPUT$(1))
    clrtext
    SELECT CASE k$
      CASE "R"
        getaway = INT(RND * playerstats.SPD) + 1
        IF getaway > playerstats.SPD / 2 + 1 THEN
          msgbox "You got away!", ""
          done = 1
          pause
          clrtext
        ELSE
          msgbox "You couldn't get away!", ""
          pause
          ran = 1
        END IF
      CASE "F"
        IF enum > 0 THEN
          DO
          lup = 1
          clrtext
          msgbox "Which enemy to attack?", "1 to " + STR$(enum + 1)
          toattack = VAL(INPUT$(1)) - 1
          IF toattack < 0 THEN toattack = 0
          IF toattack > enum THEN toattack = enum
          IF enemystats(toattack).HP < 1 THEN
            clrtext
            msgbox "That enemy is already dead!", ""
            pause
            lup = 0
          END IF
          LOOP UNTIL lup
        ELSE
          toattack = 0
        END IF
        attack = ((INT(RND * 3) + 2) * playerstats.STR) - ((INT(RND * 3) + 2) * enemystats(toattack).DEFEN)
        putplayer 7, 7
        puttile 7, 8
        IF attack > 0 THEN
          FOR i = 1 TO 3
            puttile 7 + toattack, 5
            putenemy tofight, 7 + toattack, 5
          NEXT i
          clrtext
          msgbox "You attack the " + RTRIM$(enemystats(toattack).NAM), " and do" + STR$(attack) + " damage"
          enemystats(toattack).HP = enemystats(toattack).HP - attack
          pause
          putplayer 7, 8
          puttile 7, 7
          clrtext
        ELSE
          clrtext
          msgbox "You missed the " + RTRIM$(enemystats(toattack).NAM), ""
          pause
          putplayer 7, 8
          puttile 7, 7
          clrtext
        END IF
        IF enemystats(toattack).HP < 1 THEN
          playerstats.EX = playerstats.EX + enemystats(toattack).EX
          puttile 7 + toattack, 5
          clrtext
          msgbox "You killed the " + RTRIM$(enemystats(toattack).NAM), "and recieved" + STR$(enemystats(toattack).EX) + " experience"
          pause
          clrtext
        END IF
        dead = 0
        FOR i = 0 TO enum
          IF enemystats(i).HP > 0 THEN
            attack = INT((1 + (INT(RND * 3) + 2) * enemystats(i).STR) - ((INT(RND * 3) + 2) * playerstats.DEFEN))
            puttile 7 + i, 5
            putenemy tofight, 7 + i, 6
            IF attack > 0 THEN
              FOR j = 1 TO 3
                puttile 7, 8
                putplayer 7, 8
              NEXT j
              clrtext
              msgbox "The " + RTRIM$(enemystats(toattack).NAM), " attacks you and does" + STR$(attack) + " damage"
              playerstats.HP = playerstats.HP - attack
              pause
              puttile 7 + i, 6
              putenemy tofight, 7 + i, 5
              clrtext
            ELSE
              clrtext
              msgbox "The " + RTRIM$(enemystats(toattack).NAM) + " missed you", ""
              pause
              puttile 7 + i, 6
              putenemy tofight, 7 + i, 5
              clrtext
            END IF
            IF playerstats.HP < 1 THEN gameover
            IF ded = 1 THEN done = 1
            IF done = 1 THEN pause
            clrtext
          ELSE
            dead = dead + 1
            IF dead = enum + 1 THEN
              IF enum > 0 THEN
                clrtext
                msgbox "You killed all the " + RTRIM$(enemytype(tofight).NAM) + "s", ""
                pause
                clrtext
              END IF
              done = 1
            END IF
          END IF
        NEXT i
      END SELECT
    LOOP UNTIL done

    IF playerstats.EX >= (playerstats.LVL * 75 + ((playerstats.LVL - 1) * (playerstats.LVL - 1)) * 5) THEN
      playerstats.LVL = playerstats.LVL + 1
      playerstats.STR = playerstats.STR + 1
      playerstats.maxHP = playerstats.maxHP + 5
      playerstats.HP = playerstats.maxHP
      playerstats.DEFEN = playerstats.DEFEN + 1
      clrtext
      msgbox "You gained a level! Experience, ", "HitPoints, and Defense all increased"
      pause
      clrtext
    END IF

    curmap = tempmap
    playerdir = tempdir
    msgbox "Exiting Battle...", ""
    drawmap
    clrtext
    putplayer playerx, playery

  END IF

END SUB

SUB gameover

  msgbox "You Have Died! You are a failure to", "your country And to your people!"
  ded = 1
  
END SUB

SUB intro

  w "Paul Bonser", 100, 1, 4, 1, 40
  w "3rd Period", 100, 24, 4, 1, 40
  w "Book Report", 100, 32, 4, 1, 40
  w "Press any key to continue", 50, 80, 4, 1, 40
  pause
  CLS

  w "BIBLIOGRAPHY", 100, 1, 4, 1, 40
  w "David Brin, The Postman, (C)1985", 25, 24, 4, 1, 40
  w "321/321 read", 100, 34, 4, 1, 40
  w "Press any key to continue", 50, 80, 4, 1, 40
  LINE (122, 32)-(209, 32), 4
  pause
  CLS
  '  ________________________________________
  w "The year is is 2010. Civilization is", 1, 8, 4, 1, 40
  w "just beginning to be rebuilt after a", 1, 16, 4, 1, 40
  w "nuclear war. The world would still be in", 1, 24, 4, 1, 40
  w "chaos if it were not for one man, Gordon", 1, 32, 4, 1, 40
  w "Krantz. Better Known as...", 1, 40, 4, 1, 40
  pause
  curmap = 36
  drawmap
  pause
  curmap = 0
  drawmap
  putenemy 4, 3, 3
  msgbox "GORDON: Ahh that's a good cup of tea...", ""
  pause
  putenemy 2, 0, 8
  clrtext
  msgbox "GORDON: Hey, What's that in the woods?", ""
  pause
  puttile 0, 8
  putenemy 2, 1, 7
  putenemy 1, 0, 8
  FOR i = 1 TO 100000: NEXT i
  puttile 1, 7
  puttile 0, 8
  putenemy 2, 2, 6
  putenemy 1, 1, 7
  putenemy 0, 0, 8
  FOR i = 1 TO 100000: NEXT i
  clrtext
  msgbox "GORDON: Oh no, survivalists!", ""
  pause
  puttile 2, 6
  puttile 1, 7
  puttile 0, 8
  putenemy 2, 3, 5
  putenemy 1, 2, 6
  putenemy 0, 1, 7
  FOR i = 1 TO 100000: NEXT i
  puttile 3, 5
  puttile 2, 6
  puttile 1, 7
  putenemy 2, 4, 5
  putenemy 1, 3, 5
  putenemy 0, 2, 6
  FOR i = 1 TO 100000: NEXT i
  puttile 4, 5
  puttile 3, 5
  puttile 2, 6
  putenemy 2, 5, 5
  putenemy 1, 4, 5
  putenemy 0, 3, 5
  FOR i = 1 TO 100000: NEXT i
  puttile 5, 5
  puttile 4, 5
  puttile 3, 5
  putenemy 2, 6, 5
  putenemy 1, 5, 5
  putenemy 0, 4, 5
  FOR i = 1 TO 100000: NEXT i
  clrtext
  msgbox "SURVIVALIST LEADER: Get him!", "SURVIVALIST: 'right Jas"
  pause
  puttile 5, 5
  puttile 4, 5
  
  putenemy 1, 5, 4
  putenemy 0, 4, 4
 
  FOR j = 3 TO 14
    puttile j, 3
    putenemy 4, j + 1, 3
    FOR i = 1 TO 25000: NEXT i
  NEXT j
  puttile 15, 3
  FOR i = 1 TO 100000: NEXT i
  clrtext
  msgbox "SURVIVALIST: Look at him run like a", "scared rabbit! Hehehe!"
  pause
  FOR j = 6 TO 4 STEP -1
    puttile j, 5
    putenemy 2, j - 1, 5
    FOR i = 1 TO 25000: NEXT i
  NEXT j
  clrtext
  
    w "JAS: Let him go, he can't survive", 1, 184, 4, 1, 40
    w "without this. Hahaha!!", 1, 192, 4, 1, 40
    FOR i = 1 TO 500000: NEXT i
  map(0, 3, 5) = 18
  puttile 3, 5
  putenemy 2, 4, 5
  pause
  CLS
  '  ________________________________________
  w "After Gordon is robbed, he trys to track", 1, 8, 4, 1, 40
  w "down the survivalists who robbed him.", 1, 16, 4, 1, 40
  w "Instead of survivalists, he finds a Jeep", 1, 24, 4, 1, 40
  w "with a dead postman in it. Taking the", 1, 32, 4, 1, 40
  w "clothes of the dead postman, Gordon un-", 1, 40, 4, 1, 40
  w "wittingly sparks a flame that will help", 1, 48, 4, 1, 40
  w "civilization to rise once more...", 1, 56, 4, 1, 40
  pause
  CLS
  '  ________________________________________
  w "Your name is John Bonser, grandson of", 1, 8, 4, 1, 40
  w "one of our greatest Presidents, Paul", 1, 16, 4, 1, 40
  w "Bonser. The Postman came to your city,", 1, 24, 4, 1, 40
  w "Rainier, and chose you to be one of the", 1, 32, 4, 1, 40
  w "local mailmen. You were greatly honored", 1, 40, 4, 1, 40
  w "and very excited about your first", 1, 48, 4, 1, 40
  w "mission...", 1, 56, 4, 1, 40
  pause
  CLS
  '  ________________________________________
  w "Your mission is to go south to the city", 1, 8, 4, 1, 40
  w "of Vernonia. They are expecting a", 1, 16, 4, 1, 40
  w "package that you are carrying. Hurry, it", 1, 24, 4, 1, 40
  w "is very important, and watch out for", 1, 32, 4, 1, 40
  w "survivalists. Good luck and goodbye...", 1, 40, 4, 1, 40
  pause



END SUB

SUB loadmaps

CHDIR "maps"

OPEN "intro.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(0, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(0).left = 1
maps(0).right = 1

OPEN "1n5.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(1, x, y)
      map(5, x, y) = map(1, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(1).left = 1
maps(1).right = 2
maps(5).left = 4
maps(5).right = 5

OPEN "2.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(2, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(2).left = 1
maps(2).right = 3
maps(2).down = 7

OPEN "3.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(3, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(3).left = 2
maps(3).right = 4
maps(3).down = 8

OPEN "4.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(4, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(4).left = 3
maps(4).right = 5
maps(4).down = 9

OPEN "6n33.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(6, x, y)
      map(35, x, y) = map(6, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(6).left = 10
maps(6).right = 6
maps(33).left = 33
maps(33).right = 10


OPEN "7.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(7, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(7).left = 7
maps(7).right = 8
maps(7).up = 2
maps(7).down = 12

OPEN "8.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(8, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(8).left = 7
maps(8).right = 9
maps(8).up = 3
maps(8).down = 13

OPEN "9.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(9, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(9).left = 8
maps(9).right = 10
maps(9).up = 4
maps(9).down = 14

OPEN "10.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(10, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(10).left = 33
maps(10).right = 6
maps(10).up = 31
maps(10).down = 15

OPEN "11.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(11, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(11).left = 15
maps(11).right = 15
maps(11).up = 15
maps(11).down = 15

OPEN "12.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(12, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(12).left = 11
maps(12).right = 13
maps(12).up = 7
maps(12).down = 17

OPEN "13.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(13, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(13).left = 12
maps(13).right = 14
maps(13).up = 8
maps(13).down = 18

OPEN "14.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(14, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(14).left = 13
maps(14).right = 15
maps(14).up = 9
maps(14).down = 19

OPEN "15.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(15, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(15).left = 15
maps(15).right = 15
maps(15).up = 10
maps(15).down = 15

OPEN "lr.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(16, x, y)
      map(19, x, y) = map(16, x, y)
      map(20, x, y) = map(16, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(16).left = 20
maps(16).right = 17
maps(19).left = 25
maps(19).right = 20
maps(20).left = 19
maps(20).right = 16

OPEN "17.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(17, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(17).left = 16
maps(17).right = 18
maps(17).up = 12
maps(17).down = 15

OPEN "18n28.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(18, x, y)
      map(28, x, y) = map(18, x, y)
      map(32, x, y) = map(18, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(18).left = 17
maps(18).up = 13
maps(28).left = 27
maps(28).up = 23
maps(32).left = 31
maps(32).up = 27

OPEN "21.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(21, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(21).down = 26

OPEN "22.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(22, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(22).right = 23
maps(22).up = 34

OPEN "23.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(23, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(23).left = 22
maps(23).down = 28

OPEN "ud.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(24, x, y)
      map(30, x, y) = map(24, x, y)
      map(35, x, y) = map(24, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(24).up = 35
maps(24).down = 29
maps(30).up = 25
maps(30).down = 35
maps(35).up = 30
maps(35).down = 24

OPEN "25n27.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(25, x, y)
      map(27, x, y) = map(25, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(25).right = 19
maps(25).down = 30
maps(27).right = 28
maps(27).down = 32

OPEN "26.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(26, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(26).up = 21
maps(26).down = 31

OPEN "29.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(29, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(29).up = 24
maps(29).down = 34

OPEN "31.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(31, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(31).right = 32
maps(31).up = 26
maps(31).down = 10

OPEN "34.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(34, x, y)
    NEXT x
  NEXT y
CLOSE #1
maps(34).up = 29
maps(34).down = 22

OPEN "postman.map" FOR INPUT AS #1
  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(36, x, y)
    NEXT x
  NEXT y
CLOSE #1

CHDIR ".."

END SUB

SUB loadpal (touse() AS LONG)

  DEF SEG = VARSEG(touse(0))
  FOR temp% = 0 TO 255
    OUT &H3C8, temp%
    OUT &H3C9, PEEK(VARPTR(touse(temp%)))
    OUT &H3C9, PEEK(VARPTR(touse(temp%)) + 1)
    OUT &H3C9, PEEK(VARPTR(touse(temp%)) + 2)
  NEXT
  DEF SEG

END SUB

SUB loadtiles

CHDIR "tiles"
'----------------------Player-------------------
'load player data
OPEN "playern1.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, player(0, 0, x, y)
  NEXT x
NEXT y
CLOSE #1

OPEN "playern2.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, player(0, 1, x, y)
  NEXT x
NEXT y
CLOSE #1

OPEN "playere1.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, player(1, 0, x, y)
  NEXT x
NEXT y
CLOSE #1

OPEN "playere2.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, player(1, 1, x, y)
  NEXT x
NEXT y
CLOSE #1

OPEN "players1.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, player(2, 0, x, y)
  NEXT x
NEXT y
CLOSE #1

OPEN "players2.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, player(2, 1, x, y)
  NEXT x
NEXT y
CLOSE #1

OPEN "playerw1.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, player(3, 0, x, y)
  NEXT x
NEXT y
CLOSE #1

OPEN "playerw2.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, player(3, 1, x, y)
  NEXT x
NEXT y
CLOSE #1

'-----------------Tiles----------------------------

OPEN "dirt.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(0, x, y)
  NEXT x
NEXT y
CLOSE #1

OPEN "tree.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(1, x, y)
  NEXT x
NEXT y
CLOSE #1

OPEN "grass.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(2, x, y)
  NEXT x
NEXT y
CLOSE #1

OPEN "wall.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(3, x, y)
  NEXT x
NEXT y
CLOSE #1


'load sidewalk data
OPEN "sidewalk.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(4, x, y)
  NEXT x
NEXT y
CLOSE #1

'load left door data
OPEN "doorl.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(5, x, y)
  NEXT x
NEXT y
CLOSE #1

'load right door data
OPEN "doorr.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(6, x, y)
  NEXT x
NEXT y
CLOSE #1

'load letters
OPEN "the.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(7, x, y)
  NEXT x
NEXT y
CLOSE #1
OPEN "p.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(8, x, y)
  NEXT x
NEXT y
CLOSE #1
OPEN "o.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(9, x, y)
  NEXT x
NEXT y
CLOSE #1
OPEN "s.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(10, x, y)
  NEXT x
NEXT y
CLOSE #1
OPEN "t.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(11, x, y)
  NEXT x
NEXT y
CLOSE #1
OPEN "m.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(12, x, y)
  NEXT x
NEXT y
CLOSE #1
OPEN "a.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(13, x, y)
  NEXT x
NEXT y
CLOSE #1
OPEN "n.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(14, x, y)
  NEXT x
NEXT y
CLOSE #1

'Load black tile
OPEN "black.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(15, x, y)
  NEXT x
NEXT y
CLOSE #1

'Load fire tile
OPEN "fire.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(16, x, y)
  NEXT x
NEXT y
CLOSE #1

'Load tent tile
OPEN "tent.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(17, x, y)
  NEXT x
NEXT y
CLOSE #1

'Load trashed tent tile
OPEN "badtent.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, tile(18, x, y)
  NEXT x
NEXT y
CLOSE #1


'------------------Enemys----------------------
'load holnist data
OPEN "holnist.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, enemy(3, x, y)
  NEXT x
NEXT y
CLOSE #1
enemytype(3).NAM = "Holnist"
enemytype(3).HP = 55
enemytype(3).EX = 55
enemytype(3).DEFEN = 5.5
enemytype(3).STR = 6.25

'load survivalist data
OPEN "survival.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, enemy(2, x, y)
  NEXT x
NEXT y
CLOSE #1
enemytype(2).NAM = "Survivalist"
enemytype(2).HP = 40
enemytype(2).EX = 30
enemytype(2).DEFEN = 2.5
enemytype(2).STR = 4.5

'load stupid survivalist data
OPEN "stupid.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, enemy(1, x, y)
  NEXT x
NEXT y
CLOSE #1
enemytype(1).NAM = "Stupid Survivalist"
enemytype(1).HP = 25
enemytype(1).EX = 25
enemytype(1).DEFEN = 1.5
enemytype(1).STR = 2.75
'load retarded survivalist data
OPEN "retard.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, enemy(0, x, y)
  NEXT x
NEXT y
CLOSE #1
enemytype(0).NAM = "Retarded Survivalist"
enemytype(0).HP = 12
enemytype(0).EX = 20
enemytype(0).DEFEN = 1
enemytype(0).STR = 1.55

'Load Gordon data, not really an enemy, but now i can use putenemy to move him
OPEN "gordon.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, enemy(4, x, y)
  NEXT x
NEXT y
CLOSE #1
CHDIR ".."

END SUB

SUB movedown
 
  IF playerdir <> 2 THEN playerdir = 2
    IF playery + 1 <= 8 THEN
      IF map(curmap, playerx, playery + 1) >= 0 THEN
        puttile playerx, playery
        playery = playery + 1
      END IF
    ELSE
      playery = 0
      curmap = maps(curmap).down
      puttile playerx, playery
      drawmap
      putplayer playerx, playery

    END IF
    putplayer playerx, playery

END SUB

SUB moveleft

  IF playerdir <> 3 THEN playerdir = 3
    IF playerx - 1 >= 0 THEN
      IF map(curmap, playerx - 1, playery) >= 0 THEN
        puttile playerx, playery
        playerx = playerx - 1
      END IF
    ELSE
      playerx = 15
      curmap = maps(curmap).left
      puttile playerx, playery
      drawmap
      putplayer playerx, playery
    END IF
    putplayer playerx, playery


END SUB

SUB moveright

  IF playerdir <> 1 THEN playerdir = 1
    IF playerx + 1 <= 15 THEN
      IF map(curmap, playerx + 1, playery) >= 0 THEN
        puttile playerx, playery
        playerx = playerx + 1
      END IF
    ELSE
      playerx = 0
      curmap = maps(curmap).right
      puttile playerx, playery
      drawmap
      putplayer playerx, playery
    END IF
    putplayer playerx, playery
 
END SUB

SUB moveup
 
  IF playerdir <> 0 THEN playerdir = 0
    IF playery - 1 >= 0 THEN
      IF map(curmap, playerx, playery - 1) >= 0 THEN
        puttile playerx, playery
        playery = playery - 1
      END IF
    ELSE
      playery = 8
      curmap = maps(curmap).up
      puttile playerx, playery
      drawmap
      putplayer playerx, playery
    END IF
    putplayer playerx, playery
 

END SUB

SUB msgbox (msg1$, msg2$)
 
    w msg1$, 1, 184, 4, 1, 40
    w msg2$, 1, 192, 4, 1, 40

END SUB

SUB pause
  
  DO: LOOP WHILE INKEY$ = ""

END SUB

SUB putenemy (enum, EX, ey)
 
  DEF SEG = &HA000
  FOR y = 0 TO 19
    FOR x = 0 TO 19
      IF enemy(enum, x, y) > 0 THEN
        temp& = (y + ey * 20) * 320 + (x + EX * 20)
        POKE temp&, enemy(enum, x, y)
      END IF
    NEXT x
  NEXT y
  DEF SEG
  
END SUB

SUB putplayer (tilex, tiley)

  IF movenum THEN
    movenum = 0
  ELSE
    movenum = 1
  END IF


  puttile playerx, playery
  DEF SEG = &HA000
  FOR y = 0 TO 19
    FOR x = 0 TO 19
      IF player(playerdir, movenum, x, y) > 0 THEN
        temp& = (y + tiley * 20) * 320 + (x + tilex * 20)
        POKE temp&, player(playerdir, movenum, x, y)
      END IF
    NEXT x
  NEXT y
  DEF SEG
 

END SUB

SUB puttile (tilex, tiley)

  DEF SEG = &HA000
  FOR y = 0 TO 19
    FOR x = 0 TO 19
        temp& = (y + tiley * 20) * 320 + (x + tilex * 20)
        tmp = map(curmap, tilex, tiley)
        POKE temp&, tile(ABS((tmp)), x, y)
    NEXT x
  NEXT y
  DEF SEG

END SUB

SUB rotatepal

  IF rotdir THEN
    FOR i = 0 TO 188
      SWAP pale(i), pale(i + 1)
      
      
    NEXT i
  ELSE
    FOR i = 188 TO 1 STEP -1
      SWAP pale(i), pale(i - 1)
      
      
    NEXT i
  END IF
   
  SWAP pale(0), pale(188)
  
  

END SUB

DEFINT A-Z
SUB w (a$, x%, y%, Co%, Bkgd%, Shadow%)

DEFINT A-Z
extX% = 8: extY% = 0
DEF SEG = &HFFA6
 FOR i% = 1 TO LEN(a$)
   ADDR% = 8 * ASC(MID$(a$, i%)) + 14
IF Background% THEN
IF Background% = 256 THEN BG% = false ELSE BG% = Bkgd%
IF i% = LEN(a$) THEN extX% = false: extY% = false
LINE (x%, y%)-(x% + 7 + extX%, y% + 7 + extY%), BG%, BF
END IF
FOR j% = 0 TO 7: mask% = PEEK(ADDR% + j%) * 128
IF Shadow% THEN
IF Shadow% > 1 THEN
LINE (x% + 9, y% + j% + 2)-(x% + 1, y% + j% + 1), Shadow%, , mask%
ELSE
LINE (x% + 9, y% + j% + 2)-(x% + 2, y% + j% + 2), 0, , mask%
END IF
END IF
LINE (x% + 7, y% + j%)-(x%, y% + j%), Co%, , mask%
NEXT: x% = x% + extX%: y% = y% + extY%:  NEXT: DEF SEG
END SUB

DEFSNG A-Z
SUB wingame
  CLS
  PRINT "           CONGRATULATIONS"
  PRINT "You have accomplished your mission."
  PRINT "This concludes this pre-release demo"
  PRINT "of The POSTMAN"

END SUB

