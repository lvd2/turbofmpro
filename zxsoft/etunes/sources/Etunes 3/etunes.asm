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
		
		ld	hl,8000h			;��㧨� �࠭
		ld	de,(5CF4h)
		ld	bc,1B05h
		call	3d13h
		ld	hl,98E1h
		ld	c,11
ETunes_clear_y:
		push	hl
		ld	b,24
ETunes_clear_x:
		ld	(hl),0
		inc	hl
		djnz	ETunes_clear_x
		pop	hl
		ld	de,0020h
		add	hl,de
		dec	c
		jr	nz,ETunes_clear_y
		ld	hl,8000h
		ld	de,4000h
		ld	bc,1b00h
		ldir	

		call	Str_init_load
		ei
ETunes_loading:
		halt
		ld	b,0
Etunes_wait:
		djnz	Etunes_wait			
		call	Str_play
		jr	nc,ETunes_loading	

		di                                      ;�� ��直� ������ ����⨬ ���뢠���
		ld	a,10h 				;��⠭���� ��砫��� ��࠭��� �����
		ld	(ETunes_page_memory),a
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 1.
		ld	de,(5CF4h)
		ld	bc,3E05h
		call	3d13h

		ld	hl,59A1h
		ld	(hl),01h
		inc	hl
		ld	(hl),41h
		inc	hl
		ld	(hl),02h
		
		ld	a,11h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 2.
		ld	de,(5CF4h)
		ld	bc,3E05h
		call	3d13h

		ld	hl,59A4h
		ld	(hl),42h
		inc	hl
		ld	(hl),03h
		inc	hl
		ld	(hl),43h

		ld	a,13h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 3.
		ld	de,(5CF4h)
		ld	bc,3905h
		call	3d13h

		ld	hl,59A7h
		ld	(hl),04h
		inc	hl
		ld	(hl),44h
		inc	hl
		ld	(hl),05h

		ld	a,14h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 4.
		ld	de,(5CF4h)
		ld	bc,3F05h
		call	3d13h

		ld	hl,59A9h
		ld	(hl),45h
		inc	hl
		ld	(hl),06h
		inc	hl
		ld	(hl),46h

		ld	a,16h 
		ld	bc,7ffdh
		out	(c),a
		ld	hl,0C000h			;��㧨� ��몠��� ��� 5.
		ld	de,(5CF4h)
		ld	bc,1F05h
		call	3d13h

		ld	a,10h 
		ld	bc,7ffdh
		out	(c),a

		ld	sp,5fffh
		call	Str_init			;���樠������ ����饩 ��ப�
		call	Analyzer_init			
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
		
		call 	Analyzer_update
		call 	Analyzer_view
		call	Str_play

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
		cp	40
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

ETunes_tabl_music:
		db	10h   				; 1 ��몠�쭮� �ந��������
		dw	0C000h
		db	10h   				; 2 ��몠�쭮� �ந��������
		dw	0C220h
		db	10h   				; 3 ��몠�쭮� �ந��������
		dw	0C600h
		db	10h   				; 4 ��몠�쭮� �ந��������
		dw	0CBB0h
		db	10h   				; 5 ��몠�쭮� �ந��������
		dw	0D260h
		db	10h   				; 6 ��몠�쭮� �ந��������
		dw	0D7D0h
		db	10h   				; 7 ��몠�쭮� �ந��������
		dw	0DCE0h
		db	10h   				; 8 ��몠�쭮� �ந��������
		dw	0E1C0h
		db	10h   				; 9 ��몠�쭮� �ந��������
		dw	0E4F0h
		db	10h   				; 10 ��몠�쭮� �ந��������
		dw	0E870h
		db	10h   				; 11 ��몠�쭮� �ந��������
		dw	0EE70h
		db	10h   				; 12 ��몠�쭮� �ந��������
		dw	0F430h

		db	11h   				; 13 ��몠�쭮� �ந��������
		dw	0C000h
		db	11h   				; 14 ��몠�쭮� �ந��������
		dw	0CC50h
		db	11h   				; 15 ��몠�쭮� �ந��������
		dw	0D440h
		db	11h   				; 16 ��몠�쭮� �ந��������
		dw	0EFC0h
		db	11h   				; 17 ��몠�쭮� �ந��������
		dw	0F4A0h

		db	13h   				; 18 ��몠�쭮� �ந��������
		dw	0C000h
		db	13h   				; 19 ��몠�쭮� �ந��������
		dw	0C220h
		db	13h   				; 20 ��몠�쭮� �ந��������
		dw	0C720h
		db	13h   				; 21 ��몠�쭮� �ந��������
		dw	0D7A0h
		db	13h   				; 22 ��몠�쭮� �ந��������
		dw	0DEC0h
		db	13h   				; 23 ��몠�쭮� �ந��������
		dw	0E120h
		db	13h   				; 24 ��몠�쭮� �ந��������
		dw	0E660h
		db	13h   				; 25 ��몠�쭮� �ந��������
		dw	0ECF0h
		db	13h   				; 26 ��몠�쭮� �ந��������
		dw	0F060h

		db	14h   				; 27 ��몠�쭮� �ந��������
		dw	0C000h
		db	14h   				; 28 ��몠�쭮� �ந��������
		dw	0C8E0h
		db	14h   				; 29 ��몠�쭮� �ந��������
		dw	0CC90h
		db	14h   				; 30 ��몠�쭮� �ந��������
		dw	0D2C0h
		db	14h   				; 31 ��몠�쭮� �ந��������
		dw	0D9F0h
		db	14h   				; 32 ��몠�쭮� �ந��������
		dw	0DE20h
		db	14h   				; 33 ��몠�쭮� �ந��������
		dw	0E450h
		db	14h   				; 34 ��몠�쭮� �ந��������
		dw	0EAF0h
		db	14h   				; 35 ��몠�쭮� �ந��������
		dw	0EE70h
		db	14h   				; 36 ��몠�쭮� �ந��������
		dw	0F730h

		db	16h   				; 37 ��몠�쭮� �ந��������
		dw	0C000h
		db	16h   				; 38 ��몠�쭮� �ந��������
		dw	0C7D0h
		db	16h   				; 39 ��몠�쭮� �ந��������
		dw	0D0D0h
		db	16h   				; 40 ��몠�쭮� �ந��������
		dw	0D8F0h

ETunes_page_memory:
		db	0		
ETunes_count_music:
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
		.include  string.asm
Etunes_end:

		.savebin "etunes.bin",ETunes_Start, Etunes_end - ETunes_Start
		.end

