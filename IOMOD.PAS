	{IOMOD.PAS: provides a context in which to run a program using

                Software Tools in Pascal by Kernighan & Plauger (p322)}

	{maintainers of STIP use UMB$DISK2:[MATH.STIP.MODULAR]MAKEIOMOD.COM to
         compile this module everytime a global definition, primitive, or 
         utility is changed}
        {users   use  UMB$DISK2:[MATH.CS210.JLDOCS.COM]COMPILE.COM  to  compile
         user-written modules and link them to this one}

	[environment('UMB$DISK2:[MATH.STIP.MODULAR]IOMOD.PEN')]

	PROGRAM outer(input,output);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ globdefs (UCB) -- global constants, types and variables }

	CONST 

	{ standard file descriptors. subscripts in open, etc. }
        {these are not to be changed }
          STDIN  = 1;   STDOUT = 2;  STDERR = 3;

	{ other io-related stuff }
          { status values for open files }
          IOERROR = 0;  IOAVAIL = 1; IOREAD  = 2; IOWRITE = 3;

          MAXOPEN = 10;   {maximum number of open files}
          MAXARGS =  8;   {max # of args from cmd line - depends on GETFOREIGN}
          ABUFLEN = 1024; {size of argument buffer}

	{ universal manifest constants }
          ENDFILE =  26;   { VMS end-of-file mark is CTRL-Z }
          ENDSTR  =   0;   { null-terminated strings }
          MAXSTR  = 256;   { (one more than) longest possible string }

	{ ascii character set in decimal (NEWLINE is ^J which is a linefeed) }
          BELL    = 7;           BACKSPACE = 8;           TAB       = 9;
          NEWLINE = 10;          BLANK     = 32;
          EXCLAM  = 33;   { ! }  DQUOTE    = 34;   { " }  SHARP     = 35; { # }
          DOLLAR  = 36;   { $ }  PERCENT   = 37;   { % }  AMPER     = 38; { & }
          SQUOTE  = 39;   { ' }  ACUTE     = SQUOTE;      LPAREN    = 40; { ( }
          RPAREN  = 41;   { ) }  STAR      = 42;   { * }  PLUS      = 43; { + }
          COMMA   = 44;   { , }  MINUS     = 45;   { - }  DASH      = MINUS;
          PERIOD  = 46;   { . }  SLASH     = 47;   { / }  COLON     = 58; { : }
          SEMICOL = 59;   { ; }  LESS      = 60;   { < }  EQUALS    = 61; { = }
          GREATER = 62;   { > }  QUESTION  = 63;   { ? }  ATSIGN    = 64; { @ }
          ESCAPE  = ATSIGN;      LBRACK    = 91;   { [ }  BACKSLASH = 92; { \ }
          RBRACK  = 93;   { ] }  CARET     = 94;   { ^ }  UNDERLINE = 95; { _ }
          GRAVE   = 96;   { ` }

	{ digits ... }
	  DIGIT0 = 48;   DIGIT1 = 49;    DIGIT2 = 50;	DIGIT3 = 51;
	  DIGIT4 = 52;	 DIGIT5 = 53;	 DIGIT6 = 54;	DIGIT7 = 55;
	  DIGIT8 = 56;	 DIGIT9 = 57;











	{ upper case ... }
	  UCLETA = 65;	 UCLETB = 66;	 UCLETC = 67;	UCLETD = 68;
	  UCLETE = 69;   UCLETF = 70;	 UCLETG = 71;	UCLETH = 72;
	  UCLETI = 73;   UCLETJ = 74;	 UCLETK = 75;	UCLETL = 76;
	  UCLETM = 77;   UCLETN = 78;	 UCLETO = 79;	UCLETP = 80;
	  UCLETQ = 81;   UCLETR = 82;	 UCLETS = 83;	UCLETT = 84;
	  UCLETU = 85;	 UCLETV = 86;	 UCLETW = 87;	UCLETX = 88;
	  UCLETY = 89; 	 UCLETZ = 90;

        { lower case letters }
          LETA = 97;      LETB = 98;      LETC = 99;      LETD = 100;
          LETE = 101;     LETF = 102;     LETG = 103;     LETH = 104;
          LETI = 105;     LETJ = 106;     LETK = 107;     LETL = 108;
          LETM = 109;     LETN = 110;     LETO = 111;     LETP = 112;
          LETQ = 113;     LETR = 114;     LETS = 115;     LETT = 116;
          LETU = 117;     LETV = 118;     LETW = 119;     LETX = 120;
          LETY = 121;     LETZ = 122; 

          { other miscellaneous punctuation }
          LBRACE = 123;   { left brace }  RBRACE = 125;   { right brace }
          BAR    = 124;   { | }           TILDE  = 126;   { ~ }

	TYPE
          character   = 0..255;  { byte-sized -- ascii + other stuff }
          string      = array [1..MAXSTR] of character;
          filedesc    = IOERROR..MAXOPEN;
          ioblock     = record        { to keep track of open files }
             filevar : text;
             mode    : IOERROR..IOWRITE
          end;
          vms_string  = varying [MAXSTR] of char;
          arg_buftype = varying [ABUFLEN] of char;

	VAR
        { these global variables are used without being passed via parameters }

          openlist : array [1..MAXOPEN] of ioblock;       { open files }

        { objects for GETARG and NARG }
          arg_buffer : arg_buftype;                 {string of args from VMS}
          argv       : array[1..MAXARGS] of string; {vector of args for getarg}
          argcount   : 0..MAXARGS;                  {number of vectors in argv}

    	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ PRIMS -- primitive FUNCTIONs and PROCEDUREs for UCB }
	{ message (VMS) -- print a message on user's terminal and continue }
	PROCEDURE message( msg: vms_string );
	begin (* message *)
          writeln( openlist[STDERR].filevar, msg )
	end   (* message *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ error (VMS) -- print a message on user's terminal and exit }
	PROCEDURE error( errmsg: vms_string );
	begin (* error *)
          writeln( openlist[STDERR].filevar, errmsg ); halt
	end   (* error *);









	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ open (UCB) -- open a file for reading or writing }
	{       no status can be returned, unfortunately }
	FUNCTION popen (var name : string; mode : integer) : filedesc;
	var  i : integer; intname : vms_string; found : boolean;

	  procedure vms_open(var f: ioblock; fname: vms_string);
	  begin (* vms_open *)
           if (f.mode = IOREAD) then begin
	     open( FILE_VARIABLE    := f.filevar,  FILE_NAME     := fname,
                   HISTORY          := READONLY,   RECORD_LENGTH := 255,
                   ACCESS_METHOD    := SEQUENTIAL, RECORD_TYPE   := VARIABLE,
                   CARRIAGE_CONTROL := LIST,       ORGANIZATION  := SEQUENTIAL,
                   DISPOSITION      := SAVE,       SHARING       := READONLY,
                   ERROR            := MESSAGE);
             reset(f.filevar)
           end
           else begin
             open( FILE_VARIABLE    := f.filevar,  FILE_NAME     := fname,
                   HISTORY          := NEW,        RECORD_LENGTH := 255,
                   ACCESS_METHOD    := SEQUENTIAL, RECORD_TYPE   := VARIABLE,
                   CARRIAGE_CONTROL := LIST,       ORGANIZATION  := SEQUENTIAL,
                   DISPOSITION      := SAVE,       SHARING        := NONE,
                   ERROR            := MESSAGE);
             rewrite(f.filevar)
           end
          end (* vms_open *);

        begin (* popen *)
          i := 1;
          intname.length := 0;
          while not (name[i] in [ENDSTR, NEWLINE]) do begin
             intname.length := intname.length+1; {see VMS type VARYING OF CHAR}
             intname[i] := chr(name[i]);
             i := i + 1
          end;
          { find the first free slot in openlist }
          popen := IOERROR;
          found := false;
          i := 1;
          while (i <= MAXOPEN) and (not found) do begin
                if (openlist[i].mode = IOAVAIL) then begin
                        openlist[i].mode := mode;
                        vms_open(openlist[i],intname);
                        popen := i;
                        found := true
                end;
                i := i + 1
          end
        end   (* popen *);
















  	{ initio (VMS) -- initialize open file list and process cmd line args }
	PROCEDURE initio;
	var
		fn : vms_string;
        	j : integer;
	        fname : string;
        	i : filedesc;

	  { parse_args (VMS) - copies arguments from cmd line to global array 
            argv, sets global var argcount -- written by John A. Lutts  and
            revised by Chet Edelman -- Fall 85 }
	  procedure parse_args;
          const 
             OK_GET_FOREIGN = 1;
             PA_BLANK = ' ';
             PA_DQUOTE = '"';
             PA_TAB = CHR(9);
          type 
             state = (inqtdelimwrdst, inbldelimwrdst, innowrdst);
	        (* only possible states while parsing argument line *)
          var 
    	     pos, av_index, ab_ptr : integer;
             currentstate : state;

	    [EXTERNAL,ASYNCHRONOUS]

	  function LIB$GET_FOREIGN  ( %DESCR buffer: arg_buftype ) : integer;
	  extern;

	  procedure finish_old_start_new (var ind, pos : integer);
	   (* finishes off old argument and initializes next *)
	  begin { finish_old_start_new }
            argv[ind][pos] := endstr;
            if (pos>1) then (* argument is not empty *)
               begin
                 ind := ind+1;
                 pos := 1
               end
	  end;  { finish_old_start_new }

	  function append_char (var pos : integer; 
                                ind : integer; ch : char) : boolean;
           (* if there is room, it appends ord(ch) to argv[ind] by storing
              it in argv[ind][pos] and returns true; otherwise it returns 
              false and terminates argv[ind] *)
	  begin { append_char }
	    append_char := (pos<maxstr);
	    if (pos<maxstr) then
               begin
                 argv[ind][pos] := ord(ch);
                 pos := pos+1
               end
            else (* finish off the argument -- no more room *)
               argv[ind][pos] := endstr
          end; { append_char }

	  begin { parse_args }
            {load arg_buffer}
            if (OK_GET_FOREIGN <> lib$get_foreign ( arg_buffer )) then
              error('parseargs: problem in getting arguments into arg_buffer');






            {assumes that arg_buffer has blank-or-tab delimited or doublequote
	     delimited parts in it; it stores these in argv, one at a time --
	     note: if there are an odd number of double quotes in arg_buffer or
	     if an argument is too long to go into a string then the program
	     stops. No more than maxargs-1 arguments are collected -- all
	     others, if any, are ignored -- argcount contains one more than
	     the actual number of arguments stored.}

	    currentstate := innowrdst;
            av_index := 1; ab_ptr := 1; pos := 1;
	    while (ab_ptr<=arg_buffer.length) and (av_index<maxargs) do begin
              case currentstate of
                innowrdst:      case arg_buffer[ab_ptr] of
                                  PA_DQUOTE: currentstate := inqtdelimwrdst;
                                  PA_TAB,
                                  PA_BLANK:  { do nothing };
                                  OTHERWISE
                                    begin
                                     currentstate := inbldelimwrdst;
                                     if ( NOT append_char
				            (pos, av_index, arg_buffer[ab_ptr]))
                                     then error('parseargs: Argument too long!')
                                    end
                                end (* case arg_buffer[ab_ptr] of *);
                inbldelimwrdst: case arg_buffer[ab_ptr] of
                                  PA_DQUOTE: 
                                    begin
                                      finish_old_start_new(av_index, pos);
                                      currentstate := inqtdelimwrdst
                                    end;
                                  PA_TAB,
                                  PA_BLANK: 
                                    begin
                                       finish_old_start_new(av_index, pos);
                                       currentstate := innowrdst
                                    end;
                                  OTHERWISE
                                    if ( NOT append_char
			                (pos, av_index, arg_buffer[ab_ptr]))
                                    then error('parseargs: Argument too long!')
                                end (* case arg_buffer[ab_ptr] of *);
                inqtdelimwrdst: case arg_buffer[ab_ptr] of
                                  PA_DQUOTE: 
                                    begin
                                      finish_old_start_new(av_index, pos);
                                      currentstate := innowrdst
                                    end;
                                  OTHERWISE
                                    if ( NOT append_char
                                         (pos, av_index, arg_buffer[ab_ptr]))
                                    then error('parseargs: Argument too long!')
                                end (* case arg_buffer[ab_ptr] of *);
              end; {case currentstate}
              ab_ptr := ab_ptr+1
            end (* while ab_ptr *);











  	    { finish off last argument, if any }
            if ab_ptr = arg_buffer.length+1 
               then (* full command line was done *)
              case currentstate of
                inqtdelimwrdst : 
                  if (currentstate = inqtdelimwrdst) then
                   error ('parseargs: Bad argument line, odd number of quotes');
                inbldelimwrdst : finish_old_start_new (av_index, pos);
                innowrdst      : (* do nothing *)
              end (* case currentstate of *);

            argcount := av_index

          end; { parse_args }

	begin { initio }
          openlist[STDIN].mode := IOREAD;
          openlist[STDOUT].mode := IOWRITE;
          for i := STDERR to MAXOPEN do openlist[i].mode := IOAVAIL;

          { connect STDERR to user's terminal ... }
          { setstring(fname, 'SYS$ERROR:'); }
	  fn := 'SYS$ERROR:';
	  for j := 1 to 10 do fname[j] := ord(fn[j]); fname[11] := endstr;
          if (popen(fname, IOWRITE) <> STDERR) then begin
             message('Failed to open STDERR...');
             error('    INITIO must be the first PROCEDURE executed')
            end;
          rewrite( openlist[STDERR].filevar );
          reset(input);
          rewrite(output);
          parse_args;
        end   (* initio *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ create (VMS) -- create a file }
	FUNCTION create(var name: string; mode: integer): filedesc;
	var
        	fd: filedesc;
	begin (* create *)
        	fd := popen(name, mode);
	        create := fd;
        	if ((fd <> IOERROR) and (mode = IOREAD)) then begin
                	rewrite(openlist[fd].filevar);
	                reset(openlist[fd].filevar)
        	end
	end   (* create *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ getc (UCB) -- get one character from standard input }
	FUNCTION getc (var c : character) : character;
	var
        	ch : char;
	begin (* getc *)
        	if eof then c := ENDFILE
	        else if eoln then begin readln; c := NEWLINE end
	        else begin read(ch); c := ord(ch) end;
        	getc := c
	end   (* getc *);







	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ getcf (UCB) -- get one character from file }
	FUNCTION getcf (var c: character; fd : filedesc) : character;
	var
        	ch : char;
	begin (* getcf *)
        	if (fd = STDIN) then getcf := getc(c)
	        else if eof(openlist[fd].filevar) then c := ENDFILE
	        else if eoln(openlist[fd].filevar) then
                   begin readln(openlist[fd].filevar); 	c := NEWLINE end
        	else begin read(openlist[fd].filevar, ch); c := ord(ch) end;
	        getcf := c
	end   (* getcf *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ getline (UCB) -- get a line from file }
	FUNCTION getline (var s   : string;
			  fd      : filedesc;
                	  maxsize : integer) : boolean;
	var
        	i : integer; c : character;
	begin (* getline *)
        	i := 1;
	        repeat
        	  s[i] := getcf(c, fd);
                  i := i + 1
	        until (c = ENDFILE) or (c = NEWLINE) or (i >= maxsize);
        	if (c = ENDFILE) then   { went one too far }
                   i := i - 1;
	        s[i] := ENDSTR;
        	getline := (c <> ENDFILE)
	end   (* getline *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ putc (UCB) -- put one character on standard output }
	PROCEDURE putc (c : character);
	begin (* putc *)
        	if c = NEWLINE then writeln else write(chr(c))
	end   (* putc *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ putcf (UCB) -- put a single character on file fd }
	PROCEDURE putcf (c : character; fd : filedesc);
	begin (* putcf *)
        	if (fd = STDOUT) then putc(c)
	        else if c = NEWLINE then writeln(openlist[fd].filevar)
	        else write(openlist[fd].filevar, chr(c))
	end   (* putcf *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ putstr (UCB) -- put out string on file }
	PROCEDURE putstr (var s : string; f : filedesc);
	var
        	i : integer;
	begin (* putstr *)
        	i := 1;
	        while (s[i] <> ENDSTR) do begin putcf(s[i], f); i := i+1 end
	end   (* putstr *);








	{ close (VMS) -- release file descriptor slot for open file, 
          close file }
 	PROCEDURE pclose(fd: filedesc);

	  procedure vms_close(var fil:text);
	     begin    close(fil)   end;

	begin (* pclose *)
        	if ((fd > STDERR) and (fd <= MAXOPEN)) then begin
                	vms_close(openlist[fd].filevar);
	                openlist[fd].mode := IOAVAIL
	        end
	end   (* pclose *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ remove (UCB) -- remove file s from file system }

	{ this version just prints a message }
	PROCEDURE remove (var s : string);
	begin (* remove *)
           message('If we had remove, we would be removing ');
           putcf(TAB, STDERR);
           putstr(s, STDERR);
           putcf(NEWLINE, STDERR);
           {VMS -- open and close, with dispose=delete}
	end   (* remove *);

	{ nargs (VMS) -- return number of arguments (non-portable) }
	FUNCTION nargs : integer;
	begin   nargs := argcount - 1   end;

	{ getarg (VMS) -- copy n-th command line argument into s }
	{ work is done in INITIO, returned here. }
	FUNCTION getarg (n : integer; var s : string;
        	         maxs : integer) : boolean;
	var
        	i : integer;
	begin (* getarg *)
        	i := 1;
	        if (n > 0) and (n <= nargs) then begin  { in the list }
        	        while ((argv[n][i] <> ENDSTR) and (i < maxs)) do begin
                	        s[i] := argv[n][i]; i := i + 1
	                end;
        	        getarg := true
        	   end
        	else
                	getarg := false;
	        s[i] := ENDSTR
	end   (* getarg *);

















	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ UTILS - generally useful FUNCTIONs and PROCEDUREs }

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ addstr -- put c in outset[j] if it fits, increment j }
	FUNCTION addstr(c : character; var outset : string;
        	        var j : integer; maxset : integer) : boolean;
	begin (* addstr *)
        	if (j > maxset) then 
                	addstr := false
	        else begin
        	        outset[j] := c; j := j + 1; addstr := true
        	end
	end   (* addstr *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ equal -- test two strings for equality }
	FUNCTION equal (var str1, str2 : string) : boolean;
	var
	        i : integer;
	begin (* equal *)
	        i := 1;
	        while (str1[i] = str2[i]) and (str1[i] <> ENDSTR) do i := i+1;
	        equal := (str1[i] = str2[i])
	end   (* equal *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ esc -- map s[i] into escaped character, increment i }
	FUNCTION esc (var s : string; var i : integer) : character;
	begin (* esc *)
	        if (s[i] <> ESCAPE) then 
	                esc := s[i]
	        else if (s[i+1] = ENDSTR) then  { @ not special at end }
        	        esc := ESCAPE
	        else begin
        	        i := i + 1;
                	if (s[i] = letn) then esc := NEWLINE
	                else if (s[i] = lett) then  esc := TAB
                	else esc := s[i]
	        end
	end   (* esc *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ getword -- get word from s[i] into out }
	{ modified by J.A. Lutts 1/30/86 and 5/31/88 }
	FUNCTION getword (var s : string; i : integer;
        		  var out : string) : integer;
	var
        	j : integer;
	begin (* getword *)
        	while (s[i] in [BLANK, TAB, NEWLINE]) do i := i + 1;
	        j := 1;
        	while (not (s[i] in [ENDSTR,BLANK,TAB,NEWLINE])) do begin
                	out[j] := s[i]; i := i + 1; j := j + 1
	        end;
	        out[j] := ENDSTR;
	        if (j=1) then getword := 0 else getword := i
	end   (* getword *);








	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ index -- find position of character c in string s }
	FUNCTION index (var s : string; c : character) : integer;
	var
        	i : integer;
	begin (* index *)
        	i := 1;
	        while (s[i] <> c) and (s[i] <> ENDSTR) do i := i+1;
	        if (s[i] = ENDSTR) then index := 0 else index := i
	end   (* index *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ isalphanum -- true if c is letter or digit }
	FUNCTION isalphanum (c : character) : boolean;
	begin (* isalphanum *)
          isalphanum := 
            c in [leta..letz, ucleta..ucletz, digit0..digit9]
	end   (* isalphanum *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ isdigit -- true if c is a digit }
	FUNCTION isdigit (c : character) : boolean;
	begin (* isdigit *)
        	isdigit := c in [digit0..digit9]
	end   (* isdigit *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ isletter -- true if c is a letter of either case }
	FUNCTION isletter (c : character) : boolean;
	begin (* isletter *)
        	isletter := c in [leta..letz, ucleta..ucletz]
	end   (* isletter *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ islower -- true if c is lower case letter }
	FUNCTION islower (c : character) : boolean;
	begin (* islower *)
        	islower := c in [leta..letz]
	end   (* islower *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ isupper -- true if c is upper case letter }
	FUNCTION isupper (c : character) : boolean;
	begin (* isupper *)
	        isupper := c in [ucleta..ucletz]
	end   (* isupper *);

	{toupper -- if c is lowercase then return uppercase equivalent; 
	 otherwise return c.  Written by W Campbell, 2/22/89. }
	FUNCTION toupper( c : character ) : character;
	begin (* toupper *)
	  	if islower(c) then
		   toupper := c + ucleta - leta
	  	else
		   toupper := c
	end (* toupper *);
    









	{tolower -- if c is uppercase then return lowercase equivalent;
	 otherwise return c.  Written by W Campbell, 2/22/89. }
	FUNCTION tolower( c : character ) : character;
	begin (* tolower *)
	  	if isupper(c) then
		   tolower := c + leta - ucleta
		else
		   tolower := c
	end (* tolower *);
    
	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ itoc - convert integer n to char string in s[i]... 
          -- will crash if n = -maxint-1 }
	FUNCTION itoc (n     : integer;  var s : string;
 		       i     : integer) : integer; { returns end of s }
	begin (* itoc *)
        	if (n < 0) then 
  	           begin s[i] := minus; itoc := itoc(-n, s, i+1) end
	        else begin
                   if (n >= 10) then i := itoc(n div 10, s, i);
                   s[i] := n mod 10 + digit0;
                   s[i+1] := ENDSTR;
                   itoc := i + 1
                end
	end (* itoc *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ length -- compute length of string }
	FUNCTION length (var s : string) : integer;
	var
        	n : integer;
	begin (* length *)
        	n := 1;
	        while (s[n] <> ENDSTR) do n := n + 1;
	        length := n - 1
	end   (* length *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ max -- compute maximum of two integers }
	FUNCTION max (x, y : integer) : integer;
	begin (* max *)
        	if (x > y) then max := x else max := y
	end   (* max *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ min -- compute minimum of two integers }
	FUNCTION min (x, y : integer) : integer;
	begin (* min *)
	        if (x < y) then min := x else min := y
	end   (* min *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ scopy -- copy string at src[i] to dest[j] }
	PROCEDURE scopy (var src : string;  i : integer;
        	         var dest : string; j : integer);
	begin (* scopy *)
        	while (src[i] <> ENDSTR) do begin
                	dest[j] := src[i]; i := i + 1; j := j + 1
                end;
	        dest[j] := ENDSTR
	end   (* scopy *);





	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ ctoi -- convert string at s[i] to integer, increment i; modified on
          4/3/87 by J. Lutts to prevent problems with maxint }
	FUNCTION ctoi (var s : string; var i : integer) : integer;
	var
        	n, tmp, sign : integer;
	begin (* ctoi *)
        	while (s[i] = BLANK) or (s[i] = TAB) do
                	i := i + 1;
	        if (s[i] = MINUS) then sign := -1 else sign := 1;
	        if (s[i] = PLUS) or (s[i] = MINUS) then i := i + 1;
	        n := 0;
        	while (isdigit(s[i])) do begin
                        tmp := s[i]-digit0;   (* added on 4/3/87 *)
                	n := 10 * n + tmp;    (* modified on 4/3/87 *)
	                i := i + 1
        	end;
	        ctoi := sign * n
	end   (* ctoi *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ fcopy -- copy file fin to file fout }
	PROCEDURE fcopy (fin, fout : filedesc);
	var c : character;
	begin (* fcopy *)
        	while (getcf(c, fin) <> ENDFILE) do putcf(c, fout)
	end   (* fcopy *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ mustcreate -- create file or die }
	FUNCTION mustcreate (var name : string; mode : integer) : filedesc;
	var
        	fd : filedesc;
	begin (* mustcreate *)
        	fd := create(name, mode);
	        if (fd = IOERROR) then 
                   begin
        	        putstr(name, STDERR); error(': can''t create file')
        	   end;
                mustcreate := fd
	end (* mustcreate *);

	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ mustopen -- open file or die }
	FUNCTION mustopen (var name : string; mode : integer) : filedesc;
	var
        	fd : filedesc;
	begin (* mustopen *)
        	fd := popen(name, mode);
	        if (fd = IOERROR) then 
                   begin
        	     putstr(name, STDERR); error(': can''t open file')
                   end;
             	mustopen := fd
	end   (* mustopen *);











	{ Copyright (C) 1981 by Bell Laboratories, Inc., and Whitesmiths Ltd. }
	{ putdec -- put decimal integer n in field width >= w }
	PROCEDURE putdec (n, w : integer);
	var
        	i, nd : integer;
	        s : string;
	begin (* putdec *)
        	nd := itoc(n, s, 1);
	        for i := nd to w do putc(BLANK);
	        for i := 1 to nd-1 do putc(s[i])
	end   (* putdec *);

	[EXTERNAL]
	PROCEDURE MYPROGRAM;
        extern;

	begin (* outer *)
	        initio;
        	MYPROGRAM
	end   (* outer *).
