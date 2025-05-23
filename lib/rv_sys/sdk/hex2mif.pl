#!/usr/bin/perl
# 2005 - David Grant.
# Take an ihex input from STDIN, and write a .mif file to STDOUT
# This script could probably be implemented with something like:
#    $#!@_%^$@%$@%$_!^$@#^@%$#@_%$@^&!%$_!%!%&$*(#^#@%^)
# But I perfer the somewhat readable version.

# Flow from within the Nios2 SDK Shell:
# nios2-elf-as file.asm -o file.o
# nios2-elf-objcopy file.o --target ihex file.hex
# cat file.hex | perl hex2mif.pl > file.mif

sub conv {
	my ($in) = @_;
#	Changes endianness
#	$out = substr($in,6,2).substr($in,4,2).substr($in,2,2).substr($in,0,2);
	$out = $in;
	return hex $out;
}

my @code = ();
$hiaddr = 0;

while (<STDIN>) {
	$l = $_;
	$count = (hex substr($l, 1, 2)) / 4;
	$addr = (hex substr($l, 3, 4)) / 4;
	$type = (hex substr($l, 7, 2));
	last if $type eq 1;
	next if $type eq 5; # ignore record type 5
	if ($type eq 4) {   # upper 16 bits of address, topmost 2 bits are bogus
		$hiaddr = ((hex substr($l, 9, 4)) & 0x3fff) << 16;
		next;
	}
	if ($type eq 0) {   # actual data
		$l = substr($l, 9, $count*8);
		for($x=0; $x<$count; $x++) {
			$sstr = substr($l, 8*$x, 8);
			#chomp(chomp($sstr));
			#$sstr =~ s/\R//;
			$sstr = $sstr.'00000000';
			$sstr = substr($sstr, 0, 8);
			$code[$hiaddr + $addr + $x] = conv($sstr);
		}
		next;
	}
	printf("Unknown Intel hex record: %s\n", $l);
}

for($x=0; $x<@code; $x++) {
	printf("%08x\n", $code[$x]);
}

