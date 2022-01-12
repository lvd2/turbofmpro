;--------------------------------------------------------------------
; Описание: Модуль отображения анализатора
; Автор порта: Тарасов М.Н.(Mick),2011
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
		ld	hl,5AE6h
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
		ld	hl,5AFCh
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
		ld	hl,5AEAh
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
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view:
		ld	a,(Analyzer_ch0_vol)
		ld	hl,4B21h
		ld	de,Analyzer_table_01
		call	Analyzer_draw

		ld	a,(Analyzer_ch1_vol)
		ld	hl,4B21h + 17h
		ld	de,Analyzer_table_02
		call	Analyzer_draw

		ld	a,(Analyzer_ch2_vol)
		ld	hl,4BA1h
		ld	de,Analyzer_table_03
		call	Analyzer_draw

		ld	a,(Analyzer_ch3_vol)
		ld	hl,4BA1h + 17h
		ld	de,Analyzer_table_04
		call	Analyzer_draw

		ld	a,(Analyzer_ch4_vol)
		ld	hl,5321h
		ld	de,Analyzer_table_05
		call	Analyzer_draw

		ld	a,(Analyzer_ch5_vol)
		ld	hl,5321h + 17h
		ld	de,Analyzer_table_06
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw:
		push	hl
		ld	l,a
		ld	h,0
		add	hl,hl
		ex	hl,de 			;hl - адрес таблицы de - смещение

		add	hl,de
		ex	hl,de                   ;hl - смещение de - адрес данных
		ld	bc,Analyzer_table_07
		add	hl,bc
		ld	b,h
		ld	c,l
		pop	hl			;hl - адрес экрана	
		ex	hl,de                   ;hl - адрес таблицы de -адрес экрана
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a

		push	de
		push	bc
		ld	b,20				;размерность по Y
Analyzer_loop_Y:
		ld	c,d
		push	de
		ldi
		ldi
		ldi
		pop	de

		inc	d
		ld	a,d
		and 	7
		jr	nz,Analyzer_next_line
		ld	a,e
		add	20h
		ld	e,a
		jr	c,Analyzer_next_line
		ld	a,d
		sub	8
		ld	d,a
Analyzer_next_line:
    		djnz    Analyzer_loop_Y

		pop	hl
		pop	de
		inc	de
		inc	de
		inc	de
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ld	b,20				;размерность по Y

Analyzer_loop_Y1:
		ld	c,d
		push	de
		ldi
		ldi
		ldi
		ldi
		pop	de

		inc	d
		ld	a,d
		and 	7
		jr	nz,Analyzer_next_line1
		ld	a,e
		add	20h
		ld	e,a
		jr	c,Analyzer_next_line1
		ld	a,d
		sub	8
		ld	d,a
Analyzer_next_line1:
    		djnz    Analyzer_loop_Y1

		ret	    
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table:
		db	58h,58h,58h,58h,5Dh,5Dh,5Dh,5Ch,5Ch,5Ch,5Fh,5Fh,5Ah,5Ah,59h,59h	
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------

Analyzer_table_01:
		dw	Analyzer_phase_100	;0
		dw	Analyzer_phase_101      ;1
		dw	Analyzer_phase_102      ;2
		dw	Analyzer_phase_103      ;3
		dw	Analyzer_phase_104      ;4
		dw	Analyzer_phase_105      ;5
		dw	Analyzer_phase_106      ;6
		dw	Analyzer_phase_107      ;7
		dw	Analyzer_phase_107      ;8
		dw	Analyzer_phase_107      ;9
		dw	Analyzer_phase_107      ;10
		dw	Analyzer_phase_107      ;11
		dw	Analyzer_phase_107      ;12
		dw	Analyzer_phase_107      ;13
		dw	Analyzer_phase_107      ;14
		dw	Analyzer_phase_107      ;15

Analyzer_table_02:
		dw	Analyzer_phase_200	;0
		dw	Analyzer_phase_201      ;1
		dw	Analyzer_phase_202      ;2
		dw	Analyzer_phase_203      ;3
		dw	Analyzer_phase_204      ;4
		dw	Analyzer_phase_205      ;5
		dw	Analyzer_phase_206      ;6
		dw	Analyzer_phase_207      ;7
		dw	Analyzer_phase_207      ;8
		dw	Analyzer_phase_207      ;9
		dw	Analyzer_phase_207      ;10
		dw	Analyzer_phase_207      ;11
		dw	Analyzer_phase_207      ;12
		dw	Analyzer_phase_207      ;13
		dw	Analyzer_phase_207      ;14
		dw	Analyzer_phase_207      ;15

