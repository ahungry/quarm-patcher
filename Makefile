all: quarm_patcher.bin

# Use the -r to run at compile time if desired

quarm_patcher.bin: quarm_patcher.nim
	nim c -d:ssl -d:release --mm:orc -o:$@ $<

quarm_patcher.exe: quarm_patcher.nim zlib1.dll libcrypto-1_1-x64.dll libssp-0.dll libssl-1_1-x64.dll
	nim -l:"-lz" c -d:ssl -d:release -d:mingw --mm:orc -o:$@ quarm_patcher.nim

zlib1.dll:
	cp /usr/x86_64-w64-mingw32/bin/$@ ./

libssl-1_1-x64.dll:
	cp /usr/x86_64-w64-mingw32/bin/$@ ./

libcrypto-1_1-x64.dll:
	cp /usr/x86_64-w64-mingw32/bin/$@ ./

libssp-0.dll:
	cp /usr/x86_64-w64-mingw32/bin/$@ ./

release: quarm_patcher.bin quarm_patcher.exe
	-rm -f quarm-patcher.tar.gz
	tar czvf quarm-patcher.tar.gz quarm_patcher.bin
	mkdir -p quarm-patcher
	cp quarm_patcher.exe zlib1.dll libcrypto-1_1-x64.dll libssp-0.dll libssl-1_1-x64.dll cacert.pem quarm-patcher/
	-rm -f quarm-patcher.zip
	zip -r quarm-patcher.zip quarm-patcher

clean:
	-rm -f eqgame.dll
	-rm -f *.tar.gz
	-rm -f *.zip
	-rm -fr quarm-patcher/

.PHONY: release
