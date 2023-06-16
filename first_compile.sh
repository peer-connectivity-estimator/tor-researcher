./autogen.sh
./configure --disable-asciidoc
make -j$(nproc)
sudo make install