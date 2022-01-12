;--------------------------------------------------------------------
; Описание: Программа проигрывания модулей E-Tracker
; поддержка в железе: ZXM-SoundCard
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------
		DEVICE ZXSPECTRUM128

		.org 	6000h

;-------------------------------------------------------------------
; описание: Точка входа в программу после передачи управления из ОС
;---------------------------------------------------------------------
ETunes_Start:		
		xor	a               		;бордер в черный цвет
		out	(0feh),a	
		ld	(ETunes_count_music),a		;счетчик номера музыки

		ld	hl,4000h
		ld	de,4001h
		ld	bc,1b00h
		ld	(hl),c
		ldir
		
		ld	hl,4000h			;грузим экран
		ld	de,(5CF4h)
		ld	bc,1B05h
		call	3d13h
		call	Str_init_load
		ei
ETunes_loading:
		halt
		ld	b,0
ETunes_wait:
		djnz	ETunes_wait			
		call	Str_play
		jr	c,ETunes_load
		jr	nc,ETunes_loading	
ETunes_load:
		di                                      ;на всякий пожарный запретим прерывания
		ld	a,10h 				;установим начальную страницу памяти
		ld	(ETunes_page_memory),a
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 1.
		ld	de,(5CF4h)
		ld	bc,3A05h
		call	3d13h

		ld	a,11h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 2.
		ld	de,(5CF4h)
		ld	bc,3F05h
		call	3d13h

		ld	a,13h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 3.
		ld	de,(5CF4h)
		ld	bc,3505h
		call	3d13h

		ld	a,14h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 4.
		ld	de,(5CF4h)
		ld	bc,2705h
		call	3d13h

		ld	a,16h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 5.
		ld	de,(5CF4h)
		ld	bc,3105h
		call	3d13h

		ld	a,17h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 6.
		ld	de,(5CF4h)
		ld	bc,3405h
		call	3d13h

		call	ETunes_memory_detect
		jr	z,ETunes_skip_animation
		ld	a,90h 				
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим анимацию пак 1.
		ld	de,(5CF4h)
		ld	bc,3F05h
		call	3d13h

ETunes_skip_animation:
		ld	a,10h 
		ld	bc,7ffdh
		out	(c),a

		ld	sp,5fffh
		call	Str_init			;инициализация бегущей строки
		call	Analyzer_init
		ld	a,(ETunes_memory_ok)
		and	a
		call	nz,Animation_init
		ld	a,1
		ld	(ETunes_number_music),a
		call	ETunes_view_number
		call	ETunes_time_init
		ld	hl,0C000h
		ld	(EPlayer_Init+1),hl            ;адрес музыкального произведения
		ld	bc,0FFFDh                       ;разрешим работу SAA1099
		ld	a,0f6h
		out	(c),a
		call	EPlayer_Init			;инициализация проигрывающего модуля
		ld	hl,0fe00h                       ;создаем таблицу прерывания для im 2
		ld	de,0fe01h
		ld	bc,0100h
		ld	(hl),0fdh
		ldir
		ld	a,0c3h                          ;установим вектор прерывания
		ld	(0fdfdh),a
		ld	hl,Interrupt_handle
		ld	(0fdfeh),hl
		di
		ld	a,0feh                          ;окончание установки прерывания
		ld	i,a
		im	2
		ei
ETunes_key:		
		xor	a
                ld	(ETunes_key_press),a
ETunes_loop:		
		halt
		ld	a,7fh				;ожидаем пробел - переход к следующей композиции
		in	a,(0feh)
		rra	
		jr	c,ETunes_key

		ld	a,0FEh
		in	a,(0FEh)
		rra	    
		jr	nc,ETunes_exit

		ld	a,(ETunes_key_press)
		and	a
		jr	nz,ETunes_loop

		di	
		inc	a
                ld	(ETunes_key_press),a
		ld	a,(ETunes_page_memory)		;загрузим номер страницы памяти
		ld	bc,7ffdh
		out	(c),a
		call	EPlayer_Init			;глушим работу проигрывающего модуля
		ld	bc,0FFFDh                       ;запрещаем работу SAA1099
		ld	a,0feh
		out	(c),a
		ld	a,(ETunes_count_music)
		inc	a
		cp	20
		jr	c,ETunes_next_music
		xor	a

