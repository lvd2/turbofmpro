;--------------------------------------------------------------------
; ???ᠭ??: ?????? ?⮡ࠦ???? ???????????
; ????? ?????: ????ᮢ ?.?.(Mick),2010
;--------------------------------------------------------------------

;-------------------------------------------------------------------
; ???ᠭ??: ?????????? ??ࠬ??஢ ???????????
; ??ࠬ????: ???
; ??????頥???  ???祭??: ???
;---------------------------------------------------------------------
Analyzer_update:
		ld	hl,EAmplitude_ch0

		ld	a,(hl)				;+00h - Amplitude 0 right/left
		and	0Fh
		ld	(Analyzer_ch0_left),a           ;Amplitude 0 left 
		ld	a,(hl)				;+00h - Amplitude 0 right/left				
		and	0F0h
		rrca	
		rrca	
		rrca
		rrca	
		ld	(Analyzer_ch0_right),a          ;Amplitude 0 right 

		inc	hl
		ld	a,(hl)				;+01h - Amplitude 1 right/left
		and	0Fh
		ld	(Analyzer_ch1_left),a           ;Amplitude 1 left 
		ld	a, (hl)				;+01h - Amplitude 1 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch1_right),a          ;Amplitude 1 right 

		inc	hl
		ld	a,(hl) 				;+02h - Amplitude 2 right/left
		and	0Fh
		ld	(Analyzer_ch2_left),a           ;Amplitude 2 left 
		ld	a,(hl)				;+02h - Amplitude 2 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch2_right),a         	;Amplitude 2 right 

		inc	hl
		ld	a, (hl) 			;+03h - Amplitude 3 right/left
		and	0Fh
		ld	(Analyzer_ch3_left),a          	;Amplitude 3 left 
		ld	a, (hl)                         ;+03h - Amplitude 3 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch3_right),a         	;Amplitude 3 right 

		inc	hl
		ld	a, (hl)				;+04h - Amplitude 4 right/left
		and	0Fh
		ld	(Analyzer_ch4_left),a           ;Amplitude 4 left 
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch4_right),a          ;Amplitude 4 right 

		inc	hl
		ld	a, (hl)				;+05h - Amplitude 5 right/left
		and	0Fh
		ld	(Analyzer_ch5_left),a           ;Amplitude 5 left 
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch5_right),a		;Amplitude 5 right 
		ret

;-------------------------------------------------------------------
; ???ᠭ??: ?⮡ࠦ???? ???????????
; ??ࠬ????: ???
; ??????頥???  ???祭??: ???
;---------------------------------------------------------------------
Analyzer_view:
		ld	c,15
		ld	hl,504Dh
		call	Analyzer_draw

		ld	c,13
		ld	hl,514Dh
		call	Analyzer_draw

		ld	c,11
		ld	hl,524Dh
		call	Analyzer_draw

		ld	c,10
		ld	hl,534Dh
		call	Analyzer_draw

		ld	c,8
		ld	hl,544Dh
		call	Analyzer_draw

		ld	c,7
		ld	hl,554Dh
		call	Analyzer_draw
                                                        
		ld	c,6
		ld	hl,564Dh
		call	Analyzer_draw

		ld	c,5
		ld	hl,574Dh
		call	Analyzer_draw
                                                        
		ld	c,4
		ld	hl,506Dh
		call	Analyzer_draw

		ld	c,3
		ld	hl,516Dh
		call	Analyzer_draw

		ld	c,2
		ld	hl,526Dh
		call	Analyzer_draw

		ld	c,1
		ld	hl,536Dh
		call	Analyzer_draw

		ret
;-------------------------------------------------------------------
; ???ᠭ??: ????ᮢ?? ?????? ?????? ???????????
; ??ࠬ????: HL - ????? ??࠭?
;            C - ??????? ? ??????????
; ??????頥???  ???祭??: ???
;---------------------------------------------------------------------
Analyzer_draw:
		ld	b,6
		ld	de,Analyzer_ch0_left
Analyzer_loop:
		ld	(hl),0
		ld	a,(de)
		cp	c
		jr	c,Analyzer_next
		ld	(hl),0E0h

Analyzer_next:
		inc	de
		ld	a,(de)
		cp	c
		jr	c,Analyzer_next_1
		ld	a,0Eh
		or	(hl)
		ld	(hl),a

Analyzer_next_1:
		inc	l
		inc	de
		djnz	Analyzer_loop
		ret	
;-------------------------------------------------------------------
; ???ᠭ??: ????ᮢ?? ?????? ?????? ???????????
; ??ࠬ????: HL - ????? ??࠭?
;            C - ??????? ? ??????????
; ??????頥???  ???祭??: ???
;---------------------------------------------------------------------
Analyzer_draw_flash:
		ld	a,(Analyzer_ch0_left)
		ld	e,a
		ld	a,(Analyzer_ch0_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch1_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch1_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch2_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch2_right)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5A8Dh
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	l,0ADh
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch3_left)
		ld	e,a
		ld	a,(Analyzer_ch3_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch4_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch4_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch5_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch5_right)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5A91h
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	l,0B1h
		ld	(hl),a
		inc	l
		ld	(hl),a
		ret

;-------------------------------------------------------------------
; ???ᠭ??: ?????????? ??ࠬ??஢ ???????????
; ??ࠬ????: ???
; ??????頥???  ???祭??: ???
;---------------------------------------------------------------------
Analyzer_init:
              	ld	b, 12
		ld	hl,Analyzer_ch0_left

Analyzer_init_loop:
                ld	(hl),0
		inc	hl
		djnz	Analyzer_init_loop
		ret
;-------------------------------------------------------------------
; ???ᠭ??:  ??६????? ?ࠢ??? ? ?????? ??????? ???????????
;---------------------------------------------------------------------
Analyzer_table:
		db	78h,78h,78h,78h,7Dh,7Dh,7Dh,7Ch,7Ch,7Ch,7Bh,7Bh,7Ah,7Ah,79h,79h	
;-------------------------------------------------------------------
; ???ᠭ??:  ??६????? ?ࠢ??? ? ?????? ??????? ???????????
;---------------------------------------------------------------------
Analyzer_ch0_left:
		db	0	
Analyzer_ch0_right:
		db	0	
Analyzer_ch1_left:
		db	0	
Analyzer_ch1_right:
		db	0	
Analyzer_ch2_left:
		db	0	
Analyzer_ch2_right:
		db	0	
Analyzer_ch3_left:
		db	0	
Analyzer_ch3_right:
		db	0	
Analyzer_ch4_left:
		db	0	
Analyzer_ch4_right:
		db	0	
Analyzer_ch5_left:
		db	0	
Analyzer_ch5_right:
		db	0	
;		.end