;--------------------------------------------------------------------
; Описание: Модуль отображения анализатора
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------

;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_update:
		ld	hl,EAmplitude_ch0

		ld	a,(hl)				;+00h - Amplitude 0 right/left
		and	0Fh
		ld	c,a
		ld	a,(hl)				;+00h - Amplitude 0 right/left				
		and	0F0h
		rrca	
		rrca	
		rrca
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch0
		ld	a,c	
Analyzer_up_ch0:
		ld	(Analyzer_ch0_vol),a          	;Amplitude 0

		inc	hl
		ld	a,(hl)				;+01h - Amplitude 1 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)				;+01h - Amplitude 1 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch1
		ld	a,c	
Analyzer_up_ch1:
		ld	(Analyzer_ch1_vol),a          	;Amplitude 1 

		inc	hl
		ld	a,(hl) 				;+02h - Amplitude 2 right/left
		and	0Fh
		ld	c,a
		ld	a,(hl)				;+02h - Amplitude 2 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch2
		ld	a,c	
Analyzer_up_ch2:
		ld	(Analyzer_ch2_vol),a         	;Amplitude 2  

		inc	hl
		ld	a, (hl) 			;+03h - Amplitude 3 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)                         ;+03h - Amplitude 3 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch3
		ld	a,c	
Analyzer_up_ch3:
		ld	(Analyzer_ch3_vol),a         	;Amplitude 3  

		inc	hl
		ld	a, (hl)				;+04h - Amplitude 4 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch4
		ld	a,c	
Analyzer_up_ch4:
		ld	(Analyzer_ch4_vol),a          ;Amplitude 4  

		inc	hl
		ld	a, (hl)				;+05h - Amplitude 5 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch5
		ld	a,c	
Analyzer_up_ch5:
		ld	(Analyzer_ch5_vol),a		;Amplitude 5  
		ret
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view:
		ld	a,(Analyzer_ch0_vol)
		ld	de,4042h
		call	Analyzer_draw

		ld	a,(Analyzer_ch1_vol)
		ld	de,4042h + 17h
		call	Analyzer_draw

		ld	a,(Analyzer_ch2_vol)
		ld	de,4842h
		call	Analyzer_draw

		ld	a,(Analyzer_ch3_vol)
		ld	de,4842h + 17h
		call	Analyzer_draw

		ld	a,(Analyzer_ch4_vol)
		ld	de,5042h
		call	Analyzer_draw

		ld	a,(Analyzer_ch5_vol)
		ld	de,5042h + 17h
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw:

		ld	l,a
		ld	h,0
		add	hl,hl
		ld	bc,Animation_table_phase
		add	hl,bc
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ex	de,hl

		ld	b,16				;размерность по Y
Analyzer_loop_Y:
		push	hl
		ex	hl,de
		ldi
		ldi
		ldi
		ldi
		ldi
		ex	hl,de
		pop	hl
		inc	h
		ld	a,h
		and 	7
		jr	nz,Analyzer_next_line
		ld	a,l
		add	20h
		ld	l,a
		jr	c,Analyzer_next_line
		ld	a,h
		sub	8
		ld	h,a