ETunes_next_music:
		ld	(ETunes_count_music),a
		ld	l,a
		ld	e,a
		ld	h,0
		ld	d,h
		add	hl,hl
		add	hl,de
		ld	de,ETunes_tabl_music
		add	hl,de
		ld	a,(hl)				;номер страницы памяти
		ld	(ETunes_page_memory),a
		inc	hl
		ld	a,(hl)                          
		inc	hl
		ld	h,(hl)
		ld	l,a
		ld	a,(ETunes_page_memory)		;загрузим номер страницы памяти
		ld	bc,7ffdh
		out	(c),a
		ld	(EPlayer_Init+1),hl            ;адрес музыкального произведения
		ld	bc,0FFFDh                       ;разрешим работу SAA1099
		ld	a,0f6h
		out	(c),a
		call	EPlayer_Init			;инициализируем проигрыватель
		ld	a,10h
		ld	bc,7ffdh
		out	(c),a

		ld	a,(ETunes_number_music)
		inc	a
		ld	c,a
		and	0Fh
		cp	10
		jr	c,ETunes_number_correct
		ld	a,6
		add	c
		ld	c,a

ETunes_number_correct:
		ld	a,c
		ld	(ETunes_number_music),a
		cp	21h
		jr	c,ETunes_number_valid
		ld	a,1

ETunes_number_valid:
		ld	(ETunes_number_music),a
		call	ETunes_view_number
		call	ETunes_time_init

		ei
		jp      ETunes_loop

ETunes_exit:		
		di	
		call	EPlayer_Init			;глушим работу проигрывающего модуля
		ld	bc,0FFFDh                       ;запрещаем работу SAA1099
		ld	a,0feh
		out	(c),a
		ld	hl,0	
		push	hl
      		jp  	3d2fh				;выход в TR-DOS

ETunes_time_init:
		xor	a
                ld	(ETunes_time_int),a
		ld	(ETunes_time_count),a		
		ld	(ETunes_time_minute),a
		jr	ETunes_time_draw

ETunes_time_view:
                ld	a,(ETunes_time_int)
		inc	a
                ld	(ETunes_time_int),a
		cp	50
		ret	c
		xor	a
                ld	(ETunes_time_int),a
                ld	a,(ETunes_time_count)
		inc	a
		ld	c,a
		and	0Fh
		cp	10
		jr	c,ETunes_time_next
		ld	a,6
		add	c
		ld	c,a
ETunes_time_next:
		ld	a,c
		ld	(ETunes_time_count),a		
		cp	60h
		jr	c,ETunes_time_draw
		xor	a
		ld	(ETunes_time_count),a		
		ld	a,(ETunes_time_minute)
		inc	a
		ld	(ETunes_time_minute),a
		cp	10
		jr	c,ETunes_time_draw
		xor	a
		ld	(ETunes_time_minute),a
ETunes_time_draw:
		ld	a,(ETunes_time_minute)
		ld	hl,481Ch
		and	0Fh
		call 	ETunes_view_symbol
		ld	a,(ETunes_time_count)
		ld	c,a
		and	0F0h
		rrca
		rrca
		rrca
		rrca
		ld	hl,481Eh
		call	ETunes_view_symbol
		ld	a,c
		and	0Fh
		ld	hl,481Fh
		jr	ETunes_view_symbol

 
ETunes_view_number:
		ld	c,a
		and	0F0h
		rrca
		rrca
		rrca
		rrca
		ld	hl,4806h
		call	ETunes_view_symbol
		ld	a,c
		and	0Fh
		ld	hl,4807h

ETunes_view_symbol:
		push	hl
		ld	h,0
		ld	l,a
		add	hl,hl
		add	hl,hl
		add	hl,hl
		ld	de,ETunes_table_symbol
	        add	hl,de	
		ex	de,hl
		pop	hl
		ld	b,8

ETunes_view_loop:
		ld	a,(de)
		ld	(hl),a
		inc	de		
		inc	h
		ld	a,h
		and	7
		jr	nz,ETunes_next_line
		ld	a,l
		add	a,20h
		ld	l,a
		jr	c,ETunes_next_line
		ld	a,h
		sub	8
		ld	h,a