Analyzer_table_03:
		dw	Analyzer_phase_300	;0
		dw	Analyzer_phase_301      ;1
		dw	Analyzer_phase_302      ;2
		dw	Analyzer_phase_303      ;3
		dw	Analyzer_phase_304      ;4
		dw	Analyzer_phase_305      ;5
		dw	Analyzer_phase_306      ;6
		dw	Analyzer_phase_307      ;7
		dw	Analyzer_phase_307      ;8
		dw	Analyzer_phase_307      ;9
		dw	Analyzer_phase_307      ;10
		dw	Analyzer_phase_307      ;11
		dw	Analyzer_phase_307      ;12
		dw	Analyzer_phase_307      ;13
		dw	Analyzer_phase_307      ;14
		dw	Analyzer_phase_307      ;15

Analyzer_table_04:
		dw	Analyzer_phase_400	;0
		dw	Analyzer_phase_401      ;1
		dw	Analyzer_phase_402      ;2
		dw	Analyzer_phase_403      ;3
		dw	Analyzer_phase_404      ;4
		dw	Analyzer_phase_405      ;5
		dw	Analyzer_phase_406      ;6
		dw	Analyzer_phase_407      ;7
		dw	Analyzer_phase_407      ;8
		dw	Analyzer_phase_407      ;9
		dw	Analyzer_phase_407      ;10
		dw	Analyzer_phase_407      ;11
		dw	Analyzer_phase_407      ;12
		dw	Analyzer_phase_407      ;13
		dw	Analyzer_phase_407      ;14
		dw	Analyzer_phase_407      ;15

Analyzer_table_05:
		dw	Analyzer_phase_500	;0
		dw	Analyzer_phase_501      ;1
		dw	Analyzer_phase_502      ;2
		dw	Analyzer_phase_503      ;3
		dw	Analyzer_phase_504      ;4
		dw	Analyzer_phase_505      ;5
		dw	Analyzer_phase_506      ;6
		dw	Analyzer_phase_507      ;7
		dw	Analyzer_phase_507      ;8
		dw	Analyzer_phase_507      ;9
		dw	Analyzer_phase_507      ;10
		dw	Analyzer_phase_507      ;11
		dw	Analyzer_phase_507      ;12
		dw	Analyzer_phase_507      ;13
		dw	Analyzer_phase_507      ;14
		dw	Analyzer_phase_507      ;15

Analyzer_table_06:
		dw	Analyzer_phase_600	;0
		dw	Analyzer_phase_601      ;1
		dw	Analyzer_phase_602      ;2
		dw	Analyzer_phase_603      ;3
		dw	Analyzer_phase_604      ;4
		dw	Analyzer_phase_605      ;5
		dw	Analyzer_phase_606      ;6
		dw	Analyzer_phase_607      ;7
		dw	Analyzer_phase_607      ;8
		dw	Analyzer_phase_607      ;9
		dw	Analyzer_phase_607      ;10
		dw	Analyzer_phase_607      ;11
		dw	Analyzer_phase_607      ;12
		dw	Analyzer_phase_607      ;13
		dw	Analyzer_phase_607      ;14
		dw	Analyzer_phase_607      ;15

Analyzer_table_07:
		dw	Analyzer_phase_700	;0
		dw	Analyzer_phase_700      ;1
		dw	Analyzer_phase_700      ;2
		dw	Analyzer_phase_700      ;3
		dw	Analyzer_phase_700      ;4
		dw	Analyzer_phase_700      ;5
		dw	Analyzer_phase_701      ;6
		dw	Analyzer_phase_702      ;7
		dw	Analyzer_phase_703      ;8
		dw	Analyzer_phase_704      ;9
		dw	Analyzer_phase_705      ;10
		dw	Analyzer_phase_706      ;11
		dw	Analyzer_phase_707      ;12
		dw	Analyzer_phase_708      ;13
		dw	Analyzer_phase_709      ;14
		dw	Analyzer_phase_710      ;15

Analyzer_phase_100:
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,3Ah,06h
		db	0C4h,62h,0Eh
		db	0C4h,63h,86h
		db	0C4h,7Bh,46h
		db	0C4h,3Bh,4Fh
		db	0C4h,00h,00h
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C4h,00h,00h
		db	86h,00h,00h
		db	0D9h,0FFh,0FFh


Analyzer_phase_101:
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,0BAh,06h
		db	0C0h,0A2h,0Eh
		db	0C0h,0A3h,86h
		db	0C0h,0BBh,46h
		db	0C0h,0BBh,4Fh
		db	0C0h,80h,00h
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C0h,0BFh,0FFh
		db	0C0h,80h,00h
		db	80h,0C0h,00h
		db	0DFh,3Fh,0FFh

Analyzer_phase_102:
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,12h,06h
		db	0C0h,52h,0Eh
		db	0C0h,53h,86h
		db	0C0h,53h,46h
		db	0C0h,13h,4Fh
		db	0C0h,10h,00h
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C1h,0D7h,0FFh
		db	0C0h,10h,00h
		db	80h,18h,00h
		db	0DFh,0E7h,0FFh

