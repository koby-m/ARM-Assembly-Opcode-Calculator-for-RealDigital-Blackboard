.global main

.include "../src/klibio.S"
.include "../src/klibpfrl.S"
.include "../src/calculator.S"

.text

main:

	bl setupSevSeg

	mainloop:
	
		bl setOperation

		bl getInputs
		
		bl setOperation

		bl performCalc
		mov r1, r0
		mov r5, r0
		
		bl outputToSevSeg
		
	b mainloop

.end
@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
@ EoF
@ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

