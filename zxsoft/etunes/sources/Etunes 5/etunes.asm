;--------------------------------------------------------------------
; ���ᠭ��: �ணࠬ�� �ந��뢠��� ���㫥� E-Tracker
; �����প� � ������: ZXM-SoundCard
; ���� ����: ���ᮢ �.�.(Mick),2010
;--------------------------------------------------------------------
		DEVICE ZXSPECTRUM128

		.org 	6000h

;-------------------------------------------------------------------
; ���ᠭ��: ��窠 �室� � �ணࠬ�� ��᫥ ��।�� �ࠢ����� �� ��
;---------------------------------------------------------------------
ETunes_Start:		
		xor	a               		;��थ� � ��� 梥�
		out	(0feh),a	
		ld	(ETunes_count_music),a		;���稪 ����� ��모

		ld	hl,4000h
		ld	de,4001h
		ld	bc,1b00h
		ld	(hl),c
		ldir
		
		ld	hl,4000h			;��㧨� �࠭
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
		call	Str_draw_symbol
		call	Str_play
		jr	c,ETunes_load
		call	Str_update_symbol
		jr	nc,ETunes_loading	
ETunes_load:
		di                                      ;�� ��直� ������ ����⨬ ���뢠���
		ld	a,10h 				;��⠭���� ��砫��� ��࠭��� �����
		ld	(ETunes_page_memory),a
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 1.
		ld	de,(5CF4h)
		ld	bc,3B05h
		call	3d13h

		ld	a,11h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 2.
		ld	de,(5CF4h)
		ld	bc,3B05h
		call	3d13h

		ld	a,13h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 3.
		ld	de,(5CF4h)
		ld	bc,3A05h
		call	3d13h

		ld	a,14h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 4.
		ld	de,(5CF4h)
		ld	bc,2F05h
		call	3d13h

		ld	a,16h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 5.
		ld	de,(5CF4h)
		ld	bc,3A05h
		call	3d13h

		ld	a,17h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 6.
		ld	de,(5CF4h)
		ld	bc,1C05h
		call	3d13h

		ld	a,10h 
		ld	bc,7ffdh
		out	(c),a

		ld	sp,5fffh
		call	Str_init			;���樠������ ����饩 ��ப�
		call	Analyzer_init			
		ld	a,1
		ld	(ETunes_number_music),a
		call	ETunes_view_number
		call	Star_init
		ld	hl,0C000h
		ld	(EPlayer_Init+1),hl            ;���� ��몠�쭮�� �ந��������
		ld	bc,0FFFDh                       ;ࠧ�訬 ࠡ��� SAA1099
		ld	a,0f6h
		out	(c),a
		call	EPlayer_Init			;���樠������ �ந��뢠�饣� �����
		ld	hl,0fe00h                       ;ᮧ���� ⠡���� ���뢠��� ��� im 2
		ld	de,0fe01h
		ld	bc,0100h
		ld	(hl),0fdh
		ldir
		ld	a,0c3h                          ;��⠭���� ����� ���뢠���
		ld	(0fdfdh),a
		ld	hl,Interrupt_handle
		ld	(0fdfeh),hl
		di
		ld	a,0feh                          ;����砭�� ��⠭���� ���뢠���
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

		ld	a,7fh				;������� �஡�� - ���室 � ᫥���饩 �������樨
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
		ld	a,(ETunes_page_memory)		;����㧨� ����� ��࠭��� �����
		ld	bc,7ffdh
		out	(c),a
		call	EPlayer_Init			;���訬 ࠡ��� �ந��뢠�饣� �����
		ld	bc,0FFFDh                       ;����頥� ࠡ��� SAA1099
		ld	a,0feh
		out	(c),a
		ld	a,(ETunes_count_music)
		inc	a
		cp	30
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
		ld	a,(hl)				;����� ��࠭��� �����
		ld	(ETunes_page_memory),a
		inc	hl
		ld	a,(hl)                          
		inc	hl
		ld	h,(hl)
		ld	l,a
		ld	a,(ETunes_page_memory)		;����㧨� ����� ��࠭��� �����
		ld	bc,7ffdh
		out	(c),a
		ld	(EPlayer_Init+1),hl            ;���� ��몠�쭮�� �ந��������
		ld	bc,0FFFDh                       ;ࠧ�訬 ࠡ��� SAA1099
		ld	a,0f6h
		out	(c),a
		call	EPlayer_Init			;���樠�����㥬 �ந��뢠⥫�
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
		cp	31h
		jr	c,ETunes_number_valid
		ld	a,1

ETunes_number_valid:
		ld	(ETunes_number_music),a
		call	ETunes_view_number

		ei
		jp      ETunes_loop