Analyzer_phase_103:
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,3Ah,06h
		db	0C0h,62h,0Eh
		db	0C0h,62h,86h
		db	0C0h,7Ah,46h
		db	0C0h,3Ah,4Fh
		db	0C0h,02h,00h
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C1h,0FAh,0FFh
		db	0C0h,02h,00h
		db	80h,03h,00h
		db	0DFh,0FCh,0FFh

Analyzer_phase_104:
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,3Ah,46h
		db	0C0h,62h,4Eh
		db	0C0h,63h,46h
		db	0C0h,7Bh,46h
		db	0C0h,3Bh,4Fh
		db	0C0h,00h,40h
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C1h,0FFh,5Fh
		db	0C0h,00h,40h
		db	80h,00h,20h
		db	0DFh,0FFh,9Fh

Analyzer_phase_105:
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,3Ah,0Ah
		db	0C0h,62h,0Ah
		db	0C0h,63h,8Ah
		db	0C0h,7Bh,4Ah
		db	0C0h,3Bh,4Bh
		db	0C0h,00h,08h
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C1h,0FFh,0EBh
		db	0C0h,00h,08h
		db	80h,00h,04h
		db	0DFh,0FFh,0F3h

Analyzer_phase_106:
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,3Ah,05h
		db	0C0h,62h,0Dh
		db	0C0h,63h,85h
		db	0C0h,7Bh,45h
		db	0C0h,3Bh,4Dh
		db	0C0h,00h,01h
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C1h,0FFh,0FDh
		db	0C0h,00h,01h
		db	80h,00h,00h
		db	0DFh,0FFh,0FEh

Analyzer_phase_107:
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,3Ah,06h
		db	0C0h,62h,0Eh
		db	0C0h,63h,86h
		db	0C0h,7Bh,46h
		db	0C0h,3Bh,4Fh
		db	0C0h,00h,00h
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C1h,0FFh,0FFh
		db	0C0h,00h,00h
		db	80h,00h,00h
		db	0DFh,0FFh,0FFh


Analyzer_phase_200:
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,3Ah,0Eh
		db	0C4h,62h,03h
		db	0C4h,63h,8Fh
		db	0C4h,7Bh,4Ch
		db	0C4h,3Bh,47h
		db	0C4h,00h,00h
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C4h,00h,00h
		db	86h,00h,00h
		db	0D9h,0FFh,0FFh

Analyzer_phase_201:
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,0BAh,0Eh
		db	0C0h,0A2h,03h
		db	0C0h,0A3h,8Fh
		db	0C0h,0BBh,4Ch
		db	0C0h,0BBh,47h
		db	0C0h,80h,00h
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C0h,0BFh,0FFh
		db	0C0h,80h,00h
		db	80h,0C0h,00h
		db	0DFh,3Fh,0FFh

Analyzer_phase_202:
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,12h,0Eh
		db	0C0h,52h,03h
		db	0C0h,53h,8Fh
		db	0C0h,53h,4Ch
		db	0C0h,13h,47h
		db	0C0h,10h,00h
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C1h,0D7h,0FFh
		db	0C0h,10h,00h
		db	80h,18h,00h
		db	0DFh,0E7h,0FFh

Analyzer_phase_203:
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,3Ah,0Eh
		db	0C0h,62h,03h
		db	0C0h,62h,8Fh
		db	0C0h,7Ah,4Ch
		db	0C0h,3Ah,47h
		db	0C0h,02h,00h
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C1h,0FAh,0FFh
		db	0C0h,02h,00h
		db	80h,03h,00h
		db	0DFh,0FCh,0FFh

Analyzer_phase_204:
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,3Ah,4Eh
		db	0C0h,62h,43h
		db	0C0h,63h,4Fh
		db	0C0h,7Bh,4Ch
		db	0C0h,3Bh,47h
		db	0C0h,00h,40h
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C1h,0FFh,5Fh
		db	0C0h,00h,40h
		db	80h,00h,20h
		db	0DFh,0FFh,9Fh

Analyzer_phase_205:
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,3Ah,0Ah
		db	0C0h,62h,0Bh
		db	0C0h,63h,8Bh
		db	0C0h,7Bh,48h
		db	0C0h,3Bh,4Bh
		db	0C0h,00h,08h
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C1h,0FFh,0EBh
		db	0C0h,00h,08h
		db	80h,00h,04h
		db	0DFh,0FFh,0F3h

Analyzer_phase_206:
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,3Ah,0Dh
		db	0C0h,62h,01h
		db	0C0h,63h,8Dh
		db	0C0h,7Bh,4Dh
		db	0C0h,3Bh,45h
		db	0C0h,00h,01h
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C1h,0FFh,0FDh
		db	0C0h,00h,01h
		db	80h,00h,00h
		db	0DFh,0FFh,0FEh

Analyzer_phase_207:
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,3Ah,0Eh
		db	0C0h,62h,03h
		db	0C0h,63h,8Fh
		db	0C0h,7Bh,4Ch
		db	0C0h,3Bh,47h
		db	0C0h,00h,00h
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C1h,0FFh,0FFh
		db	0C0h,00h,00h
		db	80h,00h,00h
		db	0DFh,0FFh,0FFh

