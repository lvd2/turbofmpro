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

		ld	hl,4000h
		ld	de,4001h
		ld	bc,1b00h
		ld	(hl),c
		ldir
		
		ld	hl,4000h			;грузим экран
		ld	de,(5CF4h)
		ld	bc,1B05h
		call	3d13h
		ld	a,10h 				;установим начальную страницу памяти
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0D000h			;грузим анализатор
		ld	de,(5CF4h)
		ld	bc,0905h
		call	3d13h
		ld	hl,0E000h			;грузим данные анализатора
		ld	de,(5CF4h)
		ld	bc,1305h
		call	3d13h
		call	Str_init_load
		ei
ETunes_loading:
		halt
		call	Str_play
		jr	c,ETunes_load
		call	Str_update_symbol
		jr	nc,ETunes_loading	
ETunes_load:
		di                                      ;на всякий пожарный запретим прерывания
		ld	de,(5CF4h)
		ld (sect_pack0),de
		call load_packs_0
		ld	de,(5CF4h)
		ld (sect_pack1),de

		; xor	a 
		; ld	bc,1ffdh
		; out	(c),a
		
		ld	a,10h 
		ld	bc,0x7ffd
		out	(c),a

		ld	sp,5fffh
		call	Str_init			;инициализация бегущей строки
		call	Attribute_init			
		call	Analyzer_init			
		ld	a,1
		ld	(ETunes_number_music),a
		call	ETunes_view_number
		xor	a
		ld	(ETunes_count_music),a		;счетчик номера музыки
		call	ETunes_copy_music
		ld	bc,0FFFDh                       ;разрешим работу SAA1099
		ld	a,0f6h
		out	(c),a
		call	ESIPlayer_Init			;инициализация проигрывающего модуля
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
		call	Str_play
		call	Str_update_symbol
		call	Attribute_update

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
	
		call	ESIPlayer_Init			;глушим работу проигрывающего модуля
		ld	bc,0FFFDh                       ;запрещаем работу SAA1099
		ld	a,0feh
		out	(c),a
		ld	a,(ETunes_count_music)
		inc	a
		cp	26
		jr	c,ETunes_next_music
		xor	a

ETunes_next_music:
		ld	(ETunes_count_music),a
		im 1
		call	ETunes_copy_music
		im 2
		ld	bc,0FFFDh                       ;разрешим работу SAA1099
		ld	a,0f6h
		out	(c),a
		call	ESIPlayer_Init			;инициализируем проигрыватель

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
		cp	27h
		jr	c,ETunes_number_valid
		ld	a,1

ETunes_number_valid:
		ld	(ETunes_number_music),a
		call	ETunes_view_number

		ei
		jp      ETunes_loop

ETunes_exit:		
		di	
		call	ESIPlayer_Init			;глушим работу проигрывающего модуля
		ld	bc,0FFFDh                       ;запрещаем работу SAA1099
		ld	a,0feh
		out	(c),a
		ld	hl,0	
		push	hl
      		jp  	3d2fh				;выход в TR-DOS
		display $
ETunes_copy_music:
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	d,h
		ld	e,l
		add	hl,hl
		add	hl,de
		ld	de,ETunes_tabl_music
		add	hl,de
		push hl
		ld	a,(hl)				;номер страницы памяти
		and 0x80
curr_packs=$+1
		cp 0x00
		jr z,ETunes_copy_0
		ld (curr_packs),a
		or a
		jr nz,is_pack1
		call load_packs_0
		jr ETunes_copy_0
is_pack1
		call load_packs_1
ETunes_copy_0:
		pop hl
		ld	a,(hl)				;номер страницы памяти
		and 0x7f
		ld	bc,7ffdh
		out	(c),a
		inc	hl
		ld	c,(hl)				;признак что залезет в С000h
		inc	hl
		ld	e,(hl)				;адрес где модуль                          
		inc	hl
		ld	d,(hl)
		inc	hl
		ld	a,(hl) 				;адрес куда копировать                          
		inc	hl
		ld	h,(hl)
		ld	l,a
		ex	hl,de
		push 	de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		inc	hl
		ex      hl,de
		ld	(ESIPlayer_Init+1),hl            ;адрес музыкального произведения
		ex	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		inc	hl
		ex      hl,de
		ld	(ESIPlayer_InitS+1),hl          ;адрес музыкального произведения
		ex	hl,de
		ld	a,c                             ;флаг копирования
		ld	c,(hl) 				;размер файла
		inc	hl
		ld	b,(hl)
		inc	hl
		pop	de
		and	a
		jr	z,ETunes_copy_1
		ld	a,d
		cp	0C0h				;копируем в область C000h
		jr	nc,ETunes_copy_2
ETunes_copy_3:
		ldi
		ld	a,d
		cp	0C0h
		jr	c,ETunes_copy_3
ETunes_copy_2:
		push	de
		push	bc
		ld	de,8000h
		ldir
;		xor	a 
;		ld	bc,1ffdh
;		out	(c),a
		ld	a,10h 
		ld	bc,7ffdh
		out	(c),a
		pop	bc
		pop	de
		ld	hl,8000h
		ldir
		ret
		
ETunes_copy_1:
		ldir
;		xor	a 
;		ld	bc,1ffdh
;		out	(c),a
		ld	a,10h 
		ld	bc,7ffdh
		out	(c),a
		ret


ETunes_view_number:
		ld	c,a
		and	0F0h
		rrca
		rrca
		rrca
		rrca
		ld	hl,55DDh
		call	ETunes_view_symbol
		ld	a,c
		and	0Fh
		ld	hl,55DEh

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
		ld	a, l
		add	a,20h
		ld	l, a
		jr	c,ETunes_next_line
		ld	a,h
		sub	8
		ld	h,a
