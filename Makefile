all: quarm_patcher.bin

# Use the -r to run at compile time if desired

quarm_patcher.bin: quarm_patcher.nim
	nim c -d:ssl -d:release --gc:orc -o:$@ $<

quarm_patcher.exe: quarm_patcher.nim zlib1.dll libcrypto-1_1-x64.dll libssp-0.dll libssl-1_1-x64.dll
	nim -l:"-lz" c -d:ssl -d:release -d:mingw --gc:orc -o:$@ quarm_patcher.nim

zlib1.dll:
	cp /usr/x86_64-w64-mingw32/bin/$@ ./

libssl-1_1-x64.dll:
	cp /usr/x86_64-w64-mingw32/bin/$@ ./

libcrypto-1_1-x64.dll:
	cp /usr/x86_64-w64-mingw32/bin/$@ ./

libssp-0.dll:
	cp /usr/x86_64-w64-mingw32/bin/$@ ./

clean:
	-rm -f eqgame.dll
	-rm -f quarm_latest.zip