Analyzer_phase_300:
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,3Ah,0Eh
		db	0C4h,62h,03h
		db	0C4h,63h,87h
		db	0C4h,7Bh,43h
		db	0C4h,3Bh,4Eh
		db	0C4h,00h,00h
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C4h,00h,00h
		db	86h,00h,00h
		db	0D9h,0FFh,0FFh

Analyzer_phase_301:
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,0BAh,0Eh
		db	0C0h,0A2h,03h
		db	0C0h,0A3h,87h
		db	0C0h,0BBh,43h
		db	0C0h,0BBh,4Eh
		db	0C0h,80h,00h
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C0h,0BFh,0FFh
		db	0C0h,80h,00h
		db	80h,0C0h,00h
		db	0DFh,3Fh,0FFh

Analyzer_phase_302:
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,12h,0Eh
		db	0C0h,52h,03h
		db	0C0h,53h,87h
		db	0C0h,53h,43h
		db	0C0h,13h,4Eh
		db	0C0h,10h,00h
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C1h,0D7h,0FFh
		db	0C0h,10h,00h
		db	80h,18h,00h
		db	0DFh,0E7h,0FFh

Analyzer_phase_303:
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,3Ah,0Eh
		db	0C0h,62h,03h
		db	0C0h,62h,87h
		db	0C0h,7Ah,43h
		db	0C0h,3Ah,4Eh
		db	0C0h,02h,00h
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C1h,0FAh,0FFh
		db	0C0h,02h,00h
		db	80h,03h,00h
		db	0DFh,0FCh,0FFh

Analyzer_phase_304:
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,3Ah,4Eh
		db	0C0h,62h,43h
		db	0C0h,63h,47h
		db	0C0h,7Bh,43h
		db	0C0h,3Bh,4Eh
		db	0C0h,00h,40h
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C1h,0FFh,5Fh
		db	0C0h,00h,40h
		db	80h,00h,20h
		db	0DFh,0FFh,9Fh

Analyzer_phase_305:
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,3Ah,0Ah
		db	0C0h,62h,0Bh
		db	0C0h,63h,8Bh
		db	0C0h,7Bh,4Bh
		db	0C0h,3Bh,4Ah
		db	0C0h,00h,08h
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C1h,0FFh,0EBh
		db	0C0h,00h,08h
		db	80h,00h,04h
		db	0DFh,0FFh,0F3h

Analyzer_phase_306:
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,3Ah,0Dh
		db	0C0h,62h,01h
		db	0C0h,63h,85h
		db	0C0h,7Bh,41h
		db	0C0h,3Bh,4Dh
		db	0C0h,00h,01h
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C1h,0FFh,0FDh
		db	0C0h,00h,01h
		db	80h,00h,00h
		db	0DFh,0FFh,0FEh

Analyzer_phase_307:
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,3Ah,0Eh
		db	0C0h,62h,03h
		db	0C0h,63h,87h
		db	0C0h,7Bh,43h
		db	0C0h,3Bh,4Eh
		db	0C0h,00h,00h
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C1h,0FFh,0FFh
		db	0C0h,00h,00h
		db	80h,00h,00h
		db	0DFh,0FFh,0FFh

Analyzer_phase_400:
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,3Ah,0Ah
		db	0C4h,62h,0Bh
		db	0C4h,63h,8Fh
		db	0C4h,7Bh,43h
		db	0C4h,3Bh,43h
		db	0C4h,00h,00h
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C4h,00h,00h
		db	86h,00h,00h
		db	0D9h,0FFh,0FFh

Analyzer_phase_401:
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,0BAh,0Ah
		db	0C0h,0A2h,0Bh
		db	0C0h,0A3h,8Fh
		db	0C0h,0BBh,43h
		db	0C0h,0BBh,43h
		db	0C0h,80h,00h
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C0h,0BFh,0FFh
		db	0C0h,80h,00h
		db	80h,0C0h,00h
		db	0DFh,3Fh,0FFh

Analyzer_phase_402:
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,12h,0Ah
		db	0C0h,52h,0Bh
		db	0C0h,53h,8Fh
		db	0C0h,53h,43h
		db	0C0h,13h,43h
		db	0C0h,10h,00h
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C1h,0D7h,0FFh
		db	0C0h,10h,00h
		db	80h,18h,00h
		db	0DFh,0E7h,0FFh

Analyzer_phase_403:
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,3Ah,0Ah
		db	0C0h,62h,0Bh
		db	0C0h,62h,8Fh
		db	0C0h,7Ah,43h
		db	0C0h,3Ah,43h
		db	0C0h,02h,00h
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C1h,0FAh,0FFh
		db	0C0h,02h,00h
		db	80h,03h,00h
		db	0DFh,0FCh,0FFh

