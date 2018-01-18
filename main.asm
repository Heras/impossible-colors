*=$c000                 ; 49152 

Init    LDA #%01111111
        STA $DC0D       ; "Switch off" interrupts signals from CIA-1
        AND $D011
        STA $D011       ; Clear most significant bit in VIC's raster register
        
        LDA #1
        STA $D012       ; Set the raster line number where interrupt should occur
        
        LDA #<Irq
        STA $0314
        LDA #>Irq
        STA $0315       ; Set the interrupt vector to point to interrupt service routine below
        LDA #%00000001
        STA $D01A       ; Enable raster interrupt signals from VIC
        RTS             ; Initialization done; return to BASIC

Irq     LDA $d020       ; yellow
        CMP #$f5         ; because when read, this will be F7 even when you put in 7
        BEQ Black       ; if same go away

Yellow  LDA #$f5
        STA $D020       ; Turn screen frame yellow
        ASL $D019       ; "Acknowledge" the interrupt by clearing the VIC's interrupt flag.
        JMP $EA31       ; Jump into KERNAL's standard interrupt service routine to handle keyboard scan, cursor display etc.

Black   LDA #14
        STA $D020       ; Switch frame color back to black
        ASL $D019       ; "Acknowledge" the interrupt by clearing the VIC's interrupt flag.
        JMP $EA31       ; Jump into KERNAL's standard interrupt service routine to handle keyboard scan, cursor display etc.