'Tile Editor - Paul Bonser




DECLARE SUB reflect ()
DECLARE SUB promptsave ()
DECLARE SUB pickup ()
DECLARE SUB changeall ()
DECLARE SUB choosecol ()
DECLARE SUB load ()
DECLARE SUB refresh ()
DECLARE SUB save ()
DECLARE SUB pgup ()
DECLARE SUB pgdown ()
DECLARE SUB drawcurcol ()
DECLARE SUB settile ()
DECLARE SUB nextcol ()
DECLARE SUB prevcol ()
DECLARE SUB moveup ()
DECLARE SUB movedown ()
DECLARE SUB moveleft ()
DECLARE SUB moveright ()
DECLARE SUB drawtile ()
DECLARE SUB drawbigtile ()
DECLARE SUB dopal ()


SCREEN 13
DIM SHARED cx, cy, curcol
DIM SHARED tile(19, 19)


loadnew:
FOR y = 0 TO 19
  FOR x = 0 TO 19
    tile(x, y) = 15
  NEXT x
NEXT y

dopal
cx = 19
cy = 19
refresh


DO
k$ = INKEY$
SELECT CASE RIGHT$(UCASE$(k$), 1)
  CASE " "
    settile
  CASE "H"
    moveup
  CASE "P"
    movedown
  CASE "K"
    moveleft
  CASE "M"
    moveright
  CASE "I"
    pgup
  CASE "Q"
    pgdown
  CASE "S"
    save
  CASE "L"
    load
  CASE "C"
    choosecol
  CASE "U"
    pickup
  CASE "A"
    changeall
  CASE "R"
    reflect
  CASE "N"
    promptsave
    GOTO loadnew
  CASE "+"
    nextcol
  CASE "-"
    prevcol
  CASE CHR$(27)
    EXIT DO
  CASE ELSE
    'IF LEN(k$) > 0 THEN PRINT RIGHT$(UCASE$(k$), 1)
END SELECT

LOOP

promptsave

SUB changeall

  LOCATE 6, 27
  INPUT "Change All"; yn$
  IF UCASE$(LEFT$(yn$, 1)) = "Y" THEN
    FOR y = 0 TO 19
      FOR x = 0 TO 19
        IF tile(x, y) = tile(cx, cy) THEN tile(x, y) = curcol
      NEXT x
    NEXT y
  END IF
  refresh

END SUB

SUB choosecol
  
  LOCATE 6, 27
  INPUT curcol
  refresh
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

SUB drawbigtile
  
  FOR y = 0 TO 19
    FOR x = 0 TO 19
      LINE (x * 10 + 1, y * 10 + 1)-(x * 10 + 9, y * 10 + 9), tile(x, y), BF
    NEXT x
  NEXT y

END SUB

SUB drawcurcol

  LINE (210, 24)-(310, 29), curcol, BF
  LOCATE 2, 27
  PRINT "    "
  LOCATE 2, 27
  PRINT curcol
  LOCATE 2, 35
  PRINT "    "
  LOCATE 2, 35
  PRINT tile(cx, cy)



END SUB

SUB drawtile
  
  FOR y = 0 TO 19
    FOR x = 0 TO 19
      PSET (x + 250, y), tile(x, y)
    NEXT x
  NEXT y

END SUB

SUB load
  CLS
  INPUT "File Name"; file$
  OPEN file$ FOR INPUT AS #1
  FOR y = 0 TO 19
    FOR x = 0 TO 19
      INPUT #1, tile(x, y)
    NEXT x
  NEXT y
  CLOSE #1
  CLS
  refresh
  
END SUB

SUB movedown

  IF cy < 19 THEN
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 0, B
    cy = cy + 1
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 15, B
  ELSE
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 0, B
    cy = 0
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 15, B
  END IF
  drawcurcol
END SUB

SUB moveleft

  IF cx > 0 THEN
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 0, B
    cx = cx - 1
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 15, B
  ELSE
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 0, B
    cx = 19
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 15, B
   
  END IF
  drawcurcol
END SUB

SUB moveright

  IF cx < 19 THEN
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 0, B
    cx = cx + 1
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 15, B
  ELSE
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 0, B
    cx = 0
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 15, B
   
  END IF
  drawcurcol
END SUB

SUB moveup
 
  IF cy > 0 THEN
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 0, B
    cy = cy - 1
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 15, B
  ELSE
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 0, B
    cy = 19
    LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 15, B
   
  END IF
  drawcurcol
END SUB

SUB nextcol
 
  IF curcol < 255 THEN
    curcol = curcol + 1
  ELSE
    curcol = 0
  END IF
  drawcurcol

END SUB

SUB pgdown
  FOR i = 1 TO 5
    nextcol
  NEXT i
END SUB

SUB pgup
  FOR i = 1 TO 5
    prevcol
  NEXT i
END SUB

SUB pickup

  curcol = tile(cx, cy)
  drawcurcol

END SUB

SUB prevcol

  IF curcol > 0 THEN
    curcol = curcol - 1
  ELSE
    curcol = 255
  END IF
  drawcurcol

END SUB

SUB promptsave
  
   CLS
   INPUT "Do You Want To Save Tile"; yn$
   IF LEFT$(UCASE$(yn$), 1) = "Y" THEN save

END SUB

SUB reflect

  FOR y = 0 TO 19
    FOR i = 0 TO 9
      SWAP tile(i, y), tile(19 - i, y)
    NEXT i
  NEXT y
  refresh
    
END SUB

SUB refresh

  CLS
  drawbigtile
  drawtile
  drawcurcol
  LINE (cx * 10, cy * 10)-(cx * 10 + 10, cy * 10 + 10), 15, B
  LOCATE 5, 27
  PRINT "Current Color"
  LINE (209, 23)-(311, 30), 15, B

END SUB

SUB save
  CLS
  INPUT "File Name"; file$
  OPEN file$ FOR OUTPUT AS #1
  FOR y = 0 TO 19
    FOR x = 0 TO 19
      PRINT #1, tile(x, y);
      PRINT #1, ",";
    NEXT x
  NEXT y
  CLOSE #1
  PRINT "File Saved"
  PRINT "Press Any Key To Return To Program"
  DO: LOOP WHILE INKEY$ = ""
  CLS
  refresh
END SUB

SUB settile
  tile(cx, cy) = curcol
  LINE (cx * 10 + 1, cy * 10 + 1)-(cx * 10 + 9, cy * 10 + 9), tile(cx, cy), BF
  drawtile
  drawcurcol
END SUB