Analyzer_phase_404:
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,3Ah,4Ah
		db	0C0h,62h,4Bh
		db	0C0h,63h,4Fh
		db	0C0h,7Bh,43h
		db	0C0h,3Bh,43h
		db	0C0h,00h,40h
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C1h,0FFh,5Fh
		db	0C0h,00h,40h
		db	80h,00h,20h
		db	0DFh,0FFh,9Fh

Analyzer_phase_405:
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,3Ah,0Ah
		db	0C0h,62h,0Bh
		db	0C0h,63h,8Bh
		db	0C0h,7Bh,4Bh
		db	0C0h,3Bh,4Bh
		db	0C0h,00h,08h
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C1h,0FFh,0EBh
		db	0C0h,00h,08h
		db	80h,00h,04h
		db	0DFh,0FFh,0F3h

Analyzer_phase_406:
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,3Ah,09h
		db	0C0h,62h,09h
		db	0C0h,63h,8Dh
		db	0C0h,7Bh,41h
		db	0C0h,3Bh,41h
		db	0C0h,00h,01h
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C1h,0FFh,0FDh
		db	0C0h,00h,01h
		db	80h,00h,00h
		db	0DFh,0FFh,0FEh

Analyzer_phase_407:
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,3Ah,0Ah
		db	0C0h,62h,0Bh
		db	0C0h,63h,8Fh
		db	0C0h,7Bh,43h
		db	0C0h,3Bh,43h
		db	0C0h,00h,00h
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C1h,0FFh,0FFh
		db	0C0h,00h,00h
		db	80h,00h,00h
		db	0DFh,0FFh,0FFh

Analyzer_phase_500:
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,3Ah,07h
		db	0C4h,62h,0Ch
		db	0C4h,63h,8Fh
		db	0C4h,7Bh,43h
		db	0C4h,3Bh,4Eh
		db	0C4h,00h,00h
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C4h,00h,00h
		db	86h,00h,00h
		db	0D9h,0FFh,0FFh

Analyzer_phase_501:
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,0BAh,07h
		db	0C0h,0A2h,0Ch
		db	0C0h,0A3h,8Fh
		db	0C0h,0BBh,43h
		db	0C0h,0BBh,4Eh
		db	0C0h,80h,00h
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C0h,0BFh,0FFh
		db	0C0h,80h,00h
		db	80h,0C0h,00h
		db	0DFh,3Fh,0FFh

Analyzer_phase_502:
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,12h,07h
		db	0C0h,52h,0Ch
		db	0C0h,53h,8Fh
		db	0C0h,53h,43h
		db	0C0h,13h,4Eh
		db	0C0h,10h,00h
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C1h,0D7h,0FFh
		db	0C0h,10h,00h
		db	80h,18h,00h
		db	0DFh,0E7h,0FFh

Analyzer_phase_503:
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,3Ah,07h
		db	0C0h,62h,0Ch
		db	0C0h,62h,8Fh
		db	0C0h,7Ah,43h
		db	0C0h,3Ah,4Eh
		db	0C0h,02h,00h
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C1h,0FAh,0FFh
		db	0C0h,02h,00h
		db	80h,03h,00h
		db	0DFh,0FCh,0FFh

Analyzer_phase_504:
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,3Ah,47h
		db	0C0h,62h,4Ch
		db	0C0h,63h,4Fh
		db	0C0h,7Bh,43h
		db	0C0h,3Bh,4Eh
		db	0C0h,00h,40h
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C1h,0FFh,5Fh
		db	0C0h,00h,40h
		db	80h,00h,20h
		db	0DFh,0FFh,9Fh

Analyzer_phase_505:
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,3Ah,0Bh
		db	0C0h,62h,08h
		db	0C0h,63h,8Bh
		db	0C0h,7Bh,4Bh
		db	0C0h,3Bh,4Ah
		db	0C0h,00h,08h
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C1h,0FFh,0EBh
		db	0C0h,00h,08h
		db	80h,00h,04h
		db	0DFh,0FFh,0F3h

Analyzer_phase_506:
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,3Ah,05h
		db	0C0h,62h,0Dh
		db	0C0h,63h,8Dh
		db	0C0h,7Bh,41h
		db	0C0h,3Bh,4Dh
		db	0C0h,00h,01h
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C1h,0FFh,0FDh
		db	0C0h,00h,01h
		db	80h,00h,00h
		db	0DFh,0FFh,0FEh

Analyzer_phase_507:
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,3Ah,07h
		db	0C0h,62h,0Ch
		db	0C0h,63h,8Fh
		db	0C0h,7Bh,43h
		db	0C0h,3Bh,4Eh
		db	0C0h,00h,00h
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C1h,0FFh,0FFh
		db	0C0h,00h,00h
		db	80h,00h,00h
		db	0DFh,0FFh,0FFh

Analyzer_phase_600:
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,00h,00h
		db	0C4h,3Ah,07h
		db	0C4h,62h,0Ch
		db	0C4h,63h,8Fh
		db	0C4h,7Bh,4Dh
		db	0C4h,3Bh,4Fh
		db	0C4h,00h,00h
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C5h,0FFh,0FFh
		db	0C4h,00h,00h
		db	86h,00h,00h
		db	0D9h,0FFh,0FFh

