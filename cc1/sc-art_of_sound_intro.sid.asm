BasicUpstart2(start)
//---------------------------------------------------------
//---------------------------------------------------------
//			SID Player (Single speed)
//---------------------------------------------------------
//---------------------------------------------------------

.var music = LoadSid("../sids/art_of_sound_intro.sid")		//<- Here we load the sid file

// Get the Commodore64_Programming Repo for these import files 
#import "../Commodore64_Programming/include/Constants.asm"
#import "../Commodore64_Programming/include/Macros.asm"
#import "../Commodore64_Programming/include/DrawPetMateScreen.asm"

*=$4000 "SCREENS"
#import "../petmate/screen1.asm"

*=$0810
start:

lda 23
sta 53272



    DrawPetMateScreen(screen_001)

    ldx #$00
!pl:
    lda mname,x
    beq !pl+
    sta 1024+8,x
    inx
    jmp !pl-
!pl:
    ldx #$00
!pl:
    lda mauthor,x
    beq !pl+
    sta 1024+8+40,x
    inx
    jmp !pl-
!pl:
    jmp music_start

.encoding "screencode_mixed"
mname:
.text music.name
.byte 0
mauthor:
.text music.author
.byte 0

music_start:
            lda #$00
			sta $d020
			sta $d021
			ldx #0
			ldy #0
			lda #music.startSong-1						//<- Here we get the startsong and init address from the sid file
			jsr music.init	
			sei
			lda #<irq1
			sta $0314
			lda #>irq1
			sta $0315
			lda #$1b
			sta $d011
			lda #$80
			sta $d012
			lda #$7f
			sta $dc0d
			sta $dd0d
			lda #$81
			sta $d01a
			lda $dc0d
			lda $dd0d
			asl $d019
			cli
			jmp *

//---------------------------------------------------------
irq1:  	    asl $d019
			inc $d020
			jsr music.play 									// <- Here we get the play address from the sid file
			dec $d020
			jmp $ea81

//---------------------------------------------------------
			*=music.location "Music"
			.fill music.size, music.getData(i)				// <- Here we put the music in memory

//----------------------------------------------------------
			// Print the music info while assembling
			.print ""
			.print "SID Data"
			.print "--------"
			.print "location=$"+toHexString(music.location)
			.print "init=$"+toHexString(music.init)
			.print "play=$"+toHexString(music.play)
			.print "songs="+music.songs
			.print "startSong="+music.startSong
			.print "size=$"+toHexString(music.size)
			.print "name="+music.name
			.print "author="+music.author
			.print "copyright="+music.copyright

			.print ""
			.print "Additional tech data"
			.print "--------------------"
			.print "header="+music.header
			.print "header version="+music.version
			.print "flags="+toBinaryString(music.flags)
			.print "speed="+toBinaryString(music.speed)
			.print "startpage="+music.startpage
			.print "pagelength="+music.pagelength