Analyzer_next_line:
    		djnz    Analyzer_loop_Y
		ret	    
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_flash:
		ld	a,(Analyzer_ch0_vol)
		ld	e,a
		ld	a,(Analyzer_ch3_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,580Eh
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch1_vol)
		ld	e,a
		ld	a,(Analyzer_ch4_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5814h
		ld	(hl),a
		inc	l
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch2_vol)
		ld	e,a
		ld	a,(Analyzer_ch5_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5ACAh
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	l,0EAh
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a

		ret

;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_init:
              	ld	b, 6
		ld	hl,Analyzer_ch0_vol

Analyzer_init_loop:
                ld	(hl),0
		inc	hl
		djnz	Analyzer_init_loop
		ret
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table:
		db	47h,47h,47h,47h,46h,46h,45h,45h,44h,44h,43h,43h,42h,42h,41h,41h	
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Animation_table_phase:
		dw	Analyzer_phase_00		;0
		dw	Analyzer_phase_01               ;1
		dw	Analyzer_phase_01               ;2
		dw	Analyzer_phase_02               ;3
		dw	Analyzer_phase_02               ;4
		dw	Analyzer_phase_03               ;5
		dw	Analyzer_phase_04               ;6
		dw	Analyzer_phase_05               ;7
		dw	Analyzer_phase_06               ;8
		dw	Analyzer_phase_07               ;9
		dw	Analyzer_phase_08               ;10
		dw	Analyzer_phase_09               ;11
		dw	Analyzer_phase_09               ;12
		dw	Analyzer_phase_10               ;13
		dw	Analyzer_phase_10               ;14
		dw	Analyzer_phase_11               ;15


Analyzer_phase_00:
		db	0AAh,01h,0FFh,80h,55h
		db	0F4h,07h,00h,0E0h,2Fh
		db	0E8h,1Ch,42h,38h,17h
		db	50h,70h,42h,0Eh,0Ah
		db	0A1h,0C8h,00h,13h,85h
		db	45h,08h,00h,10h,0C2h
		db	82h,00h,00h,00h,41h
		db	01h,00h,00h,00h,82h
		db	80h,80h,00h,01h,01h
		db	00h,40h,00h,00h,00h
		db	00h,20h,00h,00h,01h
		db	00h,10h,00h,00h,00h
		db	00h,08h,00h,00h,01h
		db	00h,04h,00h,00h,00h
		db	00h,02h,00h,00h,01h
		db	00h,01h,00h,00h,00h
Analyzer_phase_01:
		db	0AAh,01h,0FFh,80h,55h
		db	0F4h,07h,00h,0E0h,2Fh
		db	0E8h,1Ch,42h,38h,17h
		db	50h,90h,42h,0Eh,0Ah
		db	0A1h,48h,00h,13h,85h
		db	43h,48h,00h,10h,0C2h
		db	82h,20h,00h,00h,41h
		db	01h,10h,00h,00h,82h
		db	80h,90h,00h,01h,01h
		db	00h,08h,00h,00h,00h
		db	00h,04h,00h,00h,01h
		db	00h,04h,00h,00h,00h
		db	00h,02h,00h,00h,01h
		db	00h,01h,00h,00h,00h
		db	00h,01h,00h,00h,01h
		db	00h,00h,80h,00h,00h
Analyzer_phase_02:
		db	0AAh,01h,0FFh,80h,55h
		db	0F4h,07h,00h,0E0h,2Fh
		db	0E8h,2Ch,42h,38h,17h
		db	50h,50h,42h,0Eh,0Ah
		db	0A1h,0D0h,00h,13h,85h
		db	43h,08h,00h,10h,0C2h
		db	82h,08h,00h,00h,41h
		db	01h,04h,00h,00h,82h
		db	80h,84h,00h,01h,01h
		db	00h,02h,00h,00h,00h
		db	00h,02h,00h,00h,01h
		db	00h,01h,00h,00h,00h
		db	00h,01h,00h,00h,01h
		db	00h,00h,80h,00h,00h
		db	00h,00h,80h,00h,01h
		db	00h,00h,40h,00h,00h
Analyzer_phase_03:
		db	0AAh,01h,0FFh,80h,55h
		db	0F4h,05h,00h,0E0h,2Fh
		db	0E8h,14h,42h,38h,17h
		db	50h,72h,42h,0Eh,0Ah
		db	0A1h,0CAh,00h,13h,85h
		db	43h,0Ah,00h,10h,0C2h
		db	82h,01h,00h,00h,41h
		db	01h,01h,00h,00h,82h
		db	80h,81h,00h,01h,01h
		db	00h,00h,80h,00h,00h
		db	00h,00h,80h,00h,01h
		db	00h,00h,40h,00h,00h
		db	00h,00h,40h,00h,01h
		db	00h,00h,40h,00h,00h
		db	00h,00h,20h,00h,01h
		db	00h,00h,20h,00h,00h
Analyzer_phase_04:
		db	0AAh,00h,0BFh,80h,55h
		db	0F4h,06h,80h,0E0h,2Fh
		db	0E8h,1Ch,82h,38h,17h
		db	50h,70h,42h,0Eh,0Ah
		db	0A1h,0C8h,40h,13h,85h
		db	43h,08h,40h,10h,0C2h
		db	82h,00h,40h,00h,41h
		db	01h,00h,40h,00h,82h
		db	80h,80h,20h,01h,01h
		db	00h,00h,20h,00h,00h
		db	00h,00h,20h,00h,01h
		db	00h,00h,20h,00h,00h
		db	00h,00h,20h,00h,01h
		db	00h,00h,10h,00h,00h
		db	00h,00h,10h,00h,01h
		db	00h,00h,10h,00h,00h
Analyzer_phase_05:
		db	0AAh,01h,0AFh,80h,55h
		db	0F4h,07h,20h,0E0h,2Fh
		db	0E8h,1Ch,62h,38h,17h
		db	50h,70h,62h,0Eh,0Ah
		db	0A1h,0C8h,20h,13h,85h
		db	43h,08h,20h,10h,0C2h
		db	82h,00h,20h,00h,41h
		db	01h,00h,20h,00h,82h
		db	80h,80h,10h,01h,01h
		db	00h,00h,10h,00h,00h
		db	00h,00h,10h,00h,01h
		db	00h,00h,10h,00h,00h
		db	00h,00h,10h,00h,01h
		db	00h,00h,10h,00h,00h
		db	00h,00h,10h,00h,01h
		db	00h,00h,10h,00h,00h
Analyzer_phase_06:
		db	0AAh,01h,0F5h,80h,55h
		db	0F4h,07h,04h,0E0h,2Fh
		db	0E8h,1Ch,46h,38h,17h
		db	50h,70h,46h,0Eh,0Ah
		db	0A1h,0C8h,04h,13h,85h
		db	43h,08h,04h,10h,0C2h
		db	82h,00h,04h,00h,41h
		db	01h,00h,04h,00h,82h
		db	80h,80h,08h,01h,01h
		db	00h,00h,08h,00h,00h
		db	00h,00h,08h,00h,01h
		db	00h,00h,08h,00h,00h
		db	00h,00h,08h,00h,01h
		db	00h,00h,08h,00h,00h
		db	00h,00h,08h,00h,01h
		db	00h,00h,08h,00h,00h
Analyzer_phase_07:
		db	0AAh,01h,0FDh,00h,55h
		db	0F4h,07h,01h,60h,2Fh
		db	0E8h,1Ch,41h,38h,17h
		db	50h,70h,42h,0Eh,0Ah
		db	0A1h,0C8h,02h,13h,85h
		db	43h,08h,02h,10h,0C2h
		db	82h,00h,02h,00h,41h
		db	01h,00h,02h,00h,82h
		db	80h,80h,04h,01h,01h
		db	00h,00h,04h,00h,00h
		db	00h,00h,04h,00h,01h
		db	00h,00h,04h,00h,00h
		db	00h,00h,04h,00h,01h
		db	00h,00h,08h,00h,00h
		db	00h,00h,08h,00h,01h
		db	00h,00h,08h,00h,00h
Analyzer_phase_08:
		db	0AAh,01h,0FFh,80h,55h
		db	0F4h,07h,00h,0A0h,2Fh
		db	0E8h,1Ch,42h,28h,17h
		db	50h,70h,42h,4Eh,0Ah
		db	0A1h,0C8h,00h,53h,85h
		db	43h,08h,00h,50h,0C2h
		db	82h,00h,00h,80h,41h
		db	01h,00h,00h,80h,82h
		db	80h,80h,00h,81h,01h
		db	00h,00h,01h,00h,00h
		db	00h,00h,01h,00h,01h
		db	00h,00h,02h,00h,00h
		db	00h,00h,02h,00h,01h
		db	00h,00h,02h,00h,00h
		db	00h,00h,04h,00h,01h
		db	00h,00h,04h,00h,00h
Analyzer_phase_09:
		db	0AAh,01h,0FFh,80h,55h
		db	0F4h,07h,00h,0E0h,2Fh
		db	0E8h,1Ch,42h,34h,17h
		db	50h,70h,42h,0Ah,0Ah
		db	0A1h,0C8h,00h,0Bh,85h
		db	43h,08h,00h,10h,0C2h
		db	82h,00h,00h,10h,41h
		db	01h,00h,00h,20h,82h
		db	80h,80h,00h,21h,01h
		db	00h,00h,00h,40h,00h
		db	00h,00h,00h,40h,01h
		db	00h,00h,00h,80h,00h
		db	00h,00h,00h,80h,01h
		db	00h,00h,01h,00h,00h
		db	00h,00h,01h,00h,01h
		db	00h,00h,02h,00h,00h
Analyzer_phase_10:
		db	0AAh,01h,0FFh,80h,55h
		db	0F4h,07h,00h,0E0h,2Fh
		db	0E8h,1Ch,42h,38h,17h
		db	50h,70h,42h,0Dh,0Ah
		db	0A1h,0C8h,00h,12h,85h
		db	43h,08h,00h,12h,0C2h
		db	82h,00h,00h,04h,41h
		db	01h,00h,00h,08h,82h
		db	80h,80h,00h,09h,01h
		db	00h,00h,00h,10h,00h
		db	00h,00h,00h,20h,01h
		db	00h,00h,00h,20h,00h
		db	00h,00h,00h,40h,01h
		db	00h,00h,00h,80h,00h
		db	00h,00h,00h,80h,01h
		db	00h,00h,01h,00h,00h
Analyzer_phase_11:
		db	0AAh,01h,0FFh,80h,55h
		db	0F4h,07h,00h,0E0h,2Fh
		db	0E8h,1Ch,42h,38h,17h
		db	50h,70h,42h,0Eh,0Ah
		db	0A1h,0C8h,00h,13h,85h
		db	43h,08h,00h,10h,0A2h
		db	82h,00h,00h,00h,41h
		db	01h,00h,00h,00h,82h
		db	80h,80h,00h,01h,01h
		db	00h,00h,00h,02h,00h
		db	00h,00h,00h,04h,01h
		db	00h,00h,00h,08h,00h
		db	00h,00h,00h,10h,01h
		db	00h,00h,00h,20h,00h
		db	00h,00h,00h,40h,01h
		db	00h,00h,00h,80h,00h

;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_ch0_vol:
		db	0
Analyzer_ch1_vol:
		db	0
Analyzer_ch2_vol:
		db	0
Analyzer_ch3_vol:
		db	0
Analyzer_ch4_vol:
		db	0
Analyzer_ch5_vol:
		db	0