Analyzer_phase_601:
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,80h,00h
		db	0C0h,0BAh,07h
		db	0C0h,0A2h,0Ch
		db	0C0h,0A3h,8Fh
		db	0C0h,0BBh,4Dh
		db	0C0h,0BBh,4Fh
		db	0C0h,80h,00h
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C2h,0BFh,0FFh
		db	0C0h,0BFh,0FFh
		db	0C0h,80h,00h
		db	80h,0C0h,00h
		db	0DFh,3Fh,0FFh

Analyzer_phase_602:
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,10h,00h
		db	0C0h,12h,07h
		db	0C0h,52h,0Ch
		db	0C0h,53h,8Fh
		db	0C0h,53h,4Dh
		db	0C0h,13h,4Fh
		db	0C0h,10h,00h
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C3h,0D7h,0FFh
		db	0C1h,0D7h,0FFh
		db	0C0h,10h,00h
		db	80h,18h,00h
		db	0DFh,0E7h,0FFh

Analyzer_phase_603:
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,02h,00h
		db	0C0h,3Ah,07h
		db	0C0h,62h,0Ch
		db	0C0h,62h,8Fh
		db	0C0h,7Ah,4Dh
		db	0C0h,3Ah,4Fh
		db	0C0h,02h,00h
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C3h,0FAh,0FFh
		db	0C1h,0FAh,0FFh
		db	0C0h,02h,00h
		db	80h,03h,00h
		db	0DFh,0FCh,0FFh

Analyzer_phase_604:
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,00h,40h
		db	0C0h,3Ah,47h
		db	0C0h,62h,4Ch
		db	0C0h,63h,4Fh
		db	0C0h,7Bh,4Dh
		db	0C0h,3Bh,4Fh
		db	0C0h,00h,40h
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C3h,0FFh,5Fh
		db	0C1h,0FFh,5Fh
		db	0C0h,00h,40h
		db	80h,00h,20h
		db	0DFh,0FFh,9Fh

Analyzer_phase_605:
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,00h,08h
		db	0C0h,3Ah,0Bh
		db	0C0h,62h,08h
		db	0C0h,63h,8Bh
		db	0C0h,7Bh,49h
		db	0C0h,3Bh,4Bh
		db	0C0h,00h,08h
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C3h,0FFh,0EBh
		db	0C1h,0FFh,0EBh
		db	0C0h,00h,08h
		db	80h,00h,04h
		db	0DFh,0FFh,0F3h

Analyzer_phase_606:
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,00h,01h
		db	0C0h,3Ah,05h
		db	0C0h,62h,0Dh
		db	0C0h,63h,8Dh
		db	0C0h,7Bh,4Dh
		db	0C0h,3Bh,4Dh
		db	0C0h,00h,01h
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C3h,0FFh,0FDh
		db	0C1h,0FFh,0FDh
		db	0C0h,00h,01h
		db	80h,00h,00h
		db	0DFh,0FFh,0FEh

Analyzer_phase_607:
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,00h,00h
		db	0C0h,3Ah,07h
		db	0C0h,62h,0Ch
		db	0C0h,63h,8Fh
		db	0C0h,7Bh,4Dh
		db	0C0h,3Bh,4Fh
		db	0C0h,00h,00h
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C3h,0FFh,0FFh
		db	0C1h,0FFh,0FFh
		db	0C0h,00h,00h
		db	80h,00h,00h
		db	0DFh,0FFh,0FFh

Analyzer_phase_700:
		db	00h,00h,00h,03h
		db	00h,00h,00h,03h
		db	00h,00h,00h,03h
		db	0Fh,03h,0FFh,0C3h
		db	03h,0C3h,0FFh,0C3h
		db	00h,73h,0FFh,0C3h
		db	03h,0C3h,0FFh,0C3h
		db	0Fh,03h,0FFh,0C3h
		db	00h,03h,0FFh,0C3h
		db	0FFh,0FFh,0FFh,0C3h
		db	0FFh,0FFh,0FFh,0C3h
		db	0FFh,0FFh,0FFh,0C3h
		db	0FFh,0FFh,0FFh,0C3h
		db	0FFh,0FFh,0FFh,0C3h
		db	0FFh,0FFh,0FFh,83h
		db	0FFh,0FEh,00h,03h
		db	0FFh,0FEh,00h,03h
		db	00h,00h,00h,03h
		db	00h,00h,00h,01h
		db	0FFh,0FFh,0FFh,0FBh

