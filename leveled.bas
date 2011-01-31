DECLARE SUB showcurtile ()
DECLARE SUB setwalk ()
DECLARE SUB settile ()
DECLARE SUB load ()
DECLARE SUB tiledown ()
DECLARE SUB save ()
DECLARE SUB tileup ()
DECLARE SUB newmap ()
DECLARE SUB w (a$, x%, y%, Co%, Bkgd%, Shadow%)
DECLARE SUB msgbox (msg1$, msg2$)
DECLARE SUB loadtiles ()
DECLARE SUB loadmaps ()
DECLARE SUB dopal ()
DECLARE SUB rotatepal ()
DECLARE SUB loadpal (touse() AS LONG)
DECLARE SUB putcursor (tilex!, tiley!)
DECLARE SUB movedown ()
DECLARE SUB moveleft ()
DECLARE SUB moveright ()
DECLARE SUB moveup ()
DECLARE SUB puttile (tilex!, tiley!)
DECLARE SUB drawmap ()
SCREEN 13
CONST numtiles = 19
 
DIM SHARED tile(numtiles - 1, 19, 19)
DIM SHARED map(15, 8)
DIM SHARED cursor(19, 19)
DIM SHARED cursorx, cursory, curtile, walkable$
DIM SHARED pale(255) AS LONG

dopal
loadtiles
newmap
LINE (0, 180)-(319, 180), 40
LINE (0, 181)-(319, 181), 4
LINE (0, 182)-(319, 182), 40

curtile = 0
cursorx = 2
cursory = 2
walkable$ = "W"
drawmap
showcurtile
putcursor 2, 2
DO
  K$ = INKEY$
  SELECT CASE UCASE$(RIGHT$(K$, 1))
    CASE "H"
      moveup
    CASE "P"
      movedown
    CASE "K"
      moveleft
    CASE "M"
      moveright
    CASE " "
      settile
    CASE "S"
      save
    CASE "L"
      load
    CASE "+"
      tileup
    CASE "-"
      tiledown
    CASE "*"
      setwalk
    CASE CHR$(27)
      EXIT DO
  END SELECT
LOOP

INPUT "Would you like to save"; yn$
IF UCASE$(yn$) = "Y" THEN save

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

SUB load

  INPUT "Name Of File"; file$
  OPEN file$ FOR INPUT AS #1

  FOR y = 0 TO 8
    FOR x = 0 TO 15
      INPUT #1, map(x, y)
    NEXT x
  NEXT y
  CLOSE #1
  drawmap
  putcursor cursorx, cursory

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

'load cursor data
OPEN "cursor.til" FOR INPUT AS #1
FOR y = 0 TO 19
  FOR x = 0 TO 19
    INPUT #1, cursor(x, y)
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



END SUB

SUB movedown

  puttile cursorx, cursory
  IF cursory < 8 THEN
    cursory = cursory + 1
  ELSE
    cursory = 0
  END IF
  putcursor cursorx, cursory

END SUB

SUB moveleft

  puttile cursorx, cursory
  IF cursorx > 0 THEN
    cursorx = cursorx - 1
  ELSE
    cursorx = 15
  END IF
  putcursor cursorx, cursory

END SUB

SUB moveright

  puttile cursorx, cursory
  IF cursorx < 15 THEN
    cursorx = cursorx + 1
  ELSE
    cursorx = 0
  END IF
  putcursor cursorx, cursory
 
END SUB

SUB moveup

  puttile cursorx, cursory
  IF cursory > 0 THEN
    cursory = cursory - 1
  ELSE
    cursory = 8
  END IF
  putcursor cursorx, cursory
 

END SUB

SUB msgbox (msg1$, msg2$)
 
    w msg1$, 1, 184, 4, 1, 40
    w msg2$, 1, 192, 4, 1, 40

END SUB

SUB newmap

  FOR y = 0 TO 8
    FOR x = 0 TO 15
      map(x, y) = 2
    NEXT x
  NEXT y

END SUB

SUB putcursor (tilex, tiley)

  puttile cursorx, cursory
  DEF SEG = &HA000
  FOR y = 0 TO 19
    FOR x = 0 TO 19
      IF cursor(x, y) > 0 THEN
        temp& = (y + tiley * 20) * 320 + (x + tilex * 20)
        POKE temp&, cursor(x, y)
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
        POKE temp&, tile(ABS(map(tilex, tiley)), x, y)
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

SUB save

  INPUT "Name of file"; file$
  OPEN file$ FOR OUTPUT AS #1

  FOR y = 0 TO 8
    FOR x = 0 TO 15
      PRINT #1, map(x, y);
      PRINT #1, ",";
    NEXT x
  NEXT y
  CLOSE #1
  PRINT "File Saved"
  PRINT "Press any key to return to program"
  DO
  LOOP WHILE INKEY$ = ""
  drawmap
  putcursor cursorx, cursory

END SUB

SUB settile

  IF walkable$ = "W" THEN
    map(cursorx, cursory) = curtile
  ELSE
    map(cursorx, cursory) = -curtile
  END IF
  puttile cursorx, cursory
  putcursor cursorx, cursory

END SUB

SUB setwalk

  IF walkable$ = "W" THEN
    walkable$ = "NW"
  ELSE
    walkable$ = "W"
  END IF
  showcurtile

END SUB

SUB showcurtile

  DEF SEG = &HA000
  FOR y = 0 TO 19
    FOR x = 0 TO 19
        temp& = (y + 9 * 20) * 320 + (x + 15 * 20)
        POKE temp&, tile(curtile, x, y)
    NEXT x
  NEXT y
  DEF SEG

  LINE (280, 184)-(299, 200), 0, BF
  w walkable$, 280, 184, 4, 1, 40

END SUB

SUB tiledown

  IF curtile > 0 THEN
    curtile = curtile - 1
  ELSE
    curtile = numtiles - 1
  END IF
  showcurtile

END SUB

SUB tileup
 
  IF curtile < numtiles - 1 THEN
    curtile = curtile + 1
  ELSE
    curtile = 0
  END IF
  
  showcurtile

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