ETunes_next_line:
		djnz	ETunes_view_loop
		ret	

ETunes_memory_detect:
		ld	bc,7ffdh
		ld 	a,10h
		out	(c),a
		ld	hl,0C000h
		ld	e,(hl)	
		ld	a,90h
		out	(c),a
		ld	a,(hl)
		cp	e
		ld	a,1
		jr	nz,ETunes_memory_flg
		xor	a
ETunes_memory_flg:
		ld	(ETunes_memory_ok),a
		and	a
		ret

	
ETunes_tabl_music:
		db	10h   				; 1 музыкальное произведение
		dw	0C000h
		db	10h   				; 2 музыкальное произведение
		dw	0C440h
		db	10h   				; 3 музыкальное произведение
		dw	0C940h
		db	10h   				; 4 музыкальное произведение
		dw	0D120h
		db	10h   				; 5 музыкальное произведение
		dw	0D5E0h
		db	10h   				; 6 музыкальное произведение
		dw	0F050h

		db	11h   				; 7 музыкальное произведение
		dw	0C000h
		db	11h   				; 8 музыкальное произведение
		dw	0DDA0h
		db	11h   				; 9 музыкальное произведение
		dw	0F250h

		db	13h   				; 10 музыкальное произведение
		dw	0C000h

		db	14h   				; 11 музыкальное произведение
		dw	0C000h
		db	14h   				; 12 музыкальное произведение
		dw	0D0A0h

		db	16h   				; 13 музыкальное произведение
		dw	0C000h
		db	16h   				; 14 музыкальное произведение
		dw	0E930h

		db	17h   				; 15 музыкальное произведение
		dw	0C000h
		db	17h   				; 16 музыкальное произведение
		dw	0D580h
		db	17h   				; 17 музыкальное произведение
		dw	0E120h
		db	17h   				; 18 музыкальное произведение
		dw	0E610h
		db	17h   				; 19 музыкальное произведение
		dw	0EB30h
		db	17h   				; 20 музыкальное произведение
		dw	0EFF0h

ETunes_table_symbol:
  		db 	0,3Ch,66h,6Eh,76h,66h,3Ch,0
  		db 	0,18h,38h,18h,18h,18h,7Eh,0
  		db 	0,3Ch,66h,0Ch,18h,30h,7Eh,0
  		db 	0,7Eh,0Ch,18h,0Ch,66h,3Ch,0
  		db 	0,0Ch,1Ch,3Ch,6Ch,7Eh,0Ch,0
  		db 	0,7Eh,60h,7Ch,06h,66h,3Ch,0
  		db 	0,3Ch,60h,7Ch,66h,66h,3Ch,0
  		db 	0,7Eh,06h,0Ch,18h,30h,30h,0
  		db 	0,3Ch,66h,3Ch,66h,66h,3Ch,0
		db 	0,3Ch,66h,3Eh,06h,0Ch,38h,0

ETunes_page_memory:
		db	0		
ETunes_count_music:
		db	0
ETunes_number_music:
		db	0
ETunes_key_press:
		db	0
ETunes_time_int:
		db	0
ETunes_time_count:
		db	0		
ETunes_time_minute:
		db	0
ETunes_memory_ok:
		db	0

Interrupt_handle:
		push	hl	
		push	bc	
		push	de
		push	af	

		call 	Analyzer_update
		call    Analyzer_draw_flash
		call	ETunes_time_view
		call	Str_play
		ld	a,(ETunes_memory_ok)
		and	a
		call	nz,Animation_view

		call 	Analyzer_view


		ld	a,(ETunes_page_memory)
		ld	bc,7ffdh
		out	(c),a
		call	EPlayer_Play
		ld	a,10h
		ld	bc,7ffdh
		out	(c),a

		pop	af
		pop	de
		pop	bc
		pop	hl
		ei
		ret


		.include  analyzer.asm
		.include  etplayer.asm
		.include  animation.asm
		.include  string.asm
Etunes_end:
		.savebin "etunes.bin",ETunes_Start, Etunes_end - ETunes_Start

		.include  anidata.asm
		.savebin "anidata.bin",Animation_phase_02, Animation_end - Animation_phase_02

		.end