ETunes_next_line:	
		djnz	ETunes_view_loop
		ret	

load_packs_0
		ld	a,11h 				;установим начальную страницу памяти
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 1.
		ld	de,0x0000
sect_pack0=$-2
		ld	bc,3A05h
		call	3d13h

		ld	a,13h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 2.
		ld	de,(5CF4h)
		ld	bc,3F05h
		call	3d13h

		ld	a,14h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 3.
		ld	de,(5CF4h)
		ld	bc,3905h
		call	3d13h

		ld	a,16h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 4.
		ld	de,(5CF4h)
		ld	bc,3B05h
		call	3d13h

		ld	a,17h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 5.
		ld	de,(5CF4h)
		ld	bc,3505h
		call	3d13h
		ret
		
load_packs_1
		ld	a,11h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 6.
		ld	de,0x0000
sect_pack1=$-2
		ld	bc,2A05h
		call	3d13h

		ld	a,13h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 7.
		ld	de,(5CF4h)
		ld	bc,2205h
		call	3d13h

		ld	a,14h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 8.
		ld	de,(5CF4h)
		ld	bc,3B05h
		call	3d13h

		ld	a,16h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;грузим музыкальный пак 9.
		ld	de,(5CF4h)
		ld	bc,3205h
		call	3d13h
		ret

ETunes_tabl_music:
		db	11h   				; 1 музыкальное произведение
		db	0
		dw	0C000h
		dw	8567h
		db	11h   				; 2 музыкальное произведение
		db	0
		dw	0DC10h
		dw	8567h

		db	13h   				; 3 музыкальное произведение
		db	0
		dw	0C000h
		dw	8567h
		db	13h   				; 4 музыкальное произведение
		db	0
		dw	0D210h
		dw	8567h

		db	14h   				; 5 музыкальное произведение
		db	0
		dw	0C000h
		dw	8567h
		db	14h   				; 6 музыкальное произведение
		db	0
		dw	0D7F0h
		dw	8567h

		db	16h   				; 7 музыкальное произведение
		db	0
		dw	0C000h
		dw	8567h
		db	16h   				; 8 музыкальное произведение
		db	0
		dw	0D200h
		dw	8567h
		db	16h   				; 9 музыкальное произведение
		db	0
		dw	0D9D0h
		dw	8567h
		db	16h   				; 10 музыкальное произведение
		db	0
		dw	0EAC0h
		dw	85A8h
		db	16h   				; 11 музыкальное произведение
		db	0
		dw	0EE40h
		dw	891Ch
		db	16h   				; 12 музыкальное произведение
		db	0
		dw	0F450h
		dw	8F20h
		db	16h   				; 13 музыкальное произведение
		db	1
		dw	0F760h
		dw	0C220h

		db	17h   				; 14 музыкальное произведение
		db	0
		dw	0C000h
		dw	8590h
		db	17h   				; 15 музыкальное произведение
		db	0
		dw	0D0A0h
		dw	9628h
		db	17h   				; 16 музыкальное произведение
		db	0
		dw	0DEC0h
		dw	921Ch
		db	17h   				; 17 музыкальное произведение
		db	0
		dw	0E5D0h
		dw	991Ch

		db	91h   				; 18 музыкальное произведение
		db	0
		dw	0C000h
		dw	0A820h
		db	91h   				; 19 музыкальное произведение
		db	1
		dw	0CD10h
		dw	0B524h
		db	91h   				; 20 музыкальное произведение
		db	0
		dw	0DA20h
		dw	8598h
		db	91h   				; 21 музыкальное произведение
		db	0
		dw	0E5C0h
		dw	9128h

		db	93h   				; 22 музыкальное произведение
		db	0
		dw	0C000h
		dw	951Ch
		db	93h   				; 23 музыкальное произведение
		db	0
		dw	0D660h
		dw	0AB6Ch

		db	94h   				; 24 музыкальное произведение
		db	0
		dw	0C000h
		dw	85ACh
		db	94h   				; 25 музыкальное произведение
		db	0
		dw	0EAB0h
		dw	8567h

		db	96h   				; 26 музыкальное произведение
		db	0
		dw	0C000h
		dw	8567h


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



ETunes_count_music:
		db	0
ETunes_number_music:
		db	0
ETunes_key_press:
		db	0
ETunes_phase:
		db	0

Interrupt_handle:
		push	hl	
		push	bc	
		push	de
		push	af	

		call 	Analyzer_clear
		call 	Analyzer_update
		ld	a,(ETunes_count_music)
		cp	8
		jr 	z,ETunes_analyzer_0
		cp	0Dh
		jr	z,ETunes_analyzer_1
		cp	0Eh
		jr	z,ETunes_analyzer_1
		cp	18h
		jr	z,ETunes_analyzer_0
		call	Analyzer_view_0
ETunes_continue:
		call    Analyzer_draw_flash
		call	ESIPlayer_Play
		pop	af
		pop	de
		pop	bc
		pop	hl
		ei
		ret

ETunes_analyzer_0:
		call	Analyzer_view_1
		jr      ETunes_continue

ETunes_analyzer_1:
		call	Analyzer_view_2
		jr      ETunes_continue

		.include  esplayer.asm
		.include  attribute.asm
		.include  string.asm
Etunes_end:
		.savebin "etunes.bin",ETunes_Start, Etunes_end - ETunes_Start

		.include  analyzer.asm

		.savebin "erunea.bin",Analyzer_update, Analyzer_end - Analyzer_update
		.end

