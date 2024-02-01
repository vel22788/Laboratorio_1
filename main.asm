//***************************************************
;
; Universidad del Valle de Guatemala
; IE2023: Programación de Microcontroladores
; Autor: Angel Velásquez
; Descripción: Primer programa
; Hardware: atmega328p
; Proyecto: AssemblerApplication1.asm
; Created: 24/01/2024 17:39:41
;
//**************************************************


//**************************************************
; ENCABEZADO
//**************************************************
.include "M328PDEF.inc"
.cseg								//Indica inicio del código
.org 0x00							//Indica en que dirección va a estar el vector RESET


//**************************************************
; Configuración de pila
//**************************************************
LDI R16, LOW(RAMEND)              //STACKPOINTER, PARTE BAJA
OUT SPL, R16
LDI R16, HIGH(RAMEND)             //STACKPOINTER, PARTE DE ARRIBA
OUT SPH, R16


//**************************************************
; CONFIGURACIÓN MCU
//**************************************************
SETUP:
	LDI R16, 0b1000_0000		  // 
	STS CLKPR,R16				  // Habilitar el prescaler (STS GUARDA R16 EN UN LUGAR FUERA DE I/O)
	LDI R16, 0b0000_0100
	STS CLKPR,R16				  // Definir el prescaler de 16 Fcpu = 1MHz

	LDI R16, 0b0011_1111		  //PUERTO B
	LDI R17, 0b0010_0000		  //PUERTO C
	LDI R18, 0b1111_1100		  //PUERTO D
	
	OUT DDRB, R16				  //SETEO DE PUERTOS
	OUT DDRC, R17
	OUT DDRD, R18 

	LDI r18, 0b1101_1111		  //PULL-UPS de los pines
	OUT PORTC, R18 

	LDI R19, 0b1111_0000		//Primer numero
	LDI R21, 0b1111_0000		//Segundo numero


LOOP:							  //LOOP INFINITO DEL PROGRAMA

	IN R18, PINC				//LEER ESTADO DE LOS BOTONES
	
	Boton_1: 
			SBRS R18, PC0  // SALTA SI ESL PINC 0, ESTA EN 1, ES DECIR NO PRESIONADO
			RJMP DelayBounce1
	Boton_2: 
			SBRS R18, PC1  // SALTA SI ESL PINC 0, ESTA EN 1, ES DECIR NO PRESIONADO
			RJMP DelayBounce2
	Boton_3: 
			SBRS R18, PC2  // SALTA SI ESL PINC 0, ESTA EN 1, ES DECIR NO PRESIONADO
			RJMP DelayBounce3
	Boton_4: 
			SBRS R18, PC3  // SALTA SI ESL PINC 0, ESTA EN 1, ES DECIR NO PRESIONADO
			RJMP DelayBounce4
	Boton_5: 
			SBRS R18, PC4  // SALTA SI ESL PINC 0, ESTA EN 1, ES DECIR NO PRESIONADO
			RJMP DelayBounce5


	RJMP LOOP


//**************************************************
; SUBRUTINAS
//**************************************************

DelayBounce1:
	LDI R16, 200
delay1:
	DEC R16
	BRNE delay1
	IN R18, PINC
	SBRS R18, PC0 // SALTA SI ESL PINC 0, ESTA EN 1, ES DECIR YA SOLTO EL BOTÓN
	RJMP DelayBounce1

	CPI R19, 0b1111_1111
	BRNE N1_add
	RJMP LOOP

DelayBounce2:
	LDI R16, 200
delay2:
	DEC R16
	BRNE delay2
	IN R18, PINC
	SBRS R18, PC1 // SALTA SI ESL PINC 1, ESTA EN 1, ES DECIR YA SOLTO EL BOTÓN
	RJMP DelayBounce2

	CPI R19, 0b1111_0000
	BRNE N1_res
	RJMP LOOP

DelayBounce3:
	LDI R16, 200
delay3:
	DEC R16
	BRNE delay3
	IN R18, PINC
	SBRS R18, PC2 // SALTA SI ESL PINC 0, ESTA EN 1, ES DECIR YA SOLTO EL BOTÓN
	RJMP DelayBounce3

	CPI R21, 0b1111_1111
	BRNE N2_add
	RJMP LOOP

DelayBounce4:
	LDI R16, 200
delay4:
	DEC R16
	BRNE delay4
	IN R18, PINC
	SBRS R18, PC3 // SALTA SI ESL PINC 1, ESTA EN 1, ES DECIR YA SOLTO EL BOTÓN
	RJMP DelayBounce4
	CPI R21, 0b1111_0000

	BRNE N2_res
	RJMP LOOP

DelayBounce5:
	LDI R16, 2
delay5:
	DEC R16
	BRNE delay5
	IN R18, PINC
	SBRS R18, PC4 // SALTA SI ESL PINC 1, ESTA EN 1, ES DECIR YA SOLTO EL BOTÓN
	RJMP DelayBounce5

	RJMP suma
			
N1_add:
	INC R19
	RJMP N1_update
N1_res:
	DEC R19
	RJMP N1_update
N2_add:
	INC R21
	RJMP N2_update
N2_res:
	DEC R21
	RJMP N2_update

N1_update:
	MOV R20, R19
	ANDI R20, 0b0000_1111
	LSL R20
	OUT PORTB, R20
	RJMP LOOP

N2_update:
	MOV R22, R21
	ANDI R22, 0b0000_1111
	LSL R22
	LSL R22
	OUT PORTD, R22
	RJMP LOOP

carry_on:
	SBI PORTB, PB5
	RJMP N3_update
carry_off:
	CBI PORTB, PB5
	RJMP N3_update

Suma:
	MOV R23, R19
	ANDI R23, 0b0000_1111
	MOV R24, R21
	ANDI R24, 0b0000_1111
	ADC R23, R24
	SBRC R23, 4
	RJMP carry_on
	RJMP carry_off


	digito0_on:
	SBI PORTD, PD6
	RJMP digito1

	digito1_on:
	SBI PORTD, PD7
	RJMP digito2

	digito2_on:
	SBI PORTB, PB0
	RJMP digito3

	digito3_on:
	SBI PORTC, PC5
	RJMP LOOP

N3_update:
	CBI PORTB, PB5
	digito0:
	SBRC R23, 0
	RJMP digito0_on
	CBI PORTD, PD6
	
	digito1:
	SBRC R23, 1
	RJMP digito1_on
	CBI PORTD, PD7

	digito2:
	SBRC R23, 2
	RJMP digito2_on
	CBI PORTB, PB0

	digito3:
	SBRC R23, 3
	RJMP digito3_on
	CBI PORTC, PC5

	RJMP LOOP
	

	

	
	



	
	
	

	



	