Analyzer_phase_701:
		db	00h,00h,00h,03h
		db	00h,00h,00h,03h
		db	00h,00h,00h,03h
		db	0Fh,03h,0FFh,0C3h
		db	03h,0C3h,0FFh,0C3h
		db	00h,73h,0FFh,0C3h
		db	03h,0C3h,0FFh,0C3h
		db	0Fh,03h,0FFh,0C3h
		db	00h,03h,0FFh,0C3h
		db	7Fh,0FFh,0FFh,0C3h
		db	7Fh,0FFh,0FFh,0C3h
		db	7Fh,0FFh,0FFh,0C3h
		db	7Fh,0FFh,0FFh,0C3h
		db	7Fh,0FFh,0FFh,0C3h
		db	7Fh,0FFh,0FFh,83h
		db	7Fh,0FEh,00h,03h
		db	7Fh,0FEh,00h,03h
		db	00h,00h,00h,03h
		db	80h,00h,00h,01h
		db	7Fh,0FFh,0FFh,0FBh

Analyzer_phase_702:
		db	20h,00h,00h,03h
		db	20h,00h,00h,03h
		db	20h,00h,00h,03h
		db	2Fh,03h,0FFh,0C3h
		db	23h,0C3h,0FFh,0C3h
		db	20h,73h,0FFh,0C3h
		db	23h,0C3h,0FFh,0C3h
		db	2Fh,03h,0FFh,0C3h
		db	20h,03h,0FFh,0C3h
		db	0AFh,0FFh,0FFh,0C3h
		db	0AFh,0FFh,0FFh,0C3h
		db	0AFh,0FFh,0FFh,0C3h
		db	0AFh,0FFh,0FFh,0C3h
		db	0AFh,0FFh,0FFh,0C3h
		db	0AFh,0FFh,0FFh,83h
		db	0AFh,0FEh,00h,03h
		db	0AFh,0FEh,00h,03h
		db	20h,00h,00h,03h
		db	20h,00h,00h,01h
		db	8Fh,0FFh,0FFh,0FBh

Analyzer_phase_703:
		db	04h,00h,00h,03h
		db	04h,00h,00h,03h
		db	04h,00h,00h,03h
		db	05h,03h,0FFh,0C3h
		db	05h,0C3h,0FFh,0C3h
		db	04h,73h,0FFh,0C3h
		db	05h,0C3h,0FFh,0C3h
		db	05h,03h,0FFh,0C3h
		db	04h,03h,0FFh,0C3h
		db	0F5h,0FFh,0FFh,0C3h
		db	0F5h,0FFh,0FFh,0C3h
		db	0F5h,0FFh,0FFh,0C3h
		db	0F5h,0FFh,0FFh,0C3h
		db	0F5h,0FFh,0FFh,0C3h
		db	0F5h,0FFh,0FFh,83h
		db	0F5h,0FEh,00h,03h
		db	0F5h,0FEh,00h,03h
		db	04h,00h,00h,03h
		db	04h,00h,00h,01h
		db	0F1h,0FFh,0FFh,0FBh

Analyzer_phase_704:
		db	00h,80h,00h,03h
		db	00h,80h,00h,03h
		db	00h,80h,00h,03h
		db	0Eh,83h,0FFh,0C3h
		db	02h,83h,0FFh,0C3h
		db	00h,0B3h,0FFh,0C3h
		db	02h,83h,0FFh,0C3h
		db	0Eh,83h,0FFh,0C3h
		db	00h,83h,0FFh,0C3h
		db	0FEh,0BFh,0FFh,0C3h
		db	0FEh,0BFh,0FFh,0C3h
		db	0FEh,0BFh,0FFh,0C3h
		db	0FEh,0BFh,0FFh,0C3h
		db	0FEh,0BFh,0FFh,0C3h
		db	0FEh,0BFh,0FFh,83h
		db	0FEh,0BEh,00h,03h
		db	0FEh,0BEh,00h,03h
		db	00h,80h,00h,03h
		db	01h,00h,00h,01h
		db	0FEh,7Fh,0FFh,0FBh

Analyzer_phase_705:
		db	00h,10h,00h,03h
		db	00h,10h,00h,03h
		db	00h,10h,00h,03h
		db	0Fh,13h,0FFh,0C3h
		db	03h,0D3h,0FFh,0C3h
		db	00h,53h,0FFh,0C3h
		db	03h,0D3h,0FFh,0C3h
		db	0Fh,13h,0FFh,0C3h
		db	00h,13h,0FFh,0C3h
		db	0FFh,0D7h,0FFh,0C3h
		db	0FFh,0D7h,0FFh,0C3h
		db	0FFh,0D7h,0FFh,0C3h
		db	0FFh,0D7h,0FFh,0C3h
		db	0FFh,0D7h,0FFh,0C3h
		db	0FFh,0D7h,0FFh,83h
		db	0FFh,0D6h,00h,03h
		db	0FFh,0D6h,00h,03h
		db	00h,10h,00h,03h
		db	00h,20h,00h,01h
		db	0FFh,0CFh,0FFh,0FBh

