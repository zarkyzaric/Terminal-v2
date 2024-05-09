﻿;/*
;===========================================
;  FindText - Capture screen image into text and then find it
;  https://autohotkey.com/boards/viewtopic.php?f=6&t=17834
;
;  Author  : FeiYue
;  Version : 8.9
;  Date    : 2022-05-28
;
;  Usage:  (required AHK v2.0 beta 7)
;  1. Capture the image to text string.
;  2. Test find the text string on full Screen.
;  3. When test is successful, you may copy the code
;     and paste it into your own script.
;     Note: Copy the "FindText()" function and the following
;     functions and paste it into your own script Just once.
;  4. The more recommended way is to save the script as
;     "FindText.ahk" and copy it to the "Lib" subdirectory
;     of AHK program, instead of copying the "FindText()"
;     function and the following functions, add a line to
;     the beginning of your script: #Include <FindText>
;  5. If you want to call a method in the "FindTextClass" class,
;     use the parameterless FindText() to get the default object
;
;===========================================
;*/


if (!A_IsCompiled and A_LineFile=A_ScriptFullPath)
	FindText().Gui("Show")
  
  
  ;===== Copy The Following Functions To Your Own Code Just once =====
  
  
  ;--------------------------------
  ;  FindText - Capture screen image into text and then find it
  ;--------------------------------
  ;  returnArray := FindText(
  ;      &OutputX --> The name of the variable used to store the returned X coordinate
  ;    , &OutputY --> The name of the variable used to store the returned Y coordinate
  ;    , X1 --> the search scope's upper left corner X coordinates
  ;    , Y1 --> the search scope's upper left corner Y coordinates
  ;    , X2 --> the search scope's lower right corner X coordinates
  ;    , Y2 --> the search scope's lower right corner Y coordinates
  ;    , err1 --> Fault tolerance percentage of text       (0.1=10%)
  ;    , err0 --> Fault tolerance percentage of background (0.1=10%)
  ;    , Text --> can be a lot of text parsed into images, separated by "|"
  ;    , ScreenShot --> if the value is 0, the last screenshot will be used
  ;    , FindAll --> if the value is 0, Just find one result and return
  ;    , JoinText --> if you want to combine find, it can be 1, or an array of words to find
  ;    , offsetX --> Set the max text offset (X) for combination lookup
  ;    , offsetY --> Set the max text offset (Y) for combination lookup
  ;    , dir --> Nine directions for searching: up, down, left, right and center
  ;    , zoomW --> Zoom percentage of image width  (1.0=100%)
  ;    , zoomH --> Zoom percentage of image height (1.0=100%)
  ;  )
  ;
  ;  The function returns an Array containing all lookup results,
  ;  any result is a Map object with the following values:
  ;  {x:X, y:Y, w:W, h:H, mx:X+W//2, my:Y+H//2, id:Comment}
  ;  If no image is found, the function returns an empty array.
  ;  All coordinates are relative to Screen, colors are in RGB format
  ;
  ;  If the return variable is set to "ok", ok[1] is the first result found.
  ;  ok[1][1], ok[1][2] is the X, Y coordinate of the upper left corner of the found image,
  ;  ok[1][3] is the width of the found image, and ok[1][4] is the height of the found image,
  ;  ok[1].x <==> ok[1][1]+ok[1][3]//2 ( is the Center X coordinate of the found image ),
  ;  ok[1].y <==> ok[1][2]+ok[1][4]//2 ( is the Center Y coordinate of the found image ),
  ;  ok[1].id is the comment text, which is included in the <> of its parameter.
  ;
  ;  If &OutputX is equal to "wait" or "wait1"(appear), or "wait0"(disappear)
  ;  it means using a loop to wait for the image to appear or disappear.
  ;  the &OutputY is the wait time in seconds, time less than 0 means infinite waiting
  ;  Timeout means failure, returns 0. 
  ;  If you want to appear and the image is found, return the found array object, otherwise 0
  ;  If you want to disappear and the image cannot be found, return 1 (success)
  ;  Example 1: FindText(&X:="wait", &Y:=3, 0,0,0,0,0,0,Text)   ; Wait 3 seconds for appear
  ;  Example 2: FindText(&X:="wait0", &Y:=-1, 0,0,0,0,0,0,Text) ; Wait indefinitely for disappear
  ;--------------------------------
  
  FindText(&x := "FindTextClass", &y:="", args*)
  {
	  static FindTextInstance := FindTextClass()
	  if IsSet(x) && (x=="FindTextClass")
		  return FindTextInstance
	  else
		  return FindTextInstance.FindText(&x, &y, args*)
  }
  
  Class FindTextClass
  {  ;// Class Begin
  
	  static bind:=[], bits:=[], Lib:=[], Cursor:=0, FindText_Screen:=0
  
	  __New()
	  {
		  this.bind:={id:0, mode:0}, this.bits:={oldzh:0, oldzw:0, hBM:0}, this.Cursor:=0, this.Lib:=Map(), this.Lib.Default:=""
	  }
  
	  __Delete()
	  {
		  if (this.bits.hBM)
			  DllCall("DeleteObject", "Ptr", this.bits.hBM)
	  }
  
	  FindText(&OutputX:="", &OutputY:=""  
		, x1:="", y1:="", x2:="", y2:="", err1:="", err0:=""
		, text:="", ScreenShot:="", FindAll:=""
		, JoinText:="", offsetX:="", offsetY:="", dir:=""
		, zoomW:=1, zoomH:=1)
	  {
		if IsSet(OutputX) && RegExMatch(OutputX, "i)^\s*wait[10]?\s*$")
		{
		  found:=!InStr(OutputX, "0"), time:=OutputY
		  , timeout:=A_TickCount+Round(time*1000)
		  , OutputX:=OutputY:=""
		  Loop
		  {
			; Wait for the image to remain stable
			While (ok:=this.FindText(&OutputX, &OutputY
			  , x1, y1, x2, y2, err1, err0, text, ScreenShot, FindAll
			  , JoinText, offsetX, offsetY, dir, zoomW, zoomH))
			  and (found)
			{
			  v:=ok[1], x:=v.x, y:=v.y, w:=v.w, h:=v.h
			  Sleep(10)
			  if this.FindText(&null:=0, &null:=0, x, y, x+w-1, y+h-1
			  , err1, err0, text, ScreenShot, FindAll
			  , JoinText, offsetX, offsetY, dir, zoomW, zoomH)
				return (this.ok:=ok)
			}
			if (!found and !ok)
			  return 1
			if (time>=0 and A_TickCount>=timeout)
				return 0
			Sleep(50)
		  }
		  Throw Error("Infinite loop was escaped without break",-1)
		}
		if InStr(err1, "$") and !InStr(text, "$")
		{
		  dir:=offsetX, offsetY:=JoinText, offsetX:=FindAll
		  , JoinText:=ScreenShot, FindAll:=text, ScreenShot:=err0
		  , text:=err1, err0:=y2, err1:=x2
		  , y2:=y1, x2:=x1, y1:=OutputY, x1:=OutputX
		}
		(err1="" && err1:=0), (err0="" && err0:=0), (x1="" && x1:=0), (x2="" && x2:=0), (y1="" && y1:=0), (y2="" && y2:=0)
		, (ScreenShot="" && ScreenShot:=1)
		, (FindAll="" && FindAll:=1)
		, (JoinText="" && JoinText:=0)
		, (offsetX="" && offsetX:=20)
		, (offsetY="" && offsetY:=10)
		, (dir="" && dir:=1)
		if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
		  n:=150000, x:=y:=-n, w:=h:=2*n
		else
		  x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
		bits:=this.GetBitsFromScreen(&x,&y,&w,&h,ScreenShot,&zx,&zy,&zw,&zh)  , x-=zx, y-=zy, info:=[], this.ok:=0
		Loop Parse, text, "|"
		  if IsObject(j:=this.PicInfo(A_LoopField))
			info.Push(j)
		if (w<1 or h<1 or !(num:=info.Length) or !bits.Scan0)
		{
		  return []
		}
		arr:=[], info2:=Map(), k:=0, s:=""  , mode:=(IsObject(JoinText) ? 2 : JoinText ? 1 : 0)
		For i,j in info
		{
		  k:=Max(k, j[2]*j[3]), v:=(mode=1 ? i : j[11]) ""
		  if (mode and v!="")
			s.="|" v, (!info2.Has(v) && info2[v]:=[]), info2[v].Push(j)
		}
		JoinText:=(mode=1 ? [s] : JoinText)
		, s1:=Buffer(k*4), s0:=Buffer(k*4)
		, ss:=Buffer(2*(w+2)*(h+2))
		, FindAll:=(dir=9 ? 1 : FindAll)
		, allpos_max:=(FindAll or JoinText ? 10240 : 1)
		, ini:={sx:x, sy:y, sw:w, sh:h, zx:zx, zy:zy, zw:zw, zh:zh
		, mode:mode, bits:bits, ss:ss, s1:s1, s0:s0
		, allpos_max:allpos_max, zoomW:zoomW, zoomH:zoomH}
		Loop 2
		{
		  if (err1=0 and err0=0) and (num>1 or A_Index>1)
			err1:=0.05, err0:=0.05
		  ini.err1:=err1, ini.err0:=err0
		  if (!JoinText)
		  {
			allpos := Buffer(allpos_max*8)
			For i,j in info
			Loop this.PicFind(ini, j, dir, &allpos, ini.sx, ini.sy, ini.sw, ini.sh)
			{
			  x:=NumGet(allpos, 8*A_Index-8, "uint") + zx
			  , y:=NumGet(allpos, 8*A_Index-4, "uint") + zy
			  , w:=j[2], h:=j[3], comment:=j[11]
			  , arr.Push({x:x, y:y, w:w, h:h, mx:x+w//2, my:y+h//2, id:comment})
			  if (!FindAll)
				Break 3
			}
		  }
		  else
		  For k,v in JoinText
		  {
			v:=RegExReplace(v, "\s*\|[|\s]*", "|")
			, v:=StrSplit(Trim(v,"|"), (InStr(v, "|")?"|":""), " `t")
			, this.JoinText(ini, arr, info2, v, offsetX, offsetY, FindAll
			, 1, v.Length, dir, 0, 0, ini.sx, ini.sy, ini.sw, ini.sh)
			if (!FindAll and arr.Length)
			  Break 2
		  }
		  if (err1!=0 or err0!=0 or arr.Length
		  or info[1][8]=5 or info[1][12])
			Break
		}
		if (dir=9)
		  arr:=this.Sort2(arr, Round(x1+x2)//2, Round(y1+y2)//2)
		if (arr.Length)
		{
		  OutputX:=arr[1].mx, OutputY:=arr[1].my, this.ok:=arr
		  return arr
		}
		return []
	  }
  
	  ; the join text object <==> [ "abc", "xyz", "a1|a2|a3" ]
  
	  JoinText(ini, arr, info2, text, offsetX, offsetY, FindAll
	  , index:="", Len:="", dir:="", minY:="", maxY:=""
	  , sx:="", sy:="", sw:="", sh:="")
	  {
		allpos := Buffer(ini.allpos_max*8)
		For i,j in info2[text[index]]
		if (ini.mode=1 or text[index]==j[11])
		Loop this.PicFind(ini, j, dir, &allpos, sx, sy
		, (index=1 ? sw : Min(sx+offsetX+j[2],ini.sx+ini.sw)-sx), sh)
		{
		  x:=NumGet(allpos, 8*A_Index-8, "uint")
		  , y:=NumGet(allpos, 8*A_Index-4, "uint"), w:=j[2], h:=j[3]
		  , (index=1) && (ini.x:=x, minY:=y, maxY:=y+h)
		  if (index<Len)
		  {
			if this.JoinText(ini, arr, info2, text, offsetX, offsetY, FindAll
			, index+1, Len, 5, (y1:=Min(y,minY)), (y2:=Max(y+h,maxY)), x+w
			, (y:=Max(y1-offsetY,ini.sy)), 0, Min(y2+offsetY,ini.sy+ini.sh)-y)
			and (index>1 or !FindAll)
			  return 1
		  }
		  else
		  {
			comment:=""
			For k,v in text
			  comment.=(ini.mode=1 ? info2[v][1][11] : v)
			w:=x+w-ini.x, x:=ini.x+ini.zx
			, h:=Max(y+h,maxY)-Min(y,minY), y:=Min(y,minY)+ini.zy
			, arr.Push({x:x, y:y, w:w, h:h, mx:x+w//2, my:y+h//2, id:comment})
			if (index>1 or !FindAll)
			  return 1
		  }
		}
	  }
  
	  PicFind(ini, j, dir, &allpos, sx, sy, sw, sh)
	  {
		static MyFunc:=""
		if (!MyFunc)
		{
		  x32:=""    
		  . "5557565383EC6C83BC2480000000058BBC24C00000000F84E60800008BAC24C4"
		  . "00000085ED0F8ECE0D0000C744240400000000C74424140000000031EDC74424"
		  . "0800000000C7442418000000008D76008B8424BC0000008B4C241831F631DB01"
		  . "C885FF894424107F3DE99100000066900FAF8424A800000089C189F099F7FF01"
		  . "C18B442410803C1831744D8B8424B800000083C30103B424D8000000890CA883"
		  . "C50139DF74558B44240499F7BC24C400000083BC24800000000375B40FAF8424"
		  . "9400000089C189F099F7FF8D0C818B442410803C183175B38B4424088B9424B4"
		  . "00000083C30103B424D8000000890C8283C00139DF8944240875AB017C241883"
		  . "442414018B9C24DC0000008B442414015C2404398424C40000000F8530FFFFFF"
		  . "896C241031C08B74240839B424C80000008B5C24100F4DF0399C24CC00000089"
		  . "7424080F4CC339C6894424100F4DC683BC248000000003894424040F846C0800"
		  . "008BAC24940000008B8424A00000000FAFAC24A40000008BB42494000000C1E0"
		  . "028944243801C58B8424A8000000896C2434F7D88D0486894424248B84248000"
		  . "000085C00F858A0300008B842484000000C744242000000000C7442428000000"
		  . "00C1E8100FB6E88B8424840000000FB6C4894424140FB6842484000000894424"
		  . "188B8424A8000000C1E002894424308B8424AC00000085C00F8EC60000008B7C"
		  . "240C8B442434896C241C8BAC24A800000085ED0F8E8D0000008BB42490000000"
		  . "8B6C242803AC24B000000001C6034424308944242C038424900000008944240C"
		  . "0FB67E028B4C241C0FB6160FB646012B5424182B44241489FB01CF29CB8D8F00"
		  . "0400000FAFC00FAFCBC1E00B0FAFCBBBFE05000029FB0FAFDA01C10FAFD301CA"
		  . "399424880000000F93450083C60483C5013B74240C75A98B9C24A8000000015C"
		  . "24288B44242C8344242001034424248B74242039B424AC0000000F854AFFFFFF"
		  . "897C240C8B8424A80000002B8424D8000000C644244F00C644244E00C7442454"
		  . "00000000C744246000000000894424588B8424AC0000002B8424DC0000008944"
		  . "243C8B84248C00000083E80183F8070F87D005000083F803894424440F8ECB05"
		  . "00008B4424608B74245489442454897424608B742458397424540F8FCE0A0000"
		  . "8B4424588B742408C7442430000000008944245C8B8424B40000008D04B08B74"
		  . "24448944245089F083E0018944244889F08BB4249000000083E003894424648B"
		  . "4424608B7C243C39F80F8F7F010000837C2464018B5C24540F4F5C245C897C24"
		  . "2C89442420895C24408DB426000000008B7C24488B44242C85FF0F4444242083"
		  . "7C244403894424240F8FD5020000807C244E008B442440894424288B4424280F"
		  . "85DD020000807C244F000F85800300000FAF8424A80000008B5424048B5C2424"
		  . "85D28D2C180F8E840000008BBC24CC0000008B9424B000000031C08B9C24C800"
		  . "0000896C24348B4C24088974241C01EA897C24188B6C24048B7C2410895C2414"
		  . "39C17E1C8B9C24B40000008B348301D6803E00750B836C2414010F8860040000"
		  . "39C77E1C8B9C24B80000008B348301D6803E00740B836C2418010F8840040000"
		  . "83C00139E875B98B6C24348B74241C8B44240885C074278BBC24B00000008B84"
		  . "24B40000008B5C24508D0C2F8D7426008B1083C00401CA39D8C6020075F28B44"
		  . "2424038424A00000008B5C24308BBC24D00000008904DF8B442428038424A400"
		  . "00008944DF0483C3013B9C24D4000000895C24307D308344242001836C242C01"
		  . "8B4424203944243C0F8DA2FEFFFF8344245401836C245C018B44245439442458"
		  . "0F8D59FEFFFF8B44243083C46C5B5E5F5DC2600083BC2480000000010F84E007"
		  . "000083BC2480000000020F843B0500008B8424840000000FB6BC2484000000C7"
		  . "44242C00000000C744243000000000C1E8100FB6D08B84248400000089D50FB6"
		  . "DC8B842488000000C1E8100FB6C88B84248800000029CD01D1896C243C89DD89"
		  . "4C24140FB6F40FB684248800000029F501DE896C241889FD8974241C29C501F8"
		  . "894424288B8424A8000000896C2420C1E002894424388B8424AC00000085C00F"
		  . "8EDFFCFFFF8B4C24348B6C243C8B8424A800000085C00F8E880000008B842490"
		  . "0000008B542430039424B000000001C8034C243889CF894C243403BC24900000"
		  . "00EB34395C24147C3D394C24187F37394C241C7C3189F30FB6F3397424200F9E"
		  . "C3397424280F9DC183C00483C20121D9884AFF39C7741E0FB658020FB648010F"
		  . "B63039DD7EBD31C983C00483C201884AFF39C775E28BB424A800000001742430"
		  . "8B4C24348344242C01034C24248B44242C398424AC0000000F854FFFFFFFE921"
		  . "FCFFFF8B442424807C244E00894424288B442440894424248B4424280F8423FD"
		  . "FFFF0FAF8424940000008B5C24248D2C988B5C240485DB0F8EE1FDFFFF8BBC24"
		  . "C800000031C9896C24148DB6000000008B8424B40000008B5C2414031C888B84"
		  . "24B80000008B2C880FB6441E0289EAC1EA100FB6D229D00FB6541E010FB61C1E"
		  . "0FAFC03B44240C7F2789E80FB6C429C20FAFD23B54240C7F1789E80FB6C029C3"
		  . "0FAFDB3B5C240C7E108DB4260000000083EF010F887701000083C1013B4C2404"
		  . "758E89AC2484000000E950FDFFFF66900FAF8424940000008B7C24248B4C2404"
		  . "8D04B8894424140384248400000085C90FB65C06010FB67C06020FB60406895C"
		  . "24188944241C0F8E12FDFFFF8B8424CC00000031DB894424388B8424C8000000"
		  . "894424348B44240C897C240C8D742600395C24087E658B8424B40000008B4C24"
		  . "148B7C240C030C980FB6440E020FB6540E010FB60C0E2B5424182B4C241C89C5"
		  . "01F829FD8DB8000400000FAFD20FAFFDC1E20B0FAFFDBDFE05000029C50FAFE9"
		  . "01FA0FAFCD01D1398C2488000000730B836C2434010F88A1000000395C24107E"
		  . "618B8424B80000008B4C24148B7C240C030C980FB6440E020FB6540E010FB60C"
		  . "0E2B5424182B4C241C89C501F829FD8DB8000400000FAFD20FAFFDC1E20B0FAF"
		  . "FDBDFE05000029C50FAFE901FA0FAFCD01D1398C24880000007207836C243801"
		  . "783A83C3013B5C24040F8521FFFFFF8944240CE906FCFFFF908DB42600000000"
		  . "8B74241CE92DFCFFFF8DB4260000000089AC2484000000E91AFCFFFF8944240C"
		  . "E911FCFFFFC7442444000000008B44243C8B742458894424588974243CE930FA"
		  . "FFFF8B8424880000008BB424BC00000031C931DB31ED89BC24C0000000894424"
		  . "048B8424840000000FAFC08944240CEB1AB80A0000006BDB0AF7E189F901DA89"
		  . "FBC1FB1F01C111D383C6010FBE0685C00F84B80000008D78D083FF0976D383F8"
		  . "2F75E58D04AD000000008944241489C80FACD8100FB7C00FAF8424DC00000099"
		  . "F7BC24C40000000FAF84249400000089C70FB7C131C90FAF8424D800000099F7"
		  . "BC24C00000008B9424B40000008D04878B7C24148904AA89D88B9C24B8000000"
		  . "83C50189043B31DBE97BFFFFFF8B842484000000C1E8100FAF8424DC00000099"
		  . "F7BC24C40000000FAF84249400000089C10FB78424840000000FAF8424D80000"
		  . "0099F7FF8D04818984248400000083BC2480000000058B8424A80000000F9444"
		  . "244E83BC2480000000030F9444244F038424A00000002B8424D8000000894424"
		  . "588B8424A4000000038424AC0000002B8424DC0000008944243C8B8424A40000"
		  . "00C78424A400000000000000894424548B8424A0000000C78424A00000000000"
		  . "000089442460E977F8FFFF8B8424A8000000038424A00000008BAC24A8000000"
		  . "8BB424A40000000FAFAC24AC000000894424208B8424A400000083EE01038424"
		  . "AC00000003AC24B00000008974241439F0896C241C0F8C0E0100008BB424A000"
		  . "000083C001C7442428000000008944242C8B8424800000002B8424A000000083"
		  . "EE01897424308B7424140FAFB4249400000089C7897424248B74242001F78D6E"
		  . "01897C24348B442430394424200F8C980000008B7C24148B5C24248B74242803"
		  . "5C24382BB424A0000000039C2490000000C1EF1F0374241C897C2418EB4D6690"
		  . "398424980000007E4B807C24180075448B7C241439BC249C0000007E370FB64B"
		  . "FE0FB653FD83C3040FB67BF86BD24B6BC92601D189FAC1E20429FA01CAC1FA07"
		  . "8854060183C00139E8741889C2C1EA1F84D274ACC64406010083C00183C30439"
		  . "E875E88B7424340174242883442414018BBC24940000008B442414017C242439"
		  . "44242C0F853CFFFFFF8B8424A80000008B8C24AC00000083C00285C989442420"
		  . "0F8EBEF6FFFF8B8424AC0000008B6C241C036C2420C744241C01000000C74424"
		  . "240000000083C001894424288B8424A8000000896C241883C0048944242C8B84"
		  . "24880000008B9424A800000085D20F8EA70000008B4424188B5C24248B74242C"
		  . "039C24B000000089C12B8C24A800000089C201C6894C2414908DB42600000000"
		  . "0FB642010FB62ABF010000000384248400000039E8723D0FB66A0239E872358B"
		  . "4C24140FB669FF39E872290FB66EFF39E872210FB669FE39E872190FB62939E8"
		  . "72120FB66EFE39E8720A0FB63E39F80F92C189CF89F9834424140183C201880B"
		  . "83C60183C3018B7C2414397C241875908BBC24A8000000017C24248344241C01"
		  . "8B5C24208B74241C015C2418397424280F852FFFFFFF89842488000000E9A2F5"
		  . "FFFF8B8424840000008BB424AC000000C744241400000000C744241800000000"
		  . "83C001C1E007898424840000008B8424A8000000C1E00285F68944241C0F8E61"
		  . "F5FFFF8B4424348BAC24840000008B9C24A800000085DB7E618B8C2490000000"
		  . "8B5C2418039C24B000000001C10344241C894424200384249000000089C76690"
		  . "0FB651020FB641010FB6316BC04B6BD22601C289F0C1E00429F001D039C50F97"
		  . "0383C10483C30139F975D58BBC24A8000000017C24188B442420834424140103"
		  . "4424248B74241439B424AC0000000F857AFFFFFFE9CBF4FFFFC7442410000000"
		  . "00C744240800000000E916F3FFFFC744243000000000E90BF7FFFF9090909090"
		  x64:=""
		  . "4157415641554154555756534881EC88000000488BBC24F0000000488BB42430"
		  . "01000083F905898C24D000000089542468448944240444898C24E80000004C8B"
		  . "AC2438010000488B9C2440010000448B942450010000448B9C24580100000F84"
		  . "5909000031ED4531E44585DB0F8E1901000044897424104C89AC243801000031"
		  . "C0448BBC2420010000448BAC24D000000031ED448BB424800100004889B42430"
		  . "0100004531E4C744240800000000C74424380000000089C64889BC24F0000000"
		  . "48637C24384531C94531C04803BC24480100004585D27F33EB7B660F1F440000"
		  . "410FAFC789C14489C89941F7FA01C142803C0731743C4983C0014863C54501F1"
		  . "83C5014539C2890C837E4589F09941F7FB4183FD0375C90FAF8424F800000089"
		  . "C14489C89941F7FA42803C07318D0C8175C4488B9424380100004983C0014963"
		  . "C44501F14183C4014539C2890C827FBB4401542438834424080103B424880100"
		  . "008B4424084139C30F8552FFFFFF448B742410488BBC24F0000000488BB42430"
		  . "0100004C8BAC243801000031C04439A42460010000440F4DE039AC2468010000"
		  . "0F4DE84139EC4189EF450F4DFC83BC24D0000000030F849A0800008B8424F800"
		  . "00008B8C24100100000FAF8424180100008D04888B8C24F8000000894424208B"
		  . "842420010000F7D88D0481894424088B8424D000000085C00F859E0300008B4C"
		  . "24684889C84189CB0FB6C441C1EB1089C20FB6C1450FB6DB4189C28B84242801"
		  . "000085C00F8E300100008B842420010000448964242831C94889B42430010000"
		  . "4C89AC2438010000448B6424048BB42420010000448B6C2420C1E00244897C24"
		  . "18896C24304889BC24F00000004489D5C744243800000000894424104189CF89"
		  . "D748899C244001000085F60F8E84000000488B9C24F00000004963C54531D24C"
		  . "8D4C030248635C243848039C2430010000450FB631410FB651FE410FB641FF29"
		  . "EA4489F14501DE4189D0418D96000400004429D929F80FAFD10FAFC00FAFD1C1"
		  . "E00B8D0402BAFE0500004429F2410FAFD0410FAFD001D04139C4420F93041349"
		  . "83C2014983C1044439D67FA544036C2410017424384183C70144036C24084439"
		  . "BC24280100000F855DFFFFFF448B7C2418448B6424288B6C2430488BBC24F000"
		  . "0000488BB424300100004C8BAC2438010000488B9C24400100008B8424200100"
		  . "002B842480010000C644245700C644245600C744246C00000000C74424780000"
		  . "0000894424708B8424280100002B842488010000894424448B8424E800000083"
		  . "E80183F8070F87F505000083F8038944244C0F8EF00500008B4424788B4C246C"
		  . "8944246C894C24788B4C2470394C246C0F8F600B00008B4424708B4C244C4889"
		  . "9C24400100004889F34C89EEC74424300000000089442474418D4424FF498D44"
		  . "85044589E54C8BA42440010000488944246089C883E0018944245089C883E003"
		  . "8944247C8B4424788B4C244439C80F8F38010000837C247C018B54246C0F4F54"
		  . "2474894C2428894424088954244866908B44245085C08B4424280F4444240883"
		  . "7C244C03894424380F8FD2020000807C2456008B442448894424100F85DA0200"
		  . "00807C2457000F85740300008B4C24100FAF8C2420010000034C24384585FF7E"
		  . "50448B942468010000448B8C246001000031C04139C589C27E184189C8440304"
		  . "8642803C0300750A4183E9010F888200000039D57E1289CA41031484803C1300"
		  . "74064183EA01786C4883C0014139C77FC24585ED741B4C8B4424604889F06690"
		  . "89CA03104883C0044C39C0C604130075EF8B4C24308B54243803942410010000"
		  . "4C8B94247001000089C801C04898418914828B54241003942418010000418954"
		  . "820489C883C0013B842478010000894424307D308344240801836C2428018B44"
		  . "2408394424440F8DE4FEFFFF8344246C01836C2474018B44246C394424700F8D"
		  . "A0FEFFFF8B4424304881C4880000005B5E5F5D415C415D415E415FC383BC24D0"
		  . "000000010F84AC08000083BC24D0000000020F84520500008B542468448B5424"
		  . "04C744241000000000C74424180000000089D0440FB6C2C1E810440FB6C84889"
		  . "D00FB6CC4489D04589CBC1E810894C24380FB6D04C89D00FB6C44129D34401CA"
		  . "89C18B44243829C8034C243889442430410FB6C24589C24129C24401C0448B84"
		  . "2428010000894424388B842420010000C1E0024585C0894424280F8E1AFDFFFF"
		  . "448974243C896C24484C89AC2438010000448B7424208BAC2420010000448B6C"
		  . "243044897C244044896424444189CF48899C24400100004189D44489D385ED7E"
		  . "724C635424184963C631D2488D4407024901F2EB314539C47C3E4139CD7F3941"
		  . "39CF7C344439CB410F9EC044394C24380F9DC14883C0044421C141880C124883"
		  . "C20139D57E24440FB6000FB648FF440FB648FE4539C37EBD31C94883C0044188"
		  . "0C124883C20139D57FDC4403742428016C2418834424100144037424088B4424"
		  . "10398424280100000F856FFFFFFF448B74243C448B7C2440448B6424448B6C24"
		  . "484C8BAC2438010000488B9C2440010000E924FCFFFF662E0F1F840000000000"
		  . "8B442438807C245600894424108B442448894424380F8426FDFFFF8B4424108B"
		  . "4C24380FAF8424F80000004585FF448D14880F8E99FDFFFF448B8C2460010000"
		  . "4531C04989DB662E0F1F840000000000428B1486438B1C844401D289D98D4202"
		  . "C1E9100FB6C948980FB6040729C88D4A014863D20FAFC00FB614174863C90FB6"
		  . "0C0F4439F07F1A0FB6C729C10FAFC94439F17F0D0FB6C329C20FAFD24439F27E"
		  . "0A4183E9010F88950100004983C0014539C77F9C895C24684C89DBE911FDFFFF"
		  . "8B4424108B4C24380FAF8424F80000008D048889C1034424684585FF8D500248"
		  . "63D2440FB614178D500148980FB604074863D20FB614170F8ED4FCFFFF448B9C"
		  . "246801000048895C24584531C948897424184C8964242089CB89C64189D44489"
		  . "5C2440448B9C246001000044895C243C4539CD4589C87E6E488B442418428B14"
		  . "8801DA8D42024898440FB634078D42014863D20FB6141748980FB604074589F3"
		  . "4501D6418D8E000400004529D329F2410FAFCB4429E00FAFC0410FAFCB41BBFE"
		  . "050000C1E00B4529F3440FAFDA01C8410FAFD301C239542404730B836C243C01"
		  . "0F88A60000004439C57E6A488B442420428B148801DA8D42024898440FB63407"
		  . "8D42014863D20FB6141748980FB604074589F04501D6418D8E000400004529D0"
		  . "29F2410FAFC84429E00FAFC0410FAFC841B8FE050000C1E00B4529F0440FAFC2"
		  . "01C8410FAFD001C2395424047207836C24400178374983C1014539CF0F8F0EFF"
		  . "FFFF488B5C2458488B7424184C8B642420E99BFBFFFF662E0F1F840000000000"
		  . "895C24684C89DBE9C8FBFFFF488B5C2458488B7424184C8B642420E9B4FBFFFF"
		  . "C744244C000000008B4424448B4C247089442470894C2444E90BFAFFFF8B4424"
		  . "68448B7C24044531C04C8B8C244801000031C94189C6440FAFF0EB0F4B8D0480"
		  . "4863D24C8D04424983C101410FBE0185C00F84960000008D50D083FA0976DD83"
		  . "F82F75E34C89C048C1E8100FB7C00FAF8424880100009941F7FB0FAF8424F800"
		  . "000089442408410FB7C049C1E8200FAF8424800100009941F7FA8B5424088D04"
		  . "824863D183C1014189449500448904934531C0EB92448B4C24684489C8C1E810"
		  . "0FAF8424880100009941F7FB0FAF8424F800000089C1410FB7C10FAF84248001"
		  . "00009941F7FA8D04818944246883BC24D0000000058B8424200100000F944424"
		  . "5683BC24D0000000030F94442457038424100100002B84248001000089442470"
		  . "8B842418010000038424280100002B842488010000894424448B842418010000"
		  . "C7842418010000000000008944246C8B842410010000C7842410010000000000"
		  . "0089442478E98EF8FFFF8B8424200100008B8C24180100000FAF842428010000"
		  . "83E90189CA48984801F048894424088B84242001000003842410010000894424"
		  . "388B8424180100000384242801000039C80F8C750100008B8C241001000083C0"
		  . "0148899C244001000089442420C74424180000000089D3448974244444897C24"
		  . "4883E901448964244C4889B424300100004189CA894C243C8B8C24F800000042"
		  . "8D0495000000000FAFCA89442430489848894424288B8424D00000002B842410"
		  . "010000894C24108B4C24384189C3448D51014101CB44895C2440448B9C240001"
		  . "00008B44243C394424380F8CA50000008B4C24108B5424304189DE488B742428"
		  . "4C6344241841C1EE1F4C0344240801CA4C63F94863D24C8D0C174829D6EB5190"
		  . "4139C37E544584F6754F399C24080100007E46410FB64902410FB6510183C001"
		  . "4983C0016BD24B6BC92601D14A8D140E4983C104460FB6243A4489E2C1E20444"
		  . "29E201D1C1F907418848FF4139C2741D89C2C1EA1F84D274A783C00141C60000"
		  . "4983C1044983C0014139C275E38B7424400174241883C3018BB424F800000001"
		  . "742410395C24200F8535FFFFFF448B742444448B7C2448448B64244C488BB424"
		  . "30010000488B9C24400100008B842420010000448B94242801000083C0024585"
		  . "D20F8E73F6FFFF488B4C2408489844897C24404889442410448B7C246848899C"
		  . "2440010000C744240801000000488D440101C744243800000000448974243C48"
		  . "89C18B8424280100004889CB83C001894424184863842420010000488D500348"
		  . "F7D048894424288B84242001000048895424208B54240483E8014883C0014889"
		  . "442430448B8C24200100004585C90F8EAF000000488B44242048634C24384C8D"
		  . "0C18488B4424284801F14C8D0418488B4424304C8D34184889D8660F1F440000"
		  . "0FB610440FB650FF41BB010000004401FA4439D2724A440FB650014439D27240"
		  . "450FB650FF4439D27236450FB651FF4439D2722C450FB650FE4439D27222450F"
		  . "B6104439D27219450FB651FE4439D2720F450FB6114439D2410F92C30F1F4000"
		  . "4883C0014488194983C1014883C1014983C0014C39F075888B8C242001000001"
		  . "4C2438834424080148035C24108B442408394424180F8528FFFFFF448B74243C"
		  . "448B7C244089542404488B9C2440010000E904F5FFFF8B4424684531DBC74424"
		  . "380000000083C001C1E007894424688B842420010000C1E002894424108B8424"
		  . "2801000085C00F8ECEF4FFFF44897C242848899C2440010000448B7C2468448B"
		  . "9424200100008B5C242044897424184585D27E594C637424384863C34531C048"
		  . "8D4C07024901F6660F1F8400000000000FB6110FB641FF440FB649FE6BC04B6B"
		  . "D22601C24489C8C1E0044429C801D04139C7430F9704064983C0014883C10445"
		  . "39C27FCC035C241044015424384183C301035C240844399C2428010000759044"
		  . "8B742418448B7C2428488B9C2440010000E924F4FFFFC744243000000000E941"
		  . "F6FFFF90909090909090909090909090"
		  this.MCode(&MyFunc, A_PtrSize=8 ? x64:x32)
		}
		text:=j[1], w:=j[2], h:=j[3]  , e1:=(j[12] ? j[6] : Floor(j[4] * ini.err1))  , e0:=(j[12] ? j[7] : Floor(j[5] * ini.err0))  , mode:=j[8], color:=j[9], n:=j[10]
		return (!ini.bits.Scan0) ? 0 : DllCall(MyFunc, "int", mode, "uint", color, "uint", n, "int", dir, "int", ini.bits.Scan0, "int", ini.bits.Stride, "int", ini.zw, "int", ini.zh, "int", sx, "int", sy, "int", sw, "int", sh, "ptr", ini.ss, "ptr", ini.s1, "ptr", ini.s0, "AStr", text, "int", w, "int", h, "int", e1, "int", e0, "ptr", allpos, "int", ini.allpos_max, "int", w*ini.zoomW, "int", h*ini.zoomH)
	  }
  
	  GetBitsFromScreen(&x:=0, &y:=0, &w:=0, &h:=0  , ScreenShot:=1, &zx:="", &zy:="", &zw:="", &zh:="")
	  {
		static CAPTUREBLT:=""
		(!IsObject(this.bits) && this.bits:=[]), bits:=this.bits
		if (!ScreenShot and bits.Scan0)
		{
		  zx:=bits.zx, zy:=bits.zy, zw:=bits.zw, zh:=bits.zh
		  if x is VarRef
			w:=Min(x+w,zx+zw), x:=Max(x,zx), w-=x
			, h:=Min(y+h,zy+zh), y:=Max(y,zy), h-=y
		  return bits
		}
		cri:=A_IsCritical
		Critical()
		if (id:=this.BindWindow(0,0,1))
		{
		  id := WinGetID("ahk_id " id)
		  WinGetPos(&zx, &zy, &zw, &zh, "ahk_id " id)
		}
		if (!id)
		{
		  zx := SysGet(76)
		  zy := SysGet(77)
		  zw := SysGet(78)
		  zh := SysGet(79)
		}
		bits.zx:=zx, bits.zy:=zy, bits.zw:=zw, bits.zh:=zh  , w:=Min(x+w,zx+zw), x:=Max(x,zx), w-=x  , h:=Min(y+h,zy+zh), y:=Max(y,zy), h-=y
		if (zw>bits.oldzw or zh>bits.oldzh or !bits.hBM)
		{
		  DllCall("DeleteObject", "Ptr", bits.hBM)
		  , bits.hBM:=this.CreateDIBSection(zw, zh, bpp:=32, &ppvBits ?? 0)
		  , bits.Scan0:=(!bits.hBM ? 0:ppvBits)
		  , bits.Stride:=((zw*bpp+31)//32)*4
		  , bits.oldzw:=zw, bits.oldzh:=zh
		}
		if (!ScreenShot or w<1 or h<1 or !bits.hBM)
		{
		  Critical(cri)
		  return bits
		}
		if (k:="GetBitsFromScreen2") is Func
		  and %k%(bits, x-zx, y-zy, w, h)
		{
		  zx:=bits.zx, zy:=bits.zy, zw:=bits.zw, zh:=bits.zh
		  Critical(cri)
		  return bits
		}
		if (CAPTUREBLT="")  ; thanks Descolada
		{
		  DllCall("Dwmapi\DwmIsCompositionEnabled", "Int*", &compositionEnabled:=0)
		  CAPTUREBLT:=compositionEnabled ? 0 : 0x40000000
		}
		mDC:=DllCall("CreateCompatibleDC", "Ptr", 0, "Ptr")
		oBM:=DllCall("SelectObject", "Ptr", mDC, "Ptr", bits.hBM, "Ptr")
		if (id)
		{
		  if (mode:=this.BindWindow(0,0,0,1))<2
		  {
			hDC2:=DllCall("GetDCEx", "Ptr", id, "Ptr", 0, "int", 3, "Ptr")
			DllCall("BitBlt", "Ptr", mDC, "int", x-zx, "int", y-zy, "int", w, "int", h, "Ptr", hDC2, "int", x-zx, "int", y-zy, "uint", 0xCC0020|CAPTUREBLT)
			DllCall("ReleaseDC", "Ptr", id, "Ptr", hDC2)
		  }
		  else
		  {
			hBM2:=this.CreateDIBSection(zw, zh)
			mDC2:=DllCall("CreateCompatibleDC", "Ptr", 0, "Ptr")
			oBM2:=DllCall("SelectObject", "Ptr", mDC2, "Ptr", hBM2, "Ptr")
			DllCall("PrintWindow", "Ptr", id, "Ptr", mDC2, "uint", (mode>3)*3)
			DllCall("BitBlt", "Ptr", mDC, "int", x-zx, "int", y-zy, "int", w, "int", h, "Ptr", mDC2, "int", x-zx, "int", y-zy, "uint", 0xCC0020)
			DllCall("SelectObject", "Ptr", mDC2, "Ptr", oBM2)
			DllCall("DeleteDC", "Ptr", mDC2)
			DllCall("DeleteObject", "Ptr", hBM2)
		  }
		}
		else
		{
		  win:=DllCall("GetDesktopWindow", "Ptr")
		  hDC:=DllCall("GetWindowDC", "Ptr", win, "Ptr")
		  DllCall("BitBlt", "Ptr", mDC, "int", x-zx, "int", y-zy, "int", w, "int", h, "Ptr", hDC, "int", x, "int", y, "uint", 0xCC0020|CAPTUREBLT)
		  DllCall("ReleaseDC", "Ptr", win, "Ptr", hDC)
		}
		if this.CaptureCursor(0,0,0,0,0,1)
		  this.CaptureCursor(mDC, zx, zy, zw, zh)
		DllCall("SelectObject", "Ptr", mDC, "Ptr", oBM)
		DllCall("DeleteDC", "Ptr", mDC)
		Critical(cri)
		return bits
	  }
  
	  CreateDIBSection(w, h, bpp:=32, &ppvBits:=0, &bi:="")
	  {
		bi := Buffer(40, 0), NumPut("int", 40, bi, 0)  , NumPut("int", w, bi, 4), NumPut("int", -h, bi, 8)  , NumPut("short", 1, bi, 12), NumPut("short", bpp, bi, 14) ; V1toV2: if 'bi' is a UTF-16 string, use 'VarSetStrCapacity(&bi, 40)'
		return DllCall("CreateDIBSection", "Ptr", 0, "Ptr", bi, "int", 0, "Ptr*", &ppvBits:=0, "Ptr", 0, "int", 0, "Ptr")
	  }
  
	  PicInfo(text)
	  {
		static info:=Map()
		if !InStr(text, "$")
		  return
		key:=(r:=StrLen(text))<10000 ? text
		  : DllCall("ntdll\RtlComputeCrc32", "uint", 0, "Ptr", text, "uint", r*(1+!!1), "uint")
		if info.Has(key)
		  return info[key]
		v:=text, comment:="", seterr:=e1:=e0:=0
		; You Can Add Comment Text within The <>
		if RegExMatch(v, "<([^>\n]*)>", &r)
		  v:=StrReplace(v, r[]), comment:=Trim(r[1])
		; You can Add two fault-tolerant in the [], separated by commas
		if RegExMatch(v, "\[([^\]\n]*)]", &r)
		{
		  v:=StrReplace(v, r[]), r:=StrSplit(r[1], ","), seterr:=1, e1:=r[1], e0:=r[2]
		}
		color:=StrSplit(v,"$")[1], v:=Trim(SubStr(v, (InStr(v, "$")+1)<1 ? (InStr(v, "$")+1)-1 : (InStr(v, "$")+1)))
		mode:=InStr(color, "##") ? 5
		  : InStr(color, "-") ? 4 : InStr(color, "#") ? 3
		  : InStr(color, "**") ? 2 : InStr(color, "*") ? 1 : 0
		color:=RegExReplace(color, "[*#\s]")
		if (mode=5)
		{
		  if (v~="[^\s\w/]") and FileExist(v)  ; ImageSearch
		  {
			if !(hBM:=LoadPicture(v))
			  return
			this.GetBitmapWH(hBM, &w, &h)
			if (w<1 or h<1)
			  return
			hBM2:=this.CreateDIBSection(w, h, 32, &Scan0)
			this.CopyHBM(hBM2, 0, 0, hBM, 0, 0, w, h)
			DllCall("DeleteObject", "Ptr", hBM)
			if (!Scan0)
			  return
			c1:=NumGet(Scan0+0, "uint")&0xFFFFFF
			c2:=NumGet(Scan0+(w-1)*4, "uint")&0xFFFFFF
			c3:=NumGet(Scan0+(w*h-w)*4, "uint")&0xFFFFFF
			c4:=NumGet(Scan0+(w*h-1)*4, "uint")&0xFFFFFF
			if (c1!=c2 or c1!=c3 or c1!=c4)
			  c1:=-1
			VarSetStrCapacity(&v, w*h*18), i:=-4, y:=-1 ; V1toV2: if 'v' is NOT a UTF-16 string, use 'v := Buffer(w*h*18*(1+!!A_IsUnicode))'
			Loop h
			  Loop w+0*(++y)
				if (c:=NumGet(Scan0+(i+=4), "uint")&0xFFFFFF)!=c1
				  v.=(A_Index-1)|y<<16|c<<32 . "/"
			StrReplace(v, "/", "", , &n)
			DllCall("DeleteObject", "Ptr", hBM2)
		  }
		  else
		  {
			v:=Trim(StrReplace(RegExReplace(v, "\s"), ",", "/"),"/")
			r:=StrSplit(v,"/"), n:=r.Length//3
			if (!n)
			  return
			VarSetStrCapacity(&v, n*18) ; V1toV2: if 'v' is NOT a UTF-16 string, use 'v := Buffer(n*18*(1+!!A_IsUnicode))'
			x1:=x2:=r[1], y1:=y2:=r[2]
			Loop n + (i:=-2)*0
			  x:=r[i+=3], y:=r[i+1]
			  , (x<x1 && x1:=x), (x>x2 && x2:=x)
			  , (y<y1 && y1:=y), (y>y2 && y2:=y)
			Loop n + (i:=-2)*0
			  v.=(r[i+=3]-x1)|(r[i+1]-y1)<<16|(Floor("0x"
			  . StrReplace(r[i+2], "0x"))&0xFFFFFF)<<32 . "/"
			w:=x2-x1+1, h:=y2-y1+1
		  }
		  len1:=n, len0:=0
		}
		else
		{
		  r:=StrSplit(v,"."), w:=r[1], v:=this.base64tobit(r[2]), h:=StrLen(v)//w
		  if (w<1 or h<1 or StrLen(v)!=w*h)
			return
		  if (mode=4)
		  {
			r:=StrSplit(StrReplace(color, "0x"),"-"), color:=Floor("0x" r[1]), n:=Floor("0x" r[2])
		  }
		  else
		  {
			r:=StrSplit(color,"@"), color:=r[1], n:=r.Length<2?1:Round(r[2],2)+(!r[2]), n:=Floor(512*9*255*255*(1-n)*(1-n))
			if (mode=3)
			  color:=(((color-1)//w)<<16)|Mod(color-1,w)
		  }
		  StrReplace(v, "1", "", , &len1), len0:=StrLen(v)-len1
		}
		e1:=Floor(len1*e1), e0:=Floor(len0*e0)
		return info[key]:=[v, w, h, len1, len0, e1, e0, mode, color, n, comment, seterr]
	  }
  
	  GetBitmapWH(hBM, &w, &h)
	  {
		bm := Buffer(size:=(A_PtrSize=8 ? 32:24), 0)
		r:=DllCall("GetObject", "Ptr", hBM, "int", size, "Ptr", bm)
		w:=NumGet(bm, 4, "int"), h:=Abs(NumGet(bm, 8, "int"))
		return r
	  }
  
	  CopyHBM(hBM1, x1, y1, hBM2, x2, y2, w2, h2)
	  {
		if (w2<1 or h2<1 or !hBM1 or !hBM2)
		  return
		mDC1:=DllCall("CreateCompatibleDC", "Ptr", 0, "Ptr")
		oBM1:=DllCall("SelectObject", "Ptr", mDC1, "Ptr", hBM1, "Ptr")
		mDC2:=DllCall("CreateCompatibleDC", "Ptr", 0, "Ptr")
		oBM2:=DllCall("SelectObject", "Ptr", mDC2, "Ptr", hBM2, "Ptr")
		DllCall("BitBlt", "Ptr", mDC1, "int", x1, "int", y1, "int", w2, "int", h2, "Ptr", mDC2, "int", x2, "int", y2, "uint", 0xCC0020)
		DllCall("SelectObject", "Ptr", mDC2, "Ptr", oBM2)
		DllCall("DeleteDC", "Ptr", mDC2)
		DllCall("SelectObject", "Ptr", mDC1, "Ptr", oBM1)
		DllCall("DeleteDC", "Ptr", mDC1)
	  }
  
	  CopyBits(Scan01,Stride1,x1,y1,Scan02,Stride2,x2,y2,w2,h2,Reverse:=0)
	  {
		if (w2<1 or h2<1 or !Scan01 or !Scan02)
		  return
		p1:=Scan01+(y1-1)*Stride1+x1*4  
		, p2:=Scan02+(y2-1)*Stride2+x2*4, w2*=4
		if (Reverse)
		  p2+=(h2+1)*Stride2, Stride2:=-Stride2
		Loop h2
		  DllCall("RtlMoveMemory", "Ptr", p1+=Stride1, "Ptr", p2+=Stride2, "Ptr", w2)
	  }
  
	  ; Bind the window so that it can find images when obscured
	  ; by other windows, it's equivalent to always being
	  ; at the front desk. Unbind Window using FindText().BindWindow(0)
  
	  BindWindow(bind_id:=0, bind_mode:=0, get_id:=0, get_mode:=0)
	  {
		(!IsObject(this.bind) && this.bind:={}), bind:=this.bind
		if (get_id)
		  return bind.id
		if (get_mode)
		  return bind.mode
		if (bind_id)
		{
		  bind.id:=bind_id, bind.mode:=bind_mode, bind.oldStyle:=0
		  if (bind_mode & 1)
		  {
			oldStyle := WinGetExStyle("ahk_id " bind_id)
			bind.oldStyle:=oldStyle
			WinSetTransparent(255, "ahk_id " bind_id)
			Loop 30
			{
			  Sleep(100)
			  i := WinGetTransparent("ahk_id " bind_id)
			}
			Until (i=255)
		  }
		}
		else
		{
		  bind_id:=bind.id
		  if (bind.mode & 1)
			WinSetExStyle(bind.oldStyle, "ahk_id " bind_id)
		  bind.id:=0, bind.mode:=0, bind.oldStyle:=0
		}
	  }
  
	  ; Use FindText().CaptureCursor(1) to Capture Cursor
	  ; Use FindText().CaptureCursor(0) to Cancel Capture Cursor
  
	  CaptureCursor(hDC:=0, zx:=0, zy:=0, zw:=0, zh:=0, get_cursor:=0)
	  {
		if (get_cursor)
		  return this.Cursor
		if (hDC=1 or hDC=0) and (zw=0)
		{
		  this.Cursor:=hDC
		  return
		}
		mi := Buffer(40, 0), NumPut("int", 16+A_PtrSize, mi)
		DllCall("GetCursorInfo", "Ptr", mi)
		bShow   := NumGet(mi, 4, "int")
		hCursor := NumGet(mi, 8, "Ptr")
		x := NumGet(mi, 8+A_PtrSize, "int")
		y := NumGet(mi, 12+A_PtrSize, "int")
		if (!bShow) or (x<zx or y<zy or x>=zx+zw or y>=zy+zh)
		  return
		ni := Buffer(40, 0)
		DllCall("GetIconInfo", "Ptr", hCursor, "Ptr", ni)
		xCenter  := NumGet(ni, 4, "int")
		yCenter  := NumGet(ni, 8, "int")
		hBMMask  := NumGet(ni, (A_PtrSize=8?16:12), "Ptr")
		hBMColor := NumGet(ni, (A_PtrSize=8?24:16), "Ptr")
		DllCall("DrawIconEx", "Ptr", hDC, "int", x-xCenter-zx, "int", y-yCenter-zy, "Ptr", hCursor, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
		DllCall("DeleteObject", "Ptr", hBMMask)
		DllCall("DeleteObject", "Ptr", hBMColor)
	  }
  
	  MCode(&code, hex)
	  {
		code := Buffer(len:=StrLen(hex)//2) ; V1toV2: if 'code' is NOT a UTF-16 string, use 'code := Buffer(len:=StrLen(hex)//2)'
		Loop len
		  NumPut("uchar", Integer("0x" SubStr(hex,2*A_Index-1,2)), code, A_Index-1)
		DllCall("VirtualProtect", "Ptr", code, "Ptr", len, "uint", 0x40, "Ptr*", 0)
	  }
  
	  base64tobit(s)
	  {
		Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		. "abcdefghijklmnopqrstuvwxyz"
		Loop Parse, Chars
		{
		  s:=RegExReplace(s, "[" A_LoopField "]", ((i:=A_Index-1)>>5&1) . (i>>4&1)
		  . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1))
		}
		return RegExReplace(RegExReplace(s, "[^01]+"), "10*$")
	  }
  
	  bit2base64(s)
	  {
		s:=RegExReplace(s, "[^01]+")
		s.=SubStr("100000", 1, 6-Mod(StrLen(s),6))
		s:=RegExReplace(s, ".{6}", "|$0")
		Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		. "abcdefghijklmnopqrstuvwxyz"
		Loop Parse, Chars
		{
		  s:=StrReplace(s, "|" . ((i:=A_Index-1)>>5&1)
		  . (i>>4&1) . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1), A_LoopField)
		}
		return s
	  }
  
	  xywh2xywh(x1,y1,w1,h1, &x, &y, &w, &h, &zx:="", &zy:="", &zw:="", &zh:="")
	  {
		zx := SysGet(76)
		zy := SysGet(77)
		zw := SysGet(78)
		zh := SysGet(79)
		w:=Min(x1+w1,zx+zw), x:=Max(x1,zx), w-=x  , h:=Min(y1+h1,zy+zh), y:=Max(y1,zy), h-=y
	  }
  
	  ASCII(s)
	  {
		if RegExMatch(s, "\$(\d+)\.([\w+/]+)", &r)
		{
		  s:=RegExReplace(this.base64tobit(r[2]), ".{" r[1] "}", "$0`n")
		  s:=StrReplace(StrReplace(s, "0", "_"), "1", "0")
		}
		else s:=""
		return s
	  }
  
	  ; You can put the text library at the beginning of the script,
	  ; and Use FindText().PicLib(Text,1) to add the text library to PicLib()'s Lib,
	  ; Use FindText().PicLib("comment1|comment2|...") to get text images from Lib
  
	  PicLib(comments, add_to_Lib:=0, index:=1)
	  {
		Lib:=this.Lib
		, (!Lib.Has(index) && Lib[index]:=Map()), Lib:=Lib[index]
		if (add_to_Lib)
		{
		  re := "<([^>\n]*)>[^$\n]+\$[^`"\r\n]+" ;"
		  Loop Parse, comments, "|"
			if RegExMatch(A_LoopField, re, &r)
			{
			  s1:=Trim(r[1]), s2:=""
			  Loop Parse, s1
				s2.="_" . Format("{:d}",Ord(A_LoopField))
			  Lib[s2]:=r[]
			}
		  Lib[""]:=""
		}
		else
		{
		  Text:=""
		  Loop Parse, comments, "|"
		  {
			s1:=Trim(A_LoopField), s2:=""
			Loop Parse, s1
			  s2.="_" . Format("{:d}",Ord(A_LoopField))
			Text.="|" . Lib[s2]
		  }
		  return Text
		}
	  }
  
	  ; Decompose a string into individual characters and get their data
  
	  PicN(Number, index:=1)
	  {
		return this.PicLib(RegExReplace(Number, ".", "|$0"), 0, index)
	  }
  
	  ; Use FindText().PicX(Text) to automatically cut into multiple characters
	  ; Can't be used in ColorPos mode, because it can cause position errors
  
	  PicX(Text)
	  {
		if !RegExMatch(Text, "(<[^$\n]+)\$(\d+)\.([\w+/]+)", &r)
		  return Text
		v:=this.base64tobit(r[3]), Text:=""
		c:=StrLen(StrReplace(v, "0"))<=StrLen(v)//2 ? "1":"0"
		txt:=RegExReplace(v, ".{" r[2] "}", "$0`n")
		While InStr(txt, c)
		{
		  While !(txt~="m`n)^" c)
			txt:=RegExReplace(txt, "m`n)^.")
		  i:=0
		  While (txt~="m`n)^.{" i "}" c)
			i:=Format("{:d}",i+1)
		  v:=RegExReplace(txt, "m`n)^(.{" i "}).*", "$1")
		  txt:=RegExReplace(txt, "m`n)^.{" i "}")
		  if (v!="")
			Text.="|" r[1] "$" i "." this.bit2base64(v)
		}
		return Text
	  }
  
	  ; Screenshot and retained as the last screenshot.
  
	  ScreenShot(x1:=0, y1:=0, x2:=0, y2:=0)
	  {
		this.FindText(&null := 0, &null := 0, x1, y1, x2, y2)
	  }
  
	  ; Get the RGB color of a point from the last screenshot.
	  ; If the point to get the color is beyond the range of
	  ; Screen, it will return White color (0xFFFFFF).
  
	  GetColor(x, y, fmt:=1)
	  {
		bits:=this.GetBitsFromScreen(&null:=0,&null:=0,&null:=0,&null:=0,0,&zx,&zy,&zw,&zh)  , c:=(x<zx or x>=zx+zw or y<zy or y>=zy+zh or !bits.Scan0)
		? 0xFFFFFF : NumGet(bits.Scan0+(y-zy)*bits.Stride+(x-zx)*4, "uint")
		return (fmt ? Format("0x{:06X}",c&0xFFFFFF) : c)
	  }
  
	  ; Set the RGB color of a point in the last screenshot
  
	  SetColor(x, y, color:=0x000000)
	  {
		bits:=this.GetBitsFromScreen(&null:=0,&null:=0,&null:=0,&null:=0,0,&zx,&zy,&zw,&zh)
		if !(x<zx or x>=zx+zw or y<zy or y>=zy+zh or !bits.Scan0)
		  NumPut("uint", color, bits.Scan0+(y-zy)*bits.Stride+(x-zx)*4)
	  }
  
	  ; Identify a line of text or verification code
	  ; based on the result returned by FindText().
	  ; offsetX is the maximum interval between two texts,
	  ; if it exceeds, a "*" sign will be inserted.
	  ; offsetY is the maximum height difference between two texts.
	  ; overlapW is used to set the width of the overlap.
	  ; return Association array {text:Text, x:X, y:Y, w:W, h:H}
  
	  Ocr(ok, offsetX:=20, offsetY:=20, overlapW:=0)
	  {
		ocr_Text:=ocr_X:=min_X:="",ocr_Y:=min_Y:=max_Y:=dx:=0
		For k,v in ok
		  x:=v.x, y:=v.y
		  , min_X:=(A_Index==1 or x<min_X ? x : min_X)    
		  , max_X:=(A_Index==1 or x>max_X ? x : max_X)
		  , ocr_Y:=y
		While (min_X!="" and min_X<=max_X)
		{
		  LeftX:=""
		  For k,v in ok
		  {
			x:=v.x, y:=v.y
			if (x<min_X) or Abs(y-ocr_Y)>offsetY
			  Continue
			; Get the leftmost X coordinates
			if (!IsInteger(LeftX) or x<LeftX)
			  LeftX:=x, LeftY:=y, LeftW:=v.w, LeftH:=v.h, LeftOCR:=v.id
		  }
		  if (LeftX="")
			Break
		  if (ocr_X="")
			ocr_X:=LeftX, min_Y:=LeftY, max_Y:=LeftY+LeftH
		  ; If the interval exceeds the set value, add "*" to the result
		  ocr_Text.=(ocr_Text!="" and LeftX>dx ? "*":"") . LeftOCR
		  ; Update for next search
		  min_X:=LeftX+LeftW-(overlapW>LeftW//2 ? LeftW//2:overlapW)
		  , dx:=LeftX+LeftW+offsetX, ocr_Y:=LeftY
		  , (LeftY<min_Y && min_Y:=LeftY)
		  , (LeftY+LeftH>max_Y && max_Y:=LeftY+LeftH)
		}
		if (ocr_X="")
		  ocr_X:=0, min_Y:=0, max_Y:=0
		return {text:ocr_Text, x:ocr_X, y:min_Y, w: min_X-ocr_X, h: max_Y-min_Y}
	  }
  
	  ; Sort the results of FindText() from left to Right
	  ; and top to bottom, ignore slight height difference
  
	  Sort(ok, dy:=10)
	  {
		if !IsObject(ok)
		  return ok
		s:="", n:=150000, ypos:=[]
		For k,v in ok
		{
		  x:=v.mx, y:=v.my, add:=1
		  For k1,v1 in ypos
		  if Abs(y-v1)<=dy
		  {
			y:=v1, add:=0
			Break
		  }
		  if (add)
			ypos.Push(y)
		  s.=(y*n+x) "." k "|"
		}
		s:=Trim(s,"|")
		s := Sort(s, "N D|")
		ok2:=[]
		Loop Parse, s, "|"
		  ok2.Push(ok[(StrSplit(A_LoopField,".")[2])])
		return ok2
	  }
  
	  ; Sort the results of FindText() according to the nearest distance
  
	  Sort2(ok, px, py)
	  {
		if !IsObject(ok)
		  return ok
		s:=""
		For k,v in ok
		  s.=((v.mx-px)**2+(v.my-py)**2) "." k "|"
		s:=Trim(s,"|")
		s := Sort(s, "N D|")
		ok2:=[]
		Loop Parse, s, "|"
		  ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
		return ok2
	  }
  
	  ; Sort the results of FindText() according to the search direction
  
	  Sort3(ok, dir:=1)
	  {
		if !IsObject(ok)
		  return ok
		s:="", n:=150000
		For k,v in ok
		  x:=v.x, y:=v.y
		  , s.=(dir=1 ? y*n+x
		  : dir=2 ? y*n-x
		  : dir=3 ? -y*n+x
		  : dir=4 ? -y*n-x
		  : dir=5 ? x*n+y
		  : dir=6 ? x*n-y
		  : dir=7 ? -x*n+y
		  : dir=8 ? -x*n-y : y*n+x) "." k "|"
		s:=Trim(s,"|")
		s := Sort(s, "N D|")
		ok2:=[]
		Loop Parse, s, "|"
		  ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
		return ok2
	  }
  
	  ; Prompt mouse position in remote assistance
  
	  MouseTip(x:="", y:="", w:=10, h:=10, d:=4)
	  {
		if (x="")
		{
		  pt := Buffer(16, 0), DllCall("GetCursorPos", "ptr", pt)
		  x:=NumGet(pt, 0, "uint"), y:=NumGet(pt, 4, "uint")
		}
		Loop 4
		{
		  this.RangeTip(x-w, y-h, 2*w+1, 2*h+1, (A_Index & 1 ? "Red":"Blue"), d)
		  Sleep(500)
		}
		this.RangeTip()
	  }
  
	  ; Shows a range of the borders, similar to the ToolTip
  
	  RangeTip(x:="", y:="", w:="", h:="", color:="Red", d:=2)
	  {
		static id:=0, range:=[]
		if (x="")
		{
		  for _, r in range
			r.Destroy()
			id:=0,range:=[]
		  return
		}
		if (!id)
		{
		  Loop 4 {
			range.Push(Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08000000"))
		  }
		  id := range[1].Hwnd
		}
		x:=Floor(x), y:=Floor(y), w:=Floor(w), h:=Floor(h), d:=Floor(d)
		Loop 4
		{
		  i:=A_Index
		  , x1:=(i=2 ? x+w : x-d)
		  , y1:=(i=3 ? y+h : y-d)
		  , w1:=(i=1 or i=3 ? w+2*d : d)
		  , h1:=(i=2 or i=4 ? h+2*d : d)
		  range[i].BackColor := color
		  range[i].Show("NA x" . x1 . " y" . y1 . " w" . w1 . " h" . h1)
		}
	  }
  
	  ; Quickly get the search data of screen image
  
	  GetTextFromScreen(x1, y1, x2, y2, Threshold:="", ScreenShot:=1, &rx:="", &ry:="")
	  {
		x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
		this.GetBitsFromScreen(&x,&y,&w,&h,ScreenShot,&zx,&zy,&zw,&zh)
		if (w<1 or h<1)
		{
		  return
		}
		gs:=Map(), k:=0
		Loop h
		{
		  j:=y+A_Index-1
		  Loop w
			i:=x+A_Index-1, c:=this.GetColor(i,j,0)
			, gs[++k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
		}
		if InStr(Threshold, "**")
		{
		  Threshold:=StrReplace(Threshold, "*")
		  if (Threshold="")
			Threshold:=50
		  s:="", sw:=w, w-=2, h-=2, x++, y++
		  Loop h
		  {
			y1:=A_Index
			Loop w
			  x1:=A_Index, i:=y1*sw+x1+1, j:=gs[i]+Threshold
			  , s.=( gs[i-1]>j || gs[i+1]>j
			  || gs[i-sw]>j || gs[i+sw]>j
			  || gs[i-sw-1]>j || gs[i-sw+1]>j
			  || gs[i+sw-1]>j || gs[i+sw+1]>j ) ? "1":"0"
		  }
		  Threshold:="**" Threshold
		}
		else
		{
		  Threshold:=StrReplace(Threshold, "*")
		  if (Threshold="")
		  {
			pp:=[]
			Loop 256
			  pp[A_Index-1]:=0
			Loop w*h
			  pp[gs[A_Index]]++
			IP0:=IS0:=0
			Loop 256
			  k:=A_Index-1, IP0+=k*pp[k], IS0+=pp[k]
			Threshold:=Floor(IP0/IS0)
			Loop 20
			{
			  LastThreshold:=Threshold
			  IP1:=IS1:=0
			  Loop LastThreshold+1
				k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
			  IP2:=IP0-IP1, IS2:=IS0-IS1
			  if (IS1!=0 and IS2!=0)
				Threshold:=Floor((IP1/IS1+IP2/IS2)/2)
			  if (Threshold=LastThreshold)
				Break
			}
		  }
		  s:=""
		  Loop w*h
			s.=gs[A_Index]<=Threshold ? "1":"0"
		  Threshold:="*" Threshold
		}
		;--------------------
		w:=Format("{:d}",w), CutUp:=CutDown:=0
		re1:="(^0{" w "}|^1{" w "})"
		re2:="(0{" w "}$|1{" w "}$)"
		While RegExMatch(s, re1)
		  s:=RegExReplace(s, re1), CutUp++
		While RegExMatch(s, re2)
		  s:=RegExReplace(s, re2), CutDown++
		rx:=x+w//2, ry:=y+CutUp+(h-CutUp-CutDown)//2
		s:="|<>" Threshold "$" w "." this.bit2base64(s)
		;--------------------
		return s
	  }
  
	  ; Quickly save screen image to BMP file for debugging
  
	  SavePic(file, x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
	  {
		if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
		  n:=150000, x:=y:=-n, w:=h:=2*n
		else
		  x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
		bits:=this.GetBitsFromScreen(&x,&y,&w,&h,ScreenShot,&zx,&zy), x-=zx, y-=zy
		if (w<1 or h<1 or !bits.Scan0)
		  return
		hBM:=this.CreateDIBSection(w, -h, bpp:=24, &ppvBits, &bi)
		hBM2:=this.CreateDIBSection(w, h, 32, &Scan0), Stride:=w*4
		this.CopyBits(Scan0,Stride,0,0,bits.Scan0,bits.Stride,x,y,w,h)
		this.CopyHBM(hBM, 0, 0, hBM2, 0, 0, w, h)
		DllCall("DeleteObject", "Ptr", hBM2)
		size:=((w*bpp+31)//32)*4*h, NumPut("uint", size, bi, 20)
		bf := Buffer(14, 0), StrPut("BM", bf, "CP0") ; V1toV2: if 'bf' is a UTF-16 string, use 'VarSetStrCapacity(&bf, 14)'
		NumPut("uint", 54+size, bf, 2), NumPut("uint", 54, bf, 10)
		f:=FileOpen(file,"w"), f.RawWrite(bf,14), f.RawWrite(bi,40)  , f.RawWrite(ppvBits+0, size), f.Close()
		DllCall("DeleteObject", "Ptr", hBM)
	  }
  
	  ; Show the saved Picture file
  
	  ShowPic(file:="", show:=1, &x:="", &y:="", &w:="", &h:="")
	  {
		if (file="")
		{
		  this.ShowScreenShot()
		  return
		}
		if !FileExist(file) or !(hBM:=LoadPicture(file))
		  return
		this.GetBitmapWH(hBM, &w, &h)
		bits:=this.GetBitsFromScreen(&null:=0,&null:=0,&null:=0,&null:=0,0,&x,&y)
		if (w<1 or h<1 or !bits.Scan0)
		{
		  DllCall("DeleteObject", "Ptr", hBM)
		  return
		}
		hBM2:=this.CreateDIBSection(w, h, 32, &Scan0), Stride:=w*4
		this.CopyHBM(hBM2, 0, 0, hBM, 0, 0, w, h)
		this.CopyBits(bits.Scan0,bits.Stride,0,0,Scan0,Stride,0,0,w,h)
		DllCall("DeleteObject", "Ptr", hBM2)
		DllCall("DeleteObject", "Ptr", hBM)
		if (show)
		  this.ShowScreenShot(x, y, x+w-1, y+h-1, 0)
	  }
  
	  ; Show the memory Screenshot for debugging
  
	  ShowScreenShot(x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
	  {
		static hPic, oldw, oldh
		if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
		{
		  this.FindText_Screen.Destroy()
		  return
		}
		x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
		bits:=this.GetBitsFromScreen(&x,&y,&w,&h,ScreenShot,&zx,&zy), x-=zx, y-=zy
		if (w<1 or h<1 or !bits.Scan0)
		  return
		hBM:=this.CreateDIBSection(w, h, 32, &Scan0), Stride:=w*4
		this.CopyBits(Scan0,Stride,0,0,bits.Scan0,bits.Stride,x,y,w,h)
		;---------------
		if !this.HasOwnProp("FindText_Screen")
		{
		  this.FindText_Screen := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08000000", "Show Pic")
		  this.FindText_Screen.MarginX:=0, this.FindText_Screen.MarginY:=0
		  ogchPic := this.FindText_Screen.Add("Pic", "w" . w . " h" . h)
		  hPic := ogchPic.Hwnd
		  this.FindText_Screen.Show("NA x" . zx . " y" . zy . " w" . w . " h" . h)
		  oldw:=w, oldh:=h
		}
		else if (oldw!=w or oldh!=h)
		{
		  oldw:=w, oldh:=h
		  ogchPic.Move(, , w, h)
		  this.FindText_Screen.Show("NA w" . w . " h" . h)
		}
		mDC:=DllCall("CreateCompatibleDC", "Ptr", 0, "Ptr")
		oBM:=DllCall("SelectObject", "Ptr", mDC, "Ptr", hBM, "Ptr")
		DllCall("BitBlt", "Ptr", mDC, "int", 0, "int", 0, "int", w, "int", h, "Ptr", mDC, "int", 0, "int", 0, "uint", 0xC000CA)
		;---------------
		hDC:=DllCall("GetDC", "Ptr", hPic, "Ptr")
		DllCall("BitBlt", "Ptr", hDC, "int", 0, "int", 0, "int", w, "int", h, "Ptr", mDC, "int", 0, "int", 0, "uint", 0xCC0020)
		DllCall("ReleaseDC", "Ptr", hPic, "Ptr", hDC)
		;---------------
		DllCall("SelectObject", "Ptr", mDC, "Ptr", oBM)
		DllCall("DeleteDC", "Ptr", mDC)
		DllCall("DeleteObject", "Ptr", hBM)
	  }
  
	  ; Wait for the screen image to change within a few seconds
	  ; Take a Screenshot before using it: FindText().ScreenShot()
  
	  WaitChange(time:=-1, x1:=0, y1:=0, x2:=0, y2:=0)
	  {
		hash:=this.GetPicHash(x1, y1, x2, y2, 0)
		timeout:=A_TickCount+Round(time*1000)
		Loop
		{
		  if (hash!=this.GetPicHash(x1, y1, x2, y2, 1))
			return 1
		  if (time>=0 and A_TickCount>=timeout)
			Break
		  Sleep(10)
		}
		return 0
	  }
  
	  GetPicHash(x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
	  {
		static h:=DllCall("LoadLibrary", "Str", "ntdll", "Ptr")
		if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
		  n:=150000, x:=y:=-n, w:=h:=2*n
		else
		  x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
		bits:=this.GetBitsFromScreen(&x,&y,&w,&h,ScreenShot,&zx,&zy), x-=zx, y-=zy
		if (w<1 or h<1 or !bits.Scan0)
		  return 0
		hash:=0, Stride:=bits.Stride, p:=bits.Scan0+(y-1)*Stride+x*4, w*=4
		Loop h
		  hash:=(hash*31+DllCall("ntdll\rtlComputeCrc32", "uint", 0, "Ptr", p+=Stride, "uint", w, "uint"))&0xFFFFFFFF
		return hash
	  }
  
	  WindowToScreen(&x, &y, x1, y1, id:="A")
	  {
		WinGetPos(&winx, &winy, , , id)
		x:=x1+Floor(winx), y:=y1+Floor(winy)
	  }
  
	  ScreenToWindow(&x, &y, x1, y1, id:="")
	  {
		this.WindowToScreen(&dx,&dy,0,0,id), x:=x1-dx, y:=y1-dy
	  }
  
	  ClientToScreen(&x, &y, x1, y1, id:="")
	  {
		if (!id)
		  id := WinGetID("A")
		pt := Buffer(8, 0), NumPut("int64", 0, pt)  
		, DllCall("ClientToScreen", "Int", id, "Ptr", pt)  
		, x:=x1+NumGet(pt, "int"), y:=y1+NumGet(pt, 4, "int")
	  }
  
	  ScreenToClient(&x, &y, x1, y1, id:="")
	  {
		this.ClientToScreen(&dx,&dy,0,0,id), x:=x1-dx, y:=y1-dy
	  }
  
	  ; It is not like FindText always use Screen Coordinates,
	  ; But like built-in command ImageSearch using CoordMode Settings
  
	  ImageSearch(&rx, &ry, x1:=-150000, y1:=-150000, x2:=150000, y2:=150000, text:="", ScreenShot:=1, FindAll:=0)
	  {
		dx:=dy:=0
		if (A_CoordModePixel="Window")
		  this.WindowToScreen(&dx,&dy,0,0)
		else if (A_CoordModePixel="Client")
		  this.ClientToScreen(&dx,&dy,0,0)
		if FileExist(pic:=RegExReplace(text, "\*\S+\s+"))
		  text:="|<>##10$" pic
		if (ok:=this.FindText(&x, &y, x1+dx, y1+dy, x2+dx, y2+dy
		, 0, 0, text, ScreenShot, FindAll)).Length
		{
		  For k,v in ok  ; you can use ok:=FindText().ok
			v.x-=dx, v.y-=dy, v.mx-=dx, v.my-=dy
		  rx:=x-dx, ry:=y-dy, ErrorLevel:=0
		  return 1
		}
		else
		{
		  rx:=ry:="", ErrorLevel:=1
		  return 0
		}
	  }
  
	  Click(x:="", y:="", other:="")
	  {
		bak:=A_CoordModeMouse
		CoordMode("Mouse", "Screen")
		MouseMove(x, y, 0)
		Click(x " " y " " other)
		CoordMode("Mouse", bak)
	  }

	  ; running AHK code dynamically with new threads
  
	  Class Thread
	  {
		__New(args*)
		{
		  this.pid:=this.Exec(args*)
		}
		__Delete()
		{
		  DetectHiddenWindows(true)
		  ErrorLevel := WinWait("ahk_pid " this.pid, , 0.5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
		  if WinExist("ahk_class AutoHotkey ahk_pid " this.pid)
		  {
			PostMessage(0x111, 65307)
			ErrorLevel := WinWaitClose(, , 0.5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
		  }
		  ErrorLevel := ProcessClose(this.pid)
		}
		Exec(s, Ahk:="", args:="")
		{
		  Ahk:=Ahk ? Ahk:A_IsCompiled ? A_ScriptDir "\AutoHotkey.exe":A_AhkPath
		  s:="`nDllCall(`"SetWindowText`",`"Ptr`",A_ScriptHwnd,`"Str`",`"<AHK>`")`n"
		  . "`n`n" . StrReplace(s, "`r")
		  Try
		  {
			shell:=ComObject("WScript.Shell")
			oExec:=shell.Exec("`"" Ahk "`" /force * " args)
			oExec.StdIn.Write(s)
			oExec.StdIn.Close(), pid:=oExec.ProcessID
		  }
		  Catch
		  {
			f:=A_Temp "\~ahk.tmp"
			s:="`n FileDelete " f "`n" s
			FileDelete(f)
			FileAppend(s, f)
			r:=this.Clear.Bind(this)
			SetTimer(r,-3000)
			Run("`"" Ahk "`" /force `"" f "`" " args, , "", &pid)
		  }
		  return pid
		}
		Clear()
		{
		  FileDelete(A_Temp "\~ahk.tmp")
		  SetTimer(,0)
		}
	  }
  
	  ; FindText().QPC() Use the same as A_TickCount
  
	  QPC()
	  {
		static f:=0, c:=DllCall("QueryPerformanceFrequency", "Int*", &f)+(f/=1000)
		return (!DllCall("QueryPerformanceCounter", "Int64*", &c))*0+(c/f)
	  }
  
	  ; FindText().ToolTip() Use the same as ToolTip
  
	  ToolTip(s:="", x:="", y:="", num:=1, arg:="")
	  {
		static ini:=Map(), ToolTipOff:=""
		f:= "ToolTip_" . Round(num)
		if (s="")
		{
		  ini.Delete(f)
		  if IsObject(%f%)
			  %f%.Destroy()
		  return
		}
		;-----------------
		r1:=A_CoordModeToolTip
		r2:=A_CoordModeMouse
		CoordMode("Mouse", "Screen")
		MouseGetPos(&x1, &y1)
		CoordMode("Mouse", r1)
		MouseGetPos(&x2, &y2)
		CoordMode("Mouse", r2)
		x:=Round(x="" ? x1+16 : x+x1-x2)
		y:=Round(y="" ? y1+16 : y+y1-y2)
		;-----------------
		bgcolor:=arg.bgcolor!="" ? arg.bgcolor : "FAFBFC"
		color:=arg.color!="" ? arg.color : "Black"
		font:=arg.font ? arg.font : "Consolas"
		size:=arg.size ? arg.size : "10"
		bold:=arg.bold ? arg.bold : ""
		trans:=arg.trans!="" ? Round(arg.trans & 255) : 255
		timeout:=arg.timeout!="" ? arg.timeout : ""
		;-----------------
		r:=bgcolor "|" color "|" font "|" size "|" bold "|" trans "|" s
		if (!ini.Has(f) || ini[f]!=r)
		{
		  ini[f]:=r
		  %f%.Destroy()
		  %f%.Opt("+AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x80020")
		  %f%.Margin("2", "2")
		  %f%.Color(bgcolor)
		  %f%.Font("c" . color . " s" . size . " " . bold, font)
		  %f%.Add("Text", , s)
		  %f%.Show("Hide", f)
		  ;------------------
		  dhw:=A_DetectHiddenWindows
		  DetectHiddenWindows(true)
		  WinSetTransparent(trans, "ahk_id " %f%.Hwnd)
		  DetectHiddenWindows(dhw)
		}
		%f%.Opt("+AlwaysOnTop")
		%f%.Show("NA x" . x . " y" . y)
		if (timeout)
		{
		  if (!ToolTipOff)
			ToolTipOff:=this.ToolTip.Bind(this,"")
		  SetTimer(ToolTipOff,-Round(Abs(timeout*1000))-1)
		}
	  }
  
	  ; FindText().ObjView()  view object values for Debug
  
	  ObjView(obj, keyname:="", *)
	  {
		static Gui_DeBug_Gui
		if obj = "Hide"
			return Gui_DeBug_Gui.Hide()
		if IsObject(obj)  ; thanks lexikos's type(v)
		{
		  s:=""
		  For k,v in (HasMethod(obj,"__Enum") ? obj : obj.OwnProps())
			s.=this.ObjView(v, keyname "[" (k is Number ? k : "`"" k "`"") "]")
		}
		else
		  s:=keyname ": " (obj is Number ? obj : "`"" obj "`"") "`n"
		if (keyname!="")
		  return s
		;------------------
		if IsSet(Gui_DeBug_Gui)
			Gui_DeBug_Gui.Destroy()
		Gui_DeBug_Gui := Gui("+AlwaysOnTop", "Debug view object values")
		Gui_DeBug_Gui.Add("Button", "y270 w350 Default", "OK").OnEvent("Click", this.ObjView.Bind(this, "Hide"))
		Gui_DeBug_Gui.Add("Edit", "xp y10 w350 h250 -Wrap -WantReturn").Value := s
		Gui_DeBug_Gui.Show()
		DetectHiddenWindows(false)
		WinWaitClose(Gui_DeBug_Gui.Hwnd)
		Gui_DeBug_Gui.Destroy()
	  }
  
  
	  /***** C source code of machine code *****
  
	  int __attribute__((__stdcall__)) PicFind(
		int mode, unsigned int c, unsigned int n, int dir
		, unsigned char * Bmp, int Stride, int zw, int zh
		, int sx, int sy, int sw, int sh
		, char * ss, unsigned int * s1, unsigned int * s0
		, char * text, int w, int h, int err1, int err0
		, unsigned int * allpos, int allpos_max
		, int new_w, int new_h )
	  {
		int ok=0, o, i, j, k, v, r, g, b, rr, gg, bb;
		int x, y, x1, y1, x2, y2, len1, len0, e1, e0, max;
		int r_min, r_max, g_min, g_max, b_min, b_max, x3, y3;
		unsigned char * gs;
		unsigned long long sum;
		//----------------------
		// MultiColor or PixelSearch or ImageSearch Mode
		if (mode==5)
		{
		  max=n; v=c*c;
		  for (i=0, sum=0, o=0; (j=text[o++])!='\0';)
		  {
			if (j>='0' && j<='9')
			  sum = sum*10 + (j-'0');
			else if (j=='/')
			{
			  y=(sum>>16)&0xFFFF; x=sum&0xFFFF;
			  s1[i]=(y*new_h/h)*Stride+(x*new_w/w)*4;
			  s0[i++]=sum>>32; sum=0;
			}
		  }
		  goto StartLookUp;
		}
		//----------------------
		// Generate Lookup Table
		o=0; len1=0; len0=0;
		for (y=0; y<h; y++)
		{
		  for (x=0; x<w; x++)
		  {
			if (mode==3)
			  i=(y*new_h/h)*Stride+(x*new_w/w)*4;
			else
			  i=(y*new_h/h)*sw+(x*new_w/w);
			if (text[o++]=='1')
			  s1[len1++]=i;
			else
			  s0[len0++]=i;
		  }
		}
		if (err1>=len1) len1=0;
		if (err0>=len0) len0=0;
		max=(len1>len0) ? len1 : len0;
		//----------------------
		// Color Position Mode
		// only used to recognize multicolored Verification Code
		if (mode==3)
		{
		  y=c>>16; x=c&0xFFFF;
		  c=(y*new_h/h)*Stride+(x*new_w/w)*4;
		  goto StartLookUp;
		}
		//----------------------
		// Generate Two Value Image
		o=sy*Stride+sx*4; j=Stride-sw*4; i=0;
		if (mode==0)  // Color Mode
		{
		  rr=(c>>16)&0xFF; gg=(c>>8)&0xFF; bb=c&0xFF;
		  for (y=0; y<sh; y++, o+=j)
			for (x=0; x<sw; x++, o+=4, i++)
			{
			  r=Bmp[2+o]-rr; g=Bmp[1+o]-gg; b=Bmp[o]-bb; v=r+rr+rr;
			  ss[i]=((1024+v)*r*r+2048*g*g+(1534-v)*b*b<=n) ? 1:0;
			}
		}
		else if (mode==1)  // Gray Threshold Mode
		{
		  c=(c+1)<<7;
		  for (y=0; y<sh; y++, o+=j)
			for (x=0; x<sw; x++, o+=4, i++)
			  ss[i]=(Bmp[2+o]*38+Bmp[1+o]*75+Bmp[o]*15<c) ? 1:0;
		}
		else if (mode==2)  // Gray Difference Mode
		{
		  gs=(unsigned char *)(ss+sw*sh);
		  x2=sx+sw; y2=sy+sh;
		  for (y=sy-1; y<=y2; y++)
		  {
			for (x=sx-1; x<=x2; x++, i++)
			  if (x<0 || x>=zw || y<0 || y>=zh)
				gs[i]=0;
			  else
			  {
				o=y*Stride+x*4;
				gs[i]=(Bmp[2+o]*38+Bmp[1+o]*75+Bmp[o]*15)>>7;
			  }
		  }
		  k=sw+2; i=0;
		  for (y=1; y<=sh; y++)
			for (x=1; x<=sw; x++, i++)
			{
			  o=y*k+x; n=gs[o]+c;
			  ss[i]=(gs[o-1]>n || gs[o+1]>n
				|| gs[o-k]>n   || gs[o+k]>n
				|| gs[o-k-1]>n || gs[o-k+1]>n
				|| gs[o+k-1]>n || gs[o+k+1]>n) ? 1:0;
			}
		}
		else  // (mode==4) Color Difference Mode
		{
		  r=(c>>16)&0xFF; g=(c>>8)&0xFF; b=c&0xFF;
		  rr=(n>>16)&0xFF; gg=(n>>8)&0xFF; bb=n&0xFF;
		  r_min=r-rr; g_min=g-gg; b_min=b-bb;
		  r_max=r+rr; g_max=g+gg; b_max=b+bb;
		  for (y=0; y<sh; y++, o+=j)
			for (x=0; x<sw; x++, o+=4, i++)
			{
			  r=Bmp[2+o]; g=Bmp[1+o]; b=Bmp[o];
			  ss[i]=(r>=r_min && r<=r_max
				  && g>=g_min && g<=g_max
				  && b>=b_min && b<=b_max) ? 1:0;
			}
		}
		//----------------------
		StartLookUp:
		w=new_w; h=new_h;
		if (mode==5 || mode==3)
		  { x1=sx; y1=sy; x2=sx+sw-w; y2=sy+sh-h; sx=0; sy=0; }
		else
		  { x1=0; y1=0; x2=sw-w; y2=sh-h; }
		if (dir<1 || dir>8) dir=1;
		// 1 ==> ( Left to Right ) Top to Bottom
		// 2 ==> ( Right to Left ) Top to Bottom
		// 3 ==> ( Left to Right ) Bottom to Top
		// 4 ==> ( Right to Left ) Bottom to Top
		// 5 ==> ( Top to Bottom ) Left to Right
		// 6 ==> ( Bottom to Top ) Left to Right
		// 7 ==> ( Top to Bottom ) Right to Left
		// 8 ==> ( Bottom to Top ) Right to Left
		if (--dir>3) { i=y1; y1=x1; x1=i; i=y2; y2=x2; x2=i; }
		for (y3=y1; y3<=y2; y3++)
		{
		  for (x3=x1; x3<=x2; x3++)
		  {
			y=((dir&3)>1) ? y1+y2-y3 : y3;
			x=(dir&1) ? x1+x2-x3 : x3;
			if (dir>3) { i=y; y=x; x=i; }
			//----------------------
			e1=err1; e0=err0;
			if (mode==5)
			{
			  o=y*Stride+x*4;
			  for (i=0; i<max; i++)
			  {
				j=o+s1[i]; c=s0[i]; r=Bmp[2+j]-((c>>16)&0xFF);
				g=Bmp[1+j]-((c>>8)&0xFF); b=Bmp[j]-(c&0xFF);
				if ((r*r>v || g*g>v || b*b>v) && (--e1)<0)
				  goto NoMatch;
			  }
			}
			else if (mode==3)
			{
			  o=y*Stride+x*4;
			  j=o+c; rr=Bmp[2+j]; gg=Bmp[1+j]; bb=Bmp[j];
			  for (i=0; i<max; i++)
			  {
				if (i<len1)
				{
				  j=o+s1[i]; r=Bmp[2+j]-rr; g=Bmp[1+j]-gg; b=Bmp[j]-bb; v=r+rr+rr;
				  if ((1024+v)*r*r+2048*g*g+(1534-v)*b*b>n && (--e1)<0)
					goto NoMatch;
				}
				if (i<len0)
				{
				  j=o+s0[i]; r=Bmp[2+j]-rr; g=Bmp[1+j]-gg; b=Bmp[j]-bb; v=r+rr+rr;
				  if ((1024+v)*r*r+2048*g*g+(1534-v)*b*b<=n && (--e0)<0)
					goto NoMatch;
				}
			  }
			}
			else
			{
			  o=y*sw+x;
			  for (i=0; i<max; i++)
			  {
				if (i<len1 && ss[o+s1[i]]==0 && (--e1)<0) goto NoMatch;
				if (i<len0 && ss[o+s0[i]]!=0 && (--e0)<0) goto NoMatch;
			  }
			  // Clear the image that has been found
			  for (i=0; i<len1; i++)
				ss[o+s1[i]]=0;
			}
			allpos[ok*2]=sx+x; allpos[ok*2+1]=sy+y;
			if (++ok>=allpos_max) goto Return1;
			NoMatch:;
		  }
		}
		//----------------------
		Return1:
		return ok;
	  }
  
	  */
  
  
	  ;==== Optional GUI interface ====
  
  
	  Gui(cmd, arg1:="", args*)
	  {
		static
		local cri
		static init:=0
		if (!init)
		{
		  init:=1
		  Gui_ := this.Gui.Bind(this)
		  Gui_G := this.Gui.Bind(this, "G")
		  Gui_Run := this.Gui.Bind(this, "Run")
		  Gui_Off := this.Gui.Bind(this, "Off")
		  Gui_Show := this.Gui.Bind(this, "Show")
		  Gui_KeyDown := this.Gui.Bind(this, "KeyDown")
		  Gui_LButtonDown := this.Gui.Bind(this, "LButtonDown")
		  Gui_MouseMove := this.Gui.Bind(this, "MouseMove")
		  Gui_ScreenShot := this.Gui.Bind(this, "ScreenShot")
		  Gui_ShowPic := this.Gui.Bind(this, "ShowPic")
		  Gui_Slider := this.Gui.Bind(this, "Slider")
		  Gui_ToolTip := this.Gui.Bind(this, "ToolTip")
		  Gui_ToolTipOff := this.Gui.Bind(this, "ToolTipOff")
		  Gui_SaveScr := this.Gui.Bind(this, "SaveScr")
		  cri:=A_IsCritical
		  Critical()

		  Gui_("Load_Language_Text")
		  Gui_("MakeCaptureWindow")
		  Gui_("MakeMainWindow")
		  OnMessage(0x100, Gui_KeyDown)
		  OnMessage(0x201, Gui_LButtonDown)
		  OnMessage(0x200, Gui_MouseMove)
		  Tray:= A_TrayMenu
		  Tray.Add()
		  Tray.Add(Lang["s1"], Gui_Show)
		  if (!A_IsCompiled and A_LineFile=A_ScriptFullPath)
		  {
			Tray.Default := Lang["s1"]
			Tray.ClickCount := 1
			TraySetIcon("Shell32.dll", "23")
		  }
		  Critical(cri)
		}
		Switch cmd
		{
		Case "Off":
		  return hk:=SubStr(A_ThisHotkey, 2)
		Case "G":
		  ;ogc%id%.Options("+g")
		  return
		Case "Run":
		  Critical()
		  Gui_(arg1, args*)
		  return
		Case "Show":
		  FindText_Main.Show("Center")
		  ogcEditscr.Focus()
		  return
		Case "Hide":
		  %arg1%.Hide()
		Case "MakeCaptureWindow":
		  WindowColor:="0xDDEEFF"
		  FindText_Capture := Gui()
		  FindText_Capture.Opt("+AlwaysOnTop -DPIScale")
		  FindText_Capture.MarginX := "15", FindText_Capture.MarginY := "15"
		  FindText_Capture.BackColor := WindowColor
		  FindText_Capture.SetFont("s12", "Verdana")
		  FindText_Capture.Opt("-Theme")
		  ww:=35, hh:=12, nW:=71, nH:=25, w:=11, C_:=[], Cid_:=Map()
		  Loop nW*(nH+1)
		  {
			i:=A_Index, j:=i=1 ? "" : (Mod(i,nW)=1 ? "xm y+1":"x+1")
			ogcid := FindText_Capture.Add("Progress", "w" . w . " h" . w . " " . j . " -E0x20000 Background000000")
			C_.InsertAt(i, ogcid.Hwnd), Cid_[ogcid.Hwnd] := i
		  }
		  FindText_Capture.Opt("+Theme")
		  ogcid.GetPos(&pX, &pY, &pW, &pH)
		  w:=pX+pW-15, h:=pY+pH-15
		  ogcMySlider1 := FindText_Capture.Add("Slider", "xm w" . w . " Disabled +Center Page20 Line10 NoTicks AltSubmit")
		  ogcMySlider1.OnEvent("Change", Gui_Run.Bind("MySlider1"))
		  ogcMySlider2 := FindText_Capture.Add("Slider", "ym h" . h . " Disabled +Center Page20 Line10 NoTicks AltSubmit +Vertical")
		  ogcMySlider2.OnEvent("Change", Gui_Run.Bind("MySlider2"))
		  ogcMySlider2.GetPos(&pX, &pY, &pW, &pH)
		  k:=pX+pW, MySlider1:=MySlider2:=dx:=dy:=0
		  ;--------------
		  ogcLangAutoid := FindText_Capture.Add("Button", "xm Hidden Section", Lang["Auto"])
		  ogcLangAutoid.OnEvent("Click", Gui_Run.Bind("Normal"))
		  ogcLangAutoid.GetPos(&pX, &pY, &pW, &pH)
		  w:=Round(pW*0.75), i:=Round(w*3+15+pW*0.5-w*1.5)
		  ogcButtonRepU := FindText_Capture.Add("Button", "xm+" . i . " yp w" . w . " hp -Wrap vRepU", Lang["RepU"])
		  ogcButtonRepU.OnEvent("Click", Gui_Run.Bind("RepU"))
		  ogcButtonCutU := FindText_Capture.Add("Button", "x+0 wp hp -Wrap vCutU", Lang["CutU"])
		  ogcButtonCutU.OnEvent("Click", Gui_Run.Bind("CutU"))
		  ogcButtonCutU3 := FindText_Capture.Add("Button", "x+0 wp hp -Wrap vCutU3", Lang["CutU3"])
		  ogcButtonCutU3.OnEvent("Click", Gui_Run.Bind("CutU3"))
		  ogcButtonRepL := FindText_Capture.Add("Button", "xm wp hp -Wrap vRepL", Lang["RepL"])
		  ogcButtonRepL.OnEvent("Click", Gui_Run.Bind("RepL"))
		  ogcButtonCutL := FindText_Capture.Add("Button", "x+0 wp hp -Wrap vCutL", Lang["CutL"])
		  ogcButtonCutL.OnEvent("Click", Gui_Run.Bind("CutL"))
		  ogcButtonCutL3 := FindText_Capture.Add("Button", "x+0 wp hp -Wrap vCutL3", Lang["CutL3"])
		  ogcButtonCutL3.OnEvent("Click", Gui_Run.Bind("CutL3"))
		  ogcButtonAuto := FindText_Capture.Add("Button", "x+15 w" . pW . " hp -Wrap vAuto", Lang["Auto"])
		  ogcButtonAuto.OnEvent("Click", Gui_Run.Bind("Auto"))
		  ogcButtonRepR := FindText_Capture.Add("Button", "x+15 w" . w . " hp -Wrap vRepR", Lang["RepR"])
		  ogcButtonRepR.OnEvent("Click", Gui_Run.Bind("RepR"))
		  ogcButtonCutR := FindText_Capture.Add("Button", "x+0 wp hp -Wrap vCutR", Lang["CutR"])
		  ogcButtonCutR.OnEvent("Click", Gui_Run.Bind("CutR"))
		  ogcButtonCutR3 := FindText_Capture.Add("Button", "x+0 wp hp -Wrap vCutR3", Lang["CutR3"])
		  ogcButtonCutR3.OnEvent("Click", Gui_Run.Bind("CutR3"))
		  ogcButtonRepD := FindText_Capture.Add("Button", "xm+" . i . " wp hp -Wrap vRepD", Lang["RepD"])
		  ogcButtonRepD.OnEvent("Click", Gui_Run.Bind("RepD"))
		  ogcButtonCutD := FindText_Capture.Add("Button", "x+0 wp hp -Wrap vCutD", Lang["CutD"])
		  ogcButtonCutD.OnEvent("Click", Gui_Run.Bind("CutD"))
		  ogcButtonCutD3 := FindText_Capture.Add("Button", "x+0 wp hp -Wrap vCutD3", Lang["CutD3"])
		  ogcButtonCutD3.OnEvent("Click", Gui_Run.Bind("CutD3"))
		  ;--------------
		  FindText_Capture.Add("Text", "x+80 ys+3 Section", Lang["SelGray"])
		  ogcEditSelGray := FindText_Capture.Add("Edit", "x+3 yp-3 w60 vSelGray ReadOnly")
		  FindText_Capture.Add("Text", "x+15 ys", Lang["SelColor"])
		  ogcEditSelColor := FindText_Capture.Add("Edit", "x+3 yp-3 w120 vSelColor ReadOnly")
		  FindText_Capture.Add("Text", "x+15 ys", Lang["SelR"])
		  ogcEditSelR := FindText_Capture.Add("Edit", "x+3 yp-3 w60 vSelR ReadOnly")
		  FindText_Capture.Add("Text", "x+5 ys", Lang["SelG"])
		  ogcEditSelG := FindText_Capture.Add("Edit", "x+3 yp-3 w60 vSelG ReadOnly")
		  FindText_Capture.Add("Text", "x+5 ys", Lang["SelB"])
		  ogcEditSelB := FindText_Capture.Add("Edit", "x+3 yp-3 w60 vSelB ReadOnly")
		  ;--------------
		  x:=w*6+pW+15*4
		  Tab := FindText_Capture.Add("Tab3", "x" . x . " y+15 -Wrap", StrSplit(Lang["s2"], "|"))
		  Tab.UseTab(1)
		  FindText_Capture.Add("Text", "x+15 y+15", Lang["Threshold"])
		  ogcEditThreshold := FindText_Capture.Add("Edit", "x+15 w100 vThreshold")
		  ogcButtonGray2Two := FindText_Capture.Add("Button", "x+15 yp-3 vGrayDiff", Lang["Gray2Two"])
		  ogcButtonGray2Two.OnEvent("Click", Gui_Run.Bind("Gray2Two"))
		  Tab.UseTab(2)
		  FindText_Capture.Add("Text", "x+15 y+15", Lang["GrayDiff"])
		  ogcEditGrayDiff := FindText_Capture.Add("Edit", "x+15 w100", "50")
		  ogcButtonGrayDiff2Two := FindText_Capture.Add("Button", "x+15 yp-3 vGray2Two", Lang["GrayDiff2Two"])
		  ogcButtonGrayDiff2Two.OnEvent("Click", Gui_Run.Bind("GrayDiff2Two"))
		  Tab.UseTab(3)
		  FindText_Capture.Add("Text", "x+15 y+15", Lang["Similar1"] " 0")
		  ogcSliderSimilar1 := FindText_Capture.Add("Slider", "x+0 w120 vSimilar1 +Center Page1 NoTicks ToolTip", 100)
		  FindText_Capture.Add("Text", "x+0", "100")
		  ogcButtonColor2Two := FindText_Capture.Add("Button", "x+15 yp-3", Lang["Color2Two"])
		  ogcButtonColor2Two.OnEvent("Click", Gui_Run.Bind("Color2Two"))
		  id := ogcButtonColor2Two.hwnd
		  Tab.UseTab(4)
		  FindText_Capture.Add("Text", "x+15 y+15", Lang["Similar2"] " 0")
		  ogcSliderSimilar2 := FindText_Capture.Add("Slider", "x+0 w120 vSimilar2 +Center Page1 NoTicks ToolTip", 100)
		  FindText_Capture.Add("Text", "x+0", "100")
		  ogcButtonColorPos2Two := FindText_Capture.Add("Button", "x+15 yp-3", Lang["ColorPos2Two"])
		  ogcButtonColorPos2Two.OnEvent("Click", Gui_Run.Bind("ColorPos2Two"))
		  Tab.UseTab(5)
		  FindText_Capture.Add("Text", "x+10 y+15", Lang["DiffR"])
		  ogcEditDiffR := FindText_Capture.Add("Edit", "x+5 w80 vDiffR Limit3")
		  ogcUpDowndR := FindText_Capture.Add("UpDown", "vdR range0-255 Wrap")
		  FindText_Capture.Add("Text", "x+5", Lang["DiffG"])
		  ogcEditDiffG := FindText_Capture.Add("Edit", "x+5 w80 vDiffG Limit3")
		  ogcUpDowndG := FindText_Capture.Add("UpDown", "vdG range0-255 Wrap")
		  FindText_Capture.Add("Text", "x+5", Lang["DiffB"])
		  ogcEditDiffB := FindText_Capture.Add("Edit", "x+5 w80 vDiffB Limit3")
		  ogcUpDowndB := FindText_Capture.Add("UpDown", "vdB range0-255 Wrap")
		  ogcButtonColorDiff2Two := FindText_Capture.Add("Button", "x+15 yp-3", Lang["ColorDiff2Two"])
		  ogcButtonColorDiff2Two.OnEvent("Click", Gui_Run.Bind("ColorDiff2Two"))
		  Tab.UseTab(6)
		  FindText_Capture.Add("Text", "x+10 y+15", Lang["DiffRGB"])
		  ogcEditDiffRGB := FindText_Capture.Add("Edit", "x+5 w80 vDiffRGB Limit3")
		  ogcUpDowndRGB := FindText_Capture.Add("UpDown", "vdRGB range0-255 Wrap")
		  ogcCheckboxMultiColor := FindText_Capture.Add("Checkbox", "x+15 yp+5 vMultiColor", Lang["MultiColor"])
		  ogcCheckboxMultiColor.OnEvent("Click", Gui_Run.Bind("MultiColor"))
		  ogcButtonUndo := FindText_Capture.Add("Button", "x+15 yp-5 vUndo", Lang["Undo"])
		  ogcButtonUndo.OnEvent("Click", Gui_Run.Bind("Undo"))
		  Tab.UseTab()
		  ;--------------
		  ogcButtonReset := FindText_Capture.Add("Button", "xm vReset", Lang["Reset"])
		  ogcButtonReset.OnEvent("Click", Gui_Run.Bind("Reset"))
		  ogcCheckboxModify := FindText_Capture.Add("Checkbox", "x+15 yp+5 vModify", Lang["Modify"])
		  ogcCheckboxModify.OnEvent("Click", Gui_Run.Bind("Modify"))
		  FindText_Capture.Add("Text", "x+30", Lang["Comment"])
		  ogcEditComment := FindText_Capture.Add("Edit", "x+5 yp-2 w150 vComment")
		  ogcButtonSplitAdd := FindText_Capture.Add("Button", "x+30 yp-3 vSplitAdd", Lang["SplitAdd"])
		  ogcButtonSplitAdd.OnEvent("Click", Gui_Run.Bind("SplitAdd"))
		  ogcButtonAllAdd := FindText_Capture.Add("Button", "x+10 vAllAdd", Lang["AllAdd"])
		  ogcButtonAllAdd.OnEvent("Click", Gui_Run.Bind("AllAdd"))
		  ogcButtonOK := FindText_Capture.Add("Button", "x+10 wp vOK", Lang["OK"])
		  ogcButtonOK.OnEvent("Click", Gui_Run.Bind("OK"))
		  ogcButtonCancel := FindText_Capture.Add("Button", "x+10 wp vCancel", Lang["Cancel"])
		  ogcButtonCancel.OnEvent("Click", Gui_Run.Bind("Hide", "FindText_Capture"))
		  ogcButtonBind0 := FindText_Capture.Add("Button", "xm vBind0", Lang["Bind0"])
		  ogcButtonBind0.OnEvent("Click", Gui_Run.Bind("Bind0"))
		  ogcButtonBind1 := FindText_Capture.Add("Button", "x+10 vBind1", Lang["Bind1"])
		  ogcButtonBind1.OnEvent("Click", Gui_Run.Bind("Bind1"))
		  ogcButtonBind2 := FindText_Capture.Add("Button", "x+10 vBind2", Lang["Bind2"])
		  ogcButtonBind2.OnEvent("Click", Gui_Run.Bind("Bind2"))
		  ogcButtonBind3 := FindText_Capture.Add("Button", "x+10 vBind3", Lang["Bind3"])
		  ogcButtonBind3.OnEvent("Click", Gui_Run.Bind("Bind3"))
		  ogcButtonBind4 := FindText_Capture.Add("Button", "x+10 vBind4", Lang["Bind4"])
		  ogcButtonBind4.OnEvent("Click", Gui_Run.Bind("Bind4"))
		  ogcButtonSave := FindText_Capture.Add("Button", "x+30 vSave", Lang["Save"])
		  ogcButtonSave.OnEvent("Click", Gui_Run.Bind("Save"))
		  FindText_Capture.Title := Lang["s3"]
		  FindText_Capture.Show("Hide")
		  return
		Case "MakeMainWindow":
		  FindText_Main := Gui()
		  FindText_Main.Opt("+AlwaysOnTop -DPIScale")
		  FindText_Main.MarginX := "15", FindText_Main.MarginY := "10"
		  FindText_Main.BackColor := WindowColor
		  FindText_Main.SetFont("s12", "Verdana")
		  FindText_Main.Add("Text", "xm", Lang["NowHotkey"])
		  ogcEditNowHotkey := FindText_Main.Add("Edit", "x+5 w200 vNowHotkey ReadOnly")
		  ogcSetHotkey1 := FindText_Main.Add("Hotkey", "x+5 w200 vSetHotkey1")
		  ogcDDLSetHotkey2 := FindText_Main.Add("DropDownList", "x+5 w180 vSetHotkey2", ["F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","LWin","MButton","ScrollLock","CapsLock","Ins","Esc","BS","Del","Tab","Home","End","PgUp","PgDn","NumpadDot","NumpadSub","NumpadAdd","NumpadDiv","NumpadMult"])
		  ogcMyGroup := FindText_Main.Add("GroupBox", "xm y+0 w280 h55 vMyGroup cBlack")
		  FindText_Main.Add("Text", "xp+15 yp+20 Section", Lang["Myww"] ": ")
		  FindText_Main.Add("Text", "x+0 w60", ww)
		  ogcUpDownMyww := FindText_Main.Add("UpDown", "vMyww range1-100", ww)
		  FindText_Main.Add("Text", "x+15 ys", Lang["Myhh"] ": ")
		  FindText_Main.Add("Text", "x+0 w60", hh)
		  ogcUpDownMyhh := FindText_Main.Add("UpDown", "vMyhh range1-100", hh)
		  id := ogcUpDownMyhh.hwnd
		  ogcUpDownMyhh.GetPos(&pX, &pY, &pW, &pH)
		  ogcMyGroup.Move(, , (pX+pW), (pH+30))
		  x:=pX+pW+15*2
		  ogcButtonApply := FindText_Main.Add("Button", "x" . x . " ys-8 w150 vApply", Lang["Apply"])
		  ogcButtonApply.OnEvent("Click", Gui_Run.Bind("Apply"))
		  ogcCheckboxAddFunc := FindText_Main.Add("Checkbox", "x+30 ys vAddFunc", Lang["AddFunc"] " FindText()")
		  ogcButtonCutL2 := FindText_Main.Add("Button", "xm y+18 w144 vCutL2", Lang["CutL2"])
		  ogcButtonCutL2.OnEvent("Click", Gui_Run.Bind("CutL2"))
		  ogcButtonCutR2 := FindText_Main.Add("Button", "x+0 wp vCutR2", Lang["CutR2"])
		  ogcButtonCutR2.OnEvent("Click", Gui_Run.Bind("CutR2"))
		  ogcButtonCutU2 := FindText_Main.Add("Button", "x+0 wp vCutU2", Lang["CutU2"])
		  ogcButtonCutU2.OnEvent("Click", Gui_Run.Bind("CutU2"))
		  ogcButtonCutD2 := FindText_Main.Add("Button", "x+0 wp vCutD2", Lang["CutD2"])
		  ogcButtonCutD2.OnEvent("Click", Gui_Run.Bind("CutD2"))
		  ogcButtonUpdate := FindText_Main.Add("Button", "x+0 wp vUpdate", Lang["Update"])
		  ogcButtonUpdate.OnEvent("Click", Gui_Run.Bind("Update"))
		  FindText_Main.SetFont("s6 bold", "Verdana")
		  ogcEditMyPic := FindText_Main.Add("Edit", "xm y+10 w720 r20 vMyPic -Wrap")
		  FindText_Main.SetFont("s12 norm", "Verdana")
		  ogcButtonCapture := FindText_Main.Add("Button", "xm w240 vCapture", Lang["Capture"])
		  ogcButtonCapture.OnEvent("Click", Gui_Run.Bind("Capture"))
		  ogcButtonTest := FindText_Main.Add("Button", "x+0 wp vTest", Lang["Test"])
		  ogcButtonTest.OnEvent("Click", Gui_Run.Bind("Test"))
		  ogcButtonCopy := FindText_Main.Add("Button", "x+0 wp vCopy", Lang["Copy"])
		  ogcButtonCopy.OnEvent("Click", Gui_Run.Bind("Copy"))
		  ogcButtonCaptureS := FindText_Main.Add("Button", "xm y+0 wp vCaptureS", Lang["CaptureS"])
		  ogcButtonCaptureS.OnEvent("Click", Gui_Run.Bind("CaptureS"))
		  ogcButtonGetRange := FindText_Main.Add("Button", "x+0 wp vGetRange", Lang["GetRange"])
		  ogcButtonGetRange.OnEvent("Click", Gui_Run.Bind("GetRange"))
		  ogcButtonGetOffset := FindText_Main.Add("Button", "x+0 wp vGetOffset", Lang["GetOffset"])
		  ogcButtonGetOffset.OnEvent("Click", Gui_Run.Bind("GetOffset"))
		  ogcEditClipText := FindText_Main.Add("Edit", "xm y+10 w180 hp vClipText")
		  ogcButtonPaste := FindText_Main.Add("Button", "x+0 vPaste", " " Lang["Paste"] " ")
		  ogcButtonPaste.OnEvent("Click", Gui_Run.Bind("Paste"))
		  ogcButtonTestClip := FindText_Main.Add("Button", "x+0 vTestClip", " " Lang["TestClip"] " ")
		  ogcButtonTestClip.OnEvent("Click", Gui_Run.Bind("TestClip"))
		  ogcButtonGetClipOffset := FindText_Main.Add("Button", "x+0 vGetClipOffset", " " Lang["GetClipOffset"] " ")
		  ogcButtonGetClipOffset.OnEvent("Click", Gui_Run.Bind("GetClipOffset"))
		  ogcEditOffset := FindText_Main.Add("Edit", "x+0 hp w150 hp vOffset")
		  id := ogcEditOffset.hwnd
		  ogcEditOffset.GetPos(&pX, &pY, &pW, &pH)
		  w:=720+15-(pX+pW)
		  ogcButtonCopyOffset := FindText_Main.Add("Button", "x+0 w" . w . " hp vCopyOffset", Lang["CopyOffset"])
		  ogcButtonCopyOffset.OnEvent("Click", Gui_Run.Bind("CopyOffset"))
		  FindText_Main.SetFont("s12 cBlue", "Verdana")
		  ogcEditscr := FindText_Main.Add("Edit", "xm w720 h300 vscr -Wrap HScroll")
		  hscr := ogcEditscr.hwnd
		  FindText_Main.Title := Lang["s4"]
		  FindText_Main.Show("Hide")
		  Gui_("LoadScr")
		  OnExit(Gui_SaveScr)
		  return
		Case "LoadScr":
		  f:=A_Temp "\~scr1.tmp"
		  try s := Fileread(f)
		  ogcEditscr.Value := s
		  return
		Case "SaveScr":
		  f:=A_Temp "\~scr1.tmp"
		  s := ogcEditscr.Value
		  FileDelete(f)
		  FileAppend(s, f)
		  return
		Case "Capture","CaptureS":
		  if (show_gui:=(WinExist()=FindText_Main.Hwnd))
		  {
			WinMinimize()
			FindText_Main.Hide()
		  }
		  ShowScreenShot:=InStr(cmd, "CaptureS")
		  if (ShowScreenShot)
		  {
			this.ScreenShot(), f:=Gui_("SelectPic")
			if (f="") or !FileExist(f)
			{
			  if (show_gui)
			  {
				FindText_Main.Show()
				ogcEditscr.Focus()
			  }
			  Exit()
			}
			this.ShowPic(f)
		  }
		  ;----------------------
		  if GetKeyState("Ctrl")
			Send("{Ctrl Up}")
		  FindText_HotkeyIf := Gui()
		  FindText_HotkeyIf.Opt("-Caption +ToolWindow +E0x80000")
		  FindText_HotkeyIf.Title := "FindText_HotkeyIf"
		  FindText_HotkeyIf.Show("NA x0 y0 w0 h0")
		  HotIfWinExist("FindText_HotkeyIf")
		  For k,v in StrSplit("RButton|Up|Down|Left|Right","|")
		  {
			if GetKeyState(v)
			  Send("{" v " Up}")
			Hotkey("*" v, Gui_Off, "On UseErrorLevel")
		  }
		  CoordMode("Mouse")
		  w := ogcUpDownMyww.Value
		  h := ogcUpDownMyhh.Value
		  oldx:=oldy:="", r:=StrSplit(Lang["s5"],"|")
		  if (!show_gui)
			w:=20, h:=8
		  Critical("Off")
		  hk:="", State:=Gui_("State")
		  Loop
		  {
			Sleep(50)
			MouseGetPos(&x, &y, &Bind_ID)
			if GetKeyState("Up","P") || (hk="Up")
			  (h>1 && h--), hk:=""
			else if GetKeyState("Down","P") || (hk="Down")
			  h++, hk:=""
			else if GetKeyState("Left","P") || (hk="Left")
			  (w>1 && w--), hk:=""
			else if GetKeyState("Right","P") || (hk="Right")
			  w++, hk:=""
			this.RangeTip(x-w,y-h,2*w+1,2*h+1,(A_MSec<500?"Red":"Blue"))
			if (oldx=x and oldy=y)
			  Continue
			oldx:=x, oldy:=y
			ToolTip(r[1] " : " x "," y "`n" r[2])
		  }
		  Until (hk="RButton") or (State!=Gui_("State"))
		  timeout:=A_TickCount+3000
		  While (A_TickCount<timeout) and (State!=Gui_("State"))
			Sleep(50)
		  hk:="", px:=x, py:=y, oldx:=oldy:=""
		  Loop
		  {
			Sleep(50)
			if GetKeyState("Up","P") || (hk="Up")
			  (h>1 && h--), hk:=""
			else if GetKeyState("Down","P") || (hk="Down")
			  h++, hk:=""
			else if GetKeyState("Left","P") || (hk="Left")
			  (w>1 && w--), hk:=""
			else if GetKeyState("Right","P") || (hk="Right")
			  w++, hk:=""
			this.RangeTip(x-w,y-h,2*w+1,2*h+1,(A_MSec<500?"Red":"Blue"))
			MouseGetPos(&x1, &y1)
			if (oldx=x1 and oldy=y1)
			  Continue
			oldx:=x1, oldy:=y1
			ToolTip(r[1] " : " x "," y "`n" r[2])
		  }
		  Until (hk="RButton") or (State!=Gui_("State"))
		  timeout:=A_TickCount+3000
		  While (A_TickCount<timeout) and (State!=Gui_("State"))
			Sleep(50)
		  ToolTip()
		  Critical()
		  this.RangeTip()
		  For k,v in StrSplit("RButton|Up|Down|Left|Right","|")
			Hotkey("*" v, Gui_Off, "Off UseErrorLevel")
		  HotIfWinExist()
		  FindText_HotkeyIf.Destroy()
		  if (ShowScreenShot)
			this.ShowPic()
		  if (!show_gui)
			return [px-w, py-h, px+w, py+h]
		  ;-----------------------
		  nW:=71, nH:=25, dx:=dy:=0, c:=WindowColor
		  c:=((c&0xFF)<<16)|(c&0xFF00)|((c&0xFF0000)>>16)
		  Loop nW*(nH+1) {
			SendMessage(0x2001, 0, (A_Index>nW*nH ? 0xAAFFFF:c), , "ahk_id " C_[A_Index])
		   }
		  ww:=w, hh:=h, nW:=2*ww+1, nH:=2*hh+1
		  i:=nW>71, j:=nH>25
		  ogcMySlider1.Enabled := i
		  ogcMySlider2.Enabled := j
		  ogcMySlider1.Value := MySlider1:=0
		  ogcMySlider2.Value := MySlider2:=0
		  ;------------------------
		  Gui_("getcors", !ShowScreenShot)
		  Gui_("Reset")
		  for _, ind in ["SelGray", "SelColor", "SelR", "SelG", "SelB", "Threshold"]
		    ogcEdit%ind%.Value := ""
		  ogcCheckboxModify.Value := Modify:=0
		  ogcCheckboxMultiColor.Value := MultiColor:=0
		  ogcEditGrayDiff.Value := 50
		  ogcButtonGray2Two.Focus()
		  ogcButtonGray2Two.Opt("+Default")
		  FindText_Capture.Show("Center")
		  Event:=result:=""
		  DetectHiddenWindows(false)
		  Critical("Off")
		  FindText_Capture.Opt("+LastFound")
		  ErrorLevel := WinWaitClose("ahk_id " WinExist()) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
		  Critical()
		  ToolTip()
		  ;--------------------------------
		  if (cors.Has("bind") && cors.bind!="")
		  {
			tt := WinGetTitle("ahk_id " Bind_ID)
			tc := WinGetClass("ahk_id " Bind_ID)
			tt:=Trim(SubStr(tt, 1, 30) (tc ? " ahk_class " tc:""))
			tt:=StrReplace(RegExReplace(tt, "[;``]", "``$0"), "`"","`"`"") ; "
			result:="`nSetTitleMatchMode(2)`nid:=WinExist(`"" tt "`")"
			. "`nFindText().BindWindow(id" (cors.bind=0 ? "":"," cors.bind)
			. ")  `; " Lang["s6"] " this.BindWindow(0)`n`n" result
		  }
		  if (Event="OK")
		  {
			if (!A_IsCompiled)
			{
			  s:=Fileread(A_LineFile)
			  s:=SubStr(s, (s~="i)\n[\s;=]+ Copy The")<1 ? (s~="i)\n[\s;=]+ Copy The")-1 : (s~="i)\n[\s;=]+ Copy The"))
			}
			else s:=""
			ogcEditscr.Value := result "`n" s
			if !InStr(result, "##")
			  ogcEditMyPic.Value := Trim(this.ASCII(result),"`n")
			result:=s:=""
		  }
		  else if (Event="SplitAdd") or (Event="AllAdd")
		  {
			s := ogcEditscr.Value
			r:=SubStr(s, 1, InStr(s, "=FindText("))
			i:=j:=0, re:="<[^>\n]*>[^$\n]+\$[^`"\r\n]+" ;"
			While j:=RegExMatch(r, re, , (j+1)<1 ? (j+1)-1 : (j+1))
			  i:=InStr(r, "`n", 0, (j)<1 ? (j)-1 : (j))
			ogcEditscr.Value := SubStr(s, 1, i) . result . SubStr(s, (i+1)<1 ? (i+1)-1 : (i+1))
			if !InStr(result, "##")
			  ogcEditMyPic.Value := Trim(this.ASCII(result),"`n")
			result:=s:=""
		  }
		  ;----------------------
		  FindText_Main.Show()
		  ogcEditscr.Focus()
		  return
		Case "State":
		  return GetKeyState((arg1?"LButton":"RButton"),"P")
		  . "|" GetKeyState((arg1?"LButton":"RButton"))
		  . "|" GetKeyState("Ctrl","P")
		  . "|" GetKeyState("Ctrl")
		Case "SelectPic":
		  if IsSet(FindText_SelectPic)
			  return FindText_SelectPic.Show()
		  FindText_SelectPic := Gui()
		  Pics:=[], Names:=[], s:=[]
		  Loop Files, A_Temp "\Ahk_ScreenShot\*.bmp"
			Pics.Push(LoadPicture(v:=A_LoopFilePath))
			, Names.Push(v), s.Push(RegExReplace(v, "i)^.*\\|\.bmp$"))
		  FindText_SelectPic.Opt("+LastFound +AlwaysOnTop -DPIScale")
		  FindText_SelectPic.MarginX := "15", FindText_SelectPic.MarginY := "15"
		  FindText_SelectPic.SetFont("s12", "Verdana")
		  ogchPic := FindText_SelectPic.Add("Pic", "w800 h500 +Border")
		  hPic := ogchPic.hwnd
		  ogcListBoxSelectBox := FindText_SelectPic.Add("ListBox", "x+15 w120 hp vSelectBox AltSubmit 0x100 Choose1", s)
		  ogcListBoxSelectBox.OnEvent("Change", Gui_Run.Bind("SelectBox"))
		  ogcButtonOK2 := FindText_SelectPic.Add("Button", "xm w170 vOK2 Default", Lang["OK2"])
		  ogcButtonOK2.OnEvent("Click", Gui_Run.Bind("OK2"))
		  ogcButtonCancel2 := FindText_SelectPic.Add("Button", "x+15 wp vCancel2", Lang["Cancel2"])
		  ogcButtonCancel2.OnEvent("Click", Gui_Run.Bind("Hide", "FindText_SelectPic"))
		  ogcButtonClearAll := FindText_SelectPic.Add("Button", "x+15 wp vClearAll", Lang["ClearAll"])
		  ogcButtonClearAll.OnEvent("Click", Gui_Run.Bind("ClearAll"))
		  ogcButtonOpenDir := FindText_SelectPic.Add("Button", "x+15 wp vOpenDir", Lang["OpenDir"])
		  ogcButtonOpenDir.OnEvent("Click", Gui_Run.Bind("OpenDir"))
		  ogcButtonSavePic := FindText_SelectPic.Add("Button", "x+15 wp vSavePic", Lang["SavePic"])
		  ogcButtonSavePic.OnEvent("Click", Gui_Run.Bind("SavePic"))
		  ogcListBoxSelectBox.Focus()
		  Gui_("SelectBox")
		  FindText_SelectPic.Title := "Select ScreenShot"
		  FindText_SelectPic.Show()
		  ;-----------------------
		  DetectHiddenWindows(false)
		  Critical("Off")
		  file:=""
		  ErrorLevel := WinWaitClose("ahk_id " WinExist()) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
		  Critical()
		  FindText_SelectPic.Destroy()
		  Loop Pics.Length
			DllCall("DeleteObject", "Ptr", Pics[A_Index])
		  Pics:="", Names:=""
		  return file
		Case "SavePic":
		  SelectBox := ogcListBoxSelectBox.Value
		  f:=Names[SelectBox]
		  FindText_SelectPic.Destroy()
		  Loop Pics.Length
			DllCall("DeleteObject", "Ptr", Pics[A_Index])
		  Pics:="", Names:="", show_gui_bak:=show_gui
		  this.ShowPic(f)
		  this.FindText_Screen.Opt("+OwnDialogs")
		  Loop
		  {
			pos:=Gui_("GetRange")
			msgResult := MsgBox(Lang["s15"] " !", "Tip", 4100)
			if (msgResult = "Yes")
			  Break
		  }
		  Gui_("ScreenShot", pos[1] "|" pos[2] "|" pos[3] "|" pos[4] "|0")
		  this.ShowPic()
		  if (show_gui_bak)
		  {
			ogcEditscr.Focus()
			FindText_Main.Show()
		  }
		  Exit()
		Case "SelectBox":
		  SelectBox := ogcListBoxSelectBox.Value
		  if (hBM:=Pics[SelectBox])
		  {
			this.GetBitmapWH(hBM, &w, &h)
			ogchPic.Value := "*W" (w<800?0:800)
			. " *H" (h<500?0:500) " HBITMAP:*" hBM
		  }
		  return
		Case "OK2":
		  SelectBox := ogcListBoxSelectBox.Value
		  file:=Names[SelectBox]
		  FindText_SelectPic.Hide()
		  return
		Case "ClearAll":
		  FileDelete(A_Temp "\Ahk_ScreenShot\*.bmp")
		  FindText_Main.Hide()
		  return
		Case "OpenDir":
		  Run(A_Temp "\Ahk_ScreenShot\")
		  return
		Case "getcors":
		  this.xywh2xywh(px-ww,py-hh,2*ww+1,2*hh+1,&x,&y,&w,&h)
		  if (w<1 or h<1)
			return
		  if (arg1)
			this.ScreenShot()
		  cors:=Map(), cors.Default:=0, gray:=Map(), gray.Default:=0, k:=0
		  Loop nH
		  {
			j:=py-hh+A_Index-1, i:=px-ww
			Loop nW {
			  cors[++k]:=c:=this.GetColor(i++,j,0)
			  , gray[k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
			}
		  }
		  cors.CutLeft:=Abs(px-ww-x)
		  cors.CutRight:=Abs(px+ww-(x+w-1))
		  cors.CutUp:=Abs(py-hh-y)
		  cors.CutDown:=Abs(py+hh-(y+h-1))
		  return
		Case "GetRange":
		  if (show_gui:=(WinExist()=FindText_Main.Hwnd))
			FindText_Main.Hide()
		  ;---------------------
		  FindText_GetRange := Gui()
		  FindText_GetRange.Opt("+LastFound +AlWaysOnTop +ToolWindow -Caption -DPIScale +E0x08000000")
		  FindText_GetRange.BackColor := "White"
		  WinSetTransparent(10)
		  this.xywh2xywh(0,0,0,0,0,0,0,0,&x,&y,&w,&h)
		  FindText_GetRange.Title := "GetRange"
		  FindText_GetRange.Show("NA x" . x . " y" . y . " w" . w . " h" . h)
		  ;---------------------
		  if GetKeyState("LButton")
			Send("{LButton Up}")
		  if GetKeyState("Ctrl")
			Send("{Ctrl Up}")
		  hk:="", State:=Gui_("State",1)
		  FindText_HotkeyIf.New("-Caption +ToolWindow +E0x80000")
		  FindText_HotkeyIf.Title := "FindText_HotkeyIf"
		  FindText_HotkeyIf.Show("NA x0 y0 w0 h0")
		  HotIfWinExist("FindText_HotkeyIf")
		  Hotkey("*LButton", Gui_Off, "On UseErrorLevel")
		  Hotkey("*LButton Up", Gui_Off, "On UseErrorLevel")
		  CoordMode("Mouse")
		  oldx:=oldy:="", r:=Lang["s7"]
		  Critical("Off")
		  Loop
		  {
			Sleep(50)
			MouseGetPos(&x, &y)
			if (oldx=x and oldy=y)
			  Continue
			oldx:=x, oldy:=y
			ToolTip(r)
		  }
		  Until (hk!="") or (State!=Gui_("State",1))
		  hk:="", State:=Gui_("State",1)
		  x1:=x, y1:=y, oldx:=oldy:=""
		  Loop
		  {
			Sleep(50)
			MouseGetPos(&x2, &y2)
			x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x1-x2), h:=Abs(y1-y2)
			this.RangeTip(x, y, w, h, (A_MSec<500 ? "Red":"Blue"))
			if (oldx=x2 and oldy=y2)
			  Continue
			oldx:=x2, oldy:=y2
			ToolTip(r)
		  }
		  Until (hk!="") or (State!=Gui_("State",1))
		  timeout:=A_TickCount+3000
		  While (A_TickCount<timeout) and (State=Gui_("State",1))
			Sleep(50)
		  ToolTip()
		  Critical()
		  this.RangeTip()
		  Hotkey("*LButton", Gui_Off, "Off UseErrorLevel")
		  Hotkey("*LButton Up", Gui_Off, "Off UseErrorLevel")
		  HotIfWinExist()
		  FindText_HotkeyIf.Destroy()
		  FindText_GetRange.Destroy()
		  A_Clipboard:=p:=x ", " y ", " (x+w-1) ", " (y+h-1)
		  if (!show_gui)
			return StrSplit(p, ",", " ")
		  ;---------------------
		  s := ogcEditscr.Value
		  re:="i)(=FindText\([^\n]*?)([^,\n]*,){4}"
		  . "([^,\n]*,[^,\n]*,[^,\n]*Text)"
		  if RegExMatch(s, re, &r)
		  {
			s:=StrReplace(s, r, r[1] " " p "," r[3], ,, 1)
			ogcEditscr.Value := s
		  }
		  FindText_Main.Show()
		  return
		Case "Test","TestClip":
		  FindText_Main.Opt("+LastFound")
		  WinMinimize()
		  FindText_Main.Hide()
		  DetectHiddenWindows(false)
		  ErrorLevel := WinWaitClose("ahk_id " WinExist()) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
		  Sleep(100)
		  ;----------------------
		  if (cmd="Test")
			s := ogcEditscr.Value
		  else
			s := ogcEditClipText.Value
		  if (!A_IsCompiled) and InStr(s, "MCode(") and (cmd="Test")
		  {
			Thread := FindTextClass.Thread(s)
			DetectHiddenWindows(true)
			if WinWait("ahk_class AutoHotkey ahk_pid " Thread.pid, , 3)
			  WinWaitClose(, , 30)
			; Thread:=""  ; kill the Thread
		  }
		  else
		  {
			FindText_Main.Opt("+OwnDialogs")
			t:=A_TickCount, n:=150000, X:=Y:="" 
			, RegExMatch(s, "<[^>\n]*>[^$\n]+\$[^`"\r\n]+", &r) ;"   
			, v:=this.FindText(&X, &Y, -n, -n, n, n, 0, 0, r[])
			, r:=StrSplit(Lang["s8"],"|")
			MsgBox(r[1] ":`t" Round(v.Length) "`n`n"
			. r[2] ":`t" (A_TickCount-t) " " r[3] "`n`n"
			. (v.Length ? r[4] ":`t" X ", " Y "`n`n"
			. r[5] ":`t<" (Comment:=v[1].id) ">" : ""), "Tip", "4096 T3")
			for i,j in v
			if (i<=2)
				this.MouseTip(j.mx, j.my)
			v:="", A_Clipboard:=X "," Y
		  }
		  ;----------------------
		  FindText_Main.Show()
		  ogcEditscr.Focus()
		  return
		Case "GetOffset","GetClipOffset":
		  FindText_Main.Hide()
		  FindText_Capture.Opt("+LastFound")
		  Gui_("Capture")
		  if (cmd="GetOffset")
			s := ogcEditscr.Value
		  else
			s := ogcEditClipText.Value
		  RegExMatch(s, "<[^>\n]*>[^$\n]+\$[^`"\r\n]+", &r) ;"
		  n:=150000, v:=this.FindText(&X, &Y, -n, -n, n, n, 0, 0, r[])
		  r:=StrReplace("X+" (px-X) ", Y+" (py-Y), "+-", "-")
		  if (cmd="GetOffset")
		  {
			s:=RegExReplace(s, "i)(\.Click\()[^,\n`"]*,[^,)\n]*", "$1" r,, 1) ;"
			ogcEditscr.Value := s
		  }
		  else
			ogcEditOffset.Value := v ? r:""
		  FindText_Main.Show()
		  ogcEditscr.Focus()
		  s:=v:=""
		  return
		Case "Paste":
		  if RegExMatch(A_Clipboard, "\|?<[^>\n]*>[^$\n]+\$[^`"\r\n]+", &r) ;"
		  {
			ogcEditClipText.Value := r[]
			ogcEditMyPic.Value := Trim(this.ASCII(r[]),"`n")
		  }
		  return
		Case "CopyOffset":
		  s := ogcEditOffset.Value
		  A_Clipboard:=s
		  return
		Case "Copy":
		  s := EditGetSelectedText(hscr)
		  if (s="")
		  {
			s := ogcEditscr.Value
			r := ogcCheckboxAddFunc.Text
			if (r != 1)
			  s:=RegExReplace(s, "\n\K[\s;=]+ Copy The[\s\S]*")
			  , s:=RegExReplace(s, "\n; ok:=FindText[\s\S]*")
			  , s:=SubStr(s, (s~="\n[^\n]*?Text"))
		  }
		  A_Clipboard:=RegExReplace(s, "\r", "`r`n")
		  ogcEditscr.Focus()
		  return
		Case "Apply":
		  NowHotkey := ogcEditNowHotkey.Text
		  SetHotkey1 := ogcSetHotkey1.Text
		  SetHotkey2 := ogcDDLSetHotkey2.Text
		  if (NowHotkey!="")
			Hotkey("*" NowHotkey, , "Off UseErrorLevel")
		  k:=SetHotkey1!="" ? SetHotkey1 : SetHotkey2
		  if (k!="")
			Hotkey("*" k, Gui_ScreenShot, "On UseErrorLevel")
		  ogcEditNowHotkey.Value := k
		  ogcSetHotkey1.Value := ""
		  ogcDDLSetHotkey2.Choose(0)
		  return
		Case "ScreenShot":
		  Critical()
		  f:=A_Temp "\Ahk_ScreenShot"
		  if !InStr(r:=FileExist(f), "D")
		  {
			if (r)
			{
			  FileSetAttrib("-r", f)
			  FileDelete(f)
			}
			DirCreate(f)
		  }
		  Loop
			f:=A_Temp "\Ahk_ScreenShot\" Format("{:03d}",A_Index) ".bmp"
		  Until !FileExist(f)
		  this.SavePic(f, StrSplit(InStr(arg1,"|")?arg1:"","|")*)
		  FindText_Tip := Gui()
		  FindText_Tip.Opt("+LastFound +AlwaysOnTop +ToolWindow -Caption -DPIScale +E0x08000020") ; WS_EX_NOACTIVATE:=0x08000000, WS_EX_TRANSPARENT:=0x20
		  FindText_Tip.BackColor := "Yellow"
		  FindText_Tip.SetFont("cRed s48 bold")
		  FindText_Tip.Add("Text", , Lang["s9"])
		  WinSetTransparent(200)
		  FindText_Tip.Title := "ScreenShot Tip"
		  FindText_Tip.Show("NA y0")
		  Sleep(100)
		  FindText_Tip.Destroy()
		  return
		Case "Bind0","Bind1","Bind2","Bind3","Bind4":
		  this.BindWindow(Bind_ID, bind_mode:=SubStr(cmd, 5))
		  if GetKeyState("RButton")
			Send("{RButton Up}")
		  if GetKeyState("Ctrl")
			Send("{Ctrl Up}")
		  hk:="", State:=Gui_("State")
		  FindText_HotkeyIf := Gui("-Caption +ToolWindow +E0x80000")
		  FindText_HotkeyIf.Title := "FindText_HotkeyIf"
		  FindText_HotkeyIf.Show("NA x0 y0 w0 h0")
		  HotIfWinExist("FindText_HotkeyIf")
		  Hotkey("*RButton", Gui_Off, "On UseErrorLevel")
		  CoordMode("Mouse")
		  oldx:=oldy:=""
		  Critical("Off")
		  Loop
		  {
			Sleep(50)
			MouseGetPos(&x, &y)
			if (oldx=x and oldy=y)
			  Continue
			oldx:=x, oldy:=y
			;---------------
			px:=x, py:=y, Gui_("getcors",1)
			Gui_("Reset"), r:=StrSplit(Lang["s10"],"|")
			ToolTip(r[1] " : " x "," y "`n" r[2])
		  }
		  Until (hk!="") or (State!=Gui_("State"))
		  timeout:=A_TickCount+3000
		  While (A_TickCount<timeout) and (State!=Gui_("State"))
			Sleep(50)
		  ToolTip()
		  Critical()
		  Hotkey("*RButton", Gui_Off, "Off UseErrorLevel")
		  HotIfWinExist()
		  FindText_HotkeyIf.Destroy()
		  this.BindWindow(0), cors.bind:=bind_mode
		  return
		Case "MySlider1","MySlider2":
		  SetTimer(Gui_Slider,-10)
		  return
		Case "Slider":
		  Critical()
		  dx:=nW>71 ? Round((nW-71)*ogcMySlider1.Value/100) : 0
		  dy:=nH>25 ? Round((nH-25)*ogcMySlider2.Value/100) : 0
		  if (oldx=dx and oldy=dy)
			return
		  oldy:=dy, k:=0
		  Loop nW*nH
			c:=(!show.Has(++k) ? WindowColor
			: bg="" ? cors[k] : ascii[k]
			? "Black":"White"), Gui_("SetColor")
		  Loop nW*(oldx!=dx)
		  {
			i:=A_Index-dx
			if (i>=1 && i<=71)
			{
			  c:=show.Has(nW*nH+A_Index) ? 0x0000FF : 0xAAFFFF
			  ErrorLevel := SendMessage(0x2001, 0, c, , C_[71*25+i])
			}
		  }
		  oldx:=dx
		  return
		Case "Reset":
		  show:=[], ascii:=Map(), bg:=color:=""
		  CutLeft:=CutRight:=CutUp:=CutDown:=k:=0
		  Loop nW*nH
			show.InsertAt(++k,1), c:=cors[k], Gui_("SetColor")
		  Loop cors.CutLeft
			Gui_("CutL")
		  Loop cors.CutRight
			Gui_("CutR")
		  Loop cors.CutUp
			Gui_("CutU")
		  Loop cors.CutDown
			Gui_("CutD")
		  return
		Case "SetColor":
		  if (nW=71 && nH=25)
			tk:=k
		  else
		  {
			tx:=Mod(k-1,nW)-dx, ty:=(k-1)//nW-dy
			if (tx<0 || tx>=71 || ty<0 || ty>=25)
			  return
			tk:=ty*71+tx+1
		  }
		  c:=c="Black" ? 0x000000 : c="White" ? 0xFFFFFF
			: ((c&0xFF)<<16)|(c&0xFF00)|((c&0xFF0000)>>16)
		  ErrorLevel := SendMessage(0x2001, 0, c, , C_[tk])
		  return
		Case "RepColor":
		  show[k]:=1, c:=(bg="" ? cors[k] : ascii[k]
			? "Black":"White"), Gui_("SetColor")
		  return
		Case "CutColor":
		  show[k]:=0, c:=WindowColor, Gui_("SetColor")
		  return
		Case "RepL":
		  if (CutLeft<=cors.CutLeft)
		  or (bg!="" and InStr(color,"**")
		  and CutLeft=cors.CutLeft+1)
			return
		  k:=CutLeft-nW, CutLeft--
		  Loop nH
			k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
			  ? Gui_("RepColor") : "")
		  return
		Case "CutL":
		  if (CutLeft+CutRight>=nW)
			return
		  CutLeft++, k:=CutLeft-nW
		  Loop nH
			k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
			  ? Gui_("CutColor") : "")
		  return
		Case "CutL3":
		  Loop 3
			Gui_("CutL")
		  return
		Case "RepR":
		  if (CutRight<=cors.CutRight)
		  or (bg!="" and InStr(color,"**")
		  and CutRight=cors.CutRight+1)
			return
		  k:=1-CutRight, CutRight--
		  Loop nH
			k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
			  ? Gui_("RepColor") : "")
		  return
		Case "CutR":
		  if (CutLeft+CutRight>=nW)
			return
		  CutRight++, k:=1-CutRight
		  Loop nH
			k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
			  ? Gui_("CutColor") : "")
		  return
		Case "CutR3":
		  Loop 3
			Gui_("CutR")
		  return
		Case "RepU":
		  if (CutUp<=cors.CutUp)
		  or (bg!="" and InStr(color,"**")
		  and CutUp=cors.CutUp+1)
			return
		  k:=(CutUp-1)*nW, CutUp--
		  Loop nW
			k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
			  ? Gui_("RepColor") : "")
		  return
		Case "CutU":
		  if (CutUp+CutDown>=nH)
			return
		  CutUp++, k:=(CutUp-1)*nW
		  Loop nW
			k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
			  ? Gui_("CutColor") : "")
		  return
		Case "CutU3":
		  Loop 3
			Gui_("CutU")
		  return
		Case "RepD":
		  if (CutDown<=cors.CutDown)
		  or (bg!="" and InStr(color,"**")
		  and CutDown=cors.CutDown+1)
			return
		  k:=(nH-CutDown)*nW, CutDown--
		  Loop nW
			k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
			  ? Gui_("RepColor") : "")
		  return
		Case "CutD":
		  if (CutUp+CutDown>=nH)
			return
		  CutDown++, k:=(nH-CutDown)*nW
		  Loop nW
			k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
			  ? Gui_("CutColor") : "")
		  return
		Case "CutD3":
		  Loop 3
			Gui_("CutD")
		  return
		Case "Gray2Two":
		  ogcEditThreshold.Focus()
		  Threshold := ogcEditThreshold.Text
		  if (Threshold="")
		  {
			pp:=Map()
			Loop 256
			  pp[A_Index-1]:=0
			Loop nW*nH
			  if (show[A_Index])
				pp[gray[A_Index]]++
			IP0:=IS0:=0
			Loop 256
			  k:=A_Index-1, IP0+=k*pp[k], IS0+=pp[k]
			Threshold:=Floor(IP0/IS0)
			Loop 20
			{
			  LastThreshold:=Threshold
			  IP1:=IS1:=0
			  Loop LastThreshold+1
				k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
			  IP2:=IP0-IP1, IS2:=IS0-IS1
			  if (IS1!=0 and IS2!=0)
				Threshold:=Floor((IP1/IS1+IP2/IS2)/2)
			  if (Threshold=LastThreshold)
				Break
			}
			ogcEditThreshold.Value := Threshold
		  }
		  Threshold:=Round(Threshold)
		  color:="*" Threshold, k:=i:=0
		  Loop nW*nH
		  {
			ascii[++k]:=v:=(gray[k]<=Threshold)
			if (show[k])
			  i:=(v?i+1:i-1), c:=(v?"Black":"White"), Gui_("SetColor")
		  }
		  bg:=i>0 ? "1":"0"
		  return
		Case "GrayDiff2Two":
		  GrayDiff := ogcEditGrayDiff.Text
		  if (GrayDiff="")
		  {
			FindText_Capture.Opt("+OwnDialogs")
			MsgBox(Lang["s11"] " !", "Tip", "4096 T1")
			return
		  }
		  if (CutLeft=cors.CutLeft)
			Gui_("CutL")
		  if (CutRight=cors.CutRight)
			Gui_("CutR")
		  if (CutUp=cors.CutUp)
			Gui_("CutU")
		  if (CutDown=cors.CutDown)
			Gui_("CutD")
		  GrayDiff:=Round(GrayDiff)
		  color:="**" GrayDiff, k:=i:=0
		  Loop nW*nH
		  {
			j:=gray[++k]+GrayDiff
			, ascii[k]:=v:=( gray[k-1]>j or gray[k+1]>j
			or gray[k-nW]>j or gray[k+nW]>j
			or gray[k-nW-1]>j or gray[k-nW+1]>j
			or gray[k+nW-1]>j or gray[k+nW+1]>j )
			if (show[k])
			  i:=(v?i+1:i-1), c:=(v?"Black":"White"), Gui_("SetColor")
		  }
		  bg:=i>0 ? "1":"0"
		  return
		Case "Color2Two","ColorPos2Two":
		  c := ogcEditSelColor.Text
		  if (c="")
		  {
			FindText_Capture.Opt("+OwnDialogs")
			MsgBox(Lang["s12"] " !", "Tip", "4096 T1")
			return
		  }
		  UsePos:=(cmd="ColorPos2Two") ? 1:0
		  n := ogcSliderSimilar1.Value
		  n:=Round(n/100,2), color:=c "@" n
		  , n:=Floor(512*9*255*255*(1-n)*(1-n)), k:=i:=0
		  , rr:=(c>>16)&0xFF, gg:=(c>>8)&0xFF, bb:=c&0xFF
		  Loop nW*nH
		  {
			c:=cors[++k], r:=((c>>16)&0xFF)-rr
			, g:=((c>>8)&0xFF)-gg, b:=(c&0xFF)-bb, j:=r+rr+rr
			, ascii[k]:=v:=((1024+j)*r*r+2048*g*g+(1534-j)*b*b<=n)
			if (show[k])
			  i:=(v?i+1:i-1), c:=(v?"Black":"White"), Gui_("SetColor")
		  }
		  bg:=i>0 ? "1":"0"
		  return
		Case "ColorDiff2Two":
		  c := ogcEditSelColor.Text
		  if (c="")
		  {
			FindText_Capture.Opt("+OwnDialogs")
			MsgBox(Lang["s12"] " !", "Tip", "4096 T1")
			return
		  }
		  dR := ogcUpDowndR.Value
		  dG := ogcUpDowndG.Value
		  dB := ogcUpDowndB.Value
		  rr:=(c>>16)&0xFF, gg:=(c>>8)&0xFF, bb:=c&0xFF
		  , n:=Format("{:06X}",(dR<<16)|(dG<<8)|dB)
		  , color:=StrReplace(c "-" n, "0x"), k:=i:=0
		  Loop nW*nH
		  {
			c:=cors[++k], r:=(c>>16)&0xFF, g:=(c>>8)&0xFF
			, b:=c&0xFF, ascii[k]:=v:=(Abs(r-rr)<=dR
			and Abs(g-gg)<=dG and Abs(b-bb)<=dB)
			if (show[k])
			  i:=(v?i+1:i-1), c:=(v?"Black":"White"), Gui_("SetColor")
		  }
		  bg:=i>0 ? "1":"0"
		  return
		Case "Modify":
		  Modify := ogcCheckboxModify.Value
		  return
		Case "MultiColor":
		  MultiColor := ogcCheckboxMultiColor.Value
		  result:=""
		  ToolTip()
		  return
		Case "Undo":
		  result:=RegExReplace(result, ",[^/]+/[^/]+/[^/]+$")
		  ToolTip(Trim(result,"/,"))
		  return
		Case "Similar1":
		  ogcSliderSimilar2.Value := ogcSliderSimilar1.Value
		  return
		Case "Similar2":
		  ogcSliderSimilar1.Value := ogcSliderSimilar2.Value
		  return
		Case "GetTxt":
		  txt:=""
		  if (bg="")
			return
		  k:=0
		  Loop nH
		  {
			v:=""
			Loop nW
			  v.=!show[++k] ? "" : ascii[k] ? "1":"0"
			txt.=v="" ? "" : v "`n"
		  }
		  return
		Case "Auto":
		  Gui_("GetTxt")
		  if (txt="")
		  {
			FindText_Capture.Opt("+OwnDialogs")
			MsgBox(Lang["s13"] " !", "Tip", "4096 T1")
			return
		  }
		  While InStr(txt, bg)
		  {
			if (txt~="^" bg "+\n")
			  txt:=RegExReplace(txt, "^" bg "+\n"), Gui_("CutU")
			else if !(txt~="m`n)[^\n" bg "]$")
			  txt:=RegExReplace(txt, "m`n)" bg "$"), Gui_("CutR")
			else if (txt~="\n" bg "+\n$")
			  txt:=RegExReplace(txt, "\n\K" bg "+\n$"), Gui_("CutD")
			else if !(txt~="m`n)^[^\n" bg "]")
			  txt:=RegExReplace(txt, "m`n)^" bg), Gui_("CutL")
			else Break
		  }
		  txt:=""
		  return
		Case "OK","SplitAdd","AllAdd":
		  FindText_Capture.Opt("+OwnDialogs")
		  Gui_("GetTxt")
		  if (txt="") and (!MultiColor)
		  {
			MsgBox(Lang["s13"] " !", "Tip", "4096 T1")
			return
		  }
		  if InStr(color, "@") and (UsePos) and (!MultiColor)
		  {
			r:=StrSplit(color,"@")
			k:=i:=j:=0
			Loop nW*nH
			{
			  if (!show.Has(k++))
				Continue
			  i++
			  if (k=cors.SelPos)
			  {
				j:=i
				Break
			  }
			}
			if (j=0)
			{
			  MsgBox(Lang["s12"] " !", "Tip", "4096 T1")
			  return
			}
			color:="#" j "@" r[2]
		  }
		  Comment := ogcEditComment.Text
		  if (cmd="SplitAdd") and (!MultiColor)
		  {
			if InStr(color, "#")
			{
			  MsgBox(Lang["s14"], "Tip", "4096 T3")
			  return
			}
			bg:=StrLen(StrReplace(txt, "0"))
			  > StrLen(StrReplace(txt, "1")) ? "1":"0"
			s:="", i:=0, k:=nW*nH+1+CutLeft
			Loop w:=nW-CutLeft-CutRight
			{
			  i++
			  if (!show.Has(k++) and A_Index<w)
				Continue
			  i:=Format("{:d}",i)
			  v:=RegExReplace(txt, "m`n)^(.{" i "}).*", "$1")
			  txt:=RegExReplace(txt, "m`n)^.{" i "}"), i:=0
			  While InStr(v, bg)
			  {
				if (v~="^" bg "+\n")
				  v:=RegExReplace(v, "^" bg "+\n")
				else if !(v~="m`n)[^\n" bg "]$")
				  v:=RegExReplace(v, "m`n)" bg "$")
				else if (v~="\n" bg "+\n$")
				  v:=RegExReplace(v, "\n\K" bg "+\n$")
				else if !(v~="m`n)^[^\n" bg "]")
				  v:=RegExReplace(v, "m`n)^" bg)
				else Break
			  }
			  if (v!="")
			  {
				v:=Format("{:d}",InStr(v, "`n")-1) "." this.bit2base64(v)
				s.="`nText.=`"|<" SubStr(Comment, 1, 1) ">" color "$" v "`"`n"
				Comment:=SubStr(Comment, 2)
			  }
			}
			Event:=cmd, result:=s
			FindText_Capture.Hide()
			return
		  }
		  if (!MultiColor)
			txt:=Format("{:d}",InStr(txt, "`n")-1) "." this.bit2base64(txt)
		  else
		  {
			dRGB := ogcUpDowndRGB.Value
			r:=StrSplit(Trim(StrReplace(result, ",", "/"),"/"),"/")
			, x:=r[1], y:=r[2], s:="", i:=1
			Loop r.Length//3
			  s.="," (r[i++]-x) "/" (r[i++]-y) "/" r[i++]
			txt:=SubStr(s, 2), color:="##" dRGB
		  }
		  s:="`nText.=`"|<" Comment ">" color "$" txt "`"`n"
		  if (cmd="AllAdd")
		  {
			Event:=cmd, result:=s
			FindText_Capture.Hide()
			return
		  }
		  x:=px-ww+CutLeft+(nW-CutLeft-CutRight)//2
		  y:=py-hh+CutUp+(nH-CutUp-CutDown)//2
		  s:=StrReplace(s, "Text.=", "Text:="), r:=StrSplit(Lang["s8"],"|")
		  s:="`; #Include <FindText>`n"
		  . "`nt1:=A_TickCount, Text:=X:=Y:=`"`"`n" s
		  . "`nif (ok:=FindText(&X, &Y, " x "-150000, "
		  . y "-150000, " x "+150000, " y "+150000, 0, 0, Text))"
		  . "`n{"
		  . "`n  `; FindText().Click(" . "X, Y, `"L`")"
		  . "`n}`n"
		  . "`n`; ok:=FindText(&X:=`"wait`", &Y:=3, 0,0,0,0,0,0,Text)    `; " r[7]
		  . "`n`; ok:=FindText(&X:=`"wait0`", &Y:=-1, 0,0,0,0,0,0,Text)  `; " r[8]
		  . "`n`nMsgBox(`"" r[1] ":``t`" Round(ok.Length)"
		  . "`n  . `"``n``n" r[2] ":``t`" (A_TickCount-t1) `" " r[3] "`""
		  . "`n  . (ok.Length ? `"``n``n" r[4] ":``t`" ok[1].mx `", `" ok[1].my"
		  . "`n  . `"``n``n" r[5] ":``t<`" (Comment:=ok[1].id) `">`" : `"`"), `"Tip`", 4096)`n"
		  . "`nfor i,v in ok  `; ok " r[6] " ok:=FindText().ok"
		  . "`n  if (i<=2)"
		  . "`n    FindText().MouseTip(ok[i].mx, ok[i].my)`n"
		  Event:=cmd, result:=s
		  FindText_Capture.Hide()
		  return
		Case "Save":
		  x:=px-ww+CutLeft, w:=nW-CutLeft-CutRight
		  y:=py-hh+CutUp, h:=nH-CutUp-CutDown
		  Gui_("ScreenShot"
		  , x "|" y "|" (x+w-1) "|" (y+h-1) "|0")
		  return
		Case "KeyDown":
		  Critical()
		  MouseGetPos(,,&h,&ctrl,2)
		  if (h!=FindText_Main.Hwnd)
			return
		  if (ctrl=hscr)
			SetTimer(Gui_ShowPic,-150)
		  else if (ctrl=ogcEditClipText.Hwnd)
		  {
			s := ogcEditClipText.Text
			ogcEditMyPic.Value := Trim(this.ASCII(s),"`n")
		  }
		  return
		Case "ShowPic":
		  i := EditGetCurrentLine(hscr)
		  s := EditGetLine(i, hscr)
		  ogcEditMyPic.Value := Trim(this.ASCII(s),"`n")
		  return
		Case "LButtonDown":
		  Critical()
		  MouseGetPos(, , &win, &k2, 2)
		  if (win!=FindText_Capture.Hwnd)
			return Gui_("KeyDown")
		  if (k1:=Cid_.Has(k2)?Round(Cid_[k2]):0)<1
			return
		  if (k1>71*25)
		  {
			k3:=nW*nH+(k1-71*25)+dx
			k1:=(show[k3]:=!show[k3]) ? 0x0000FF : 0xAAFFFF
			ErrorLevel := SendMessage(0x2001, 0, k1, , "ahk_id " k2)
			return
		  }
		  k2:=Mod(k1-1,71)+dx, k3:=(k1-1)//71+dy
		  if (k2>=nW || k3>=nH)
			return
		  k1:=k, k:=k3*nW+k2+1, k2:=c
		  if (MultiColor and show[k])
		  {
			c:="," Mod(k-1,nW) "/" k3 "/"
			. Format("{:06X}",cors[k]&0xFFFFFF)
			, result.=InStr(result, c) ? "":c
			ToolTip(Trim(result,"/,"))
		  }
		  else if (Modify and bg!="" and show[k])
		  {
			c:=((ascii[k]:=!ascii[k]) ? "Black":"White")
			, Gui_("SetColor")
		  }
		  else
		  {
			c:=cors[k], cors.SelPos:=k
			ogcEditSelGray.Value := gray[k]
			ogcEditSelColor.Value := Format("0x{:06X}",c&0xFFFFFF)
			ogcEditSelR.Value := (c>>16)&0xFF
			ogcEditSelG.Value := (c>>8)&0xFF
			ogcEditSelB.Value := c&0xFF
		  }
		  k:=k1, c:=k2
		  return
		Case "MouseMove":
		  static PrevControl:=""
		  A_GuiControl := ControlGetFocus()
		  if (PrevControl!=A_GuiControl)
		  {
			PrevControl:=A_GuiControl
			SetTimer(Gui_ToolTip,PrevControl ? -500 : 0)
			SetTimer(Gui_ToolTipOff,PrevControl ? -5500 : 0)
			ToolTip()
		  }
		  return
		Case "ToolTip":
		  MouseGetPos(, , &_TT)
		  if WinExist("ahk_id " _TT " ahk_class AutoHotkeyGUI")
			try ToolTip(Tip_Text[PrevControl])
		  return
		Case "ToolTipOff":
		  ToolTip()
		  return
		Case "CutL2","CutR2","CutU2","CutD2":
		  s := ogcEditMyPic.Value
		  s:=Trim(s,"`n") . "`n", v:=SubStr(cmd, 4, 1)
		  if (v="U")
			s:=RegExReplace(s, "^[^\n]+\n")
		  else if (v="D")
			s:=RegExReplace(s, "[^\n]+\n$")
		  else if (v="L")
			s:=RegExReplace(s, "m`n)^[^\n]")
		  else if (v="R")
			s:=RegExReplace(s, "m`n)[^\n]$")
		  ogcEditMyPic.Value := Trim(s,"`n")
		  return
		Case "Update":
		  ;ogcEditscr.Focus()
		  i := EditGetCurrentLine(hscr)
		  s := EditGetLine(i, hscr)
		  if !RegExMatch(s, "(<[^>\n]*>[^$\n]+\$)\d+\.[\w+/]+", &r)
			return
		  v := ogcEditMyPic.Value
		  v:=Trim(v,"`n") . "`n", w:=Format("{:d}",InStr(v, "`n")-1)
		  v:=StrReplace(StrReplace(v, "0", "1"), "_", "0")
		  s:=StrReplace(s, r[], r[1] . w "." this.bit2base64(v))
		  v:="{End}{Shift Down}{Home}{Shift Up}{Del}"
		  ControlSend(v, , hscr)
		  EditPaste(s,hscr)
		  ControlSend("{Home}", , hscr)
		  return
		Case "Load_Language_Text":
		  s:="
		  (
	  Myww       = Width = Adjust the width of the capture range
	  Myhh       = Height = Adjust the height of the capture range
	  AddFunc    = Add = Additional FindText() in Copy
	  NowHotkey  = Hotkey = Current screenshot hotkey
	  SetHotkey1 = = First sequence Screenshot hotkey
	  SetHotkey2 = = Second sequence Screenshot hotkey
	  Apply      = Apply = Apply new screenshot hotkey
	  CutU2      = CutU = Cut the Upper Edge of the text in the edit box below
	  CutL2      = CutL = Cut the Left Edge of the text in the edit box below
	  CutR2      = CutR = Cut the Right Edge of the text in the edit box below
	  CutD2      = CutD = Cut the Lower Edge of the text in the edit box below
	  Update     = Update = Update the text in the edit box below to the line of Code
	  GetRange   = GetRange = Get screen range to A_Clipboard and update the search range of the Code
	  GetOffset  = GetOffset = Get position offset relative to the Text from the Code and update FindText().Click()
	  GetClipOffset  = GetOffset2 = Get position offset relative to the Text from the Left Box
	  Capture    = Capture = Initiate Image Capture Sequence
	  CaptureS   = CaptureS = Restore the Saved ScreenShot by Hotkey and then start capturing
	  Test       = Test = Test the Text from the Code to see if it can be found on the screen
	  TestClip   = Test2 = Test the Text from the Left Box and copy the result to A_Clipboard
	  Paste      = Paste = Paste the Text from A_Clipboard to the Left Box
	  CopyOffset = Copy2 = Copy the Offset to A_Clipboard
	  Copy       = Copy = Copy the selected or all of the code to the A_Clipboard
	  Reset      = Reset = Reset to Original Captured Image
	  SplitAdd   = SplitAdd = Using Markup Segmentation to Generate Text Library
	  AllAdd     = AllAdd = Append Another FindText Search Text into Previously Generated Code
	  OK         = OK = Create New FindText Code for Testing
	  Cancel     = Cancel = Close the Window Don't Do Anything
	  Save       = SavePic = Save the trimmed original image to the default directory
	  Gray2Two      = Gray2Two = Converts Image Pixels from Gray Threshold to Black or White
	  GrayDiff2Two  = GrayDiff2Two = Converts Image Pixels from Gray Difference to Black or White
	  Color2Two     = Color2Two = Converts Image Pixels from Color Similar to Black or White
	  ColorPos2Two  = ColorPos2Two = Converts Image Pixels from Color Position to Black or White
	  ColorDiff2Two = ColorDiff2Two = Converts Image Pixels from Color Difference to Black or White
	  SelGray    = Gray = Gray value of the selected color
	  SelColor   = Color = The selected color
	  SelR       = R = Red component of the selected color
	  SelG       = G = Green component of the selected color
	  SelB       = B = Blue component of the selected color
	  RepU       = -U = Undo Cut the Upper Edge by 1
	  CutU       = U = Cut the Upper Edge by 1
	  CutU3      = U3 = Cut the Upper Edge by 3
	  RepL       = -L = Undo Cut the Left Edge by 1
	  CutL       = L = Cut the Left Edge by 1
	  CutL3      = L3 = Cut the Left Edge by 3
	  Auto       = Auto = Automatic Cut Edge after image has been converted to black and white
	  RepR       = -R = Undo Cut the Right Edge by 1
	  CutR       = R = Cut the Right Edge by 1
	  CutR3      = R3 = Cut the Right Edge by 3
	  RepD       = -D = Undo Cut the Lower Edge by 1
	  CutD       = D = Cut the Lower Edge by 1
	  CutD3      = D3 = Cut the Lower Edge by 3
	  Modify     = Modify = Allows Modify the Black and White Image
	  MultiColor = FindMultiColor = Click multiple colors with the mouse, then Click OK button
	  Undo       = Undo = Undo the last selected color
	  Comment    = Comment = Optional Comment used to Label Code ( Within <> )
	  Threshold  = Gray Threshold = Gray Threshold which Determines Black or White Pixel Conversion (0-255)
	  GrayDiff   = Gray Difference = Gray Difference which Determines Black or White Pixel Conversion (0-255)
	  Similar1   = Similarity = Adjust color similarity as Equivalent to The Selected Color
	  Similar2   = Similarity = Adjust color similarity as Equivalent to The Selected Color
	  DiffR      = R = Red Difference which Determines Black or White Pixel Conversion (0-255)
	  DiffG      = G = Green Difference which Determines Black or White Pixel Conversion (0-255)
	  DiffB      = B = Blue Difference which Determines Black or White Pixel Conversion (0-255)
	  DiffRGB    = R/G/B = Determine the allowed R/G/B Error (0-255) when Find MultiColor
	  Bind0      = BindWin1 = Bind the window and Use GetDCEx() to get the image of background window
	  Bind1      = BindWin1+ = Bind the window Use GetDCEx() and Modify the window to support transparency
	  Bind2      = BindWin2 = Bind the window and Use PrintWindow() to get the image of background window
	  Bind3      = BindWin2+ = Bind the window Use PrintWindow() and Modify the window to support transparency
	  Bind4      = BindWin3 = Bind the window and Use PrintWindow(,,3) to get the image of background window
	  OK2        = OK = Restore this ScreenShot
	  Cancel2    = Cancel = Close the Window Don't Do Anything
	  ClearAll   = ClearAll = Clean up all saved ScreenShots
	  OpenDir    = OpenDir = Open the saved screenshots directory
	  SavePic    = SavePic = Select a range and save as a picture
	  ClipText   = = Displays the Text data from A_Clipboard
	  Offset     = = Displays the results of GetOffset2
	  s1  = FindText
	  s2  = Gray|GrayDiff|Color|ColorPos|ColorDiff|MultiColor
	  s3  = Capture Image To Text
	  s4  = Capture Image To Text And Find Text Tool
	  s5  = Position|First click RButton\nMove the mouse away\nSecond click RButton
	  s6  = Unbind Window using
	  s7  = Please drag a range with the LButton\nCoordinates are copied to A_Clipboard
	  s8  = Found|Time|ms|Pos|Result|value can be get from|Wait 3 seconds for appear|Wait indefinitely for disappear
	  s9  = Success
	  s10 = The Capture Position|Perspective binding window\nRight click to finish capture
	  s11 = Please Set Gray Difference First
	  s12 = Please select the core color first
	  s13 = Please convert the image to black or white first
	  s14 = Can't be used in ColorPos mode, because it can cause position errors
	  s15 = Are you sure about the scope of your choice?\n\nIf not, you can choose again
		  )"
		  Lang:=Map(), Tip_Text:=Map()
		  Loop Parse, s, "`n", "`r"
			if InStr(v:=A_LoopField, "=")
			  r:=StrSplit(StrReplace(v, "\n", "`n"), "=", "`t ")        
			  , Lang[r[1]]:=r[2], Tip_Text[r[1]]:=r.Length>2?r[3]:""
		  return
		}
	  }
  
  }  ;// Class End
  
  ;================= The End =================
  
  ;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  