ETunes_exit:		
		di	
		call	EPlayer_Init			;���訬 ࠡ��� �ந��뢠�饣� �����
		ld	bc,0FFFDh                       ;����頥� ࠡ��� SAA1099
		ld	a,0feh
		out	(c),a
		ld	hl,0	
		push	hl
      		jp  	3d2fh				;��室 � TR-DOS

ETunes_view_number:
		ld	c,a
		and	0F0h
		rrca
		rrca
		rrca
		rrca
		ld	hl,501Dh
		call	ETunes_view_symbol
		ld	a,c
		and	0Fh
		ld	hl,501Eh

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
		djnz	ETunes_view_loop
		ret	

ETunes_line_border:
		ld	a,01h
      		out	(0feh),a
		ld	b,18h 
ETunes_width_loop:		
		nop
		djnz	ETunes_width_loop
		xor	a
      		out	(0feh),a
		ret

ETunes_tabl_music:
		db	10h   				; 1 ��몠�쭮� �ந��������
		dw	0C000h
		db	10h   				; 2 ��몠�쭮� �ந��������
		dw	0CF60h
		db	10h   				; 3 ��몠�쭮� �ந��������
		dw	0D520h
		db	10h   				; 4 ��몠�쭮� �ந��������
		dw	0E540h
		db	10h   				; 5 ��몠�쭮� �ந��������
		dw	0EDF0h

		db	11h   				; 6 ��몠�쭮� �ந��������
		dw	0C000h
		db	11h   				; 7 ��몠�쭮� �ந��������
		dw	0C900h
		db	11h   				; 8 ��몠�쭮� �ந��������
		dw	0E010h
		db	11h   				; 9 ��몠�쭮� �ந��������
		dw	0E7C0h
		db	11h   				; 10 ��몠�쭮� �ந��������
		dw	0F420h

		db	13h   				; 11 ��몠�쭮� �ந��������
		dw	0C000h
		db	13h   				; 12 ��몠�쭮� �ந��������
		dw	0CBA0h
		db	13h   				; 13 ��몠�쭮� �ந��������
		dw	0D070h
		db	13h   				; 14 ��몠�쭮� �ந��������
		dw	0D4E0h
		db	13h   				; 15 ��몠�쭮� �ந��������
		dw	0DC50h
		db	13h   				; 16 ��몠�쭮� �ந��������
		dw	0E6D0h
		db	13h   				; 17 ��몠�쭮� �ந��������
		dw	0F1A0h

		db	14h   				; 18 ��몠�쭮� �ந��������
		dw	0C000h
		db	14h   				; 19 ��몠�쭮� �ந��������
		dw	0C650h
		db	14h   				; 20 ��몠�쭮� �ந��������
		dw	0CB00h
		db	14h   				; 21 ��몠�쭮� �ந��������
		dw	0DA10h
		db	14h   				; 22 ��몠�쭮� �ந��������
		dw	0E4F0h
		db	14h   				; 23 ��몠�쭮� �ந��������
		dw	0E870h

		db	16h   				; 24 ��몠�쭮� �ந��������
		dw	0C000h
		db	16h   				; 25 ��몠�쭮� �ந��������
		dw	0CF70h
		db	16h   				; 26 ��몠�쭮� �ந��������
		dw	0E2A0h
		db	16h   				; 27 ��몠�쭮� �ந��������
		dw	0EE90h

		db	17h   				; 28 ��몠�쭮� �ந��������
		dw	0C000h
		db	17h   				; 29 ��몠�쭮� �ந��������
		dw	0C8D0h
		db	17h   				; 30 ��몠�쭮� �ந��������
		dw	0D240h

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
ETunes_phase:
		db	0

Interrupt_handle:
		push	ix
		push	hl	
		push	bc	
		push	de
		push	af	

		call	Str_draw_symbol
		call 	Analyzer_update
		call    Analyzer_draw_flash

		ld	bc,0ABh 
MA2BA:		
		dec	bc
     		ld	a,b
      		or	a,c
      		jr	nz,MA2BA

      		call	ETunes_line_border
		call 	Analyzer_view
		call	Star_play

		ld	bc,40h 
MA2BB:		
		dec	bc
     		ld	a,b
      		or	a,c
      		jr	nz,MA2BB
      		call	ETunes_line_border

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
		pop	ix
		ei
		ret

		.include  analyzer.asm
		.include  etplayer.asm
		.include  star.asm
		.include  string.asm
Etunes_end:

		.savebin "etunes.bin",ETunes_Start, Etunes_end - ETunes_Start
		.end