Analyzer_phase_706:
		db	00h,02h,00h,03h
		db	00h,02h,00h,03h
		db	00h,02h,00h,03h
		db	0Fh,02h,0FFh,0C3h
		db	03h,0C2h,0FFh,0C3h
		db	00h,72h,0FFh,0C3h
		db	03h,0C2h,0FFh,0C3h
		db	0Fh,02h,0FFh,0C3h
		db	00h,02h,0FFh,0C3h
		db	0FFh,0FAh,0FFh,0C3h
		db	0FFh,0FAh,0FFh,0C3h
		db	0FFh,0FAh,0FFh,0C3h
		db	0FFh,0FAh,0FFh,0C3h
		db	0FFh,0FAh,0FFh,0C3h
		db	0FFh,0FAh,0FFh,83h
		db	0FFh,0FAh,00h,03h
		db	0FFh,0FAh,00h,03h
		db	00h,02h,00h,03h
		db	00h,04h,00h,01h
		db	0FFh,0F9h,0FFh,0FBh

Analyzer_phase_707:
		db	00h,00h,40h,03h
		db	00h,00h,40h,03h
		db	00h,00h,40h,03h
		db	0Fh,03h,5Fh,0C3h
		db	03h,0C3h,5Fh,0C3h
		db	00h,73h,5Fh,0C3h
		db	03h,0C3h,5Fh,0C3h
		db	0Fh,03h,5Fh,0C3h
		db	00h,03h,5Fh,0C3h
		db	0FFh,0FFh,5Fh,0C3h
		db	0FFh,0FFh,5Fh,0C3h
		db	0FFh,0FFh,5Fh,0C3h
		db	0FFh,0FFh,5Fh,0C3h
		db	0FFh,0FFh,5Fh,0C3h
		db	0FFh,0FFh,5Fh,83h
		db	0FFh,0FEh,40h,03h
		db	0FFh,0FEh,40h,03h
		db	00h,00h,40h,03h
		db	00h,00h,0C0h,01h
		db	0FFh,0FFh,3Fh,0FBh

Analyzer_phase_708:
		db	00h,00h,08h,03h
		db	00h,00h,08h,03h
		db	00h,00h,08h,03h
		db	0Fh,03h,0EBh,0C3h
		db	03h,0C3h,0EBh,0C3h
		db	00h,73h,0EBh,0C3h
		db	03h,0C3h,0EBh,0C3h
		db	0Fh,03h,0EBh,0C3h
		db	00h,03h,0EBh,0C3h
		db	0FFh,0FFh,0EBh,0C3h
		db	0FFh,0FFh,0EBh,0C3h
		db	0FFh,0FFh,0EBh,0C3h
		db	0FFh,0FFh,0EBh,0C3h
		db	0FFh,0FFh,0EBh,0C3h
		db	0FFh,0FFh,0EBh,83h
		db	0FFh,0FEh,08h,03h
		db	0FFh,0FEh,08h,03h
		db	00h,00h,08h,03h
		db	00h,00h,18h,01h
		db	0FFh,0FFh,0E7h,0FBh

Analyzer_phase_709:
		db	00h,00h,01h,03h
		db	00h,00h,01h,03h
		db	00h,00h,01h,03h
		db	0Fh,03h,0FDh,43h
		db	03h,0C3h,0FDh,43h
		db	00h,73h,0FDh,43h
		db	03h,0C3h,0FDh,43h
		db	0Fh,03h,0FDh,43h
		db	00h,03h,0FDh,43h
		db	0FFh,0FFh,0FDh,43h
		db	0FFh,0FFh,0FDh,43h
		db	0FFh,0FFh,0FDh,43h
		db	0FFh,0FFh,0FDh,43h
		db	0FFh,0FFh,0FDh,43h
		db	0FFh,0FFh,0FDh,03h
		db	0FFh,0FEh,01h,03h
		db	0FFh,0FEh,01h,03h
		db	00h,00h,01h,03h
		db	00h,00h,03h,01h
		db	0FFh,0FFh,0FCh,0FBh

Analyzer_phase_710:
		db	00h,00h,00h,23h
		db	00h,00h,00h,23h
		db	00h,00h,00h,23h
		db	0Fh,03h,0FFh,0A3h
		db	03h,0C3h,0FFh,0A3h
		db	00h,73h,0FFh,0A3h
		db	03h,0C3h,0FFh,0A3h
		db	0Fh,03h,0FFh,0A3h
		db	00h,03h,0FFh,0A3h
		db	0FFh,0FFh,0FFh,0A3h
		db	0FFh,0FFh,0FFh,0A3h
		db	0FFh,0FFh,0FFh,0A3h
		db	0FFh,0FFh,0FFh,0A3h
		db	0FFh,0FFh,0FFh,0A3h
		db	0FFh,0FFh,0FFh,0A3h
		db	0FFh,0FEh,00h,23h
		db	0FFh,0FEh,00h,23h
		db	00h,00h,00h,23h
		db	00h,00h,00h,61h
		db	0FFh,0FFh,0FFh,9Bh

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
