;--------------------------------------------------------------------; ¯¨á ­¨Ĩ: ĨŖãé ī áâāŽĒ ; ĸâŽā ¯Žāâ :  ā áŽĸ ..(Mick),2010;--------------------------------------------------------------------Str_reload:		ld	a,(Str_flg_end)		and	a		jr 	z,Str_init		xor	a		ld	(Str_flg_end),a		scf		retStr_init:		xor	a		ld	(Str_count_step),a		ld	hl,Str_addr_text		ld	(Str_addr_work),hl		ld	a,(hl)		retStr_init_load:		ld	hl,Str_addr_load		ld	(Str_addr_work),hl		xor	a		ld	(Str_count_step),a		ld	a,1		ld	(Str_flg_end),a		ld	a,(hl)		ret	Str_play:		ld	a,(Str_count_bit)		or	a		call	z,Str_next_symbol		ret	c		jp    	Str_update_stringStr_next_symbol:		ld	hl,(Str_addr_work)		ld	a,(hl)		and	a		call	z,Str_reload		ret	c		inc	hl		ld	(Str_addr_work),hl		sub	20h		ld	l, a		ld	h, 0		ld	de,Str_addr_font		add	hl,hl		add	hl,hl		add	hl,hl		add	hl,de		ld	de,Str_symbol_buf		ldi		ldi		ldi		ldi		ldi		ldi		ldi		ldi		ld	a,16		ld	(Str_count_bit),a		retStr_update_string:		ld	a,(Str_count_bit)		dec	a		ld	(Str_count_bit),a		and	1		ret	nz		ld	de,Str_symbol_buf		ld	bc,0		ld	a,(de)		rlca		ld	(de),a		rl	c		ld	hl,4CB3h                ld	a,(hl)		and	0FEh		or	c		ld	(hl),a		ld	c,b		inc	de		ld	a,(de)		rlca		ld	(de),a		rl	c		inc	h                ld	a,(hl)			;4AD3h		and	0FEh		or	c		ld	(hl),a		ld	c,b		inc	de		ld	a,(de)		rlca		ld	(de),a		rl	c		inc	h                ld	a,(hl)                  ;54B3h		and	0FEh		or	c		ld	(hl),a		ld	c,b		inc	de		ld	a,(de)		rlca		ld	(de),a		rl	c		inc	h                ld	a,(hl)                  ;56B3h		and	0FEh		or	c		ld	(hl),a		ld	c,b		inc	de		ld	a,(de)		rlca		ld	(de),a		rl	c		ld	hl,48D3h                ld	a,(hl)		and	0FEh		or	c		ld	(hl),a		ld	c,b		inc	de		ld	a,(de)		rlca		ld	(de),a		rl	c		inc	h                ld	a,(hl)			;4AD3h		and	0FEh		or	c		ld	(hl),a		ld	c,b		inc	de		ld	a,(de)		rlca		ld	(de),a		rl	c		inc	h                ld	a,(hl)                  ;54B3h		and	0FEh		or	c		ld	(hl),a		ld	c,b		inc	de		ld	a,(de)		rlca		ld	(de),a		rl	c		inc	h                ld	a,(hl)                  ;56B3h		and	0FEh		or	c		ld	(hl),a		ret		Str_move_string:		ld	de,4CB3h		call	Str_move_line                   		inc	d		call	Str_move_line                   ;52B3h		inc	d		call	Str_move_line                   ;54B3h		inc	d		call	Str_move_line                   ;56B3h		ld	de,48D3h		call	Str_move_line                   		inc	d		call	Str_move_line                   ;52B3h		inc	d		call	Str_move_line                   ;54B3h		inc	dStr_move_line:		ld	h,d		ld	l,e		and	a		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		dec	l		rl	(hl)		ret	Str_count_step:		db 	0Str_symbol_buf:		ds 	8Str_flg_end:		db 	0Str_count_bit:		db 	0Str_addr_work:		dw 	0Str_addr_sp:		dw	0Str_addr_load:		db	'  *LOAD*',0Str_addr_text:		db	'                     ! !    MICK    !!!'		db	' ,   ,     -      .'		db	'        . :)   ,     '		db	'    M&M   .   .    M'		db	'   19.       .    '		db	'     .  ,        '		db	'  .     .     ESI,    . :)'		db	'   ,     .       .      '		db	'  .      20-     .'		db	'   ,   DUKE NUKEM FOREVER,   . :) :)   '		db	' ,     - "E-TUNES".'		db	'      30    .'		db	'        '		db	' "E-TRACKER"     "SAM COUPE".'		db 	'     560    .'		db	'        "ZXM-SOUNDCARD"    "UNREAL SPECCY",'		db      '   .' 		db      '   .        '		db	' "SPACE",   TR-DOS    "BREAK"'		db 	'  :      .     '		db 	' "E-TUNES"  .          SJASMPLUS.'		db	'               -   !     '		db	' ,      .   .    ' 		db	'   MOLODCOV_ALEX ( )  .'		db	' RINDEX       .'		db	'    "ZXM-SOUNDCARD".   : AAA, PIROXILIN, , LUZANOV,'		db	'   EWGENY7 .'		db	'     :).'		db	'  ZEK  ZOREL      .   ,  ,'		db	'    - !'		db	'    , ,    .'		db	'          :) :)'		db	'     WWW.MICKLAB.NAROD.RU     '		db	'   .       WWW.ZX.PK.RU -  MICK   '		db	' MICKLAB@MAIL.RU    '		db	'  .   . , .......      :) .   '		db	'            MAY *2011*    GRAPHICS AND CODE BY MICK         '		db	'                                             ',0           		Str_addr_font:		incbin "font.fnt"Str_end_font:;		.end